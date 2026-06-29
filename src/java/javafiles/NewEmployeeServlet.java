/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.sql.*;
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
    
    private static final Logger logger = LogManager.getLogger(NewEmployeeServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String name     = req.getParameter("name");
        String username = req.getParameter("username");
        String role     = req.getParameter("role");
        String email    = req.getParameter("email");
        String entrance = req.getParameter("entrance"); // "YYYY-MM-DD"

        String sql = """
            INSERT INTO users (fullname, username, email, entrance_date, role, created_at)
            VALUES (?, ?, ?, ?, ?, NOW())
        """;

        try (java.sql.Connection conn = DBConnection.connect();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setDate  (4, entrance != null && !entrance.isEmpty()
                            ? Date.valueOf(entrance)
                            : null);
            ps.setString(5, role);

            ps.executeUpdate();

            resp.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            logger.error("ERROR NEW EMPLOYEE SERVLET: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
