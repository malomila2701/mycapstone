<%-- 
    Document   : employees
    Created on : 15 déc. 2025, 14:33:00
    Author     : HP
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javafiles.userdataDAO"%>
<%@page import="javafiles.EmployeeInfo"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="../css/admin/adm_employees_styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>
    <body>
        <%
            userdataDAO dao = new userdataDAO();
            List<EmployeeInfo> v2 = dao.getEmployeeInfo();

            String selectedAvatar = "../images/avatar1.jpg";
        %>



        <table class ="table-cards" cellspacing="0">

            <tbody>
                <%
                    if (v2 == null || v2.isEmpty()) {
                %>
                <tr>
                    <td style="border: 1px solid black; text-align: center; color: red;">
                        No employees found
                    </td>
                </tr>
                <%
                } else {
                    for (EmployeeInfo e : v2) {
                %>
                <tr>

                    <td style="display:flex; flex-direction: row; margin-left: 10px; padding-bottom: 40px; padding-right: 15px;">

                        <input type="checkbox" name="selectedUsers">

                        <div style="display:flex; flex-direction: column;">
                            <h1 style="font-size: 1.1rem; font-weight: 700; margin-top:15px; ">#100<%=e.getUserId()%></h1> 

                            <div class="card">
                                <!-- Left: Avatar + Name/Type -->
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <!-- Avatar -->
                                    <img src="<%= selectedAvatar%>" alt="User Avatar" style="width: 50px; height: 50px; border-radius: 50%;"/>

                                    <!-- Name + Holiday Type -->
                                    <div style="display: flex; flex-direction: column;">
                                        <span style="font-weight: 600;"><%=e.getFullName()%></span>
                                        <span style="margin-left: 3px; font-size: 0.8rem; color: lightslategray"><%= e.getRole()%></span>


                                        <div style="flex:1; flex-direction:row; margin-top: 5px; align-items: center; gap: 10px;">
                                            <!-- Modify button -->
                                            <a href="editEmployee.jsp?userId=<%= e.getUserId()%>" class="button" id="edit-btn">
                                                <i class="fa-regular fa-pen-to-square"></i> Edit
                                            </a>
                                            <!-- Delete button -->
                                            <form action="deleteEmployee" method="post" style="display:inline;">
                                                <input type="hidden" name="userId" value="${emp.userId}">
                                                <button type="submit" id="remove-btn" onclick="return confirm('Delete this employee?');">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </div>

                                    </div>
                                </div>

                                <%
                                    int userId = e.getUserId();
                                    String value = dao.getInfo(userId);
                                %>
                                <div class="details" style="display:grid; grid-template-columns: repeat(3, 1fr);
                                     margin-left: 25px; gap: 5px;">
                                    <p><strong>Entrance:</strong> 2024-03-21</p>
                                    <p><strong>Seniority:</strong> 2 year(s)</p>
                                    <p style="white-space: nowrap;"><strong>Email:</strong><%=e.getEmail()%></p>
                                    <p style="white-space: nowrap;"><strong>Leave Balance:</strong> 24 days </p>
                                    <p><strong>Latest Leave:</strong><%=value%></p>
                                    <p style="white-space: nowrap;"><strong>Phone:</strong> (+225) 000-000-00</p>
                                </div>
                            </div>
                        </div>

                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>

        <script src="../scripts/utils.js"></script>

    </body>
</html>
