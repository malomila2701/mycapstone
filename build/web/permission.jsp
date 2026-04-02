<%-- 
    Document   : permission.jsp
    Created on : 27 mars 2026, 14:08:46
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
              href="css/permission_styles.css">

        <link rel="stylesheet" 
              href="https://cdn.jsdelivr.net/npm/material-design-iconic-font@2.2.0/dist/css/material-design-iconic-font.min.css">

        <!--FLATPICKR-->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

        <!--FULLCALENDAR-->
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {

                const calendarEl = document.getElementById('calendar');

                const nextStep = document.getElementById('nextStep');
                const finalStep = document.getElementById('finalStep');

                const steps = document.querySelectorAll('.step');
                const stepProgress = document.getElementById('stepProgress');
                const label = document.getElementById('stepLabel');

                const eventDayInput = document.getElementById('eventDay');
                const eventTypeInput = document.getElementById('eventType');

                const startTimeInput = document.getElementById("startTime");
                const endTimeInput = document.getElementById("endTime");

                const startTime = startTimeInput.value;
                const endTime = endTimeInput.value;

                const continueBtn = document.getElementById('continueBtn');
                const confirmLeaveBtn = document.getElementById('confirmLeave');
                const cancelLeaveBtn = document.getElementById('cancelLeave');

                let selectedInfo = null; // store calendar selection

                function updateProgress(stepIndex) {
                    const totalSteps = steps.length;
                    const percent = (stepIndex / (totalSteps - 1)) * 100;
                    stepProgress.style.setProperty('--progress-width', percent + '%');
                }

                const calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridWeek',
                    selectable: true,
                    showNonCurrentDates: false,
                    firstDay: 1,
                    weekends: false,
                    events: '<%= request.getContextPath()%>/CalendarLeaveServlet',

                    select: function (info) {
                        selectedInfo = info; // save selection

                        //Fill next step form
                        eventDayInput.value = selectedInfo.startStr;

                        calendar.addEvent({
                            title: 'Permission',
                            start: info.start,
                            end: info.end,
                            display: "list-item"
                        });

                        // Update progress bar
                        steps[1].classList.add('active');
                        updateProgress(1);
                        // update label
                        label.textContent = `Step 2: Select the permission time`;

                        // Show next step section
                        showNextStep();

                    }
                });

                continueBtn.addEventListener('click', function () {

                    // Update progress bar
                    steps[2].classList.add('active');
                    updateProgress(2);
                    // update label
                    label.textContent = `Step 3: Review permission details`;

                    const startTime = document.getElementById("startTime").value;
                    const endTime = document.getElementById("endTime").value;

                    document.getElementById("finalStartTime").value = startTime;
                    document.getElementById("finalEndTime").value = endTime;
                    showFinalStep();
                });

                cancelLeaveBtn.addEventListener('click', function () {
                    leaveModal.style.display = 'none';
                    calendar.unselect();
                });

                calendar.render();
            });

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



        <div class="header">
            <div class="header-left">
            </div>
            <div class="header-right">
                <div class="header_btn">
                    <button class="header_icon">
                        <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M7.84 1.804A1 1 0 0 1 8.82 1h2.36a1 1 0 0 1 .98.804l.331 1.652a6.993 6.993 0 0 1 1.929 1.115l1.598-.54a1 1 0 0 1 1.186.447l1.18 2.044a1 1 0 0 1-.205 1.251l-1.267 1.113a7.047 7.047 0 0 1 0 2.228l1.267 1.113a1 1 0 0 1 .206 1.25l-1.18 2.045a1 1 0 0 1-1.187.447l-1.598-.54a6.993 6.993 0 0 1-1.929 1.115l-.33 1.652a1 1 0 0 1-.98.804H8.82a1 1 0 0 1-.98-.804l-.331-1.652a6.993 6.993 0 0 1-1.929-1.115l-1.598.54a1 1 0 0 1-1.186-.447l-1.18-2.044a1 1 0 0 1 .205-1.251l1.267-1.114a7.05 7.05 0 0 1 0-2.227L1.821 7.773a1 1 0 0 1-.206-1.25l1.18-2.045a1 1 0 0 1 1.187-.447l1.598.54A6.992 6.992 0 0 1 7.51 3.456l.33-1.652ZM10 13a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />
                            </svg></span>
                    </button>
                    <button class="header_icon">
                        <span class="label" style="margin-left: 10px; margin-right: 5px;">Déconnexion</span>
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
        <div id="stepLabel">Step 1: Select permission date</div>


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
                            <span style="font-weight: bold;font-size: 1rem;align-content: center;">
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
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#215F91" class="size-5">
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
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#215F91" class="size-5">
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
                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#215F91" class="size-5">
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

                        <h1 style="font-size: 1.2rem; color: #333;">Step 2: Select permission time</h1>
                        <div class="permission-time">
                            <label for="startTime">
                                <span style="font-size: 0.9rem; color: #666;">Permission Time:</span>
                            </label>

                            <div class="time-inputs">
                                <input type="text" id="startTime" placeholder="Start time">
                                <span style="margin: 0 8px;">to</span>
                                <input type="text" id="endTime" placeholder="End time">
                            </div>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="modal-btn" id="continueBtn">Confirm</button>
                            <button type="button" class="modal-btn" id="cancelLeave">Cancel</button>
                        </div>
                    </div>


                    <div id="finalStep">
                        <h3 style=" margin:0; padding: 10px; font-size:1.25rem; color:#222;">Step 3: Permission Details</h3>
                        <form id="eventForm" action="NewPermissionServlet" method="post">

                            <span style="display:flex; flex-direction: row;">
                                <label for="eventDay" style="margin-top: 7px; margin-right: 5px;">Day:</label>
                                <input type="text" id="eventDay" name ="eventDay" readonly>
                            </span>

                            <span style="display:flex; flex-direction: row;">
                                <label for="finalStartTime" style="margin-top: 10px; margin-right: 5px;">From</label>
                                <input type="text" id="finalStartTime" style="width:70px;" name ="eventStartTime" readonly>

                                <label for="finalEndTime" style="margin-top: 10px; margin-left: 5px; margin-right: 5px;"> to </label>
                                <input type="text" id="finalEndTime" style="width:70px;" name ="eventEndTime" readonly>
                            </span>

                            <label for="eventDescription">Reason:</label>
                            <textarea 
                                id="eventDescription" name ="eventDescription" 
                                rows="2"></textarea>

                            <button type="submit" id="submitBtn" disabled class="btn-disabled">Create Event</button>
                        </form>
                    </div>
                </div>


            </aside>
        </div>

        <script src="scripts/utils.js"></script>
        <!-- Flatpickr JS -->
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script>
            flatpickr("#startTime", {
                enableTime: true,
                noCalendar: true,
                dateFormat: "h:i K",
                time_24hr: false
            });

            flatpickr("#endTime", {
                enableTime: true,
                noCalendar: true,
                dateFormat: "h:i K",
                time_24hr: false
            });
        </script>
        <script>
            const nextStep = document.getElementById("nextStep");
            const finalStep = document.getElementById("finalStep");

            function showNextStep() {
                nextStep.style.display = "block";

                requestAnimationFrame(() => {
                    nextStep.classList.add("show");
                });
            }

            function showFinalStep() {
                finalStep.style.display = "block";
                finalStep.classList.add("show");
                // optional scroll
                setTimeout(() => {
                    finalStep.scrollIntoView({
                        behavior: "smooth",
                        block: "nearest"
                    });
                }, 200);
            }

            function hideNextStep() {
                nextStep.classList.remove("show");

                nextStep.addEventListener("transitionend", function handler() {
                    nextStep.style.display = "none";
                    nextStep.removeEventListener("transitionend", handler);
                });
            }
        </script>
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
