<%-- 
    Document   : home_page
    Created on : 17 nov. 2025, 16:57:58
    Author     : HP
--%>

<%@page import="javafiles.UserPermission"%>
<%@page import="javafiles.UserLeave"%>
<%@page import="javafiles.UserPending"%>
<%@page import="java.util.List"%>
<%@page import="javafiles.userdataDAO"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Responsiveness -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Home Page</title>

        <link rel="stylesheet" 
              href="css/overview_styles.css">

        <!-- FullCalendar script -->
        <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css' rel='stylesheet' />
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>


        <script>

            let calendar;
            let cellDate;
            let hasBlockEvent;
            let start;
            let end;
            const currentUserId = <%= session.getAttribute("user_id")%>;
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
                    }
                });
                calendar.render();
            });
        </script>
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

        <!-- <div class="card" id="bigcard">
             <h2>24</h2>
             <p>Total leave</p>
         </div>-->

        <div class="dashboard">
            <main class="cards-section">

                <div class="banner" id="welcome">
                    <span style="display:flex; font-size: 1.4rem;"> Welcome back <span style="font-weight: normal;">, ${sessionScope.username} ! </span></span>
                    <span style="margin-top: 3px; font-size:0.7rem; font-weight:lighter;">Entre(e) le: 19/03/2021 </span>
                    <span style="margin-top: 3px; font-size:0.7rem; font-weight:lighter;">Anciennete: 2 an(s)</span>
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
                <div class="card" id="newLeave_card">
                    <span class="card_change">+</span>
                    <p>Ask for a leave</p>
                </div>

                <div class="banner" id="pending_banner">
                    <div class="header">
                        <div class="header-left"> 
                            <button class="icon-btn-header"> <span class="icon-home">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                    <path fill-rule="evenodd" d="M4 8a6 6 0 1 1 12 0c0 1.887.454 3.665 1.257 5.234a.75.75 0 0 1-.515 1.076 32.903 32.903 0 0 1-3.256.508 3.5 3.5 0 0 1-6.972 0 32.91 32.91 0 0 1-3.256-.508.75.75 0 0 1-.515-1.076A11.448 11.448 0 0 0 4 8Zm6 7c-.655 0-1.305-.02-1.95-.057a2 2 0 0 0 3.9 0c-.645.038-1.295.057-1.95.057ZM8.75 6a.75.75 0 0 0 0 1.5h1.043L8.14 9.814A.75.75 0 0 0 8.75 11h2.5a.75.75 0 0 0 0-1.5h-1.043l1.653-2.314A.75.75 0 0 0 11.25 6h-2.5Z" clip-rule="evenodd" />
                                    </svg>
                                </span> </button>

                            <span style="
                                  font-weight: bold;
                                  font-size: 1rem;">

                                Pending Requests</span>
                        </div>
                        <div class="header-right">

                            <button class="icon-btn" id="new-leave-btn">
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
                                            <img src="<%= selectedAvatar%>" alt="User Avatar" style="padding-left: 5%; width: 50px; height: 50px; border-radius: 50%;"/>

                                            <!-- Name + Holiday Type -->
                                            <div style="display: flex; flex-direction: column;">
                                                <span style="font-weight: normal;white-space: nowrap">Holiday from <%= h.getStartDate()%> to <%= h.getEndDate()%></span>
                                                <span style="margin-left: 3px; font-size: 0.8rem; color: lightslategray"><%= h.getType()%></span>
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
                                                                data-holidayid="<%= h.getHolidayId()%>" 
                                                                data-username="<%= h.getName()%>"
                                                                data-startdate="<%= h.getStartDate()%>"
                                                                data-enddate="<%= h.getEndDate()%>"
                                                                data-motif="<%= h.getMotif()%>"
                                                                data-status="<%= h.getStatus()%>"

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
                                                                <div class="title"></div>
                                                                <div class="label"></div>
                                                            </div>
                                                            <div class="dd-footer">
                                                                <a href="#" class="view-all-link">View all</a>
                                                            </div>
                                                        </div>
                                                        <!--BUTTON FOR PENDING TABLE /LEAVE CANCEL-->
                                                        <button class="icon-btn-td"
                                                                data-userid="<%= h.getUserId()%>" 
                                                                data-holidayid="<%= h.getHolidayId()%>" 
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
                                                <span style="font-weight:normal; white-space:nowrap;">Permission on <%= p.getStartDate()%> from <%= p.getStartTime()%> to <%= p.getEndTime()%> </span>
                                                <span style="font-size:0.8rem; color:lightslategray;">Permission</span>
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
                                                                data-holidayid="<%= p.getPermissionId()%>" 
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
                                                                <div class="label"><%= p.getMotif()%></div>
                                                            </div>
                                                            <div class="dd-footer">
                                                                <a href="#" class="view-all-link">View all</a>
                                                            </div>
                                                        </div>
                                                        <!--BUTTON FOR PENDING TABLE /PERMISSION CANCEL-->
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
                </div>


                <!-- 
                
                
                LATEST
                REQUESTS
                
                -->
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
                                        <div style="display:flex; align-items:center; gap:4px;">
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
                                                    <!--DROPDOWN-->   
                                                    <div class="dd">
                                                        <div class="dd-body">
                                                            <div class="title"></div>
                                                            <div class="label"></div>
                                                        </div>
                                                        <div class="dd-footer">
                                                            <a href="#" class="view-all-link">View all</a>
                                                        </div>
                                                    </div>
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
                                                    <!--DROPDOWN-->   
                                                    <div class="dd">
                                                        <div class="dd-body">
                                                            <div class="title">Permission</div>
                                                            <div class="label"><%= p.getMotif()%></div>
                                                        </div>
                                                        <div class="dd-footer">
                                                            <a href="#" class="view-all-link">View all</a>
                                                        </div>
                                                    </div>
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

            </main>


            <!-- 
            Right section: calendar + agenda 
            -->
            <aside class="side-section">
                <!--<div class="calendar-card">-->
                <!-- <div class="fullcalendar">-->
                <div id="calendar">
                </div>
                <div class="agenda-card">
                    <h3>Agenda</h3>
                    <div class="agenda-item" id="agenda-item-holiday">
                        <div style="display:flex; flex-direction: row; justify-content: space-between;">
                            <div>
                                <h4>Next National Holiday:</h4>
                                <p>Easter Monday ( Apr 6 )</p>
                            </div>
                            <div class="icon-btn">
                                <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="darkred" class="size-10">
                                    <path d="M16.881 4.345A23.112 23.112 0 0 1 8.25 6H7.5a5.25 5.25 0 0 0-.88 10.427 21.593 21.593 0 0 0 1.378 3.94c.464 1.004 1.674 1.32 2.582.796l.657-.379c.88-.508 1.165-1.593.772-2.468a17.116 17.116 0 0 1-.628-1.607c1.918.258 3.76.75 5.5 1.446A21.727 21.727 0 0 0 18 11.25c0-2.414-.393-4.735-1.119-6.905ZM18.26 3.74a23.22 23.22 0 0 1 1.24 7.51 23.22 23.22 0 0 1-1.41 7.992.75.75 0 1 0 1.409.516 24.555 24.555 0 0 0 1.415-6.43 2.992 2.992 0 0 0 .836-2.078c0-.807-.319-1.54-.836-2.078a24.65 24.65 0 0 0-1.415-6.43.75.75 0 1 0-1.409.516c.059.16.116.321.17.483Z" />
                                    </svg></span>

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
                    motif: button.dataset.motif,
                    start: button.dataset.start,
                    end: button.dataset.end,
                    status: button.dataset.status
                };

                console.log(data);

                // Example: update dropdown content dynamically
                dropdown.querySelector(".title").textContent = data.title;
                dropdown.querySelector(".label").textContent = 'Reason: ' + data.motif;
            });

            document.addEventListener("click", function (e) {
                if (!e.target.closest(".icon-btn-td") && !e.target.closest(".dd")) {
                    document.querySelectorAll(".dd").forEach(d => {
                        d.style.display = "none";
                    });
                }
            });
        </script>
        <script src="scripts/utils.js"></script>
    </body>

</html>