/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;

/**
 *
 * @author HP
 */
@WebServlet("/UpdateLeaveStatusServlet")
public class UpdateLeaveStatusServlet extends HttpServlet {
    
    private static final Logger logger = LogManager.getLogger(UpdateLeaveStatusServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("holidayid"));
        String status = request.getParameter("status");

        try (Connection conn = DBConnection.connect()) {
            String sql = "UPDATE holidays SET status=? WHERE holidays_id=?";
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            logger.error("Error UPDATING status:" + e.getMessage());
        }

        // redirect back (important)
        response.sendRedirect(request.getContextPath() + "/admin/requests.jsp");
    }
}
