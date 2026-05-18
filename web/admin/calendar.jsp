<%-- 
    Document   : calendar
    Created on : 15 mai 2026, 16:37:48
    Author     : HP
--%>

<%@page import="java.util.Date"%>
<%@page import="javafiles.UserPermission"%>
<%@page import="javafiles.UserLeave"%>
<%@page import="javafiles.UserPending"%>
<%@page import="java.util.List"%>
<%@page import="javafiles.userdataDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Calendar Admin Page</title>

        <!-- FullCalendar script -->
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>

        <link rel="stylesheet" 
              href="../css/admin/calendar_styles.css">

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
    </head>
    <body>

        <div class="dashboard">
            <main class="cards-section">
                <div class="banner">
                    <div style="position: relative; min-height: 150px;">
                        <div id="calendarLoader" class="chart-loader-wrapper">
                            <div class="loader" id="loader"></div>
                        </div>
                        <div id="calendar"></div>
                    </div>
                </div>
            </main>

            <aside class="side-section">
                <div class="agenda-card">
                    <h3>Agenda</h3>
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
                    headerToolbar: {
                        start: 'prev',
                        center: 'title',
                        end: 'next'
                    },
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
    </body>
</html>
