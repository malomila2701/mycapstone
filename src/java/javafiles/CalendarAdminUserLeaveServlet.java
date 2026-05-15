/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
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
@WebServlet("/CalendarAdminUserLeaveServlet")
public class CalendarAdminUserLeaveServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(CalendarUserLeaveServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String userIdParam = request.getParameter("userId");
        int userId = Integer.parseInt(userIdParam);

        try (java.sql.Connection conn = DBConnection.connect(); 
                java.sql.PreparedStatement ps = conn.prepareStatement(
                "SELECT holidays.user_id, holidays.holidays_id, holidays.start_date, holidays.end_date, holidays.type, holidays.status, holidays.motif, users.user_id, users.fullname AS fullname FROM holidays INNER JOIN users ON holidays.user_id = users.user_id WHERE users.user_id= ? AND status IN ('Pending', 'Rejected');")) {

            JSONArray events = new JSONArray();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    JSONObject event = new JSONObject();

                    Date endDate = rs.getDate("end_date");
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(endDate);
                    cal.add(Calendar.DATE, 1); // FullCalendar end date is exclusive

                    event.put("title", rs.getString("fullname"));
                    event.put("id", rs.getInt("holidays_id"));
                    event.put("start", sdf.format(rs.getDate("start_date")));
                    event.put("end", sdf.format(cal.getTime()));
                    event.put("allDay", true);

                    // color by status
                    String status = rs.getString("status");
                    if ("approved".equalsIgnoreCase(status)) {
                        event.put("color", "green");
                    } else if ("pending".equalsIgnoreCase(status)) {
                        event.put("color", "orange");
                    } else if ("rejected".equalsIgnoreCase(status)) {
                        event.put("color", "red");
                    }

                    events.put(event);
                }
                response.setContentType("application/json");
                response.getWriter().write(events.toString());

            } catch (java.sql.SQLException e1) {
                logger.error("Error linkage to db: " + e1.getMessage());
            }
            ps.close();
            conn.close();
        } catch (Exception e) {
            logger.error("Error displaying Calendar Leaves: " + e.getMessage());
        }
    }
}
