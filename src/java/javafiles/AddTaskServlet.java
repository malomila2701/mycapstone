/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;

/**
 *
 * @author HP
 */
@WebServlet("/addTask")
public class AddTaskServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(AddTaskServlet.class.getName());
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // parse JSON body
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) sb.append(line);

        JSONObject json = new JSONObject(sb.toString());
        String title     = json.getString("title");
        String date      = json.getString("date");
        String startTime = json.getString("start_time");
        String endTime   = json.getString("end_time");
        //String priority  = json.getString("priority");*/

        String sql = "INSERT INTO agenda (title, start_date, end_date, start_time, end_time) VALUES (?, ?, ?, ?, ?)";

        try (java.sql.Connection conn = DBConnection.connect();
             java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, title);
            stmt.setDate(2, java.sql.Date.valueOf(date));
            stmt.setDate(3, java.sql.Date.valueOf(date));
            stmt.setTime(4, java.sql.Time.valueOf(startTime + ":00"));
            stmt.setTime(5, java.sql.Time.valueOf(endTime + ":00"));
            stmt.executeUpdate();

            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\"}");

        } catch (SQLException e) {
            logger.error("ERROR ADDING AGENDA TASK: " + e.getMessage());
            response.setStatus(500);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        } catch (Exception ex) {
            System.getLogger(AddTaskServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
    }
}
