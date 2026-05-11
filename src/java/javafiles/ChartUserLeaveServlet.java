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
import javax.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author HP
 */
@WebServlet("/ChartUserLeaveServlet")
public class ChartUserLeaveServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(ChartUserLeaveServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        String sql = """
                         SELECT 
                             MONTH(start_date) AS month,
                             COUNT(*) AS count
                         FROM (
                             SELECT start_date FROM holidays
                             WHERE user_id = ?
                             AND YEAR(start_date) = YEAR(CURDATE())
                             AND STATUS IN ('Approved','Rejected')
                             
                             UNION ALL
                             
                             SELECT start_date FROM permissions
                             WHERE user_id = ?
                             AND YEAR(start_date) = YEAR(CURDATE())
                             AND STATUS IN ('Approved','Rejected')
                         ) AS combined
                         GROUP BY MONTH(start_date)
                         ORDER BY month;
                     """;

        org.json.JSONArray result = new JSONArray();

        try (
                Connection conn = DBConnection.connect(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);         // set first
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery(); // then execute

            stmt.setInt(1, userId);

            while (rs.next()) {
                JSONObject obj = new JSONObject();
                obj.put("month", rs.getInt("month"));
                obj.put("count", rs.getInt("count"));
                result.put(obj);
            }

            resp.getWriter().write(result.toString());

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JSONObject error = new JSONObject();
            error.put("error", e.getMessage());
            resp.getWriter().write(error.toString());
        } catch (Exception ex) {
            System.getLogger(ChartUserLeaveServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            logger.error("ERROR CHART USER LEAVES : " + ex.getMessage());
        }
    }
}