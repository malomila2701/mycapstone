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
import java.util.HashSet;
import java.util.Set;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author HP
 */
@WebServlet("/CalendarHolidaysServlet")
public class CalendarHolidaysServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(CalendarHolidaysServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        try (Connection conn = DBConnection.connect(); PreparedStatement ps = conn.prepareStatement("SELECT *, users.fullname AS fullname, users.email AS email FROM holidays JOIN users ON holidays.user_id = users.user_id WHERE status IN ('approved', 'pending')")) {

            ResultSet rs = null;

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            //JSON Arrary
            //Turn db columns and data into JSON format for fullCalendar
            JSONArray events = new JSONArray();

            try {
                rs = ps.executeQuery();
                Set<Integer> addedIds = new HashSet<>();
                while (rs.next()) {

                    int holidayId = rs.getInt("holidays_id");

                    // skip if already added
                    if (addedIds.contains(holidayId)) {
                        continue;
                    }

                    addedIds.add(holidayId);

                    JSONObject event = new JSONObject();

                    Date endDate = rs.getDate("end_date");
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(endDate);
                    cal.add(Calendar.DATE, 1);

                    event.put("id", holidayId);
                    event.put("userId", rs.getInt("user_id"));
                    event.put("title", rs.getString("fullname"));
                    event.put("start", sdf.format(rs.getDate("start_date")));
                    event.put("end", sdf.format(cal.getTime()));
                    event.put("allDay", true);
                    event.put("motif", rs.getString("motif"));
                    event.put("leaveType", rs.getString("type"));
                    event.put("responseMessage", rs.getString("response_message"));

                    event.put("leaveId", rs.getInt("holidays_id"));
                    event.put("fullName", rs.getString("fullname")); // JOIN users table
                    event.put("email", rs.getString("email"));        // JOIN users table

                    // color by status
                    String status = rs.getString("status");
                    event.put("status", rs.getString("status"));
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
            } catch (SQLException e1) {
                logger.error("Error linkage to db_holidays: " + e1.getMessage());
            }
            ps.close();
            conn.close();

        } catch (Exception e) {
            logger.error("Error displaying Calendar Leaves: " + e.getMessage());
        }
    }
}
