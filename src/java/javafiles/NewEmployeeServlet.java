/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author JeanSamuel
 */
@WebServlet("/NewEmployeeServlet")
public class NewEmployeeServlet extends HttpServlet {
    
    private static final Logger logger = LogManager.getLogger(NewPermissionServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("name");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String entrance = request.getParameter("entrance");

        String sql = """
        INSERT INTO users
        (fullname, entrance_date, email, role, created_at)
        VALUES (?, ?, ?, ?, NOW())
        """;

        try (
                java.sql.Connection conn = DBConnection.connect(); 
                java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullname);

            if (entrance == null || entrance.isEmpty()) {
                ps.setNull(2, java.sql.Types.DATE);
            } else {
                ps.setDate(2, java.sql.Date.valueOf(entrance));
            }

            ps.setString(3, email);
            ps.setString(4, role);

            ps.executeUpdate();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().print("success");

        } catch (Exception e) {
            logger.error("ERROR NEW EMPLOYEE SERVLET: " + e.getMessage());
        }
    }
}
