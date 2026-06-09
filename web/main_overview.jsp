<%-- 
    Document   : home_page
    Created on : 17 nov. 2025, 16:57:58
    Author     : HP
--%>

<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Date"%>
<%@page import="javafiles.UserPermission"%>
<%@page import="javafiles.UserLeave"%>
<%@page import="javafiles.UserPending"%>
<%@page import="java.util.List"%>
<%@page import="javafiles.userdataDAO"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Date" %>
<!DOCTYPE html>
<html>
    <head>
        <!-- Responsiveness -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Home Page</title>

        <!-- FullCalendar script -->
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>
        <link rel="stylesheet" 
              href="css/overview_styles.css">

        <script>
            <%
                Integer userId = (Integer) session.getAttribute("user_id");

                if (userId != null) {
            %>
            const userid = <%= userId%>
            <%
                } else {
                    response.sendRedirect("hello.jsp");
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
        <!-- Resources utilisées dans le code -->
        <%
            SimpleDateFormat outFmt = new SimpleDateFormat("MMM d", Locale.ENGLISH);
            SimpleDateFormat yearFmt = new SimpleDateFormat("yyyy");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        %> 
    </head>
    <body>

        <div class="navbar">
            <div class="navbar-left">
                <div class="search-box">
                    <input type="text" placeholder="Search users, reports, settings...">
                </div>
            </div>

            <div class="navbar-right">
                <div class="header_btn_section">
                    <button class="header_icon" id="notificationBtn" onclick="toggleDropdownNotifs()">
                        <span class="icon-home">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                            <path d="M4.214 3.227a.75.75 0 0 0-1.156-.955 8.97 8.97 0 0 0-1.856 3.825.75.75 0 0 0 1.466.316 7.47 7.47 0 0 1 1.546-3.186ZM16.942 2.272a.75.75 0 0 0-1.157.955 7.47 7.47 0 0 1 1.547 3.186.75.75 0 0 0 1.466-.316 8.971 8.971 0 0 0-1.856-3.825Z"/>
                            <path fill-rule="evenodd" d="M10 2a6 6 0 0 0-6 6c0 1.887-.454 3.665-1.257 5.234a.75.75 0 0 0 .515 1.076 32.91 32.91 0 0 0 3.256.508 3.5 3.5 0 0 0 6.972 0 32.903 32.903 0 0 0 3.256-.508.75.75 0 0 0 .515-1.076A11.448 11.448 0 0 1 16 8a6 6 0 0 0-6-6Zm0 14.5a2 2 0 0 1-1.95-1.557 33.54 33.54 0 0 0 3.9 0A2 2 0 0 1 10 16.5Z" clip-rule="evenodd"/>
                            </svg>

                            <span class="notification-dot"></span>
                        </span>

                    </button>

                    <ul id="notificationList" class="dropdown">
                        <li>No new notifications</li>
                    </ul>

                    <button class="header_icon">
                        <span class="icon-home">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M7.84 1.804A1 1 0 0 1 8.82 1h2.36a1 1 0 0 1 .98.804l.331 1.652a6.993 6.993 0 0 1 1.929 1.115l1.598-.54a1 1 0 0 1 1.186.447l1.18 2.044a1 1 0 0 1-.205 1.251l-1.267 1.113a7.047 7.047 0 0 1 0 2.228l1.267 1.113a1 1 0 0 1 .206 1.25l-1.18 2.045a1 1 0 0 1-1.187.447l-1.598-.54a6.993 6.993 0 0 1-1.929 1.115l-.33 1.652a1 1 0 0 1-.98.804H8.82a1 1 0 0 1-.98-.804l-.331-1.652a6.993 6.993 0 0 1-1.929-1.115l-1.598.54a1 1 0 0 1-1.186-.447l-1.18-2.044a1 1 0 0 1 .205-1.251l1.267-1.114a7.05 7.05 0 0 1 0-2.227L1.821 7.773a1 1 0 0 1-.206-1.25l1.18-2.045a1 1 0 0 1 1.187-.447l1.598.54A6.992 6.992 0 0 1 7.51 3.456l.33-1.652ZM10 13a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd"/>
                            </svg>
                        </span>
                    </button>

                    <button class="header_icon" id="header_icon_logout" onclick="handleLogout()">
                        <span style="margin-left: 10px; font-size: 0.9rem; color: #666;">
                            Log out
                        </span>
                        <span class="icon-home">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 2a.75.75 0 0 1 .75.75v7.5a.75.75 0 0 1-1.5 0v-7.5A.75.75 0 0 1 10 2ZM5.404 4.343a.75.75 0 0 1 0 1.06 6.5 6.5 0 1 0 9.192 0 .75.75 0 1 1 1.06-1.06 8 8 0 1 1-11.313 0 .75.75 0 0 1 1.06 0Z" clip-rule="evenodd"/>
                            </svg>
                        </span>
                    </button>

                    <div class="profile_avatar">
                        <img src="<%= request.getContextPath()%>/AvatarServlet?userId=<%=userId%>"
                             style="width:40px; height:40px; border-radius:50%; background: #eef;" title="" alt="" />
                    </div>
                </div>
            </div>
        </div>

        <!-- <div class="card" id="bigcard">
             <h2>24</h2>
             <p>Total leave</p>
         </div>-->

        <div class="dashboard">
            <main class="cards-section">

                <div class="banner" id="welcome">
                    <span style="display:flex; font-size: 1.4rem;"> Welcome back <span style="font-weight: normal;">, ${sessionScope.username} ! </span></span>
                    <span style="margin-top: 3px; font-size:0.7rem; font-weight:lighter;">Entered on: 2023/03/11 </span>
                    <span style="margin-top: 3px; font-size:0.7rem; font-weight:lighter;">Length of Service: 2 year(s)</span>
                </div>

                <div class="card">
                    <span class="card_change up">+12%</span>
                    <h2>24</h2>
                    <p>Leave Balance</p>
                </div>
                <div class="card">
                    <span class="card_change down">-9%</span>
                    <h2>22</h2>
                    <p>Leave taken this year</p>
                </div>
                <div class="card" id="permission_card">
                    <div class="row">
                        <span class="h2">Permission</span>
                        <span class="p">4</span>
                    </div>
                    <div class="row">
                        <span class="h2">Absenteeism</span>
                        <span class="p">1</span>
                    </div>
                </div>

                <div class="banner" id="pending_banner">
                    <div class="header">
                        <div class="header-left"> 
                            <span style="
                                  font-size: 11px;
                                  text-transform: uppercase;
                                  letter-spacing: .7px;
                                  color: #9E9D99;">

                                Pending Requests</span>
                        </div>

                        <div class="header-right">
                            <button class="icon-btn" id="new-leave-btn" onclick="navigateWithLoader('main_leave.jsp')">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="white">
                                <path fill-rule="evenodd" d="M5.478 5.559A1.5 1.5 0 0 1 6.912 4.5H9A.75.75 0 0 0 9 3H6.912a3 3 0 0 0-2.868 2.118l-2.411 7.838a3 3 0 0 0-.133.882V18a3 3 0 0 0 3 3h15a3 3 0 0 0 3-3v-4.162c0-.299-.045-.596-.133-.882l-2.412-7.838A3 3 0 0 0 17.088 3H15a.75.75 0 0 0 0 1.5h2.088a1.5 1.5 0 0 1 1.434 1.059l2.213 7.191H17.89a3 3 0 0 0-2.684 1.658l-.256.513a1.5 1.5 0 0 1-1.342.829h-3.218a1.5 1.5 0 0 1-1.342-.83l-.256-.512a3 3 0 0 0-2.684-1.658H3.265l2.213-7.191Z" clip-rule="evenodd" />
                                <path fill-rule="evenodd" d="M12 2.25a.75.75 0 0 1 .75.75v6.44l1.72-1.72a.75.75 0 1 1 1.06 1.06l-3 3a.75.75 0 0 1-1.06 0l-3-3a.75.75 0 0 1 1.06-1.06l1.72 1.72V3a.75.75 0 0 1 .75-.75Z" clip-rule="evenodd" />
                                </svg>
                                <span id="new-leave-label">New Request</span>
                            </button>
                        </div>
                    </div>

                    <div class="bar"></div>

                    <table class ="reqtable" cellspacing="0" id ="#pending_t">
                        <%
                            boolean isEmptyPending = (daoPending == null || daoPending.isEmpty()) && (daoPermissionPending == null || daoPermissionPending.isEmpty());
                            if (isEmptyPending) {
                        %>
                        <tbody>
                            <tr>
                                <td colspan="1" style="
                                    padding:30px;
                                    background: white;
                                    text-align: center;
                                    border-bottom-left-radius: 16px;
                                    border-bottom-right-radius: 16px;
                                    color: red;">No pending holidays found.</td>
                            </tr>
                            <%
                            } else {
                                for (UserPending h : daoPending) {
                            %>

                            <tr>
                                <td style="padding:10px;">
                                    <div style="display:flex; justify-content:space-between; align-items:center;">
                                        <!-- Left: Avatar + Name/Type -->
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <!-- Avatar -->
                                            <button class="icon-btn-avatar holiday">
                                                <span class="icon-home">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                                    <path d="M10 2a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0v-1.5A.75.75 0 0 1 10 2ZM10 15a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0v-1.5A.75.75 0 0 1 10 15ZM10 7a3 3 0 1 0 0 6 3 3 0 0 0 0-6ZM15.657 5.404a.75.75 0 1 0-1.06-1.06l-1.061 1.06a.75.75 0 0 0 1.06 1.06l1.06-1.06ZM6.464 14.596a.75.75 0 1 0-1.06-1.06l-1.06 1.06a.75.75 0 0 0 1.06 1.06l1.06-1.06ZM18 10a.75.75 0 0 1-.75.75h-1.5a.75.75 0 0 1 0-1.5h1.5A.75.75 0 0 1 18 10ZM5 10a.75.75 0 0 1-.75.75h-1.5a.75.75 0 0 1 0-1.5h1.5A.75.75 0 0 1 5 10ZM14.596 15.657a.75.75 0 0 0 1.06-1.06l-1.06-1.061a.75.75 0 1 0-1.06 1.06l1.06 1.06ZM5.404 6.464a.75.75 0 0 0 1.06-1.06l-1.06-1.06a.75.75 0 1 0-1.061 1.06l1.06 1.06Z" />
                                                    </svg>
                                                </span>
                                            </button>
                                            <!-- Name + Holiday Type -->
                                            <div style="display: flex; flex-direction: column;">
                                                <span style="font-size: 12px; font-weight: 600; color: #444; white-space:nowrap;">
                                                    <%= outFmt.format(h.getStartDate())%> &rarr;
                                                    <%= outFmt.format(h.getEndDate())%>,
                                                    <%= yearFmt.format(h.getEndDate())%>
                                                </span>
                                                <span style="font-size:0.8rem; font-weight:lighter"><%= h.getType()%></span>
                                            </div>
                                        </div>

                                        <div style="display:flex; align-items:center; gap:10px;">
                                            <!--  <div style="border-left:1px solid #ccc; padding-left:10px; display:flex; align-items:center; min-width:80px; height:35px; justify-content:center;"> -->
                                            <div class="waiting">
                                                <span></span>
                                                <span></span>
                                                <span></span>
                                            </div>
                                            <!--BUTTONS-->
                                            <div style="border-left:1px solid #ccc; padding-left: 5px;"> 
                                                <div style="display:flex; flex-direction: row;">
                                                    <div style="position: relative; display:flex; align-items: center; gap: 4px;">
                                                        <!--BUTTON FOR PENDING TABLE /LEAVE-->
                                                        <button class="icon-btn-td"

                                                                data-userid="<%= h.getUserId()%>" 
                                                                data-title="<%=h.getType()%>"
                                                                data-holiday-id="<%= h.getHolidayId()%>" 
                                                                data-username="<%= h.getName()%>"
                                                                data-startdate="<%= h.getStartDate()%>"
                                                                data-enddate="<%= h.getEndDate()%>"
                                                                data-motif="<%= h.getMotif()%>"
                                                                data-status="<%= h.getStatus()%>"

                                                                style="background:none; border:none; cursor:pointer;">
                                                            <span class="icon-home">
                                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#4f7fa8" class="size-6">
                                                                <path fill-rule="evenodd" d="M2.625 6.75a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Zm4.875 0A.75.75 0 0 1 8.25 6h12a.75.75 0 0 1 0 1.5h-12a.75.75 0 0 1-.75-.75ZM2.625 12a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0ZM7.5 12a.75.75 0 0 1 .75-.75h12a.75.75 0 0 1 0 1.5h-12A.75.75 0 0 1 7.5 12Zm-4.875 5.25a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Zm4.875 0a.75.75 0 0 1 .75-.75h12a.75.75 0 0 1 0 1.5h-12a.75.75 0 0 1-.75-.75Z" clip-rule="evenodd"/>
                                                                </svg> 
                                                            </span>
                                                        </button>
                                                        <!--DROPDOWN-->   
                                                        <div class="dd">
                                                            <div class="dd-body">
                                                                <div class="title"></div>
                                                                <div class="dd-label"></div>
                                                            </div>
                                                            <div class="dd-footer">
                                                                <button type="button" class="view-all-link" onclick="goToHistory('<%=h.getHolidayId()%>', 'leave')">
                                                                    View in History
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <!--BUTTON FOR PENDING TABLE / CANCEL -->
                                                        <button class="icon-btn-td"
                                                                data-userid="<%= h.getUserId()%>" 
                                                                data-holiday-id="<%= h.getHolidayId()%>" 
                                                                data-username="<%= h.getName()%>"
                                                                data-startdate="<%= h.getStartDate()%>"
                                                                data-enddate="<%= h.getEndDate()%>"
                                                                data-motif="<%= h.getMotif()%>"
                                                                data-status="<%= h.getStatus()%>"

                                                                style="background:none; border:none; cursor:pointer;">
                                                            <span class="icon-home">
                                                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#0078d7" class="size-6">
                                                                <path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
                                                                </svg>
                                                            </span>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            <%
                                    } // end for UserLeavePending
                                }

                                // Loop 2: UserPermissionPending 
                                if (daoPermissionPending != null) {
                                    for (UserPermission p : daoPermissionPending) {

                                        long diffMillis = p.getEndTime().getTime() - p.getStartTime().getTime();
                                        long hours = diffMillis / (1000 * 60 * 60);

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
                                            <button class="icon-btn-avatar permission">
                                                <span class="icon-home">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#333" class="size-6">
                                                    <path fill-rule="evenodd" d="M7.5 5.25a3 3 0 0 1 3-3h3a3 3 0 0 1 3 3v.205c.933.085 1.857.197 2.774.334 1.454.218 2.476 1.483 2.476 2.917v3.033c0 1.211-.734 2.352-1.936 2.752A24.726 24.726 0 0 1 12 15.75c-2.73 0-5.357-.442-7.814-1.259-1.202-.4-1.936-1.541-1.936-2.752V8.706c0-1.434 1.022-2.7 2.476-2.917A48.814 48.814 0 0 1 7.5 5.455V5.25Zm7.5 0v.09a49.488 49.488 0 0 0-6 0v-.09a1.5 1.5 0 0 1 1.5-1.5h3a1.5 1.5 0 0 1 1.5 1.5Zm-3 8.25a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z" clip-rule="evenodd" />
                                                    <path d="M3 18.4v-2.796a4.3 4.3 0 0 0 .713.31A26.226 26.226 0 0 0 12 17.25c2.892 0 5.68-.468 8.287-1.335.252-.084.49-.189.713-.311V18.4c0 1.452-1.047 2.728-2.523 2.923-2.12.282-4.282.427-6.477.427a49.19 49.19 0 0 1-6.477-.427C4.047 21.128 3 19.852 3 18.4Z" />
                                                    </svg>
                                                </span>
                                            </button>                                            
                                            <div style="display:flex; flex-direction:column;">
                                                <span style="font-size: 12px; font-weight: 600; color: #444; white-space:nowrap;"><%= outFmt.format(p.getStartDate())%></span>
                                                <span style="font-size:0.8rem; font-weight:lighter">Permission &bull; <%= hours%> hrs</span>
                                            </div>
                                        </div>
                                        <div style="display:flex; align-items:center; gap:10px;">
                                            <!--  <div style="border-left:1px solid #ccc; padding-left:10px; display:flex; align-items:center; min-width:80px; height:35px; justify-content:center;"> -->
                                            <div class="waiting">
                                                <span></span>
                                                <span></span>
                                                <span></span>
                                            </div>
                                            <!--BUTTONS-->
                                            <div style="border-left:1px solid #ccc; padding-left: 5px;"> 
                                                <div style="display:flex; flex-direction: row;">
                                                    <div style="position: relative; display:flex; align-items: center; gap: 4px;">
                                                        <!--BUTTON FOR PENDING TABLE /PERMISSION-->
                                                        <button class="icon-btn-td"

                                                                data-userid="<%= p.getUserId()%>" 
                                                                data-title="Permission"
                                                                data-holiday-id="<%= p.getPermissionId()%>" 
                                                                data-username="<%= p.getFullName()%>"
                                                                data-startdate="<%= p.getStartDate()%>"
                                                                data-enddate="<%= p.getEndDate()%>"
                                                                data-starttime="<%= p.getStartTime()%>"
                                                                data-endtime="<%= p.getEndTime()%>"
                                                                data-motif="<%= p.getMotif()%>"
                                                                data-status="<%= p.getStatus()%>"

                                                                style="background:none; border:none; cursor:pointer;">
                                                            <span class="icon-home">
                                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#0078d7" class="size-6">
                                                                <path fill-rule="evenodd" d="M2.625 6.75a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Zm4.875 0A.75.75 0 0 1 8.25 6h12a.75.75 0 0 1 0 1.5h-12a.75.75 0 0 1-.75-.75ZM2.625 12a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0ZM7.5 12a.75.75 0 0 1 .75-.75h12a.75.75 0 0 1 0 1.5h-12A.75.75 0 0 1 7.5 12Zm-4.875 5.25a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Zm4.875 0a.75.75 0 0 1 .75-.75h12a.75.75 0 0 1 0 1.5h-12a.75.75 0 0 1-.75-.75Z" clip-rule="evenodd"/>
                                                                </svg> 
                                                            </span>
                                                        </button>
                                                        <!--DROPDOWN-->   
                                                        <div class="dd">
                                                            <div class="dd-body">
                                                                <div class="title">Permission</div>
                                                                <div class="dd-label"><%= p.getMotif()%></div>
                                                            </div>
                                                            <div class="dd-footer">
                                                                <button type="button" class="view-all-link" onclick="goToHistory('<%=p.getPermissionId()%>', 'permission')">
                                                                    View in History
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <!--BUTTON FOR PENDING TABLE /PERMISSION CANCEL-->
                                                        <button class="icon-btn-td"

                                                                data-userid="<%= p.getUserId()%>" 
                                                                data-title="Permission"
                                                                data-holiday-id="<%= p.getPermissionId()%>" 
                                                                data-username="<%= p.getFullName()%>"
                                                                data-startdate="<%= p.getStartDate()%>"
                                                                data-enddate="<%= p.getEndDate()%>"
                                                                data-starttime="<%= p.getStartTime()%>"
                                                                data-endtime="<%= p.getEndTime()%>"
                                                                data-motif="<%= p.getMotif()%>"
                                                                data-status="<%= p.getStatus()%>"

                                                                style="background:none; border:none; cursor:pointer;">
                                                            <span class="icon-home">
                                                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#0078d7" class="size-6">
                                                                <path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
                                                                </svg>
                                                            </span>
                                                        </button>
                                                    </div>
                                                </div>
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
                    <!--<div style="text-align:right; padding: 5px 0; margin-right: 5%; margin-bottom: 5px;">
                        <button onclick="goToHistory(null, 'all')" class="see-more-btn">
                            View full history &rarr;
                        </button>
                    </div>-->
                </div>


                <!-- 
                
                
                LATEST
                REQUESTS
                
                -->
                <div class="banner" id="latest_banner">
                    <div class="header">
                        <div class="header-left"> 
                            <span style="
                                  font-size: 11px;
                                  text-transform: uppercase;
                                  letter-spacing: .7px;
                                  color: #9E9D99;">

                                Latest Requests</span>
                        </div>
                        <div class="header-right">
                            <select id="typeFilter" style="margin-right: 10px;">
                                <option value="all">All Types</option>
                                <option value="holidays">Leave</option>
                                <option value="permission">Permission</option>
                            </select>
                            <select id="statusFilter">
                                <option value="all">All Status</option>
                                <option value="approved">Approved</option>
                                <option value="pending">Pending</option>
                                <option value="rejected">Rejected</option>
                            </select>
                        </div>
                    </div>

                    <div class="bar"></div>

                    <table class="reqtable" cellspacing="0" id="latest_b">
                        <tbody>
                            <%
                                // --- Merge both lists into one ---
                                List<Object> combined = new ArrayList<>();
                                if (v2 != null) {
                                    combined.addAll(v2);
                                }
                                if (v3 != null) {
                                    combined.addAll(v3);
                                }

                                // --- Sort by startDate descending (newest first) ---
                                combined.sort(( a,
                                          
                                      
                                      
                                      
                                    b) -> {
                                    Date dateA = (a instanceof UserLeave)
                                            ? ((UserLeave) a).getStartDate()
                                            : ((UserPermission) a).getStartDate();
                                    Date dateB = (b instanceof UserLeave)
                                            ? ((UserLeave) b).getStartDate()
                                            : ((UserPermission) b).getStartDate();
                                    return dateB.compareTo(dateA);
                                });

                                if (combined.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="1" style="padding:30px; background:white; text-align:center;
                                    border-bottom-left-radius:16px; border-bottom-right-radius:16px; color:red;">
                                    No latest holidays found.
                                </td>
                            </tr>
                            <%
                            } else {
                                for (Object item : combined) {
                                    boolean isLeave = item instanceof UserLeave;
                                    String status = isLeave ? ((UserLeave) item).getStatus() : ((UserPermission) item).getStatus();
                                    String cssClass = "";
                                    String cssIconStatus = "";
                                    if ("rejected".equalsIgnoreCase(status)) {
                                        cssClass = "status-rejected";
                                        cssIconStatus = "status-home-rejected";
                                    } else if ("approved".equalsIgnoreCase(status)) {
                                        cssClass = "status-approved";
                                        cssIconStatus = "status-home-approved";
                                    } else if ("pending".equalsIgnoreCase(status)) {
                                        cssClass = "status-pending";
                                        cssIconStatus = "status-home-pending";
                                    }

                                    if (isLeave) {
                                        UserLeave h = (UserLeave) item;
                                        long diffMillis = h.getEndDate().getTime() - h.getStartDate().getTime();
                                        long days = diffMillis / (1000 * 60 * 60 * 24);
                            %>
                            <tr>
                                <td style="padding:10px;">
                                    <div style="display:flex; justify-content:space-between; align-items:center;">
                                        <!-- Left: Avatar + Name/Type -->
                                        <div style="display:flex; align-items:center; gap:10px;">
                                            <button class="icon-btn-avatar holiday">
                                                <span class="icon-home">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                                    <path d="M10 2a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0v-1.5A.75.75 0 0 1 10 2ZM10 15a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0v-1.5A.75.75 0 0 1 10 15ZM10 7a3 3 0 1 0 0 6 3 3 0 0 0 0-6ZM15.657 5.404a.75.75 0 1 0-1.06-1.06l-1.061 1.06a.75.75 0 0 0 1.06 1.06l1.06-1.06ZM6.464 14.596a.75.75 0 1 0-1.06-1.06l-1.06 1.06a.75.75 0 0 0 1.06 1.06l1.06-1.06ZM18 10a.75.75 0 0 1-.75.75h-1.5a.75.75 0 0 1 0-1.5h1.5A.75.75 0 0 1 18 10ZM5 10a.75.75 0 0 1-.75.75h-1.5a.75.75 0 0 1 0-1.5h1.5A.75.75 0 0 1 5 10ZM14.596 15.657a.75.75 0 0 0 1.06-1.06l-1.06-1.061a.75.75 0 1 0-1.06 1.06l1.06 1.06ZM5.404 6.464a.75.75 0 0 0 1.06-1.06l-1.06-1.06a.75.75 0 1 0-1.061 1.06l1.06 1.06Z" />
                                                    </svg>
                                                </span>
                                            </button>
                                            <div style="display:flex; flex-direction:column;">
                                                <span style="font-size: 12px; font-weight: 600; color: #444; white-space:nowrap;">
                                                    <%= outFmt.format(h.getStartDate())%> &rarr;
                                                    <%= outFmt.format(h.getEndDate())%>,
                                                    <%= yearFmt.format(h.getEndDate())%>                                                
                                                </span>
                                                <span style="font-size:0.8rem; font-weight:lighter"><%=h.getType()%>  &bull; <%=days%> days </span>
                                            </div>
                                        </div>
                                        <!-- Right: status + details -->
                                        <div style="display:flex; align-items:center; gap:10px;">
                                            <div style="border-left:1px solid transparent; padding-left:10px; display:flex; align-items:center; min-width:80px; height:35px; justify-content:center;">

                                                <div class="status <%=cssClass%>">
                                                    <div class="icon-btn-status"><div class="icon-home <%=cssIconStatus%>">
                                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
                                                            <path fill-rule="evenodd" d="M12 3.75a6.715 6.715 0 0 0-3.722 1.118.75.75 0 1 1-.828-1.25 8.25 8.25 0 0 1 12.8 6.883c0 3.014-.574 5.897-1.62 8.543a.75.75 0 0 1-1.395-.551A21.69 21.69 0 0 0 18.75 10.5 6.75 6.75 0 0 0 12 3.75ZM6.157 5.739a.75.75 0 0 1 .21 1.04A6.715 6.715 0 0 0 5.25 10.5c0 1.613-.463 3.12-1.265 4.393a.75.75 0 0 1-1.27-.8A6.715 6.715 0 0 0 3.75 10.5c0-1.68.503-3.246 1.367-4.55a.75.75 0 0 1 1.04-.211ZM12 7.5a3 3 0 0 0-3 3c0 3.1-1.176 5.927-3.105 8.056a.75.75 0 1 1-1.112-1.008A10.459 10.459 0 0 0 7.5 10.5a4.5 4.5 0 1 1 9 0c0 .547-.022 1.09-.067 1.626a.75.75 0 0 1-1.495-.123c.041-.495.062-.996.062-1.503a3 3 0 0 0-3-3Zm0 2.25a.75.75 0 0 1 .75.75c0 3.908-1.424 7.485-3.781 10.238a.75.75 0 0 1-1.14-.975A14.19 14.19 0 0 0 11.25 10.5a.75.75 0 0 1 .75-.75Zm3.239 5.183a.75.75 0 0 1 .515.927 19.417 19.417 0 0 1-2.585 5.544.75.75 0 0 1-1.243-.84 17.915 17.915 0 0 0 2.386-5.116.75.75 0 0 1 .927-.515Z" clip-rule="evenodd" />
                                                            </svg>
                                                        </div></div>

                                                    <%=h.getStatus()%>
                                                </div>


                                            </div>
                                            <div style="border-left:1px solid #ccc; padding-left:10px; padding-right:20px; display:flex;">
                                                <div style="position:relative; display:inline-block;">
                                                    <button class="icon-btn-td"
                                                            data-holiday-id="<%=h.getHolidayId()%>"
                                                            data-type="holidays"
                                                            data-title="<%=h.getType()%>"
                                                            data-motif="<%=h.getMotif()%>"
                                                            data-start="<%=h.getStartDate()%>"
                                                            data-end="<%=h.getEndDate()%>"
                                                            data-status="<%=h.getStatus()%>">
                                                        <span class="icon-home">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#555" viewBox="0 0 256 256"><path d="M128,24A104,104,0,1,0,232,128,104.11,104.11,0,0,0,128,24Zm0,192a88,88,0,1,1,88-88A88.1,88.1,0,0,1,128,216Zm16-40a8,8,0,0,1-8,8,16,16,0,0,1-16-16V128a8,8,0,0,1,0-16,16,16,0,0,1,16,16v40A8,8,0,0,1,144,176ZM112,84a12,12,0,1,1,12,12A12,12,0,0,1,112,84Z"></path></svg>
                                                        </span>
                                                    </button>
                                                    <div class="dd">
                                                        <div class="dd-body">
                                                            <div class="title"></div>
                                                            <div class="dd-label"></div>
                                                        </div>
                                                        <div class="dd-footer">
                                                            <button type="button" class="view-all-link" onclick="goToHistory('<%=h.getHolidayId()%>', 'leave')">
                                                                View in History
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <%
                            } else {
                                UserPermission p = (UserPermission) item;

                                long diffMillis = p.getEndTime().getTime() - p.getStartTime().getTime();
                                long hours = diffMillis / (1000 * 60 * 60);
                            %>
                            <tr>
                                <td style="padding:10px;">
                                    <div style="display:flex; justify-content:space-between; align-items:center;">
                                        <!-- Left: Avatar + Name/Type -->
                                        <div style="display:flex; align-items:center; gap:10px;">
                                            <button class="icon-btn-avatar permission">
                                                <span class="icon-home">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#333" class="size-6">
                                                    <path fill-rule="evenodd" d="M7.5 5.25a3 3 0 0 1 3-3h3a3 3 0 0 1 3 3v.205c.933.085 1.857.197 2.774.334 1.454.218 2.476 1.483 2.476 2.917v3.033c0 1.211-.734 2.352-1.936 2.752A24.726 24.726 0 0 1 12 15.75c-2.73 0-5.357-.442-7.814-1.259-1.202-.4-1.936-1.541-1.936-2.752V8.706c0-1.434 1.022-2.7 2.476-2.917A48.814 48.814 0 0 1 7.5 5.455V5.25Zm7.5 0v.09a49.488 49.488 0 0 0-6 0v-.09a1.5 1.5 0 0 1 1.5-1.5h3a1.5 1.5 0 0 1 1.5 1.5Zm-3 8.25a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z" clip-rule="evenodd" />
                                                    <path d="M3 18.4v-2.796a4.3 4.3 0 0 0 .713.31A26.226 26.226 0 0 0 12 17.25c2.892 0 5.68-.468 8.287-1.335.252-.084.49-.189.713-.311V18.4c0 1.452-1.047 2.728-2.523 2.923-2.12.282-4.282.427-6.477.427a49.19 49.19 0 0 1-6.477-.427C4.047 21.128 3 19.852 3 18.4Z" />
                                                    </svg>
                                                </span>
                                            </button>
                                            <div style="display:flex; flex-direction:column;">
                                                <span style="font-size: 12px; font-weight: 600; color: #444; white-space:nowrap;">
                                                    <%= outFmt.format(p.getStartDate())%>,
                                                    <%= yearFmt.format(p.getEndDate())%>
                                                </span>
                                                <span style="font-size:0.8rem; font-weight:lighter">
                                                    Permission &bull; <%= hours%> hrs
                                                </span>
                                            </div>
                                        </div>
                                        <!-- Right: status + details -->
                                        <div style="display:flex; align-items:center; gap:10px;">
                                            <div style="border-left:1px solid transparent; padding-left:10px; display:flex; align-items:center; min-width:80px; height:35px; justify-content:center;">
                                                <div class="status <%=cssClass%>">
                                                    <div class="icon-btn-status" onclick="toggleHRTooltip(this, '<%=p.getResponseMessage() != null ? p.getResponseMessage().replace("'", "\\'") : ""%>')" style="position:relative; cursor:pointer;">
                                                        <div class="icon-home <%=cssIconStatus%>">
                                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
                                                            <path fill-rule="evenodd" d="M12 3.75a6.715 6.715 0 0 0-3.722 1.118.75.75 0 1 1-.828-1.25 8.25 8.25 0 0 1 12.8 6.883c0 3.014-.574 5.897-1.62 8.543a.75.75 0 0 1-1.395-.551A21.69 21.69 0 0 0 18.75 10.5 6.75 6.75 0 0 0 12 3.75ZM6.157 5.739a.75.75 0 0 1 .21 1.04A6.715 6.715 0 0 0 5.25 10.5c0 1.613-.463 3.12-1.265 4.393a.75.75 0 0 1-1.27-.8A6.715 6.715 0 0 0 3.75 10.5c0-1.68.503-3.246 1.367-4.55a.75.75 0 0 1 1.04-.211ZM12 7.5a3 3 0 0 0-3 3c0 3.1-1.176 5.927-3.105 8.056a.75.75 0 1 1-1.112-1.008A10.459 10.459 0 0 0 7.5 10.5a4.5 4.5 0 1 1 9 0c0 .547-.022 1.09-.067 1.626a.75.75 0 0 1-1.495-.123c.041-.495.062-.996.062-1.503a3 3 0 0 0-3-3Zm0 2.25a.75.75 0 0 1 .75.75c0 3.908-1.424 7.485-3.781 10.238a.75.75 0 0 1-1.14-.975A14.19 14.19 0 0 0 11.25 10.5a.75.75 0 0 1 .75-.75Zm3.239 5.183a.75.75 0 0 1 .515.927 19.417 19.417 0 0 1-2.585 5.544.75.75 0 0 1-1.243-.84 17.915 17.915 0 0 0 2.386-5.116.75.75 0 0 1 .927-.515Z" clip-rule="evenodd" />
                                                            </svg>
                                                        </div>
                                                        <!--Tooltip -->
                                                        <div class="hr-tooltip" style="display:none; position:absolute; bottom:calc(100% + 8px); left:50%; transform:translateX(-50%); width:220px; background:#fff; border:1px solid #ddd; border-radius:8px; padding:12px; z-index:999; box-shadow:0 4px 12px rgba(0,0,0,0.12); font-size:13px; color:#333;">
                                                            <div style="font-weight:600; margin-bottom:6px; color:#555;">HR Note:</div>
                                                            <div class="hr-message" style="color:#222; line-height:1.5;"></div>
                                                            <div style="position:absolute; top:100%; left:50%; transform:translateX(-50%); border:6px solid transparent; border-top-color:#ddd;"></div>
                                                        </div>
                                                    </div>
                                                    <%=p.getStatus()%>
                                                </div>
                                            </div>
                                            <div style="border-left:1px solid #ccc; padding-left:10px; padding-right:20px; display:flex;">
                                                <div style="position:relative; display:inline-block;">
                                                    <button class="icon-btn-td"
                                                            data-userid="<%=p.getUserId()%>"
                                                            data-type="permission"
                                                            data-title="Permission"
                                                            data-holiday-id="<%=p.getPermissionId()%>"
                                                            data-username="<%=p.getFullName()%>"
                                                            data-startdate="<%=p.getStartDate()%>"
                                                            data-enddate="<%=p.getEndDate()%>"
                                                            data-starttime="<%=p.getStartTime()%>"
                                                            data-endtime="<%=p.getEndTime()%>"
                                                            data-motif="<%=p.getMotif()%>"
                                                            data-status="<%=p.getStatus()%>">
                                                        <span class="icon-home">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#555" viewBox="0 0 256 256"><path d="M128,24A104,104,0,1,0,232,128,104.11,104.11,0,0,0,128,24Zm0,192a88,88,0,1,1,88-88A88.1,88.1,0,0,1,128,216Zm16-40a8,8,0,0,1-8,8,16,16,0,0,1-16-16V128a8,8,0,0,1,0-16,16,16,0,0,1,16,16v40A8,8,0,0,1,144,176ZM112,84a12,12,0,1,1,12,12A12,12,0,0,1,112,84Z"></path></svg>
                                                        </span>
                                                    </button>
                                                    <div class="dd">
                                                        <div class="dd-body">
                                                            <div class="title">Permission</div>
                                                            <div class="dd-label"><%=p.getMotif()%></div>
                                                        </div>
                                                        <div class="dd-footer">
                                                            <button type="button" class="view-all-link" onclick="goToHistory('<%=p.getPermissionId()%>', 'permission')">
                                                                View in History
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <%
                                        } // end if/else isLeave
                                    } // end for combined
                                } // end else
                            %>
                        </tbody>
                    </table>
                    <div class="bar" id="bar2"></div>
                    <div style="text-align:right; padding: 5px 0; margin-right: 6%; margin-bottom: 5px;">
                        <button onclick="goToHistory(null, 'all')" class="see-more-btn">
                            View full history &rarr;
                        </button>
                    </div>
                </div>

            </main>


            <!-- 
            Right section: calendar + agenda 
            -->
            <aside class="side-section">

                <div style="position: relative; min-height: 150px;">
                    <div id="calendarLoader" class="chart-loader-wrapper">
                        <div class="loader" id="loader"></div>
                    </div>
                    <div id="calendar"></div>
                </div>

                <div class="agenda-card">
                    <span style="font-size: 13px;
                          text-transform: uppercase;
                          letter-spacing: .7px;
                          color: #9E9D99;

                          line-height: 6;">
                        Agenda
                    </span>
                    <div class="agenda-item" id="agenda-item-holiday">
                        <div style="display:flex; flex-direction: row; justify-content: space-between;">
                            <div>
                                <h4>Next National Holiday:</h4>
                                <p>Easter Monday ( Apr 6 )</p>
                            </div>
                            <div class="icon-btn">
                                <span class="icon-home">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#215f91" class="size-5">
                                    <path fill-rule="evenodd" d="M4.606 12.97a.75.75 0 0 1-.134 1.051 2.494 2.494 0 0 0-.93 2.437 2.494 2.494 0 0 0 2.437-.93.75.75 0 1 1 1.186.918 3.995 3.995 0 0 1-4.482 1.332.75.75 0 0 1-.461-.461 3.994 3.994 0 0 1 1.332-4.482.75.75 0 0 1 1.052.134Z" clip-rule="evenodd" />
                                    <path fill-rule="evenodd" d="M5.752 12A13.07 13.07 0 0 0 8 14.248v4.002c0 .414.336.75.75.75a5 5 0 0 0 4.797-6.414 12.984 12.984 0 0 0 5.45-10.848.75.75 0 0 0-.735-.735 12.984 12.984 0 0 0-10.849 5.45A5 5 0 0 0 1 11.25c.001.414.337.75.751.75h4.002ZM13 9a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z" clip-rule="evenodd" />
                                    </svg>
                                </span>
                            </div>
                        </div>

                    </div>
                    <div class="agenda-item">
                        <h4>History 12</h4>
                        <p>Lecture on Cold War (10:00 AM - 11:30 AM)</p>
                    </div>
                    <div class="agenda-item">
                        <h4>History 11</h4>
                        <p>Lecture on Cold War (10:00 AM - 11:30 AM)</p>
                    </div>
                    <div class="agenda-item">
                        <h4>History 10A</h4>
                        <p>Debate Prep (4:30 PM - 5:30 PM)</p>
                    </div>
                </div>
            </aside>
        </div>

        <script src="scripts/utils.js"></script>
        <script>
                            function navigateWithLoader(page) {
                                loader.style.display = 'block';
                                window.location.href = page;
                            }
        </script>
        <script>
            function handleLogout() {
                fetch('<%= request.getContextPath()%>/LogoutServlet', {
                    method: 'POST'
                }).then(() => {
                    window.top.location.href = '<%= request.getContextPath()%>/hello.jsp';
                });
            }
        </script>
        <script>

            let calendar;
            let cellDate;
            let hasBlockEvent;
            let start;
            let end;
            const currentUserId = <%= session.getAttribute("user_id")%>;
            const loader = document.getElementById("loader");

            document.addEventListener('DOMContentLoaded', function () {
                var calendarEl = document.getElementById('calendar');
                calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    firstDay: 1,
                    weekends: false,
                    showNonCurrentDates: false,
                    eventSources: [

                        // All holidays 
                        {
                            url: '<%= request.getContextPath()%>/CalendarLeaveServlet',
                            method: 'GET',
                            className: 'event-block',
                            display: 'block'},
                        // User-specific holidays
                        {
                            url: '<%= request.getContextPath()%>/CalendarPermissionServlet',
                            method: 'GET',
                            className: 'event-list',
                            display: 'list-item',
                            extraParams: {
                                userId: currentUserId
                            }
                        }
                    ],
                    // Highlight all days of events
                    eventsSet: function (events) {

                        // reset all cells
                        document.querySelectorAll('.fc-daygrid-day').forEach(function (cell) {
                            cell.classList.remove('event-cell');
                        });
                        // loop over days
                        document.querySelectorAll('.fc-daygrid-day').forEach(function (dayCell) {

                            cellDate = dayCell.getAttribute('data-date');
                            hasBlockEvent = events.some(function (event) {

                                // ONLY highlight for block events
                                if (!event.classNames.includes('event-block'))
                                    return false;
                                start = event.startStr.substring(0, 10);
                                end = event.endStr ? event.endStr.substring(0, 10) : start;
                                return cellDate >= start && cellDate < end;
                            });
                            if (hasBlockEvent) {
                                dayCell.classList.add('event-cell');
                            }
                        });
                    },
                    eventDidMount: function (info) {
                        info.el.setAttribute('data-event-id', info.holidayId);
                    },
                    loading: function (isLoading) {

                        if (isLoading) {
                            loader.style.display = "block";
                            document.getElementById('calendar').style.visibility = 'hidden';
                        } else {
                            loader.style.display = "none";
                            document.getElementById('calendar').style.visibility = 'visible';
                        }
                    }
                });
                calendar.render();
            });
        </script>
        <script>
            function applyFilters() {
                const selectedStatus = document.getElementById('statusFilter').value.toLowerCase();
                const selectedType = document.getElementById('typeFilter').value.toLowerCase();
                const rows = document.querySelectorAll('#latest_b tbody tr');
                rows.forEach(row => {
                    if (row.querySelector('td[colspan]'))
                        return;
                    const statusSpan = row.querySelector('.status');
                    if (!statusSpan)
                        return;
                    // --- Status ---
                    const rowStatus = statusSpan.textContent.trim().toLowerCase();
                    const statusMatch = selectedStatus === 'all' || rowStatus === selectedStatus;
                    // --- Type ---
                    const btn = row.querySelector('.icon-btn-td');
                    const rowType = btn ? btn.dataset.type : '';
                    const typeMatch = selectedType === 'all' || rowType === selectedType;
                    row.style.display = (statusMatch && typeMatch) ? '' : 'none';
                });
                showEmptyMessageIfNeeded();
            }

            function showEmptyMessageIfNeeded() {
                const tbody = document.querySelector('#latest_b tbody');
                const visibleRows = Array.from(tbody.querySelectorAll('tr')).filter(row => {
                    return !row.querySelector('td[colspan]') && row.style.display !== 'none';
                });
                // Supprimer ancien message de filtre vide
                const existing = document.getElementById('filter-empty-msg');
                if (existing)
                    existing.remove();
                if (visibleRows.length === 0) {
                    const emptyRow = document.createElement('tr');
                    emptyRow.id = 'filter-empty-msg';
                    emptyRow.innerHTML = `
        <td colspan="4" style="padding:30px; background:white; text-align:center;
        border-bottom-left-radius:16px; border-bottom-right-radius:16px; color:red;">
        No results for this filter.
        </td>`;
                    tbody.appendChild(emptyRow);
                }
            }

            document.getElementById('statusFilter').addEventListener('change', applyFilters);
            document.getElementById('typeFilter').addEventListener('change', applyFilters);
        </script>
        <script>
            function toggleDropdownNotifs() {
                const dropdown = document.getElementById("notificationList");
                const notifBtn = document.getElementById("notificationBtn");
                dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
                // Quand on ouvre, marquer comme lu
                if (dropdown.style.display === "block") {
                    //markNotificationsRead();
                }
                // close when clicking outside
                document.addEventListener("click", function (e) {
                    if (!notifBtn.contains(e.target) && !btn.contains(e.target)) {
                        dropdown.style.display === "none";
                    }
                });
            }
        </script>
        <script>
            document.addEventListener("click", function (e) {
                const button = e.target.closest(".icon-btn-td");
                // If click is not on a dropdown button :  ignore
                if (!button)
                    return;
                const container = button.parentElement;
                const dropdown = container.querySelector(".dd");
                // Close all other dropdowns first
                document.querySelectorAll(".dd").forEach(d => {
                    if (d !== dropdown)
                        d.style.display = "none";
                });
                // Toggle current one
                const isOpen = dropdown.style.display === "block";
                dropdown.style.display = isOpen ? "none" : "block";
                // Access your dynamic data here
                const data = {
                    id: button.dataset.holidayId,
                    title: button.dataset.title,
                    type: button.dataset.type,
                    motif: button.dataset.motif,
                    start: button.dataset.start,
                    end: button.dataset.end,
                    status: button.dataset.status
                };
                console.log(data);
                // Example: update dropdown content dynamically
                dropdown.querySelector(".title").textContent = data.title;
                dropdown.querySelector(".dd-label").textContent = 'Reason: ' + data.motif;
            });

            document.addEventListener("click", function (e) {
                if (!e.target.closest(".icon-btn-td") && !e.target.closest(".dd")) {
                    document.querySelectorAll(".dd").forEach(d => {
                        d.style.display = "none";
                    });
                }
            });
        </script>
        <script>
            function toggleHRTooltip(btn, message) {
                const tooltip = btn.querySelector('.hr-tooltip');
                const msgDiv = btn.querySelector('.hr-message');

                // Close any other open tooltips
                document.querySelectorAll('.hr-tooltip').forEach(t => {
                    if (t !== tooltip)
                        t.style.display = 'none';
                });

                if (tooltip.style.display === 'none') {
                    msgDiv.textContent = message && message.trim() !== '' ? message : 'No message provided.';
                    tooltip.style.display = 'block';
                } else {
                    tooltip.style.display = 'none';
                }
            }

            // Close tooltip when clicking outside
            document.addEventListener('click', function (e) {
                if (!e.target.closest('.icon-btn-status')) {
                    document.querySelectorAll('.hr-tooltip').forEach(t => t.style.display = 'none');
                }
            });
        </script>
    </body>

</html>