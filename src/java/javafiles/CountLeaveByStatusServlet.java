/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author HP
 */
@WebServlet("/CountLeaveByStatus")
public class CountLeaveByStatusServlet extends HttpServlet {
    
    private userdataDAO dao = new userdataDAO();
    private static final Logger logger = LogManager.getLogger(CountLeaveByStatusServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
         JSONObject result = new JSONObject();
    try {
        Map<String, Integer> counts = dao.countRequestsByStatus();
        for (Map.Entry<String, Integer> entry : counts.entrySet()) {
            result.put(entry.getKey(), entry.getValue());
        }
    } catch (Exception ex) {
        logger.error("ERROR COUNT_LEAVE_BY_STATUS SERVLET : " + ex.getMessage());
    }

    response.getWriter().write(result.toString());
    }
}
