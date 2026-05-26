/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author HP
 */
@WebServlet("/NewLeaveServlet")
public class NewLeaveServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(NewLeaveServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("user_id");
        String start_date = request.getParameter("eventStart");
        String end_date = request.getParameter("eventEnd");
        String type = request.getParameter("eventType");
        String motif = request.getParameter("eventDescription");

        java.sql.Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DBConnection.connect();

            String sql = "INSERT INTO holidays(user_id, start_date, end_date, type, motif, status) values (?,?,?,?,?, 'pending')";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, start_date);
            stmt.setString(3, end_date);
            stmt.setString(4, type);
            stmt.setString(5, motif);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("responseMessage", "User registered successfully!");
                request.setAttribute("responseStatus", "success");
            } else {
                request.setAttribute("responseMessage", "Registration failed.");
                request.setAttribute("responseStatus", "error");
            }

            stmt.close();
            request.getRequestDispatcher("main_leave.jsp").forward(request, response);

        } catch (IOException | ClassNotFoundException | SQLException | ServletException e) {
            logger.error("NEW LEAVE ERROR : " + e.getMessage());
            request.getRequestDispatcher("main_leave.jsp").forward(request, response);
        } catch (Exception ex) {
            System.getLogger(NewLeaveServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
            }
        }
    }
}
