<%-- 
    Document   : admin_requests
    Created on : 9 déc. 2025, 17:27:35
    Author     : HP
--%>

<%@page import="javafiles.UserPermission"%>
<%@page import="javafiles.UserLeave"%>
<%@page import="javafiles.UserPending"%>
<%@page import="java.util.List"%>
<%@page import="javafiles.userdataDAO"%>
<%@page import="javafiles.EmployeeInfo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <link rel="stylesheet" 
              href="../css/admin/adm_permission_styles.css">

        <title>JSP Page</title>

        <!-- FullCalendar script -->
        <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css' rel='stylesheet' />
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>
    </head>
    <body>

        <%
            int userId = (Integer) session.getAttribute("user_id");
            userdataDAO dao = new userdataDAO();
            List<UserPermission> daoPermission = dao.getAdminPermissionAll();
        %>

        <%                String selectedAvatar = "../images/avatar1.jpg";
        %> 

        <!-- Leave type modal -->
        <div id="leaveModal" class="modal">

            <div class="modal-content">

                <main class="details-section">
                    <span style="display:flex; flex-direction:row;">
                        <img src="<%= selectedAvatar%>" alt="User Avatar" class="avatar" style="margin-left: 15px;"/>
                        <span style="display: flex; flex-direction: column;">
                            <label class="modallabel-name" id="modalUsername">Unknown</label>
                            <label class="modallabel-id" id="modalId"> ID: #</label>
                        </span>
                    </span>

                    <form action="FirstServlet" method="post">
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
                    </form>

                    <div class="modal-actions" id="actionsDiv"></div>
                    <form id="statusForm" method="POST" action="<%= request.getContextPath()%>/UpdatePermissionStatusServlet">
                        <input type="hidden" name="permission_id" id="leaveId">
                        <input type="hidden" name="user_id" id="leaveUserId">
                        <input type="hidden" name="status" id="leaveStatus">
                    </form>
                </main>

                <aside class="side-section">
                    <div id="calendar">
                    </div>
                </aside>

            </div>
        </div>








        <div style="overflow-y: visible;">
            <div class="banner">

                <div class="banner-left">
                    <div class="search-box">
                        <span class="icon-searchbox"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                            <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
                            </svg>
                        </span>
                        <input type="text" placeholder="Search by Name or ID">
                    </div>
                    <select id="dateFilter" style="margin-right: 10px;">
                        <option value="today">Today</option>
                        <option value="last_week">Last week</option>
                        <option value="older">More than 2 weeks ago</option>
                    </select>
                    <select id="dateStatus">
                        <option value="all">All Status</option>
                        <option value="approved">Approved</option>
                        <option value="pending">Pending</option>
                        <option value="older">Rejected</option>
                    </select>
                </div>

                <div class="banner-right">
                </div>

            </div>


            <div class="bar"></div>
            <!-- table for PERMISSIONS requests -->
            <table class ="reqtable" cellspacing="0" id="permissiontable">
                <%
                    if (daoPermission == null || daoPermission.isEmpty()) {
                %>
                <tbody>
                    <tr>
                        <td colspan="1" style="text-align: center; color: red;">No pending holidays found.</td>
                    </tr>
                    <%
                    } else {
                        for (UserPermission p : daoPermission) {
                    %>

                    <tr>
                        <td>

                            <!-- Left: Avatar + Name/Type -->
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <!-- Avatar -->
                                <img src="<%= selectedAvatar%>" alt="User Avatar" style="width: 50px; height: 50px; border-radius: 50%;"/>

                                <!-- Name + Holiday Type -->
                                <div style="display: flex; flex-direction: column;">
                                    <span style="font-weight: 600;"><%=p.getFullName()%></span>
                                    <span style=" font-size: 0.9rem; font-weight: normal;">Permission on <%=p.getEndDate()%> from <%=p.getStartTime()%> to <%=p.getEndTime()%></span>
                                    <span style=" font-size: 0.8rem; color: lightslategray">Permission</span>
                                </div>
                            </div>


                            <!-- Right: Status + Details Button -->
                            <div style="display: flex; align-items: center; gap: 10px;">


                                <% String status = p.getStatus();
                                    String cssClass = "";
                                    if ("rejected".equalsIgnoreCase(status)) {
                                        cssClass = "status-rejected";
                                    } else if ("approved".equalsIgnoreCase(status)) {
                                        cssClass = "status-approved";
                                    } else if ("pending".equalsIgnoreCase(status)) {
                                        cssClass = "status-pending";
                                    }%>
                                <!-- Status with vertical separator -->
                                <div style="border-left: 1px solid #ccc; padding-left: 10px; display: flex; align-items: center; min-width: 80px; height: 35px; justify-content: center;">
                                    <span class="status <%= cssClass%>"> 
                                        <%= p.getStatus()%> </span>
                                </div>

                                <!-- Details Button with vertical separator -->
                                <div style="border-left: 1px solid #ccc; padding-left: 10px; display: flex; align-items: center; justify-content: center;">
                                    <button class="detailsBtn" 

                                            data-userid="<%= p.getUserId()%>" 
                                            data-holidayid="<%= p.getPermissionId()%>" 
                                            data-username="<%= p.getFullName()%>"
                                            data-startdate="<%= p.getStartDate()%>"
                                            data-enddate="<%= p.getEndDate()%>"
                                            data-starttime="<%= p.getStartTime()%>"
                                            data-endtime="<%= p.getEndTime()%>"
                                            data-motif="<%= p.getMotif()%>"
                                            data-status="<%= p.getStatus()%>">

                                        <span class="icon-home">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#666" width="20" height="20">
                                            <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
                                            <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
                                            </svg>
                                        </span>
                                    </button>
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

        <script src="../scripts/utils.js"></script>
        <!--<script>
            const filter = document.getElementById('dateStatus');
            const tablePending = document.getElementById('pendingtable');
            const tableAll = document.getElementById('alltable');

            filter.addEventListener('change', function () {
                if (this.value === 'pending') {
                    tablePending.style.display = 'table';
                    tableAll.style.display = 'none';
                } else if (this.value === 'all') {
                    tablePending.style.display = 'none';
                    tableAll.style.display = 'table';
                }
            });

        </script>-->
        <script>

            const calendarEl = document.getElementById('calendar');
            let calendar;
            let selectedEventId = null;
            let currentUserId = null;
            const detailsAction = document.querySelector('.detailsAction');

            window.calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                eventSources: [],
                firstDay: 1,
                showNonCurrentDates: false,
                hiddenDays: [0]
            });

            window.calendar.render();

            // Open modal for each user button
            document.querySelectorAll('.detailsBtn').forEach(btn => {
                btn.addEventListener('click', () => {

                    // UserId
                    currentUserId = (btn.dataset.userid || "").trim();
                    selectedEventId = btn.dataset.holidayid;
                    console.log("Selected user_id4Calendar:", window.currentUserId);
                    console.log("Selected holiday_id4Calendar:", selectedEventId);


                    const status = btn.dataset.status;
                    const actionsDiv = document.querySelector('.modal-actions');
                    actionsDiv.innerHTML = "";
                    // Conditional buttons
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
                        actionsDiv.innerHTML = `
                <button disabled>No actions available</button>
            `;
                    }

                    // Fill modal
                    document.getElementById('modalId').textContent = "ID : #" + (btn.dataset.userid || "N/A");
                    document.getElementById('modalUsername').textContent = btn.dataset.username || "Unknown";
                    document.getElementById('modalMotif').textContent = btn.dataset.motif || "N/A";
                    document.getElementById('modalStartDate').value = btn.dataset.startdate || "";
                    document.getElementById('modalEndDate').value = btn.dataset.enddate || "";

                    // Show modal
                    document.getElementById('leaveModal').style.display = 'block';

                    // Make sure calendar exists
                    if (window.calendar) {
                        // Remove old sources
                        window.calendar.removeAllEventSources();
                        // Add holidays source
                        window.calendar.addEventSource({
                            url: '<%= request.getContextPath()%>/CalendarHolidaysServlet',
                            method: 'GET'
                        });
                        //PermissionCalendar
                        window.calendar.addEventSource({
                            url: '<%= request.getContextPath()%>/CalendarPermissionServlet',
                            method: 'GET',
                            display: 'list-item',
                            extraParams: {
                                userId: currentUserId
                            }
                        });
                        // Refresh events
                        window.calendar.refetchEvents();
                    }
                });
            });

            function submitStatus(newStatus) {

                console.log("Submitting ID:", selectedEventId);
                // SAFETY CHECK
                if (!selectedEventId) {
                    alert("No event selected!");
                    return;
                }
                // ️Passer les IDs dans des champs cachés du formulaire pour le Servlet
                document.getElementById('leaveId').value = selectedEventId;
                document.getElementById('leaveStatus').value = newStatus;
                document.getElementById('leaveUserId').value = currentUserId;
                document.getElementById('statusForm').submit();

                // après ton UPDATE + INSERT notification
                request.getHeader("Referer");
            }

        </script>
    </body>
</html>
