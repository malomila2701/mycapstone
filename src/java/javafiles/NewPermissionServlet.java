/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
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
@WebServlet("/NewPermissionServlet")
public class NewPermissionServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(NewPermissionServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("user_id");
        String date = request.getParameter("eventDay");
        String motif = request.getParameter("eventDescription");
        String start_time = request.getParameter("eventStartTime");
        String end_time = request.getParameter("eventEndTime");

        java.sql.Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DBConnection.connect();

            String sql = "INSERT INTO permissions(user_id, start_date, end_date, start_time, end_time, created_at, motif, status) values (?,?,?,?,?,CURRENT_TIMESTAMP,?, 'pending')";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, date);
            stmt.setString(3, date);
            stmt.setTime(4, convertToSqlTime(start_time));
            stmt.setTime(5, convertToSqlTime(end_time));
            stmt.setString(6, motif);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("responseMessage", "Permission request created successfully!");
                request.setAttribute("responseStatus", "success");
            } else {
                request.setAttribute("responseMessage", "Registration failed.");
                request.setAttribute("responseStatus", "error");
            }

            stmt.close();
            request.getRequestDispatcher("main_permission.jsp").forward(request, response);

        } catch (IOException | ClassNotFoundException | SQLException | ServletException  e) {
            logger.error("NEW PERMISSION ERROR : " + e.getMessage());
            request.getRequestDispatcher("main_permission.jsp").forward(request, response);
        } catch (Exception ex) {
            System.getLogger(NewPermissionServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
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

    // Convert "hh:mm a" (e.g. "12:00 PM") into java.sql.Time
    public static java.sql.Time convertToSqlTime(String time) {
    LocalTime localTime = LocalTime.parse(time); 
    return java.sql.Time.valueOf(localTime);
}
}
