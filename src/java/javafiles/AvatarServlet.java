/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
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
@WebServlet("/AvatarServlet")
public class AvatarServlet extends HttpServlet {
    
    private static final Logger logger = LogManager.getLogger(AvatarServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdParam = request.getParameter("userId");

        if (userIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int userId = Integer.parseInt(userIdParam);

        try {
            java.sql.Connection con = DBConnection.connect();

            java.sql.PreparedStatement pst = con.prepareStatement(
                "SELECT avatar, avatar_type FROM users WHERE user_id = ?"
            );

            pst.setInt(1, userId);

            java.sql.ResultSet rs = pst.executeQuery();

            if (rs.next()) {

                byte[] imageBytes = rs.getBytes("avatar");
                String contentType = rs.getString("avatar_type");

                if (imageBytes != null) {

                    response.setContentType(contentType);
                    response.setContentLength(imageBytes.length);

                    OutputStream os = response.getOutputStream();
                    os.write(imageBytes);
                    os.flush();

                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }

            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            logger.error("ERROR_AVATAR_SERVLET: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
