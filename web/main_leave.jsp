<%-- 
    Document   : makearequest
    Created on : 5 déc. 2025, 08:25:48
    Author     : HP
--%>

<%@page import="javafiles.userdataDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <link rel="stylesheet" 
              href="css/requests_styles.css">

        <link rel="stylesheet" 
              href="https://cdn.jsdelivr.net/npm/material-design-iconic-font@2.2.0/dist/css/material-design-iconic-font.min.css">

        <!--FULLCALENDAR-->
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>

        <%
            String message = (String) request.getAttribute("responseMessage");
            String status = (String) request.getAttribute("responseStatus");
        %>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const calendarEl = document.getElementById('calendar');
                const nextStep = document.getElementById('nextStep');
                const steps = document.querySelectorAll('.step');
                const stepProgress = document.getElementById('stepProgress');
                const label = document.getElementById('stepLabel');

                const eventStartInput = document.getElementById('eventStart');
                const eventEndInput = document.getElementById('eventEnd');
                const eventTypeInput = document.getElementById('eventType');

                const leaveModal = document.getElementById('leaveModal');
                const leaveTypeSelect = document.getElementById('leaveType');
                const confirmLeaveBtn = document.getElementById('confirmLeave');
                const cancelLeaveBtn = document.getElementById('cancelLeave');

                const resetBtn = document.getElementById('clearForm');

                let selectedInfo = null; // store calendar selection

                function updateProgress(stepIndex) {
                    const totalSteps = steps.length;
                    const percent = (stepIndex / (totalSteps - 1)) * 100;
                    stepProgress.style.setProperty('--progress-width', percent + '%');
                }

                const calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    selectable: true,
                    showNonCurrentDates: false,
                    firstDay: 1,
                    weekends: false,
                    events: '<%= request.getContextPath()%>/CalendarLeaveServlet',

                    select: function (info) {
                        selectedInfo = info; // save selection
                        leaveModal.style.display = 'block'; // show modal
                    }
                });

                confirmLeaveBtn.addEventListener('click', function () {
                    const leaveType = leaveTypeSelect.value;
                    if (selectedInfo && leaveType) {
                        // Add event to calendar
                        calendar.addEvent({
                            id: 'pendingLeave',
                            title: leaveType,
                            start: selectedInfo.startStr,
                            end: selectedInfo.endStr,
                            allDay: true
                        });

                        // Update progress bar
                        steps[1].classList.add('active');
                        updateProgress(1);
                        // update label
                        label.textContent = `Step 2: Review the leave details`;

                        // Close modal
                        leaveModal.style.display = 'none';
                        calendar.unselect();

                        // Show next step section
                        nextStep.style.display = 'block';
                        setTimeout(() => {
                            const aside = document.querySelector('.side-section');
                            aside.scrollTo({top: aside.scrollHeight, behavior: 'smooth'});
                        }, 50);

                        // Fill next step form
                        eventStartInput.value = selectedInfo.startStr;
                        eventEndInput.value = selectedInfo.endStr;
                        eventTypeInput.value = leaveType;

                    }
                });

                cancelLeaveBtn.addEventListener('click', function () {
                    leaveModal.style.display = 'none';
                    calendar.unselect();
                });

                document.getElementById("clearForm").addEventListener("click", function () {
                    // remove the event added to the calendar
                    const addedEvent = calendar.getEventById("pendingLeave");
                    if (addedEvent)
                        addedEvent.remove();

                    // hide next step section and reset progress
                    nextStep.style.display = 'none';
                    steps[1].classList.remove('active');
                    updateProgress(0);
                    label.textContent = `Step 1: Select leave dates`;

                    selectedInfo = null;
                    calendar.unselect();
                });

                calendar.render();
            });

        </script>
        <script>
            window.onload = function () {
            <% if (message != null) { %>
                $('#responseModal').modal('show');
            <% } %>
            };
        </script>
    </head>
    <body>


        <!-- Error Modal -->
        <div id="responseModal" class="modal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title"></h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        ${responseMessage}
                    </div>
                </div>
            </div>
        </div>

        <!-- Leave type modal -->
        <div id="leaveModal" class="modal">
            <div class="modal-content">
                <h3 style="font-size: 1rem; color: #666;">Select Leave Type</h3>
                <form id="leaveForm">
                    <label for="leaveType"><span style="font-size: 0.9rem; color: #666;">Leave Type:</span></label>
                    <select id="leaveType" name="leaveType">
                        <option value="Annual Leave">Annual Leave</option>
                        <option value="Sick Leave">Sick Leave</option>
                        <option value="Maternity Leave">Maternity Leave</option>
                        <option value="Paternity Leave">Bereavement Leave</option>
                        <option value="Unpaid Leave">Unpaid Leave</option>
                        <option value="Other">Other</option>
                    </select>
                    <div class="modal-actions">
                        <button type="button" class="modal-btn" id="confirmLeave">Confirm</button>
                        <button type="button" class="modal-btn" id="cancelLeave">Cancel</button>
                    </div>
                </form>
            </div>
        </div>



        <div class="header" id="top-header">
            <span class="header-title">Make a request</span>
            <span class="header-dot">•</span>
            <div class="header-select-wrapper">
                <select class="header-select">
                    <option>Leave</option>
                    <option>Permission</option>
                </select>
                <script>
                    const typeSelect = document.querySelector('.header-select');
                    typeSelect.value = 'Leave';

                    typeSelect.addEventListener('change', function () {
                        goToRequest(this.value.toLowerCase());
                    });
                </script>
                <svg class="chevron" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="6 9 12 15 18 9"/>
                </svg>
            </div>
        </div>

        <div id="stepProgress">
            <div class="step active"></div>
            <div class="step">
                <span class="icon-home">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#215f91" class="size-5">
                    <path fill-rule="evenodd" d="M4.606 12.97a.75.75 0 0 1-.134 1.051 2.494 2.494 0 0 0-.93 2.437 2.494 2.494 0 0 0 2.437-.93.75.75 0 1 1 1.186.918 3.995 3.995 0 0 1-4.482 1.332.75.75 0 0 1-.461-.461 3.994 3.994 0 0 1 1.332-4.482.75.75 0 0 1 1.052.134Z" clip-rule="evenodd" />
                    <path fill-rule="evenodd" d="M5.752 12A13.07 13.07 0 0 0 8 14.248v4.002c0 .414.336.75.75.75a5 5 0 0 0 4.797-6.414 12.984 12.984 0 0 0 5.45-10.848.75.75 0 0 0-.735-.735 12.984 12.984 0 0 0-10.849 5.45A5 5 0 0 0 1 11.25c.001.414.337.75.751.75h4.002ZM13 9a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z" clip-rule="evenodd" />
                    </svg>
                </span>
            </div>
        </div>
        <div id="stepLabel">Step 1: Click & Drag the leave period</div>


        <!-- 
            MAIN SECTION 
        -->
        <div class="dashboard">

            <main class="cards-section">

                <div id="user_banner">

                    <div class="header">
                        <div class="header-left"> 
                            <button class="icon-btn" id="icon-btn-header"> <span class="icon-home">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#34495e" class="size-5">
                                    <path fill-rule="evenodd" d="M1 6a3 3 0 0 1 3-3h12a3 3 0 0 1 3 3v8a3 3 0 0 1-3 3H4a3 3 0 0 1-3-3V6Zm4 1.5a2 2 0 1 1 4 0 2 2 0 0 1-4 0Zm2 3a4 4 0 0 0-3.665 2.395.75.75 0 0 0 .416 1A8.98 8.98 0 0 0 7 14.5a8.98 8.98 0 0 0 3.249-.604.75.75 0 0 0 .416-1.001A4.001 4.001 0 0 0 7 10.5Zm5-3.75a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Zm0 6.5a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Zm.75-4a.75.75 0 0 0 0 1.5h2.5a.75.75 0 0 0 0-1.5h-2.5Z" clip-rule="evenodd" />
                                    </svg></span> </button>
                            <span style="font-weight: bold;font-size: 1.5rem; color: #34495e;">
                                User Details</span>
                        </div>
                    </div>

                    <div class="content">
                        <form>
                            <div class="form-group">
                                <label for="username"> Name:</label> 
                                <div class="input-wrapper">
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#34495e" class="size-5">
                                        <path d="M10 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM3.465 14.493a1.23 1.23 0 0 0 .41 1.412A9.957 9.957 0 0 0 10 18c2.31 0 4.438-.784 6.131-2.1.43-.333.604-.903.408-1.41a7.002 7.002 0 0 0-13.074.003Z" />
                                        </svg>
                                    </span>
                                    <input type="text" name="username" id="username" 
                                           value=${sessionScope.fullname} readonly />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email"> Email: </label> 
                                <div class="input-wrapper">
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#34495e" class="size-5">
                                        <path d="M3 4a2 2 0 0 0-2 2v1.161l8.441 4.221a1.25 1.25 0 0 0 1.118 0L19 7.162V6a2 2 0 0 0-2-2H3Z" />
                                        <path d="m19 8.839-7.77 3.885a2.75 2.75 0 0 1-2.46 0L1 8.839V14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V8.839Z" />
                                        </svg>
                                    </span>
                                    <input type="email" name="email" id="email" 
                                           value=${sessionScope.email} readonly />
                                </div>
                            </div>
                            <%
                                int userId = (Integer) session.getAttribute("user_id");
                                userdataDAO dao = new userdataDAO();
                                String value = dao.getInfo(userId);
                            %>
                            <div class="form-group">
                                <label for="latestleave"> Latest leave:</label> 
                                <div class="input-wrapper">
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#34495e" class="size-5">
                                        <path d="M10 9.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V10a.75.75 0 0 0-.75-.75H10ZM6 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H6ZM8 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H8ZM9.25 14a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V14ZM12 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H12ZM12 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H12ZM13.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H14a.75.75 0 0 1-.75-.75V12ZM11.25 10.005c0-.417.338-.755.755-.755h2a.755.755 0 1 1 0 1.51h-2a.755.755 0 0 1-.755-.755ZM6.005 11.25a.755.755 0 1 0 0 1.51h4a.755.755 0 1 0 0-1.51h-4Z" />
                                        <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                        </svg></span>
                                    <input type="text" name="latestleave" id="latestleave" 
                                           value=<%= value%> readonly />
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </main>

            <aside class="side-section">

                <div id="calendarContainer">
                    <div id="calendar"></div>

                    <div id="nextStep">
                        <div>
                            <h3>Step 2: Leave Details</h3>
                            <form id="nextStep_form" action="NewLeaveServlet" method="post">

                                <div class="form-group">
                                    <label for="eventStart"> Start Date:</label> 
                                    <div class="input-wrapper">
                                        <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
                                            <path d="M12.75 12.75a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM7.5 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM8.25 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM9.75 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM10.5 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM12 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM12.75 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM14.25 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM15 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM16.5 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM15 12.75a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM16.5 13.5a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z" />
                                            <path fill-rule="evenodd" d="M6.75 2.25A.75.75 0 0 1 7.5 3v1.5h9V3A.75.75 0 0 1 18 3v1.5h.75a3 3 0 0 1 3 3v11.25a3 3 0 0 1-3 3H5.25a3 3 0 0 1-3-3V7.5a3 3 0 0 1 3-3H6V3a.75.75 0 0 1 .75-.75Zm13.5 9a1.5 1.5 0 0 0-1.5-1.5H5.25a1.5 1.5 0 0 0-1.5 1.5v7.5a1.5 1.5 0 0 0 1.5 1.5h13.5a1.5 1.5 0 0 0 1.5-1.5v-7.5Z" clip-rule="evenodd" />
                                            </svg>
                                        </span>
                                        <input type="text" name="eventStart" id="eventStart" readonly />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="eventEnd"> End Date:</label> 
                                    <div class="input-wrapper">
                                        <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
                                            <path d="M12.75 12.75a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM7.5 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM8.25 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM9.75 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM10.5 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM12 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM12.75 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM14.25 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM15 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM16.5 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM15 12.75a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM16.5 13.5a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z" />
                                            <path fill-rule="evenodd" d="M6.75 2.25A.75.75 0 0 1 7.5 3v1.5h9V3A.75.75 0 0 1 18 3v1.5h.75a3 3 0 0 1 3 3v11.25a3 3 0 0 1-3 3H5.25a3 3 0 0 1-3-3V7.5a3 3 0 0 1 3-3H6V3a.75.75 0 0 1 .75-.75Zm13.5 9a1.5 1.5 0 0 0-1.5-1.5H5.25a1.5 1.5 0 0 0-1.5 1.5v7.5a1.5 1.5 0 0 0 1.5 1.5h13.5a1.5 1.5 0 0 0 1.5-1.5v-7.5Z" clip-rule="evenodd" />
                                            </svg>
                                        </span>
                                        <input type="text" name="eventEnd" id="eventEnd" readonly />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="eventType"> Leave Type:</label> 
                                    <div class="input-wrapper">
                                        <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
                                            <path d="M12.75 12.75a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM7.5 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM8.25 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM9.75 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM10.5 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM12 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM12.75 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM14.25 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM15 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM16.5 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM15 12.75a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM16.5 13.5a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z" />
                                            <path fill-rule="evenodd" d="M6.75 2.25A.75.75 0 0 1 7.5 3v1.5h9V3A.75.75 0 0 1 18 3v1.5h.75a3 3 0 0 1 3 3v11.25a3 3 0 0 1-3 3H5.25a3 3 0 0 1-3-3V7.5a3 3 0 0 1 3-3H6V3a.75.75 0 0 1 .75-.75Zm13.5 9a1.5 1.5 0 0 0-1.5-1.5H5.25a1.5 1.5 0 0 0-1.5 1.5v7.5a1.5 1.5 0 0 0 1.5 1.5h13.5a1.5 1.5 0 0 0 1.5-1.5v-7.5Z" clip-rule="evenodd" />
                                            </svg>
                                        </span>
                                        <input type="text" name="eventType" id="eventType" readonly />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="eventDescription"> Reason:</label> 
                                    <div class="input-wrapper">
                                        <textarea 
                                            id="eventDescription" name ="eventDescription" 
                                            rows="3"></textarea>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <button type="submit" id="submitBtn" disabled class="btn-disabled">
                                        <span class="btn-label">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" width="16" height="16" style="vertical-align:-3px; margin-right:6px;">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" />
                                            </svg>
                                            Create Event
                                        </span>
                                        <span class="btn-spinner">
                                            <span class="dot-pulse"><span></span><span></span><span></span></span>
                                            Creating…
                                        </span>
                                    </button>
                                    <button type="reset" id="clearForm" class="icon-btn-form">
                                        <span class="icon-home">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#0078d7" class="size-6">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
                                            </svg>
                                        </span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </aside>
        </div>

        <script src="scripts/utils.js"></script>
        <script>
                    const textarea = document.getElementById("eventDescription");
                    const submitBtn = document.getElementById("submitBtn");

                    // your existing textarea listener stays untouched
                    textarea.addEventListener("input", () => {
                        if (textarea.value.trim().length > 0) {
                            submitBtn.disabled = false;
                            submitBtn.classList.remove("btn-disabled");
                            submitBtn.classList.add("btn-enabled");
                        } else {
                            submitBtn.disabled = true;
                            submitBtn.classList.remove("btn-enabled");
                            submitBtn.classList.add("btn-disabled");
                        }
                    });

                    document.querySelector("#nextStep_form").addEventListener("submit", function (e) {
                        e.preventDefault();
                        const btn = document.getElementById("submitBtn");
                        const form = this;

                        // ripple
                        const ripple = document.createElement("span");
                        ripple.className = "ripple";
                        const rect = btn.getBoundingClientRect();
                        const size = Math.max(rect.width, rect.height);
                        ripple.style.cssText = `width:${size}px;height:${size}px;left:${rect.width/2 - size/2}px;top:${rect.height/2 - size/2}px`;
                        btn.appendChild(ripple);
                        ripple.addEventListener("animationend", () => ripple.remove());

                        btn.classList.add("loading");


                        btn.disabled = true;

                        // let the animation show, then submit for real
                        setTimeout(() => {
                            btn.classList.remove("loading");
                            btn.classList.add("done");
                            btn.querySelector(".btn-label").innerHTML = `
        Event created! <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16" style="vertical-align:-3px;margin-right:6px;">
            <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z" clip-rule="evenodd" />
        </svg>`;
                            setTimeout(() => {
                                document.body.classList.add("fade-out");
                                setTimeout(() => form.submit(), 400); // wait for fade to finish
                            }, 600); // show green state for 600ms before fading
                        }, 800);
                    });
        </script>
    </body>
</html>