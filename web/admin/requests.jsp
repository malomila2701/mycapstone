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

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.1.0/css/all.min.css">
        <link rel="stylesheet" 
              href="../css/admin/adm_rq_styles.css">

        <title>JSP Page</title>

        <!-- FullCalendar script -->
        <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css' rel='stylesheet' />
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>
    </head>
    <body>

        <%
            int userId = (Integer) session.getAttribute("user_id");
            userdataDAO dao = new userdataDAO();
            List<UserLeave> daoAll = dao.getAdminAll();
            List<UserPending> daoPending = dao.getAdminPending();
        %>

        <%                String selectedAvatar = "../images/avatar1.jpg";
        %> 

        <!-- Pop-up détails de chaque requête -->
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
                    <!-- Actions -->
                    <div class="modal-actions" id="actionsDiv"></div>
                    <form id="statusForm" method="POST" action="<%= request.getContextPath()%>/UpdateLeaveStatusServlet">
                        <input type="hidden" name="holidayid" id="leaveId">
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
                        <option value="all">All Dates</option>
                            <option value="today">Today</option>
                            <option value="yesterday">Yesterday</option>
                            <option value="last_week">Last Week</option>
                            <option value="last_month">Last Month</option>
                    </select>
                    <select id="statusFilter">
                        <option value="all">All Status</option>
                        <option value="approved">Approved</option>
                        <option value="pending">Pending</option>
                        <option value="rejected">Rejected</option>
                    </select>
                </div>

                <div class="banner-right">
                </div>

            </div>

            <!-- Horizontal Line between request toolbar and tables-->
            <div class="bar"></div>


            <!--
            table
            ALL REQUESTS
            -->  
            <table class ="reqtable" cellspacing="0" id="alltable" style="opacity:1;">
                <%
                    if (daoAll == null || daoAll.isEmpty()) {
                %>
                <tbody>
                    <tr>
                        <td colspan="1" style="text-align: center; color: red;">No pending holidays found.</td>
                    </tr>
                    <%
                    } else {
                        for (UserLeave h : daoAll) {
                    %>

                    <tr>
                        <td>

                            <!-- Left: Avatar + Name/Type -->
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <!-- Avatar -->
                                <img src="<%= selectedAvatar%>" alt="User Avatar" style="width: 50px; height: 50px; border-radius: 50%;"/>

                                <!-- Name + Holiday Type -->
                                <div style="display: flex; flex-direction: column;">
                                    <span style="font-weight: 600;"><%=h.getFullName()%></span>
                                    <span style=" font-size: 0.9rem; font-weight: normal;">Holiday from <%= h.getStartDate()%> to <%= h.getEndDate()%></span>
                                    <span style=" font-size: 0.8rem; color: lightslategray"><%= h.getType()%></span>
                                </div>
                            </div>


                            <!-- Right: Status + Details Button -->
                            <div style="display: flex; align-items: center; gap: 10px;">


                                <% String status = h.getStatus();
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
                                        <%= h.getStatus()%> </span>
                                </div>

                                <!-- Details Button with vertical separator -->
                                <div id="detailsAction" style="border-left: 1px solid #ccc; padding-left: 10px; display: flex; align-items: center; justify-content: center;">
                                    <button class="detailsBtn" 

                                            data-userid="<%= h.getUserId()%>" 
                                            data-holidayid="<%= h.getHolidayId()%>" 
                                            data-username="<%= h.getFullName()%>"
                                            data-startdate="<%= h.getStartDate()%>"
                                            data-enddate="<%= h.getEndDate()%>"
                                            data-motif="<%= h.getMotif()%>"
                                            data-status="<%= h.getStatus()%>"

                                            style="background: none; border: none; cursor: pointer;">

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
        <script>
            const ROWS_PER_PAGE = 3; // change this to whatever limit you want
            let currentPage = 1;

            function paginateTable() {
                const table = document.getElementById('alltable');
                // Only count rows that passed the filter
                const visibleRows = Array.from(table.querySelectorAll('tbody tr'))
                        .filter(r => r.dataset.filtered !== 'true' && !r.querySelector('td[colspan]'));

                const totalPages = Math.ceil(visibleRows.length / ROWS_PER_PAGE);

                // First hide all rows, then show only the current page slice
                table.querySelectorAll('tbody tr').forEach(r => r.style.display = 'none');
                visibleRows.forEach((row, index) => {
                    const inRange = index >= (currentPage - 1) * ROWS_PER_PAGE && index < currentPage * ROWS_PER_PAGE;
                    row.style.display = inRange ? '' : 'none';
                });

                renderPagination(totalPages);
            }

            function renderPagination(totalPages) {
                let container = document.getElementById('pagination-container');
                if (!container) {
                    container = document.createElement('div');
                    container.id = 'pagination-container';
                    document.getElementById('alltable').insertAdjacentElement('afterend', container);
                }

                container.innerHTML = '';
                if (totalPages <= 1)
                    return; // hide if only one page

                // Prev button
                const prev = document.createElement('button');
                prev.textContent = '←';
                prev.className = 'page-btn';
                prev.disabled = currentPage === 1;
                prev.onclick = () => {
                    currentPage--;
                    paginateTable();
                };
                container.appendChild(prev);

                // Page numbers
                for (let i = 1; i <= totalPages; i++) {
                    const btn = document.createElement('button');
                    btn.textContent = i;
                    btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
                    btn.onclick = () => {
                        currentPage = i;
                        paginateTable();
                    };
                    container.appendChild(btn);
                }

                // Next button
                const next = document.createElement('button');
                next.textContent = '→';
                next.className = 'page-btn';
                next.disabled = currentPage === totalPages;
                next.onclick = () => {
                    currentPage++;
                    paginateTable();
                };
                container.appendChild(next);
            }

            // Init on load
            document.addEventListener('DOMContentLoaded', paginateTable);
        </script>
        <script>
            function applyFilters() {

                currentPage = 1;
                const selectedStatus = document.getElementById('statusFilter').value.toLowerCase();
                const selectedDate = document.getElementById('dateFilter').value.toLowerCase();
                const rows = document.querySelectorAll('#alltable tbody tr');

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

                    // --- Date ---
                    // The start date is in the second <span> of the first <td>
                    const spans = row.querySelectorAll('td:first-child div span');
                    const rawDate = spans[1] ? spans[1].textContent.trim() : '';
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

                    // Mark filtered rows instead of hiding directly — pagination will handle display
                    row.dataset.filtered = (statusMatch && dateMatch) ? 'false' : 'true';
                });

                // Reset to page 1 and re-paginate
                currentPage = 1;
                paginateTable();
                showEmptyMessageIfNeeded();
            }

            document.getElementById('statusFilter').addEventListener('change', applyFilters);
            document.getElementById('dateFilter').addEventListener('change', applyFilters);
        </script>
        <script>

            const calendarEl = document.getElementById('calendar');
            let calendar;
            let selectedEventId = null;
            let currentUserId = null;
            const detailsAction = document.querySelector('.detailsAction');

            window.calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                firstDay: 1,
                showNonCurrentDates: false,
                hiddenDays: [0]
            });
            window.calendar.render();


            // Open modal for each user button
            document.querySelectorAll('.detailsBtn').forEach(btn => {
                btn.addEventListener('click', () => {

                    // ✅ set correct global values
                    currentUserId = (btn.dataset.userid || "").trim();
                    selectedEventId = btn.dataset.holidayid;
                    console.log("Selected user:", currentUserId);
                    console.log("Selected event:", selectedEventId);
                    const status = btn.dataset.status;
                    const actionsDiv = document.querySelector('.modal-actions');
                    actionsDiv.innerHTML = "";
                    // buttons
                    if (status === "Pending") {
                        actionsDiv.innerHTML = `
                <button class="modal-btn" id="approveLeaveBtn" onclick="submitStatus('Approved')">Approve</button>
                <button class="modal-btn" id="rejectLeaveBtn" onclick="submitStatus('Rejected')">Reject</button>
                <button class="modal-btn" onclick="document.getElementById('leaveModal').style.display='none'">Cancel</button>
            `;
                    } else {
                        actionsDiv.innerHTML = `
                <button class="modal-btn" onclick="leaveModal.style.display='none'">Cancel</button>
            `;
                    }

                    // modal fill (FIXED)
                    document.getElementById('modalId').textContent =
                            "ID : #" + (btn.dataset.userid || "N/A");
                    document.getElementById('modalUsername').textContent =
                            btn.dataset.username || "Unknown";
                    document.getElementById('modalMotif').textContent =
                            btn.dataset.motif || "N/A";
                    document.getElementById('modalStartDate').value =
                            btn.dataset.startdate || "";
                    document.getElementById('modalEndDate').value =
                            btn.dataset.enddate || "";
                    // show modal
                    document.getElementById('leaveModal').style.display = 'block';

                    // reload calendar safely
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
                            url: '<%= request.getContextPath()%>/CalendarAdminUserLeaveServlet',
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
