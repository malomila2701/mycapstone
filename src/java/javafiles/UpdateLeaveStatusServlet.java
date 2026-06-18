/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
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
@WebServlet("/UpdateLeaveStatusServlet")
public class UpdateLeaveStatusServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(UpdateLeaveStatusServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int userId = Integer.parseInt(request.getParameter("user_id"));
        int id = Integer.parseInt(request.getParameter("holidays_id"));
        String status = request.getParameter("status");
        String response_message = request.getParameter("response_message");

        try (Connection conn = DBConnection.connect()) {
            String sql = "UPDATE holidays SET status=?, response_message=? WHERE holidays_id=?";
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, response_message);
            ps.setInt(3, id);
            ps.executeUpdate();

            // 2. Insertion dans notifications
            String sqlNotif = "INSERT INTO notifications (user_id, holiday_id, message, created_at) VALUES (?,?,?, NOW())";
            java.sql.PreparedStatement psNotif = conn.prepareStatement(sqlNotif);
            psNotif.setInt(1, userId);
            psNotif.setInt(2, id);
            //psNotif.setNull(3, java.sql.Types.INTEGER);
            psNotif.setString(3, "Permission #" + id + " has been : " + status + "!");
            psNotif.executeUpdate();

            // 3. Fetch employee info for email
            String sqlUser = "SELECT u.username, u.email, h.start_date, h.end_date, h.type, h.motif "
                    + "FROM users u JOIN holidays h ON u.user_id = h.user_id "
                    + "WHERE h.holidays_id = ?";
            java.sql.PreparedStatement psUser = conn.prepareStatement(sqlUser);
            psUser.setInt(1, id);
            java.sql.ResultSet rs = psUser.executeQuery();

            if (rs.next()) {
                String employeeName = rs.getString("username");
                String employeeEmail = rs.getString("email");
                String startDate = rs.getString("start_date");
                String endDate = rs.getString("end_date");
                String leaveType = rs.getString("type");
                String reason = rs.getString("motif");
                String initials = employeeName.substring(0, Math.min(2, employeeName.length())).toUpperCase();
                String reqId = "REQ-" + java.time.Year.now().getValue() + "-" + String.format("%04d", id);
                String adminMessage = (response_message != null && !response_message.isEmpty())
                        ? response_message : "No additional message.";

                String subject;
                String htmlBody;

                if (status.equalsIgnoreCase("Approved")) {
                    subject = "Your leave request has been approved – " + reqId;
                    htmlBody = buildApprovedEmail(reqId, initials, employeeName, employeeEmail,
                            startDate, endDate, leaveType, reason, adminMessage);
                } else if (status.equalsIgnoreCase("Rejected")) {
                    subject = "Your leave request has been rejected – " + reqId;
                    htmlBody = buildRejectedEmail(reqId, initials, employeeName, employeeEmail,
                            startDate, endDate, leaveType, reason, adminMessage);
                } else {
                    subject = null;
                    htmlBody = null;
                }

                if (subject != null) {
                    EmailService.sendEmail(employeeEmail, subject, htmlBody);
                }
            }

        } catch (Exception e) {
            logger.error("Error UPDATING HOLIDAY status: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/requests.jsp");
    }

    // ─── APPROVED EMAIL ───────────────────────────────────────────────────────
    private String buildApprovedEmail(String reqId, String initials, String employeeName,
            String employeeEmail, String startDate, String endDate,
            String leaveType, String reason, String adminMessage) {
        return "<!DOCTYPE html><html><body style='margin:0;padding:20px;background:#f0fdf4;font-family:Arial,sans-serif;'>"
                + "<div style='max-width:420px;margin:auto;background:#fff;border-radius:16px;padding:24px;border:1px solid #bbf7d0;'>"
                + "<div style='border-bottom:0.5px solid #bbf7d0;padding-bottom:10px;margin-bottom:14px;display:flex;justify-content:space-between;align-items:center;'>"
                + "<div><div style='font-size:15px;font-weight:600;color:#1E293B;'>Request Details</div>"
                + "<div style='font-size:12px;color:#64748B;'>" + reqId + "</div></div>"
                + "<div style='background:#dcfce7;border-radius:50%;width:30px;height:30px;text-align:center;line-height:30px;font-size:16px;'>&#10003;</div>"
                + "</div>"
                //Employee
                + "<div style='background:#f0fdf4;padding:10px;border:1px solid #bbf7d0;border-radius:14px;margin-bottom:10px;display:flex;align-items:center;'>"
                + "<div style='width:36px;height:36px;border-radius:50%;background:#16a34a;color:#fff;font-weight:bold;font-size:13px;text-align:center;line-height:36px;margin-right:10px;'>" + initials + "</div>"
                + "<div><div style='font-size:13px;font-weight:600;color:#1E293B;'>" + employeeName + "</div>"
                + "<div style='font-size:11px;color:#64748B;'>&#9993; " + employeeEmail + "</div></div></div>"
                + "<div style='padding:10px 14px;border:1px solid #bbf7d0;border-radius:14px;margin-bottom:10px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:6px;'>Leave period</div>"
                + "<div style='display:flex;align-items:center;justify-content:space-between;font-size:12px;color:#333;'>"
                + "<span>&#128197; " + startDate + "</span><span style='color:#16a34a;font-weight:bold;'>&rarr;</span><span>&#128197; " + endDate + "</span></div></div>"
                + "<div style='display:flex;gap:8px;margin-bottom:10px;'>"
                + "<div style='flex:1;padding:8px 12px;border:1px solid #bbf7d0;border-radius:12px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:4px;'>Leave type</div>"
                + "<span style='padding:2px 10px;border:1px solid #bbf7d0;border-radius:9999px;font-size:12px;color:#333;'>" + leaveType + "</span></div>"
                + "<div style='flex:1;background:#f0fdf4;padding:8px 12px;border:1px solid #bbf7d0;border-radius:12px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:4px;'>Status</div>"
                + "<span style='background:#dcfce7;color:#16a34a;border-radius:20px;padding:2px 10px;font-size:11px;font-weight:600;'>&#10003; APPROVED</span></div></div>"
                + "<div style='margin-bottom:10px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:4px;'>Reason / Motif</div>"
                + "<div style='padding:8px 12px;border:1px solid #bbf7d0;border-radius:14px;font-size:12px;color:#333;'>" + reason + "</div></div>"
                + "<div style='margin-bottom:14px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:4px;'>HR Note</div>"
                + "<div style='padding:8px 12px;background:#f0fdf4;border:1px solid #bbf7d0;border-radius:14px;font-size:12px;color:#333;'>" + adminMessage + "</div></div>"
                + "<div style='text-align:center;padding:14px;background:#f0fdf4;border-radius:10px;border:1px solid #bbf7d0;'>"
                + "<div style='font-size:22px;'>&#127881;</div>"
                + "<div style='font-size:13px;font-weight:600;color:#16a34a;margin-top:4px;'>Your leave request has been approved!</div>"
                + "<div style='font-size:11px;color:#64748B;margin-top:2px;'>Enjoy your time off. Have a great break!</div></div>"
                + "</div></body></html>";
    }

    // ─── REJECTED EMAIL ───────────────────────────────────────────────────────
    private String buildRejectedEmail(String reqId, String initials, String employeeName,
            String employeeEmail, String startDate, String endDate,
            String leaveType, String reason, String adminMessage) {
        return "<!DOCTYPE html><html><body style='margin:0;padding:20px;background:#fff5f5;font-family:Arial,sans-serif;'>"
                + "<div style='max-width:420px;margin:auto;background:#fff;border-radius:16px;padding:24px;border:1px solid #fecaca;'>"
                + "<div style='border-bottom:0.5px solid #fecaca;padding-bottom:10px;margin-bottom:14px;'>"
                + "<div style='font-size:15px;font-weight:600;color:#7f1d1d;'>Request Details</div>"
                + "<div style='font-size:12px;color:#991b1b;'>" + reqId + "</div>"
                + "</div>"
                //Employee section
                + "<div style='background:#fef2f2;padding:10px;border:1px solid #fecaca;border-radius:20px;margin-bottom:12px;'>"
                + "<div style='display:flex;align-items:center;'>"
                + "<div style='width:40px;height:40px;border-radius:50%;background:#dc2626;color:#fff;font-weight:bold;font-size:15px;text-align:center;line-height:40px;margin-right:10px;'>"
                + initials
                + "</div>"
                + "<div>"
                + "<div style='font-weight:600;font-size:14px;color:#7f1d1d;'>" + employeeName + "</div>"
                + "<div style='font-size:12px;color:#991b1b;margin-top:2px;'>&#9993; " + employeeEmail + "</div>"
                + "</div>"
                + "</div>"
                + "</div>"
                + "<div style='padding:10px 14px;border:1px solid #fecaca;border-radius:14px;margin-bottom:10px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:6px;'>Leave period</div>"
                + "<div style='display:flex;align-items:center;justify-content:space-between;font-size:12px;color:#333;'>"
                + "<span>&#128197; " + startDate + "</span><span style='color:#dc2626;'>&rarr;</span><span>&#128197; " + endDate + "</span></div></div>"
                + "<div style='display:flex;gap:8px;margin-bottom:10px;'>"
                + "<div style='flex:1;padding:8px 12px;border:1px solid #fecaca;border-radius:12px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:4px;'>Leave type</div>"
                + "<span style='padding:2px 10px;border:1px solid #fecaca;border-radius:9999px;font-size:12px;color:#333;'>" + leaveType + "</span></div>"
                + "<div style='flex:1;background:#fff5f5;padding:8px 12px;border:1px solid #fecaca;border-radius:12px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:4px;'>Status</div>"
                + "<span style='background:#fee2e2;color:#dc2626;border-radius:20px;padding:2px 10px;font-size:11px;font-weight:600;'>&#10005; REJECTED</span></div></div>"
                + "<div style='margin-bottom:10px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:4px;'>Reason / Motif</div>"
                + "<div style='padding:8px 12px;border:1px solid #fecaca;border-radius:14px;font-size:12px;color:#333;'>" + reason + "</div></div>"
                + "<div style='margin-bottom:14px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:lightslategray;margin-bottom:4px;'>HR Note</div>"
                + "<div style='padding:8px 12px;background:#fff5f5;border:1px solid #fecaca;border-radius:14px;font-size:12px;color:#333;'>" + adminMessage + "</div></div>"
                + "<div style='text-align:center;padding:14px;background:#fff5f5;border-radius:10px;border:1px solid #fecaca;'>"
                + "<div style='font-size:22px;'>&#128533;</div>"
                + "<div style='font-size:13px;font-weight:600;color:#dc2626;margin-top:4px;'>Your leave request has been rejected.</div>"
                + "<div style='font-size:11px;color:#64748B;margin-top:2px;'>Please contact HR for more information.</div></div>"
                + "</div></body></html>";
    }
}
