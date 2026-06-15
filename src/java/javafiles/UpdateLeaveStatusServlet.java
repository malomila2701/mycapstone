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

        int userId = Integer.parseInt(request.getParameter("user_id"));
        int id = Integer.parseInt(request.getParameter("holidays_id"));
        String status = request.getParameter("status");
        String response_message = request.getParameter("response_message");
        

        try (Connection conn = DBConnection.connect()) {
            String sql = "UPDATE holidays SET status=?, response_message=? WHERE holidays_id=?";
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, response_message);
            ps.setInt(3, id);
            ps.executeUpdate();

            // 2. Insertion dans notifications
            String sqlNotif = "INSERT INTO notifications (user_id, holiday_id, message, created_at) VALUES (?,?,?, ?, NOW())";
            java.sql.PreparedStatement psNotif = conn.prepareStatement(sqlNotif);
            psNotif.setInt(1, userId);
            psNotif.setInt(2, id);
            psNotif.setNull(3, java.sql.Types.INTEGER);
            psNotif.setString(4, "Permission #" + id + " has been : " + status + "!");
            psNotif.executeUpdate();

            conn.commit(); // tout valider

        } catch (Exception e) {
            logger.error("Error UPDATING HOLIDAY status:" + e.getMessage());
        }
        // redirect back (important)
        response.sendRedirect(request.getContextPath() + "/admin/requests.jsp");
    }
}
