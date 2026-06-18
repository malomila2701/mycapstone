/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.*;
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

        //Retrieved from session
        String username = (String) session.getAttribute("username");
        String employeeEmail = (String) session.getAttribute("email");

        //Param forms
        String start_date = request.getParameter("eventStart");
        String end_date = request.getParameter("eventEnd");
        String type = request.getParameter("eventType");
        String motif = request.getParameter("eventDescription");

        java.sql.Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DBConnection.connect();

            String sql = "INSERT INTO holidays(user_id, start_date, end_date, type, motif, status) values (?,?,?,?,?, 'Pending')";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, userId);
            stmt.setString(2, start_date);
            stmt.setString(3, end_date);
            stmt.setString(4, type);
            stmt.setString(5, motif);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("responseMessage", "User registered successfully!");
                request.setAttribute("responseStatus", "success");

                ResultSet rs = stmt.getGeneratedKeys();
                int leaveId = rs.next() ? rs.getInt(1) : 0;
                String reqId = "REQ-" + java.time.Year.now().getValue() + "-" + String.format("%04d", leaveId);
                String initials = username.substring(0, Math.min(2, username.length())).toUpperCase();

                // HTML email
                String subject = "New Leave Request – " + username;
                String htmlBody = "<!DOCTYPE html><html><body style='margin:0;padding:20px;background:#f1f5f9;font-family:Arial,sans-serif;'>"
                        + "<div style='max-width:420px;margin:auto;background:#fff;border-radius:16px;padding:24px;border:1px solid #e2e8f0;'>"
                        // Header
                        + "<div style='border-bottom:1px solid #ccc;padding-bottom:12px;margin-bottom:16px;'>"
                        + "<h2 style='margin:0;font-size:18px;font-weight:600;color:#1E293B;'>Request Details</h2>"
                        + "<span style='font-size:13px;color:#64748B;'>" + reqId + "</span>"
                        + "</div>"
                        // Employee
                        + "<div style='background:#f3f6fa;padding:10px;border:1px solid #E2E8F0;border-radius:20px;margin-bottom:12px;'>"
                        + "<div style='display:flex;align-items:center;'>"
                        + "<div style='width:40px;height:40px;border-radius:50%;background:#0078d7;color:#fff;font-weight:bold;font-size:15px;text-align:center;line-height:40px;margin-right:10px;'>" + initials + "</div>"
                        + "<div>"
                        + "<div style='font-weight:600;font-size:14px;color:#1E293B;'>" + username + "</div>"
                        + "<div style='font-size:12px;color:#64748B;margin-top:2px;'>&#9993; " + employeeEmail + "</div>"
                        + "</div></div></div>"
                        // Leave Period
                        + "<div style='background:#fff;padding:10px 15px;border:1px solid #ccc;border-radius:20px;margin-bottom:12px;'>"
                        + "<div style='font-size:11px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:8px;'>Leave Period</div>"
                        + "<div style='display:flex;align-items:center;justify-content:space-between;'>"
                        + "<span style='font-size:13px;color:#333;'>&#128197; " + start_date + "</span>"
                        + "<span style='color:#888;'>&rarr;</span>"
                        + "<span style='font-size:13px;color:#333;'>&#128197; " + end_date + "</span>"
                        + "</div></div>"
                        // Leave Type & Status
                        + "<div style='display:flex;gap:12px;margin-bottom:12px;'>"
                        + "<div style='flex:1;padding:10px 15px;border:1px solid #E2E8F0;border-radius:16px;'>"
                        + "<div style='font-size:11px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:6px;'>Leave Type</div>"
                        + "<span style='padding:4px 12px;border:1px solid #E2E8F0;border-radius:9999px;font-size:13px;font-weight:600;color:#333;'>" + type + "</span>"
                        + "</div>"
                        + "<div style='flex:1;background:#f3f6fa;padding:10px 15px;border:1px solid #E2E8F0;border-radius:16px;'>"
                        + "<div style='font-size:11px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:6px;'>Status</div>"
                        + "<span style='display:inline-block;background:#fef9c3;color:#854d0e;border-radius:20px;padding:4px 12px;font-size:12px;font-weight:600;'>&#9203; PENDING</span>"
                        + "</div></div>"
                        // Reason
                        + "<div style='margin-bottom:12px;'>"
                        + "<div style='font-size:11px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-left:10px;margin-bottom:6px;'>Reason / Motif</div>"
                        + "<div style='background:transparent;padding:10px 15px;border:1px solid #444;border-radius:20px;font-size:13px;color:#333;'>" + motif + "</div>"
                        + "</div>"
                        // Footer
                        + "<div style='margin-top:20px;text-align:center;font-size:12px;color:#94a3b8;'>This is an automated notification. Please review the request in the system.</div>"
                        + "</div></body></html>";

                // Send emails
                String hrEmail = "jeansamu001@gmail.com";
                String managerEmail = "jeansamu007@gmail.com";

                EmailService.sendEmail(hrEmail, subject, htmlBody);
                EmailService.sendEmail(managerEmail, subject, htmlBody);
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
