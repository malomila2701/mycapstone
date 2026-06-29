/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author HP
 */
@WebServlet("/LeaveBalanceServlet")
public class LeaveBalanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // If user_id param is passed (admin use), use it — otherwise fall back to session
        String paramId = request.getParameter("user_id");
        int userId = (paramId != null && !paramId.isEmpty())
                ? Integer.parseInt(paramId)
                : (int) session.getAttribute("user_id");

        userdataDAO dao = new userdataDAO();
        try {
            LeaveBalance lb = dao.getLeaveBalanceByUser(userId);
            response.setContentType("application/json");
            response.getWriter().write(
                    "{\"daysUsed\":" + lb.getDaysUsed()
                    + ",\"leaveBalance\":" + lb.getLeaveBalance() + "}"
            );
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
