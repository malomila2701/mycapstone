<%-- 
    Document   : main_history
    Created on : Apr 1, 2026, 10:35:55 PM
    Author     : JeanSamuel
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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

        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>

        <link rel="stylesheet" 
              href="css/main_history_styles.css">

        <script>
            <%
                Integer userId = (Integer) session.getAttribute("user_id");
                if (userId == null) {
                    response.sendRedirect("hello.jsp");
                    return;
                }
            %>
            // now safe to use userId in JS if needed
            const userId = <%= userId%>
        </script>
        <script>
            <%
                userdataDAO dao = new userdataDAO();

                long t0 = System.currentTimeMillis();
                List<UserLeave> v2 = dao.getUserLeave(userId);
                long t1 = System.currentTimeMillis();

                List<UserPermission> v3 = dao.getUserPermission(userId);
                long t2 = System.currentTimeMillis();

                List<UserPending> daoPending = dao.getLeavePending(userId);
                long t3 = System.currentTimeMillis();

                List<UserPermission> daoPermissionPending = dao.getPermissionPending(userId);
                long t4 = System.currentTimeMillis();

                response.setHeader("Server-Timing",
                        "getUserLeave;dur=" + (t1 - t0) + ";desc=\"getUserLeave\","
                        + "getUserPermission;dur=" + (t2 - t1) + ";desc=\"getUserPermission\","
                        + "getLeavePending;dur=" + (t3 - t2) + ";desc=\"getLeavePending\","
                        + "getPermissionPending;dur=" + (t4 - t3) + ";desc=\"getPermissionPending\","
                        + "total;dur=" + (t4 - t0) + ";desc=\"Total DB\""
                );
            %>
        </script>
        <script>
            if (new URLSearchParams(window.location.search).get('id')) {
                document.documentElement.style.opacity = '0';
            } else {
                document.documentElement.style.opacity = '1';
            }
        </script>
        <%
            String selectedAvatar = "images/avatar1.jpg";

            SimpleDateFormat outFmt = new SimpleDateFormat("MMM d", Locale.ENGLISH);
            SimpleDateFormat yearFmt = new SimpleDateFormat("yyyy");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        %> 
    </head>

    <body>

        <!-- Leave type modal -->
        <div id="leaveModal" class="modal">
            <div class="modal-content">
                <button class="modal-close-btn" onclick="document.getElementById('leaveModal').style.display = 'none'">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                    <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
                    </svg>
                </button>
                <div class="details-section">
                    <span style="display:flex; flex-direction:row;">
                        <img src="<%= selectedAvatar%>" alt="User Avatar" class="avatar" style="margin-left: 15px;"/>
                        <span style="display: flex; flex-direction: column;">
                            <label class="modallabel-name" id="modalUsername">Unknown</label>
                            <label class="modallabel-id" id="modalId"> ID: #</label>
                        </span>
                    </span>

                    <form action="FirstServlet" method="post">
                        <div class="form-group-holiday" style="display:none;">
                            <div class="form-group">
                                <label for="modalStartDate"> Start Date:</label> 
                                <div class="input-wrapper">
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                        <path d="M10 9.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V10a.75.75 0 0 0-.75-.75H10ZM6 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H6ZM8 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H8ZM9.25 14a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V14ZM12 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H12ZM12 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H12ZM13.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H14a.75.75 0 0 1-.75-.75V12ZM11.25 10.005c0-.417.338-.755.755-.755h2a.755.755 0 1 1 0 1.51h-2a.755.755 0 0 1-.755-.755ZM6.005 11.25a.755.755 0 1 0 0 1.51h4a.755.755 0 1 0 0-1.51h-4Z" />
                                        <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                        </svg>
                                    </span>
                                    <input type="text" id="modalStartDate" readonly />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="modalEndDate"> End Date:</label> 
                                <div class="input-wrapper">
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                        <path d="M10 9.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V10a.75.75 0 0 0-.75-.75H10ZM6 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H6ZM8 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H8ZM9.25 14a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V14ZM12 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H12ZM12 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H12ZM13.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H14a.75.75 0 0 1-.75-.75V12ZM11.25 10.005c0-.417.338-.755.755-.755h2a.755.755 0 1 1 0 1.51h-2a.755.755 0 0 1-.755-.755ZM6.005 11.25a.755.755 0 1 0 0 1.51h4a.755.755 0 1 0 0-1.51h-4Z" />
                                        <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                        </svg>
                                    </span>
                                    <input type="text" id="modalEndDate" readonly />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="modalMotif"> Reason</label> 
                                <textarea id="modalMotif" readonly></textarea>
                            </div>
                        </div>

                        <div class="form-group-permission" style="display:none;">
                            <div class="form-group">
                                <label for="modalStartTime"> Start Time:</label> 
                                <div class="input-wrapper">
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                        <path d="M10 9.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V10a.75.75 0 0 0-.75-.75H10ZM6 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H6ZM8 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H8ZM9.25 14a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V14ZM12 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H12ZM12 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H12ZM13.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H14a.75.75 0 0 1-.75-.75V12ZM11.25 10.005c0-.417.338-.755.755-.755h2a.755.755 0 1 1 0 1.51h-2a.755.755 0 0 1-.755-.755ZM6.005 11.25a.755.755 0 1 0 0 1.51h4a.755.755 0 1 0 0-1.51h-4Z" />
                                        <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                        </svg>
                                    </span>
                                    <input type="text" id="modalStartTime" readonly />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="modalEndTime"> End Time:</label> 
                                <div class="input-wrapper">
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                        <path d="M10 9.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V10a.75.75 0 0 0-.75-.75H10ZM6 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H6ZM8 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H8ZM9.25 14a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V14ZM12 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H12ZM12 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H12ZM13.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H14a.75.75 0 0 1-.75-.75V12ZM11.25 10.005c0-.417.338-.755.755-.755h2a.755.755 0 1 1 0 1.51h-2a.755.755 0 0 1-.755-.755ZM6.005 11.25a.755.755 0 1 0 0 1.51h4a.755.755 0 1 0 0-1.51h-4Z" />
                                        <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                        </svg>
                                    </span>
                                    <input type="text" id="modalEndTime" readonly />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="modalMotif"> Reason</label> 
                                <textarea id="modalMotifPermission" readonly></textarea>
                            </div>
                        </div>
                    </form>

                    <div class="modal-actions" id="actionsDiv"></div>
                </div>

                <aside class="modal-side-section">
                    <div id="calendar">
                    </div>
                </aside>

            </div>
        </div>


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
                    <button class="header_icon" id="header_icon_logout">
                        <span class="label">
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

        <!--
        MENU
        -->

        <div class="dashboard">
            <div class="charts_section">
                <main class="cards-section">
                    <div class="banner" id="charts_banner">
                        <div class="header">
                            <div class="header-left"> 
                                Requests Collection
                            </div> 
                        </div>
                        <!--Legend-->
                        <div class="legend-wrap">
                            <div class="legend-item">
                                <div class="legend-line">
                                    <div class="legend-line-track"></div>
                                    <div class="legend-dot"></div>
                                    <div class="legend-line-track"></div>
                                </div>
                                <span class="legend-label">Approved leaves per month</span>
                            </div>

                            <div class="legend-meta" id="legend-meta" style="display:none">
                                <div class="legend-stat">
                                    <span class="legend-stat-val" id="legend-total">—</span>
                                    <span class="legend-stat-sub">total this year</span>
                                </div>
                                <div class="legend-divider"></div>
                                <div class="legend-stat">
                                    <span class="legend-stat-val" id="legend-peak">—</span>
                                    <span class="legend-stat-sub">peak month</span>
                                </div>
                            </div>
                        </div>
                        <!-- Canvas -->
                        <div class="chart-wrap">
                            <div class="chart-loader-wrapper">
                                <div class="loader"></div>
                            </div>
                            <canvas id="leavesChart" role="img" aria-label="Area chart showing number of approved leaves per month"></canvas>
                        </div>

                        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                        <script>
                        console.time('fetch');
                        async function fetchLeavesData() {
                            const response = await fetch("<%= request.getContextPath()%>/ChartUserLeaveServlet");
                            const data = await response.json();
                            // data = [{ month: 1, count: 2 }, { month: 3, count: 5 }, ...]

                            const filled = Array(12).fill(0);
                            data.forEach(d => {
                                filled[d.month - 1] = d.count;
                            });
                            return filled;
                        }
                        console.timeEnd('fetch');
                        console.time('renderChart');
                        async function renderChart() {
                            const leavesPerMonth = await fetchLeavesData();
                            const ctx = document.getElementById('leavesChart').getContext('2d');
                            const gradient = ctx.createLinearGradient(0, 0, 0, 300);
                            gradient.addColorStop(0, 'rgba(37, 99, 235, 0.3)');
                            gradient.addColorStop(1, 'rgba(37, 99, 235, 0.0)');
                            new Chart(ctx, {
                                type: 'line',
                                data: {
                                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                                    datasets: [{
                                            label: 'Leaves taken',
                                            data: leavesPerMonth,
                                            fill: true,
                                            backgroundColor: gradient,
                                            borderColor: '#2563eb',
                                            borderWidth: 2,
                                            tension: 0.45,
                                            pointRadius: 4,
                                            pointBackgroundColor: '#2563eb',
                                            pointHoverRadius: 6,
                                            pointHoverBackgroundColor: '#fff',
                                            pointHoverBorderColor: '#2563eb',
                                            pointHoverBorderWidth: 2
                                        }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: {display: false},
                                        tooltip: {
                                            backgroundColor: '#fff',
                                            titleColor: '#7480a0',
                                            bodyColor: '#1e2a4a',
                                            borderColor: '#e5e7ef',
                                            borderWidth: 1,
                                            padding: 10,
                                            callbacks: {
                                                label: ctx => `${ctx.parsed.y} leave(s)`
                                            }
                                        }
                                    },
                                    scales: {
                                        x: {
                                            grid: {display: false},
                                            ticks: {color: '#a0a8c0', font: {size: 11}}
                                        },
                                        y: {
                                            min: 0,
                                            max: 5,
                                            ticks: {
                                                stepSize: 1,
                                                color: '#a0a8c0',
                                                font: {size: 11}
                                            },
                                            grid: {color: '#f0f2f8'},
                                            border: {display: false}
                                        }
                                    }
                                }
                            });
                            document.querySelector('.chart-loader-wrapper').style.display = 'none';
                            document.getElementById('leavesChart').style.display = 'block';
                        }
                        renderChart();
                        console.timeEnd('renderChart');
                        </script>  
                    </div>
                </main>

                <aside class="side-section">
                    <div class="card">
                        <!-- <span class="card_stats icon-home">
                             <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="white" viewBox="0 0 256 256"><path d="M232,208a8,8,0,0,1-8,8H32a8,8,0,0,1-8-8V48a8,8,0,0,1,16,0v94.37L90.73,98a8,8,0,0,1,10.07-.38l58.81,44.11L218.73,90a8,8,0,1,1,10.54,12l-64,56a8,8,0,0,1-10.07.38L96.39,114.29,40,163.63V200H224A8,8,0,0,1,232,208Z"></path></svg>
 
                         </span> -->
                        <span class="card_change down icon-home">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#d93025" class="size-5">
                            <path fill-rule="evenodd" d="M13.5 4.938a7 7 0 1 1-9.006 1.737c.202-.257.59-.218.793.039.278.352.594.672.943.954.332.269.786-.049.773-.476a5.977 5.977 0 0 1 .572-2.759 6.026 6.026 0 0 1 2.486-2.665c.247-.14.55-.016.677.238A6.967 6.967 0 0 0 13.5 4.938ZM14 12a4 4 0 0 1-4 4c-1.913 0-3.52-1.398-3.91-3.182-.093-.429.44-.643.814-.413a4.043 4.043 0 0 0 1.601.564c.303.038.531-.24.51-.544a5.975 5.975 0 0 1 1.315-4.192.447.447 0 0 1 .431-.16A4.001 4.001 0 0 1 14 12Z" clip-rule="evenodd" />
                            </svg>
                        </span>
                        <h2>April</h2>
                        <p>Hottest Month</p>
                    </div>

                    <div class="card">
                        <span class="card_change up">↑ 12%</span>
                        <h2>24</h2>
                        <p>Leave Balance</p>
                    </div>

                    <div class="card">
                        <span class="card_change up">+12%</span>
                        <h2>2</h2>
                        <p>Requests this month</p>
                    </div>

                    <div class="card">
                        <span class="card_change down">↓ 4%</span>
                        <h2>4</h2>
                        <p>Requests this year</p>
                    </div>

                </aside> 
            </div>

            <div id="latest_banner">
                <div class="header">
                    <div class="header-left"> 
                        Latest Requests
                    </div>
                    <div class="header-right">
                        <div class="search-box">
                            <input type="text" placeholder="Search by Name or ID">
                        </div>
                        <span style="display:flex; align-items: center; font-size: 0.8rem; margin-right: 10px; white-space: nowrap;">Filter by: </span>
                        <select id="dateFilter" style="margin-right: 10px;">
                            <option value="all">All Dates</option>
                            <option value="today">Today</option>
                            <option value="yesterday">Yesterday</option>
                            <option value="last_week">Last Week</option>
                            <option value="last_month">Last Month</option>
                        </select>
                        <select id="typeFilter" style="margin-right: 10px;">
                            <option value="all">All Types</option>
                            <option value="leave">Leave</option>
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

                <table class="reqtable" cellspacing="0" id="latest_b">
                    <thead>
                        <tr>
                            <th style="padding:12px; text-align:left; padding-left: 3%;">Description</th>
                            <th id="dateHeader" style="padding:12px; text-align:center; cursor:pointer;">Period ↓</th>
                            <th style="padding:12px; text-align:center;">Motif/Reason</th>
                            <th style="padding:12px; text-align:center;">Status</th>
                            <th style="padding:12px; text-align:center;">Action</th>
                        </tr>
                    </thead>
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
                            <td colspan="5" style="padding:30px; background:white; text-align:center;
                                border-bottom-left-radius:16px; border-bottom-right-radius:16px; color:red;">
                                No latest holidays found.
                            </td>
                        </tr>
                        <%
                        } else {
                            for (Object item : combined) {
                                if (item instanceof UserLeave) {
                                    UserLeave h = (UserLeave) item;

                                    /**
                                     * Compute number of days.START*
                                     */
                                    Date start = h.getStartDate();
                                    Date end = h.getEndDate();

                                    long diffMillis = end.getTime() - start.getTime();
                                    long days = diffMillis / (1000 * 60 * 60 * 24);
                                    /**
                                     * .END
                                     */

                                    String status = h.getStatus();
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

                        %>
                        <tr data-id="<%=h.getHolidayId()%>" data-type="leave">

                            <!-- DESCRIPTION -->
                            <td style="padding:10px; width: 300px;">
                                <div style="display:flex; align-items:center; gap:10px;">

                                    <!-- Avatar -->
                                    <div style="display:flex; align-items:center; gap:10px; padding-left: 3%;">
                                        <button class="icon-btn-avatar holiday">
                                            <span class="icon-home">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                                <path d="M10 2a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0v-1.5A.75.75 0 0 1 10 2ZM10 15a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0v-1.5A.75.75 0 0 1 10 15ZM10 7a3 3 0 1 0 0 6 3 3 0 0 0 0-6ZM15.657 5.404a.75.75 0 1 0-1.06-1.06l-1.061 1.06a.75.75 0 0 0 1.06 1.06l1.06-1.06ZM6.464 14.596a.75.75 0 1 0-1.06-1.06l-1.06 1.06a.75.75 0 0 0 1.06 1.06l1.06-1.06ZM18 10a.75.75 0 0 1-.75.75h-1.5a.75.75 0 0 1 0-1.5h1.5A.75.75 0 0 1 18 10ZM5 10a.75.75 0 0 1-.75.75h-1.5a.75.75 0 0 1 0-1.5h1.5A.75.75 0 0 1 5 10ZM14.596 15.657a.75.75 0 0 0 1.06-1.06l-1.06-1.061a.75.75 0 1 0-1.06 1.06l1.06 1.06ZM5.404 6.464a.75.75 0 0 0 1.06-1.06l-1.06-1.06a.75.75 0 1 0-1.061 1.06l1.06 1.06Z" />
                                                </svg>
                                            </span>
                                        </button>
                                        <div style="display:flex; flex-direction:column;">
                                            <span style="font-size: 12px; font-weight: 600; color: #444; white-space:nowrap;">
                                                <%= h.getFullName()%>
                                            </span>
                                            <span style="font-size: 11x; color:lightslategray; white-space: nowrap;">
                                                Holiday &bull; <%= days%> hrs
                                            </span>
                                        </div>
                                    </div>

                                </div>
                            </td>

                            <td data-date="<%= h.getStartDate().getTime()%>" style="padding:10px; text-align:center; width:150px;">
                                <div style="display:flex; flex-direction:column;">
                                    <span style="font-size: 12px; font-weight: 600; color: #444; white-space:nowrap;">
                                        <%= outFmt.format(h.getStartDate())%>,
                                        <%= yearFmt.format(h.getEndDate())%>
                                    </span>
                                    <span style="font-family: Consolas, sans-serif; font-size:0.8rem; font-weight:lighter; color:lightslategray;">
                                        ID: REQ-2026-00<%= h.getHolidayId()%> 
                                    </span>
                                </div>
                            </td>

                            <!-- REASON -->
                            <td style="padding:10px; text-align:center; width:350px;">

                                <span style="
                                      font-size:12px;
                                      font-weight: 600;
                                      color: #444;
                                      display:block;
                                      white-space: wrap;
                                      overflow:hidden;
                                      text-overflow:ellipsis;
                                      ">
                                    <%= h.getMotif()%>
                                </span>

                            </td>

                            <!-- STATUS -->
                            <td style="padding:10px; text-align:center; width:120px;">

                                <div class="status <%=cssClass%>">
                                    <div class="icon-btn-status" onclick="toggleHRTooltip(this, '<%=h.getResponseMessage() != null ? h.getResponseMessage().replace("'", "\\'") : ""%>')" style="position:relative; cursor:pointer;">
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
                                    <span>
                                        <%=h.getStatus()%>
                                    </span>
                                </div>

                            </td>

                            <!-- ACTION -->
                            <td style="padding:10px; text-align:center; width:100px;">

                                <button class="icon-btn-td"

                                        data-userid="<%= h.getUserId()%>" 
                                        data-type="holidays"
                                        data-title="<%= h.getType()%>"
                                        data-holidayid="<%= h.getHolidayId()%>" 
                                        data-username="<%= h.getFullName()%>"
                                        data-startdate="<%= h.getStartDate()%>"
                                        data-enddate="<%= h.getEndDate()%>"
                                        data-motif="<%= h.getMotif()%>"
                                        data-status="<%= h.getStatus()%>">

                                    <svg xmlns="http://www.w3.org/2000/svg"
                                         viewBox="0 0 20 20"
                                         fill="#666"
                                         width="18"
                                         height="18">

                                    <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />

                                    <path fill-rule="evenodd"
                                          d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z"
                                          clip-rule="evenodd" />
                                    </svg>

                                </button>

                            </td>

                        </tr>
                        <%
                        } // end for UserLeave
                        else if (item instanceof UserPermission) {
                            UserPermission p = (UserPermission) item;

                            long diffMillis = p.getEndTime().getTime() - p.getStartTime().getTime();
                            long hours = diffMillis / (1000 * 60 * 60);

                            String status = p.getStatus();
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
                        %>
                        <tr data-id="<%=p.getPermissionId()%>" data-type="permission">

                            <!-- DESCRIPTION -->
                            <td style="padding:10px; width: 300px;">
                                <div style="display:flex; align-items:center; gap:10px;">

                                    <!-- Avatar -->
                                    <div style="display:flex; align-items:center; gap:10px; padding-left: 3%;">
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
                                                <%= p.getFullName()%>
                                            </span>
                                            <span style="font-size:11px; color:lightslategray; white-space: nowrap;">
                                                Permission &bull; <%= hours%> hrs
                                            </span>
                                        </div>
                                    </div>

                                </div>
                            </td>

                            <td data-date="<%= p.getStartDate().getTime()%>" style="padding:10px; text-align:center; width:150px;">
                                <div style="display:flex; flex-direction:column;">
                                    <span style="font-size: 12px; font-weight: 600; color: #444; white-space:nowrap;">
                                        <%= outFmt.format(p.getStartDate())%>,
                                        <%= yearFmt.format(p.getEndDate())%>
                                    </span>
                                    <span style="font-family: Consolas, sans-serif; font-size:0.8rem; font-weight:lighter; color:lightslategray;">
                                        ID: REQ-2026-00<%= p.getPermissionId()%> 
                                    </span>
                                </div>
                            </td>

                            <!-- REASON -->
                            <td style="padding:10px; text-align:center; width:350px;">

                                <span style="
                                      font-size:12px;
                                      font-weight: 600;
                                      color: #444;
                                      display:block;
                                      white-space: wrap;
                                      overflow:hidden;
                                      text-overflow:ellipsis;
                                      ">
                                    <%= p.getMotif()%>
                                </span>

                            </td>

                            <!-- STATUS -->
                            <td style="padding:10px; text-align:center; width:120px;">

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
                                    <span>
                                        <%=p.getStatus()%>
                                    </span>
                                </div>

                            </td>

                            <!-- ACTION -->
                            <td style="padding:10px; text-align:center; width:100px;">

                                <button class="icon-btn-td"

                                        data-userid="<%= p.getUserId()%>" 
                                        data-useremail="<%= p.getEmail()%>"
                                        data-type="permission"
                                        data-title="Permission"
                                        data-holidayid="<%= p.getPermissionId()%>" 
                                        data-username="<%= p.getFullName()%>"
                                        data-startdate="<%= p.getStartDate()%>"
                                        data-enddate="<%= p.getEndDate()%>"
                                        data-starttime="<%= p.getStartTime()%>"
                                        data-endtime="<%= p.getEndTime()%>"
                                        data-motif="<%= p.getMotif()%>"
                                        data-status="<%= p.getStatus()%>">

                                    <svg xmlns="http://www.w3.org/2000/svg"
                                         viewBox="0 0 20 20"
                                         fill="#666"
                                         width="18"
                                         height="18">

                                    <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />

                                    <path fill-rule="evenodd"
                                          d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z"
                                          clip-rule="evenodd" />
                                    </svg>
                                </button>

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



        <script>
            window.addEventListener('load', function () {
                window.parent.postMessage('pageReady', '*');
            });

            window.addEventListener('load', function () {
                console.log('history page loaded, sending message...');
                window.parent.postMessage('pageReady', '*');
            });
        </script>
        <script>
            window.addEventListener('click', (e) => {
                const modal = document.getElementById('leaveModal');
                if (e.target === modal)
                    modal.style.display = 'none';
            });
        </script>
        <script>
            var params = new URLSearchParams(window.location.search);
            var targetId = params.get('id');
            var targetType = params.get('type');
            if (targetId) {
                document.documentElement.style.transition = 'opacity 0.5s ease';
                requestAnimationFrame(function () {
                    requestAnimationFrame(function () {
                        document.documentElement.style.opacity = '1';
                    });
                });
                setTimeout(function () {
                    var row = document.querySelector(
                            '[data-id="' + targetId + '"][data-type="' + targetType + '"]'
                            );
                    if (!row)
                        return;
                    row.scrollIntoView({behavior: 'smooth', block: 'center'});
                    row.classList.add('row-highlight');
                    setTimeout(function () {
                        row.classList.remove('row-highlight');
                    }, 2500);
                }, 500);
            }
        </script>
        <script>
            function applyFilters() {
                const selectedStatus = document.getElementById('statusFilter').value.toLowerCase();
                const selectedType = document.getElementById('typeFilter').value.toLowerCase();
                const selectedDate = document.getElementById('dateFilter').value.toLowerCase();
                const rows = document.querySelectorAll('#latest_b tbody tr');
                // --- Date range boundaries ---
                const now = new Date();
                const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                const yesterday = new Date(today);
                yesterday.setDate(today.getDate() - 1);
                const lastWeekStart = new Date(today);
                lastWeekStart.setDate(today.getDate() - 7);
                const lastMonthStart = new Date(today);
                lastMonthStart.setMonth(today.getMonth() - 1);
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
                    const descSpan = row.querySelectorAll('td:first-child div span');
                    const descText = descSpan[1] ? descSpan[1].textContent.trim().toLowerCase() : '';
                    const rowType = descText.includes('holidays') ? 'leave' : 'permission';
                    const typeMatch = selectedType === 'all' || rowType === selectedType;
                    // --- Date ---
                    // The start date is in the second <span> of the first <td>
                    const spans = row.querySelectorAll('td:first-child div span');
                    const rawDate = spans[2] ? spans[2].textContent.trim() : '';
                    const rowDate = new Date(rawDate);
                    rowDate.setHours(0, 0, 0, 0);
                    let dateMatch = true;
                    if (selectedDate !== 'all' && !isNaN(rowDate)) {
                        if (selectedDate === 'today') {
                            dateMatch = rowDate.getTime() === today.getTime();
                        } else if (selectedDate === 'yesterday') {
                            dateMatch = rowDate.getTime() === yesterday.getTime();
                        } else if (selectedDate === 'last_week') {
                            dateMatch = rowDate >= lastWeekStart && rowDate <= today;
                        } else if (selectedDate === 'last_month') {
                            dateMatch = rowDate >= lastMonthStart && rowDate <= today;
                        }
                    }

                    row.style.display = (statusMatch && typeMatch && dateMatch) ? '' : 'none';
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
            document.getElementById('dateFilter').addEventListener('change', applyFilters);
        </script>
        <script>
            const calendarEl = document.getElementById('calendar');
            let selectedEventId = null;
            let currentUserId = userId;
            const detailsAction = document.querySelector('.detailsAction');

            // 1. Create calendar first
            window.calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                firstDay: 1,
                showNonCurrentDates: false,
                hiddenDays: [0]
            });

            // 2. Add sources (triggers background fetch immediately on render)
            window.calendar.addEventSource({
                url: '<%= request.getContextPath()%>/CalendarHolidaysServlet',
                method: 'GET'
            });
            window.calendar.addEventSource({
                url: '<%= request.getContextPath()%>/CalendarPermissionServlet',
                method: 'GET',
                display: 'list-item',
                extraParams: {userId: currentUserId}
            });

            // 3. Render (fetches start here in background)
            window.calendar.render();

            // 4. Bind clicks
            document.querySelectorAll('.icon-btn-td').forEach(btn => {
                btn.addEventListener('click', () => {

                    selectedEventId = btn.dataset.holidayid;
                    console.log("Selected user_id4Calendar:", window.currentUserId);
                    console.log("Selected holiday_id4Calendar:", selectedEventId);

                    const status = btn.dataset.status;
                    const type = btn.dataset.type;
                    const actionsDiv = document.querySelector('.modal-actions');

                    // Show/hide the right form section
                    document.querySelector('.form-group-holiday').style.display = (type === 'holidays') ? 'block' : 'none';
                    document.querySelector('.form-group-permission').style.display = (type === 'permission') ? 'block' : 'none';

                    if (type === 'holidays') {
                        document.getElementById('modalId').textContent = "ID : #" + (btn.dataset.userid || "N/A");
                        document.getElementById('modalUsername').textContent = btn.dataset.username || "Unknown";
                        document.getElementById('modalMotif').textContent = btn.dataset.motif || "N/A";
                        document.getElementById('modalStartDate').value = btn.dataset.startdate || "";
                        document.getElementById('modalEndDate').value = btn.dataset.enddate || "";
                    } else if (type === 'permission') {
                        document.getElementById('modalId').textContent = "ID : #" + (btn.dataset.userid || "N/A");
                        document.getElementById('modalUsername').textContent = btn.dataset.username || "Unknown";
                        document.getElementById('modalStartTime').value = btn.dataset.starttime || "";
                        document.getElementById('modalEndTime').value = btn.dataset.endtime || "";
                        document.getElementById('modalMotifPermission').value = btn.dataset.motif || "";
                    }

                    actionsDiv.innerHTML = "";

                    if (status === "Pending") {
                        actionsDiv.innerHTML = `
                <button class="modal-btn" id="approveLeaveBtn" onclick="submitStatus('Approved')">Approve</button>
                <button class="modal-btn" id="rejectLeaveBtn" onclick="submitStatus('Rejected')">Reject</button>
                <button class="modal-btn" onclick="document.getElementById('leaveModal').style.display='none'">Cancel</button>
            `;
                    } else if (status === "Approved" || status === "Rejected") {
                        actionsDiv.innerHTML = `
                <button class="modal-btn" onclick="document.getElementById('leaveModal').style.display='none'">Cancel</button>
            `;
                    } else {
                        actionsDiv.innerHTML = `<button disabled>No actions available</button>`;
                    }



                    document.getElementById('leaveModal').style.display = 'block';

                    if (window.calendar) {
                        window.calendar.updateSize();
                    }
                });
            });
        </script>
    </body>
</html>