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
                        nextStep.scrollIntoView({behavior: 'smooth', block: 'start'});

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
            <div class="header-left">
                <span class="header-title">Make a request</span>
                <span class="header-dot">•</span>
                <div class="header-select-wrapper">
                    <select class="header-select">
                        <option>Leave</option>
                        <option>Permission</option>
                    </select>
                    <svg class="chevron" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="6 9 12 15 18 9"/>
                    </svg>
                </div>
            </div>
            <div class="header-right">
                <div class="header_btn">
                    <button class="header_icon" id="notificationBtn" onclick="toggleDropdown()">
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

        <div id="stepProgress">
            <div class="step active">1</div>
            <div class="step">2</div>
            <div class="step">3</div>
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
                            <button class="icon-btn"> <span class="icon-home">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                    <path fill-rule="evenodd" d="M1 6a3 3 0 0 1 3-3h12a3 3 0 0 1 3 3v8a3 3 0 0 1-3 3H4a3 3 0 0 1-3-3V6Zm4 1.5a2 2 0 1 1 4 0 2 2 0 0 1-4 0Zm2 3a4 4 0 0 0-3.665 2.395.75.75 0 0 0 .416 1A8.98 8.98 0 0 0 7 14.5a8.98 8.98 0 0 0 3.249-.604.75.75 0 0 0 .416-1.001A4.001 4.001 0 0 0 7 10.5Zm5-3.75a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Zm0 6.5a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Zm.75-4a.75.75 0 0 0 0 1.5h2.5a.75.75 0 0 0 0-1.5h-2.5Z" clip-rule="evenodd" />
                                    </svg></span> </button>
                            <span style="font-weight: bold;font-size: 1.4rem;align-content: center; color: #444;">
                                User Details</span>
                        </div>
                        <div class="header-right">
                        </div>
                    </div>
                    <div class="bar"></div>
                    <div class="content">
                        <form>
                            <div class="form-group">
                                <label for="username"> Name:</label> 
                                <div class="input-wrapper">
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
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
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
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
                                    <span class="icon-form"> <i class="zmdi  zmdi-calendar-alt"></i></span>
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
                            <h3 style=" margin:0; padding: 7px; font-size:1.4rem; color:#333;">Step 2: Leave Details</h3>
                            <div style="border-top: 1px solid #999; width: 90%;"></div>
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
                                <button type="submit" id="submitBtn" disabled class="btn-disabled">Create Event</button>
                                <button type="reset" id="clearForm" class="btn-enabled">Clear</button>
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
        </script>
    </body>
</html>
