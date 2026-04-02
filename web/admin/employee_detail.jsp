<%-- 
    Document   : employee_detail
    Created on : 5 janv. 2026, 17:05:59
    Author     : HP
--%>

<%@page import="javafiles.userdataDAO"%>
<%@page import="javafiles.EmployeeInfo"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="../css/admin/emp_detail_styles.css">


    </head>
    <body>
        <%
            userdataDAO dao = new userdataDAO();
            List<EmployeeInfo> v2 = dao.getEmployeeInfo();
        %>
        <div class="layout">
            <aside class="sidebar">

                <%
                    String selectedAvatar = "../images/avatar1.jpg";
                %>
                <img src="<%= selectedAvatar%>" alt="User Avatar" class="avatar"/>

                <% String employee = request.getParameter("fullname");%>
                <h2 class="name">
                    Nom : <%= employee %>
                </h2>
            </aside>

            <div class="panel">

                <p> Je suis là </p> 

            </div>
        </div>

    </body>
</html>
