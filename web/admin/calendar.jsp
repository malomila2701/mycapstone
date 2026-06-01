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

        <div id="leaveModal" class="modal">
            <div class="modal-content">
                <!--Bouton close-->
                <button class="modal-close-btn" onclick="closeModal()">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                    <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
                    </svg>
                </button>
                <!--Section de details (Nom, email) (Période de congés) (Boutons)-->
                <main class="details-section">
                    <div style="
                         background: #f3f6fa;
                         padding: 10px;
                         border: 1px solid #E2E8F0;
                         border-radius: 20px;
                         ">
                        <span style="display:flex; flex-direction:row;">
                            <img src="<%= request.getContextPath()%>/AvatarServlet?userId=<%=userId%>"
                                 style="width:40px; height:40px; border-radius:50%; background: #eef; margin-left: 15px;" title="" alt="" />

                            <span style="display: flex; flex-direction: column;">
                                <label class="modallabel-name" id="modalUsername">Unknown</label>
                                <span style="display: flex; flex-direction: row; text-align: center; align-items:center;">
                                    <span class="icon-btn-modal icon-home-modal" style="margin-left: 15px;">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
                                        </svg>
                                    </span>
                                    <label class="modallabel-email" id="modalUserEmail"></label>
                                </span>
                            </span>
                        </span>
                    </div>
                    <div style="
                         background: white;
                         padding: 10px;
                         border: 1px solid #ccc;
                         border-radius: 20px;
                         margin-top: 10px;
                         ">
                        <form action="FirstServlet" method="post">
                            <label style="margin-left: 10px; padding-bottom: 5px; font-size: 0.7rem; font-weight: 600; text-transform: uppercase; color: lightslategray; white-space: nowrap;">
                                Permission Period
                            </label>

                            <div style="display: flex; flex-direction: row; justify-content: space-between; align-items:center;">

                                <div style="display:flex; align-items:center; margin-left: 5px; gap:4px; padding-bottom: 5px;">
                                    <span class="icon-btn-modal icon-home-modal"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#0078d7" class="size-5">
                                        <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                        </svg></span>
                                    <label id="modalStartDate" style="margin-left: 0; font-size: 0.8rem; font-weight: normal; color: #333;"></label>
                                </div>

                                &rarr;

                                <div style="display:flex; align-items:center; gap:4px;">
                                    <span class="icon-btn-modal icon-home-modal"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#0078d7" class="size-5">
                                        <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                        </svg></span>
                                    <label id="modalEndDate" style="margin-left: 0; font-size: 0.8rem; font-weight: normal; color: #333;"></label> 
                                </div>
                            </div>
                        </form>
                    </div>

                    <label style="margin-top: 10px; margin-left: 10px; font-size: 0.7rem; font-weight: 600; text-transform: uppercase; color: lightslategray; white-space: nowrap;" for="modalMotif"> Reason/Motif </label> 
                    <div style="
                         background: #f3f6fa;
                         padding: 10px;
                         border: 1px solid #ccc;
                         border-radius: 20px;
                         margin-top: 5px;
                         ">
                        <textarea id="modalMotif" readonly></textarea>
                    </div>
                    <span style="border-bottom: 1px solid #ccc; width: 100%;"></span>
                    <!-- Modal Actions & form with hidden data -->
                    <div class="modal-actions" id="actionsDiv">
                        <!--Modal Action when status is pending-->
                        <div id="actions-pending" style="display:none">
                            <button class="modal-btn cancelLeaveBtn" onclick="closeModal()">
                                Cancel
                            </button>
                            <button class="modal-btn" id="rejectLeaveBtn" onclick="openConfirmPopup('Rejected')">
                                <span class="icon-btn-modal icon-home">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#c70036" class="size-5">
                                    <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
                                    </svg>
                                </span>
                                Reject
                            </button>
                            <button class="modal-btn" id="approveLeaveBtn" onclick="openConfirmPopup('Approved')">
                                <span class="icon-btn-modal icon-home">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="white" class="size-5">
                                    <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z" clip-rule="evenodd" />
                                    </svg>
                                </span>
                                Approve
                            </button>
                        </div>
                        <!--Modal Actions when status is approved/rejected-->
                        <div id="actions-reviewed" style="display:none">
                            <button class="modal-btn" id="resetPendingBtn" onclick="openConfirmPopup('Pending')">
                                <span class="icon-btn-modal icon-home">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                    <path fill-rule="evenodd" d="M15.312 11.424a5.5 5.5 0 0 1-9.201 2.466l-.312-.311h2.433a.75.75 0 0 0 0-1.5H3.989a.75.75 0 0 0-.75.75v4.242a.75.75 0 0 0 1.5 0v-2.43l.31.31a7 7 0 0 0 11.712-3.138.75.75 0 0 0-1.449-.39Zm1.23-3.723a.75.75 0 0 0 .219-.53V2.929a.75.75 0 0 0-1.5 0V5.36l-.31-.31A7 7 0 0 0 3.239 8.188a.75.75 0 1 0 1.448.389A5.5 5.5 0 0 1 13.89 6.11l.311.31h-2.432a.75.75 0 0 0 0 1.5h4.243a.75.75 0 0 0 .53-.219Z" clip-rule="evenodd" />
                                    </svg>
                                </span>
                                Put as pending
                            </button>
                            <button class="modal-btn cancelLeaveBtn" onclick="closeModal()">
                                Cancel
                            </button>
                        </div>
                        <div id="actions-none" style="display:none">
                            <button disabled>No actions available</button>
                        </div>
                    </div>
                    <form id="statusForm" method="POST" action="<%= request.getContextPath()%>/UpdatePermissionStatusServlet">
                        <input type="hidden" name="permission_id" id="leaveId">
                        <input type="hidden" name="user_id" id="leaveUserId">
                        <input type="hidden" name="status" id="leaveStatus">
                        <input type="hidden" name="admin_message" id="leaveAdminMessage">
                    </form>

                </main>
            </div>
        </div>

        <div id="confirmPopup" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:9999; align-items:center; justify-content:center;">
            <div style="background:#fff; border-radius:8px; padding:24px; width:340px; display:flex; flex-direction:column; gap:12px;">
                <h3 style="margin:0;">Confirm: <span id="confirmPopupStatus"></span></h3>
                <textarea id="adminMessageInput" rows="4" placeholder="Add a message (optional)..." style="resize:vertical; padding:8px; border:1px solid #ccc; border-radius:6px; font-size:14px;"></textarea>
                <input type="hidden" id="pendingStatus">
                <div style="display:flex; gap:8px; justify-content:flex-end;">
                    <button class="modal-btn" onclick="closeConfirmPopup()">Cancel</button>
                    <button class="modal-btn" onclick="submitWithMessage()">Submit</button>
                </div>
            </div>
        </div>

        <!--
        -
        -
        DASHBOARD
        -
        -
        -->

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
            let currentUserId = <%= session.getAttribute("user_id")%>;
            let selectedEventId;
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
                            display: 'block'
                        },
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
                    eventClick: function (info) {
                        const event = info.event;
                        const props = event.extendedProps;
                        selectedEventId = props.leaveId;
                        currentUserId = props.userId;

                        // Infos utilisateur
                        document.getElementById('modalUsername').textContent = props.fullName || 'Unknown';
                        document.getElementById('modalUserEmail').textContent = props.email || '';

                        // Avatar
                        document.querySelector('#leaveModal img').src =
                                '<%= request.getContextPath()%>/AvatarServlet?userId=' + props.userId;

                        // Période
                        document.getElementById('modalStartDate').textContent = event.startStr;
                        document.getElementById('modalEndDate').textContent = event.endStr || event.startStr;

                        // Motif
                        document.getElementById('modalMotif').value = props.motif || '';

                        // Hidden fields du statusForm
                        document.getElementById('leaveId').value = props.leaveId;
                        document.getElementById('leaveUserId').value = props.userId;
                        document.getElementById('leaveStatus').value = props.status;


                        // Boutons selon statut
                        document.getElementById('actions-pending').style.display = 'none';
                        document.getElementById('actions-reviewed').style.display = 'none';
                        document.getElementById('actions-none').style.display = 'none';

                        const status = (props.status || '').toLowerCase();
                        if (status === 'pending') {
                            document.getElementById('actions-pending').style.display = 'flex';
                        } else if (status === 'approved' || status === 'rejected') {
                            document.getElementById('actions-reviewed').style.display = 'flex';
                        } else {
                            document.getElementById('actions-none').style.display = 'block';
                        }

                        // Ouvre le modal
                        openModal();
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
            function openModal() {
                const modal = document.getElementById('leaveModal');
                modal.classList.add('active');
                document.body.style.overflow = 'hidden';
                requestAnimationFrame(() => {
                    requestAnimationFrame(() => {
                        modal.classList.add('visible');
                    });
                });
            }

            // Pour fermer
            function closeModal() {
                const modal = document.getElementById('leaveModal');
                modal.classList.remove('visible');
                document.body.style.overflow = '';
                modal.addEventListener('transitionend', () => {
                    modal.classList.remove('active');
                }, {once: true});
            }
        </script>
    </body>
</html>
