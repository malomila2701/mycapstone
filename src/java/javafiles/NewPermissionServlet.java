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

        // Database URL, username, and password
        String dbURL = "jdbc:mysql://localhost:3306/capstone_project";
        String dbUser = "root";
        String dbPassword = "admin";

        java.sql.Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String sql = "INSERT INTO permissions(user_id, start_date, end_date, start_time, end_time, motif, status) values (?,?,?,?,?,?, 'pending')";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, date);
            stmt.setString(3, date);
            stmt.setTime(4, convertToSqlTime(start_time));
            stmt.setTime(5, convertToSqlTime(end_time));
            stmt.setString(6, motif);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("responseMessage", "User registered successfully!");
                request.setAttribute("responseStatus", "success");
            } else {
                request.setAttribute("responseMessage", "Registration failed.");
                request.setAttribute("responseStatus", "error");
            }

            stmt.close();
            request.getRequestDispatcher("permission.jsp").forward(request, response);

        } catch (IOException | ClassNotFoundException | SQLException | ServletException | ParseException e) {
            logger.error("NEW PERMISSION ERROR : " + e.getMessage());
            request.getRequestDispatcher("permission.jsp").forward(request, response);
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
    public static java.sql.Time convertToSqlTime(String amPmTime) throws ParseException {
        // Parse AM/PM format
        SimpleDateFormat parser = new SimpleDateFormat("hh:mm a");
        java.util.Date date = parser.parse(amPmTime);

        // Format into 24-hour "HH:mm:ss"
        SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
        String time24 = formatter.format(date);

        // Convert to java.sql.Time for DB insertion
        return java.sql.Time.valueOf(time24);
    }
}
