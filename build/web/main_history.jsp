<%-- 
    Document   : main_history
    Created on : Apr 1, 2026, 10:35:55 PM
    Author     : JeanSamuel
--%>

<%@page import="javafiles.userdataDAO"%>
<%@page import="javafiles.UserPending"%>
<%@page import="javafiles.UserPermission"%>
<%@page import="javafiles.UserLeave"%>
<%@page import="javafiles.UserLeave"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User History Page</title>

        <link rel="stylesheet" 
              href="css/main_history_styles.css">

        <script>
            <%
                Integer userId = (Integer) session.getAttribute("user_id");

                if (userId != null) {
            %>
            User ID: <%= userId%>
            <%
                } else {
                    response.sendRedirect("login.jsp");
                }
                userdataDAO dao = new userdataDAO();
            %>
        </script>
        <script>
            <%
                List<UserLeave> v2 = dao.getUserLeave(userId);
                List<UserPermission> v3 = dao.getUserPermission(userId);
                List<UserPending> daoPending = dao.getLeavePending(userId);
                List<UserPermission> daoPermissionPending = dao.getPermissionPending(userId);
            %>
        </script>
        <script>
            function loadNotifications() {
                fetch("<%= request.getContextPath()%>/NotificationServlet")
                        .then(response => {
                            if (!response.ok) {
                                throw new Error("Erreur serveur: " + response.status);
                            }
                            return response.json();
                        })
                        .then(data => {
                            const dot = document.querySelector('.notification-dot');
                            const list = document.getElementById('notificationList');
                            list.innerHTML = "";
                            if (data.unreadCount > 0) {
                                dot.style.display = 'block';
                                if (Array.isArray(data.notifications)) {
                                    data.notifications.forEach(n => {
                                        const li = document.createElement("li");
                                        li.textContent = n.message + " - " + n.created_at;
                                        list.appendChild(li);
                                    });
                                }
                            } else {
                                dot.style.display = 'none';
                            }
                        })
                        .catch(err => {
                            console.error("Probleme lors du chargement des notifications:", err);
                        });
            }

            // Charger au demarrage et rafraichir toutes les 30s
            document.addEventListener("DOMContentLoaded", () => {
                loadNotifications();
                setInterval(loadNotifications, 30000);
            });
        </script>
        <%
            String selectedAvatar = "images/avatar1.jpg";
        %> 
    </head>

    <body>


        <div class="header" id="top-header">
            <div class="header-left">
                <div class="search-box">
                    <input type="text" placeholder="Search">
                </div>
            </div>
            <div class="header-right">
                <div class="header_btn">
                    <button class="header_icon" id="notificationBtn" onclick="toggleDropdownNotifs()">
                        <span class="icon-home" style="width: 20px;"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                            <path d="M4.214 3.227a.75.75 0 0 0-1.156-.955 8.97 8.97 0 0 0-1.856 3.825.75.75 0 0 0 1.466.316 7.47 7.47 0 0 1 1.546-3.186ZM16.942 2.272a.75.75 0 0 0-1.157.955 7.47 7.47 0 0 1 1.547 3.186.75.75 0 0 0 1.466-.316 8.971 8.971 0 0 0-1.856-3.825Z" />
                            <path fill-rule="evenodd" d="M10 2a6 6 0 0 0-6 6c0 1.887-.454 3.665-1.257 5.234a.75.75 0 0 0 .515 1.076 32.91 32.91 0 0 0 3.256.508 3.5 3.5 0 0 0 6.972 0 32.903 32.903 0 0 0 3.256-.508.75.75 0 0 0 .515-1.076A11.448 11.448 0 0 1 16 8a6 6 0 0 0-6-6Zm0 14.5a2 2 0 0 1-1.95-1.557 33.54 33.54 0 0 0 3.9 0A2 2 0 0 1 10 16.5Z" clip-rule="evenodd" />
                            </svg>
                            <span class="notification-dot"></span>
                        </span>
                    </button>
                    <ul id="notificationList" class="dropdown"></ul>

                    <button class="header_icon">
                        <span class="icon-home" style="width: 20px;"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M7.84 1.804A1 1 0 0 1 8.82 1h2.36a1 1 0 0 1 .98.804l.331 1.652a6.993 6.993 0 0 1 1.929 1.115l1.598-.54a1 1 0 0 1 1.186.447l1.18 2.044a1 1 0 0 1-.205 1.251l-1.267 1.113a7.047 7.047 0 0 1 0 2.228l1.267 1.113a1 1 0 0 1 .206 1.25l-1.18 2.045a1 1 0 0 1-1.187.447l-1.598-.54a6.993 6.993 0 0 1-1.929 1.115l-.33 1.652a1 1 0 0 1-.98.804H8.82a1 1 0 0 1-.98-.804l-.331-1.652a6.993 6.993 0 0 1-1.929-1.115l-1.598.54a1 1 0 0 1-1.186-.447l-1.18-2.044a1 1 0 0 1 .205-1.251l1.267-1.114a7.05 7.05 0 0 1 0-2.227L1.821 7.773a1 1 0 0 1-.206-1.25l1.18-2.045a1 1 0 0 1 1.187-.447l1.598.54A6.992 6.992 0 0 1 7.51 3.456l.33-1.652ZM10 13a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />
                            </svg></span>
                    </button>
                    <button class="header_icon" style="margin-right: 5px; border: 2px solid #ccc">
                        <span class="label" style="margin-left: 7px; margin-right: 5px;">Deconnexion</span>
                        <span class="icon-home">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 2a.75.75 0 0 1 .75.75v7.5a.75.75 0 0 1-1.5 0v-7.5A.75.75 0 0 1 10 2ZM5.404 4.343a.75.75 0 0 1 0 1.06 6.5 6.5 0 1 0 9.192 0 .75.75 0 1 1 1.06-1.06 8 8 0 1 1-11.313 0 .75.75 0 0 1 1.06 0Z" clip-rule="evenodd" />
                            </svg></span>
                    </button>
                </div>
            </div>
        </div>

        <!--
        MENU
        -->

        <div class="dashboard">

            <div class="banner" id="welcome">
                <span style="display:flex; font-size: 1.4rem;"> Welcome back <span style="font-weight: normal;">, ${sessionScope.username} ! </span></span>
                <span style="margin-top: 3px; font-size:0.7rem; font-weight:lighter;">Entre(e) le: 19/03/2021 </span>
                <span style="margin-top: 3px; font-size:0.7rem; font-weight:lighter;">Anciennete: 2 an(s)</span>
            </div>

            <div class="banner" id="latest_banner">
                <div class="header">
                    <div class="header-left"> 
                        <button class="icon-btn-header"> <span class="icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                <path d="M5.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H6a.75.75 0 0 1-.75-.75V12ZM6 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H6ZM7.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H8a.75.75 0 0 1-.75-.75V12ZM8 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H8ZM9.25 10a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V10ZM10 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H10ZM9.25 14a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V14ZM12 9.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V10a.75.75 0 0 0-.75-.75H12ZM11.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H12a.75.75 0 0 1-.75-.75V12ZM12 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H12ZM13.25 10a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H14a.75.75 0 0 1-.75-.75V10ZM14 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H14Z" />
                                <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                </svg></span> </button>

                        <span style="
                              font-weight: bold;
                              font-size: 1rem;">

                            Latest Requests</span>
                    </div>
                    <div class="header-right" style="display: flex; align-items: center;">
                        <span style="font-size: 0.9rem; white-space: nowrap;">Status & Action</span>
                    </div>
                </div>

                <div class="bar"></div>

                <table class="reqtable" cellspacing="0" id="latest_b">
                    <tbody>
                        <%
                            boolean isEmpty = (v2 == null || v2.isEmpty()) && (v3 == null || v3.isEmpty());
                            if (isEmpty) {
                        %>
                        <tr>
                            <td colspan="1" style="padding:30px; background:white; text-align:center;
                                border-bottom-left-radius:16px; border-bottom-right-radius:16px; color:red;">
                                No latest holidays found.
                            </td>
                        </tr>
                        <%
                        } else {
                            //  Loop 1: UserLeave (holidays) 
                            if (v2 != null) {
                                for (UserLeave h : v2) {
                                    String status = h.getStatus();
                                    String cssClass = "";
                                    if ("rejected".equalsIgnoreCase(status))
                                        cssClass = "status-rejected";
                                    else if ("approved".equalsIgnoreCase(status))
                                        cssClass = "status-approved";
                                    else if ("pending".equalsIgnoreCase(status))
                                        cssClass = "status-pending";
                        %>
                        <tr>
                            <td style="padding:10px;">
                                <div style="display:flex; justify-content:space-between; align-items:center;">
                                    <!-- Left: Avatar + Name/Type -->
                                    <div style="display:flex; align-items:center; gap:10px;">
                                        <!-- Avatar -->
                                        <img src="<%= selectedAvatar%>" alt="User Avatar" style="padding-left:5%; width:50px; height:50px; border-radius:50%;"/>
                                        <div style="display:flex; flex-direction:column;">
                                            <span style="font-weight:normal; white-space:nowrap;">Holiday on <%= h.getStartDate()%> - <%= h.getEndDate()%></span>
                                            <span style="font-size:0.8rem; color:lightslategray;"><%= h.getType()%></span>
                                        </div>
                                    </div>
                                    <div style="display:flex; align-items:center; gap:10px;">
                                        <div style="border-left:1px solid #ccc; padding-left:10px; display:flex; align-items:center; min-width:80px; height:35px; justify-content:center;">
                                            <span class="status <%= cssClass%>"><%= h.getStatus()%></span>
                                        </div>
                                        <div style="border-left:1px solid #ccc; padding-left:10px; padding-right: 20px; display:flex;">
                                            <!--MORE DETAILS BTN-->
                                            <div style="position: relative; display: inline-block;">

                                                <button class="icon-btn-td" onclick="toggleDropdownDetails(this)" 

                                                        data-holiday-id="<%= h.getHolidayId()%>"
                                                        data-title="<%= h.getType()%>"
                                                        data-motif="<%=h.getMotif()%>"
                                                        data-start="<%= h.getStartDate()%>"
                                                        data-end="<%= h.getEndDate()%>"
                                                        data-status="<%= h.getStatus()%>"
                                                        >
                                                    <span class="icon-home"> 
                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#666" width="18" height="18">
                                                        <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
                                                        <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
                                                        </svg> 
                                                    </span>
                                                </button>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <%
                                } // end for UserLeave
                            }

                            // Loop 2: UserPermission 
                            if (v3 != null) {
                                for (UserPermission p : v3) {
                                    String status = p.getStatus();
                                    String cssClass = "";
                                    if ("rejected".equalsIgnoreCase(status))
                                        cssClass = "status-rejected";
                                    else if ("approved".equalsIgnoreCase(status))
                                        cssClass = "status-approved";
                                    else if ("pending".equalsIgnoreCase(status))
                                        cssClass = "status-pending";
                        %>
                        <tr>
                            <td style="padding:10px;">
                                <div style="display:flex; justify-content:space-between; align-items:center;">
                                    <!-- Left: Avatar + Name/Type -->
                                    <div style="display:flex; align-items:center; gap:10px;">
                                        <!-- Avatar -->
                                        <img src="<%= selectedAvatar%>" alt="User Avatar" style="padding-left:5%; width:50px; height:50px; border-radius:50%;"/>
                                        <div style="display:flex; flex-direction:column;">
                                            <span style="font-weight:normal; white-space:nowrap;">Permission on <%= p.getStartDate()%> from <%= p.getStartTime()%> to <%= p.getEndTime()%></span>
                                            <span style="font-size:0.8rem; color:lightslategray;">Permission</span>
                                        </div>
                                    </div>
                                    <div style="display:flex; align-items:center; gap:10px;">
                                        <div style="border-left:1px solid #ccc; padding-left:10px; display:flex; align-items:center; min-width:80px; height:35px; justify-content:center;">
                                            <span class="status <%= cssClass%>"><%= p.getStatus()%></span>
                                        </div>
                                        <div style="border-left:1px solid #ccc; padding-left:10px; padding-right: 20px; display:flex;">                                                
                                            <!--MORE DETAILS BTN-->
                                            <div style="position: relative; display: inline-block;">
                                                <button class="icon-btn-td"

                                                        data-userid="<%= p.getUserId()%>" 
                                                        data-title="Permission"
                                                        data-holidayid="<%= p.getPermissionId()%>" 
                                                        data-username="<%= p.getFullName()%>"
                                                        data-startdate="<%= p.getStartDate()%>"
                                                        data-enddate="<%= p.getEndDate()%>"
                                                        data-starttime="<%= p.getStartTime()%>"
                                                        data-endtime="<%= p.getEndTime()%>"
                                                        data-motif="<%= p.getMotif()%>"
                                                        data-status="<%= p.getStatus()%>"
                                                        >
                                                    <span class="icon-home"> 
                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#666" width="18" height="18">
                                                        <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
                                                        <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
                                                        </svg> 
                                                    </span>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <%
                                    } // end for UserPermission
                                }
                            } // end else
%>
                    </tbody>
                </table>
            </div>

        </div>

    </body>
</html>