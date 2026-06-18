/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author HP
 */
@WebServlet("/DeletePendingRequest")
public class DeletePendingRequest extends HttpServlet {
    
    private static final Logger logger = LogManager.getLogger(DeletePendingRequest.class.getName());

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String type = request.getParameter("type");

        String sql = null;

        if ("holiday".equals(type)) {
            sql = "DELETE FROM holidays WHERE holidays_id = ?";
        } else if ("permission".equals(type)) {
            sql = "DELETE FROM permissions WHERE permission_id = ?";
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid type");
            return;
        }

        try (
                Connection conn = DBConnection.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(idStr));
            ps.executeUpdate();

        } catch (Exception e) {
            logger.error("ERROR DELETING "+type+" REQUEST: " + e.getMessage());
        }

        response.sendRedirect("main_overview.jsp");
    }
}
