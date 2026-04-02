package javafiles;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author HP
 */
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Enumeration;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class LastLeaveServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LastLeaveServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            // not logged in — redirect to login
            response.sendRedirect(request.getContextPath() + "/hello.jsp");
            return;
        }

        // Retrieve user logged in from URL
         int userId = (Integer) session.getAttribute("user_id");

        //Pass the user_id to the DAO
       /** userdataDAO dao = new userdataDAO();
        String end = dao.getInfo(userId);
        
        request.setAttribute("lastleavef", end);
        request.getRequestDispatcher("main_page.jsp").forward(request, response);
    }**/
}
}

/**
 * int h_id = 0; String last_leave = null; String end = null;
 *
 *
 * // Database URL, username, and password String dbURL =
 * "jdbc:mysql://localhost:3306/capstone_project"; String dbUser = "root"; //
 * Default XAMPP MySQL user String dbPassword = "admin"; // Default XAMPP MySQL
 * password
 *
 *
 * //Retrieve leaves taken by user try (Connection conn =
 * DriverManager.getConnection(dbURL, dbUser, dbPassword); PreparedStatement
 * stmt = conn.prepareStatement("SELECT * FROM holidays WHERE user_id= ? AND
 * status = approved AND end_date " + "<= CURRENT_DATE ORDER BY end_date DESC
 * LIMIT 1")) {
 *
 * stmt.setInt(1, userId); try (ResultSet rs = stmt.executeQuery()) {
 *
 * if (rs.next()) { logger.info("Successfully linked to DB"); end =
 * rs.getString("end_date"); }
 *
 * }
 * session.setAttribute("lastleave", end);
 * request.getRequestDispatcher("/main_overview.jsp").forward(request,
 * response); } catch (Exception e1) { logger.error("Error retrieving leaves
 * taken by user: " + userId); logger.error("Raison : " + e1.getMessage()); } }
 */
