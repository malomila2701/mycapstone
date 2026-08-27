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
        String response_message = request.getParameter("admin_message");

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
            String sqlUser = "SELECT u.username, u.email, h.start_date, h.end_date, h.type, h.motif, h.response_message "
                    + "FROM users u JOIN holidays h ON u.user_id = h.user_id "
                    + "WHERE h.holidays_id = ?";
            java.sql.PreparedStatement psUser = conn.prepareStatement(sqlUser);
            psUser.setInt(1, id);
            java.sql.ResultSet rs = psUser.executeQuery();

            if (rs.next()) {
                String employeeName = rs.getString("fullname");
                String employeeEmail = rs.getString("email");
                String startDate = rs.getString("start_date");
                String endDate = rs.getString("end_date");
                String leaveType = rs.getString("type");
                String reason = rs.getString("motif");
                String adminMessage = rs.getString("response_message");
                String initials = employeeName.substring(0, Math.min(2, employeeName.length())).toUpperCase();
                String reqId = "REQ-" + java.time.Year.now().getValue() + "-" + String.format("%04d", id);
                /**
                 * String adminMessage = (response_message != null &&
                 * !response_message.isEmpty()) ? response_message : "No
                 * additional message.";
                 */

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
        return "<!DOCTYPE html><html><body style='margin:0;padding:0;background:#f0fdf4;font-family:Arial,Helvetica,sans-serif;'>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#f0fdf4;'>"
                + "<tr><td align='center' style='padding:20px 10px;'>"
                + "<table role='presentation' width='420' cellpadding='0' cellspacing='0' border='0' style='width:420px;max-width:100%;background:#fff;border:1px solid #bbf7d0;border-radius:16px;'>"
                + "<tr><td style='padding:24px;'>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;border-bottom:1px solid #bbf7d0;margin-bottom:14px;'>"
                + "<tr>"
                + "<td style='padding-bottom:10px;'>"
                + "<div style='font-size:15px;font-weight:600;color:#1E293B;line-height:20px;'>Request Details</div>"
                + "<div style='font-size:12px;color:#64748B;line-height:18px;'>" + reqId + "</div>"
                + "</td>"
                + "<td width='30' align='right' valign='middle' style='width:30px;padding-bottom:10px;'>"
                + "<div style='width:30px;height:30px;background:#dcfce7;border-radius:50%;text-align:center;line-height:30px;font-size:16px;color:#16a34a;'>&#10003;</div>"
                + "</td>"
                + "</tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#f0fdf4;border:1px solid #bbf7d0;border-radius:14px;margin-bottom:10px;'>"
                + "<tr><td style='padding:10px;'>"
                + "<table role='presentation' cellpadding='0' cellspacing='0' border='0'>"
                + "<tr>"
                + "<td width='36' valign='middle' style='width:36px;'>"
                + "<div style='width:36px;height:36px;border-radius:50%;background:#16a34a;color:#fff;font-weight:bold;font-size:13px;text-align:center;line-height:36px;'>" + initials + "</div>"
                + "</td>"
                + "<td width='10' style='width:10px;font-size:0;line-height:0;'>&nbsp;</td>"
                + "<td valign='middle'>"
                + "<div style='font-size:13px;font-weight:600;color:#1E293B;line-height:18px;'>" + employeeName + "</div>"
                + "<div style='font-size:11px;color:#64748B;line-height:17px;'>&#9993; " + employeeEmail + "</div>"
                + "</td>"
                + "</tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;border:1px solid #bbf7d0;border-radius:14px;margin-bottom:10px;'>"
                + "<tr><td style='padding:10px 14px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:6px;line-height:14px;'>Leave period</div>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;'>"
                + "<tr>"
                + "<td align='left' style='font-size:12px;color:#333;white-space:nowrap;'>&#128197; " + startDate + "</td>"
                + "<td align='center' width='30' style='width:30px;color:#16a34a;font-size:14px;font-weight:bold;'>&rarr;</td>"
                + "<td align='right' style='font-size:12px;color:#333;white-space:nowrap;'>&#128197; " + endDate + "</td>"
                + "</tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;margin-bottom:10px;'>"
                + "<tr>"
                + "<td width='50%' valign='top' style='width:50%;padding:0 4px 0 0;'>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;border:1px solid #bbf7d0;border-radius:12px;'>"
                + "<tr><td style='padding:8px 12px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:4px;line-height:14px;'>Leave type</div>"
                + "<span style='display:inline-block;padding:2px 10px;border:1px solid #bbf7d0;border-radius:9999px;font-size:12px;line-height:16px;color:#333;'>" + leaveType + "</span>"
                + "</td></tr>"
                + "</table>"
                + "</td>"
                + "<td width='50%' valign='top' style='width:50%;padding:0 0 0 4px;'>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#f0fdf4;border:1px solid #bbf7d0;border-radius:12px;'>"
                + "<tr><td style='padding:8px 12px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:4px;line-height:14px;'>Status</div>"
                + "<span style='display:inline-block;background:#dcfce7;color:#16a34a;border-radius:20px;padding:2px 10px;font-size:11px;font-weight:600;line-height:16px;'>&#10003; APPROVED</span>"
                + "</td></tr>"
                + "</table>"
                + "</td>"
                + "</tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;margin-bottom:10px;'>"
                + "<tr><td>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:4px;line-height:14px;'>Reason / Motif</div>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;border:1px solid #bbf7d0;border-radius:14px;'>"
                + "<tr><td style='padding:8px 12px;font-size:12px;line-height:18px;color:#333;'>" + reason + "</td></tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;margin-bottom:14px;'>"
                + "<tr><td>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:4px;line-height:14px;'>HR Note</div>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#f0fdf4;border:1px solid #bbf7d0;border-radius:14px;'>"
                + "<tr><td style='padding:8px 12px;font-size:12px;line-height:18px;color:#333;'>" + adminMessage + "</td></tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#f0fdf4;border-radius:10px;border:1px solid #bbf7d0;'>"
                + "<tr><td align='center' style='padding:14px;'>"
                + "<div style='font-size:22px;line-height:26px;'>&#127881;</div>"
                + "<div style='font-size:13px;font-weight:600;color:#16a34a;margin-top:4px;line-height:18px;'>Your leave request has been approved!</div>"
                + "<div style='font-size:11px;color:#64748B;margin-top:2px;line-height:16px;'>Enjoy your time off. Have a great break!</div>"
                + "</td></tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "</body></html>";

    }

    // ─── REJECTED EMAIL ───────────────────────────────────────────────────────
    private String buildRejectedEmail(String reqId, String initials, String employeeName,
            String employeeEmail, String startDate, String endDate,
            String leaveType, String reason, String adminMessage) {
        return "<!DOCTYPE html><html><body style='margin:0;padding:0;background:#fff5f5;font-family:Arial,Helvetica,sans-serif;'>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#fff5f5;'>"
                + "<tr><td align='center' style='padding:20px 10px;'>"
                + "<table role='presentation' width='420' cellpadding='0' cellspacing='0' border='0' style='width:420px;max-width:100%;background:#fff;border:1px solid #fecaca;border-radius:16px;'>"
                + "<tr><td style='padding:24px;'>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;border-bottom:1px solid #fecaca;margin-bottom:14px;'>"
                + "<tr>"
                + "<td style='padding-bottom:10px;'>"
                + "<div style='font-size:15px;font-weight:600;color:#7f1d1d;line-height:20px;'>Request Details</div>"
                + "<div style='font-size:12px;color:#991b1b;line-height:18px;'>" + reqId + "</div>"
                + "</td>"
                + "<td width='30' align='right' valign='middle' style='width:30px;padding-bottom:10px;'>"
                + "<div style='width:30px;height:30px;background:#fee2e2;border-radius:50%;text-align:center;line-height:30px;font-size:16px;color:#dc2626;'>&#10005;</div>"
                + "</td>"
                + "</tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#fef2f2;border:1px solid #fecaca;border-radius:14px;margin-bottom:12px;'>"
                + "<tr><td style='padding:10px;'>"
                + "<table role='presentation' cellpadding='0' cellspacing='0' border='0'>"
                + "<tr>"
                + "<td width='40' valign='middle' style='width:40px;'>"
                + "<div style='width:40px;height:40px;border-radius:50%;background:#dc2626;color:#fff;font-weight:bold;font-size:15px;text-align:center;line-height:40px;'>"
                + initials
                + "</div>"
                + "</td>"
                + "<td width='10' style='width:10px;font-size:0;line-height:0;'>&nbsp;</td>"
                + "<td valign='middle'>"
                + "<div style='font-weight:600;font-size:14px;color:#7f1d1d;line-height:19px;'>" + employeeName + "</div>"
                + "<div style='font-size:12px;color:#991b1b;margin-top:2px;line-height:17px;'>&#9993; " + employeeEmail + "</div>"
                + "</td>"
                + "</tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;border:1px solid #fecaca;border-radius:14px;margin-bottom:10px;'>"
                + "<tr><td style='padding:10px 14px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:6px;line-height:14px;'>Leave period</div>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;'>"
                + "<tr>"
                + "<td align='left' style='font-size:12px;color:#333;white-space:nowrap;'>&#128197; " + startDate + "</td>"
                + "<td align='center' width='30' style='width:30px;color:#dc2626;font-size:14px;font-weight:bold;'>&rarr;</td>"
                + "<td align='right' style='font-size:12px;color:#333;white-space:nowrap;'>&#128197; " + endDate + "</td>"
                + "</tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;margin-bottom:10px;'>"
                + "<tr>"
                + "<td width='50%' valign='top' style='width:50%;padding:0 4px 0 0;'>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;border:1px solid #fecaca;border-radius:12px;'>"
                + "<tr><td style='padding:8px 12px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:4px;line-height:14px;'>Leave type</div>"
                + "<span style='display:inline-block;padding:2px 10px;border:1px solid #fecaca;border-radius:9999px;font-size:12px;line-height:16px;color:#333;'>" + leaveType + "</span>"
                + "</td></tr>"
                + "</table>"
                + "</td>"
                + "<td width='50%' valign='top' style='width:50%;padding:0 0 0 4px;'>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#fff5f5;border:1px solid #fecaca;border-radius:12px;'>"
                + "<tr><td style='padding:8px 12px;'>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:4px;line-height:14px;'>Status</div>"
                + "<span style='display:inline-block;background:#fee2e2;color:#dc2626;border-radius:20px;padding:2px 10px;font-size:11px;font-weight:600;line-height:16px;'>&#10005; REJECTED</span>"
                + "</td></tr>"
                + "</table>"
                + "</td>"
                + "</tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;margin-bottom:10px;'>"
                + "<tr><td>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:4px;line-height:14px;'>Reason / Motif</div>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;border:1px solid #fecaca;border-radius:14px;'>"
                + "<tr><td style='padding:8px 12px;font-size:12px;line-height:18px;color:#333;'>" + reason + "</td></tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;margin-bottom:14px;'>"
                + "<tr><td>"
                + "<div style='font-size:10px;font-weight:600;text-transform:uppercase;color:#78909C;margin-bottom:4px;line-height:14px;'>HR Note</div>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#fff5f5;border:1px solid #fecaca;border-radius:14px;'>"
                + "<tr><td style='padding:8px 12px;font-size:12px;line-height:18px;color:#333;'>" + adminMessage + "</td></tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "<table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;background:#fff5f5;border-radius:10px;border:1px solid #fecaca;'>"
                + "<tr><td align='center' style='padding:14px;'>"
                + "<div style='font-size:22px;line-height:26px;'>&#128533;</div>"
                + "<div style='font-size:13px;font-weight:600;color:#dc2626;margin-top:4px;line-height:18px;'>Your leave request has been rejected.</div>"
                + "<div style='font-size:11px;color:#64748B;margin-top:2px;line-height:16px;'>Please contact HR for more information.</div>"
                + "</td></tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "</td></tr>"
                + "</table>"
                + "</body></html>";
    }
}
