/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author HP
 */
@WebServlet("/UpdatePermissionStatusServlet")
public class UpdatePermissionStatusServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(UpdatePermissionStatusServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        //Valeurs récupérées des JSP
        String status = request.getParameter("status");
        int id = Integer.parseInt(request.getParameter("permission_id"));
        String response_message = request.getParameter("admin_message");
        
        int userId = Integer.parseInt(request.getParameter("user_id"));
        

        try (Connection conn = DBConnection.connect()) {
            String sql = "UPDATE permissions SET status=?, response_message=? WHERE permission_id=?";
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, response_message);
            ps.setInt(3, id);
            ps.executeUpdate();

            // 2. Insertion dans notifications
            String sqlNotif = "INSERT INTO notifications (user_id, permission_id, holiday_id, message, created_at) VALUES (?,?,?, ?, NOW())";
            java.sql.PreparedStatement psNotif = conn.prepareStatement(sqlNotif);
            psNotif.setInt(1, userId);
            psNotif.setInt(2, id);
            psNotif.setNull(3, java.sql.Types.INTEGER);
            psNotif.setString(4, "Permission #" + id + " has been : " + status + "!");
            psNotif.executeUpdate();

        } catch (Exception e) {
            logger.error("Error UPDATING PERMISSION status:" + e.getMessage());
        }

        // redirect back (important)
        String returnUrl = request.getParameter("returnUrl");
            if (returnUrl == null || returnUrl.isBlank()) {
            returnUrl = request.getContextPath() + "/admin/permissions.jsp"; // fallback par défaut
        }
        response.sendRedirect(returnUrl);
    }
}
