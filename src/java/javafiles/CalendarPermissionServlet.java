/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
@WebServlet("/CalendarPermissionServlet")
public class CalendarPermissionServlet extends HttpServlet {
    private static final Logger logger = LogManager.getLogger(CalendarUserLeaveServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String userIdParam = request.getParameter("userId");
        int userId = Integer.parseInt(userIdParam);

        try (java.sql.Connection conn = DBConnection.connect(); java.sql.PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM permissions WHERE user_id= ? and status IN ('approved', 'pending', 'rejected')")) {

            java.sql.ResultSet rs = null;
            ps.setInt(1, userId);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            //JSON Arrary
            //Turn db columns and data into JSON format for fullCalendar
            JSONArray events = new JSONArray();

            try {
                rs = ps.executeQuery();

                while (rs.next()) {

                    JSONObject event = new JSONObject();

                    Date endDate = rs.getDate("end_date");
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(endDate);
                    cal.add(Calendar.DATE, 1);

                    event.put("title", "Permission");
                    event.put("start", sdf.format(rs.getDate("start_date")));
                    event.put("end", sdf.format(cal.getTime()));
                    event.put("allDay", true);
                    event.put("motif", rs.getString("motif"));

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
