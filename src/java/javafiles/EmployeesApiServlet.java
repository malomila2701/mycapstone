/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import com.fasterxml.jackson.databind.ObjectMapper;/**
 *
 * @author HP
 */
@WebServlet("/api/employees")
public class EmployeesApiServlet extends HttpServlet {
    
        private static final Logger logger = LogManager.getLogger(EmployeesApiServlet.class.getName());


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            userdataDAO dao = new userdataDAO();
            List<EmployeeInfo> employees = dao.getEmployeeInfo();

            // On construit une liste de DTOs "propres" pour le JSON
            List<Map<String, Object>> jsonList = new ArrayList<>();

            for (EmployeeInfo e : employees) {
                Map<String, Object> emp = new LinkedHashMap<>();
                int userId = e.getUserId();

                emp.put("userId", userId);
                emp.put("fullName", e.getFullName());
                emp.put("gender", e.getGender());
                emp.put("email", e.getEmail());
                emp.put("role", e.getRole());
                emp.put("mobilePhone", e.getMobilePhone());

                // Pas le BLOB -> une URL vers l'avatar existant
                emp.put("avatarUrl", request.getContextPath() + "/AvatarServlet?userId=" + userId);

                // Latest leave (comme dans ta JSP actuelle)
                String latestLeave = dao.getInfo(userId);
                emp.put("latestLeave", (latestLeave == null || latestLeave.trim().isEmpty()) ? "—" : latestLeave);

                // Champs holiday déjà présents dans EmployeeInfo si tu les as mappés
                emp.put("leaveStartDate", e.getStartDate());
                emp.put("leaveEndDate", e.getEndDate());
                emp.put("leaveType", e.getType());
                emp.put("leaveStatus", e.getStatus());

                jsonList.add(emp);
            }

            ObjectMapper mapper = new ObjectMapper();
            mapper.writeValue(response.getWriter(), jsonList);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
            logger.error("ERROR EMPLOYEES API SERVLET / REACT : " + e.getMessage());
            
        }
    }
}
