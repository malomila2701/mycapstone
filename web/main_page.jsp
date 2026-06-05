<%-- 
    Document   : main_page
    Created on : 17 oct. 2025, 11:07:43
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Responsiveness -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/main_user_styles.css">

        <title>Main Page</title>
    </head>

    <body>

        <button id="toggleSidebar">☰</button>  <!-- mobile menu button -->

        <div class="layout">
            <aside class="sidebar">

                <img src="${pageContext.request.contextPath}/images/logo_sidebar.png" alt="" class="img_small">
                <p>MENU</p>

                <div id="normalMenu">
                    <!-- Overview side button-->
                    <button class="tab" id="homeTab" onclick="loadPage('main_overview.jsp', this)" data-url="main_overview.jsp">
                        <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M9.674 2.075a.75.75 0 0 1 .652 0l7.25 3.5A.75.75 0 0 1 17 6.957V16.5h.25a.75.75 0 0 1 0 1.5H2.75a.75.75 0 0 1 0-1.5H3V6.957a.75.75 0 0 1-.576-1.382l7.25-3.5ZM11 6a1 1 0 1 1-2 0 1 1 0 0 1 2 0ZM7.5 9.75a.75.75 0 0 0-1.5 0v5.5a.75.75 0 0 0 1.5 0v-5.5Zm3.25 0a.75.75 0 0 0-1.5 0v5.5a.75.75 0 0 0 1.5 0v-5.5Zm3.25 0a.75.75 0 0 0-1.5 0v5.5a.75.75 0 0 0 1.5 0v-5.5Z" clip-rule="evenodd" />
                            </svg>
                        </span>
                        <span class="entries">Overview</span>
                    </button>


                    <!--Make request side button -->
                    <div class="dropdown">
                        <button class="tab2">
                            <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
                                <path fill-rule="evenodd" d="M5.478 5.559A1.5 1.5 0 0 1 6.912 4.5H9A.75.75 0 0 0 9 3H6.912a3 3 0 0 0-2.868 2.118l-2.411 7.838a3 3 0 0 0-.133.882V18a3 3 0 0 0 3 3h15a3 3 0 0 0 3-3v-4.162c0-.299-.045-.596-.133-.882l-2.412-7.838A3 3 0 0 0 17.088 3H15a.75.75 0 0 0 0 1.5h2.088a1.5 1.5 0 0 1 1.434 1.059l2.213 7.191H17.89a3 3 0 0 0-2.684 1.658l-.256.513a1.5 1.5 0 0 1-1.342.829h-3.218a1.5 1.5 0 0 1-1.342-.83l-.256-.512a3 3 0 0 0-2.684-1.658H3.265l2.213-7.191Z" clip-rule="evenodd" />
                                <path fill-rule="evenodd" d="M12 2.25a.75.75 0 0 1 .75.75v6.44l1.72-1.72a.75.75 0 1 1 1.06 1.06l-3 3a.75.75 0 0 1-1.06 0l-3-3a.75.75 0 0 1 1.06-1.06l1.72 1.72V3a.75.75 0 0 1 .75-.75Z" clip-rule="evenodd" />
                                </svg>

                            </span>
                            <span class="entries">Make a request</span>
                        </button>
                        <div class="content"> 
                            <button onclick="loadPage('main_leave.jsp', this)" data-url="main_leave.jsp" style="cursor: pointer;">Leave</button>
                            <button onclick="loadPage('main_permissions.jsp', this)" data-url="main_permissions.jsp" style="cursor: pointer;" >Permission</button>
                        </div>
                    </div>


                    <button class="tab" id="historyTab" onclick="loadHistory()" data-url="main_history.jsp">
                        <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                            <path d="M5.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H6a.75.75 0 0 1-.75-.75V12ZM6 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H6ZM7.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H8a.75.75 0 0 1-.75-.75V12ZM8 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H8ZM9.25 10a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V10ZM10 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H10ZM9.25 14a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H10a.75.75 0 0 1-.75-.75V14ZM12 9.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V10a.75.75 0 0 0-.75-.75H12ZM11.25 12a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H12a.75.75 0 0 1-.75-.75V12ZM12 13.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V14a.75.75 0 0 0-.75-.75H12ZM13.25 10a.75.75 0 0 1 .75-.75h.01a.75.75 0 0 1 .75.75v.01a.75.75 0 0 1-.75.75H14a.75.75 0 0 1-.75-.75V10ZM14 11.25a.75.75 0 0 0-.75.75v.01c0 .414.336.75.75.75h.01a.75.75 0 0 0 .75-.75V12a.75.75 0 0 0-.75-.75H14Z" />
                            <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                            </svg>
                        </span>
                        <span class="entries">History</span>
                    </button>

                    <button class="tab" id="chartsTab" onclick="loadPage('charts.jsp', this)" data-url="charts.jsp">
                        <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                            <path d="M15.5 2A1.5 1.5 0 0 0 14 3.5v13a1.5 1.5 0 0 0 1.5 1.5h1a1.5 1.5 0 0 0 1.5-1.5v-13A1.5 1.5 0 0 0 16.5 2h-1ZM9.5 6A1.5 1.5 0 0 0 8 7.5v9A1.5 1.5 0 0 0 9.5 18h1a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 10.5 6h-1ZM3.5 10A1.5 1.5 0 0 0 2 11.5v5A1.5 1.5 0 0 0 3.5 18h1A1.5 1.5 0 0 0 6 16.5v-5A1.5 1.5 0 0 0 4.5 10h-1Z" />
                            </svg>

                        </span>
                        <span class="entries">Charts</span>
                    </button>

                </div>

                <!-- admin buton original place -->
                <div id="adminAnchor"></div>
                <!--ADMIN button -->
                <div id="adminContainer">

                    <div class="admin-header">
                        <%
                            String role = (String) session.getAttribute("role");
                        %>
                        <button class="tab" id="adminBtn" onclick="openAdmin(this)" data-url="admin/admin_section.jsp" <%= ("admin".equals(role) || "manager".equals(role)) || "HR".equals(role) ? "" : "disabled"%>>
                            <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                <path fill-rule="evenodd" d="M10 1a4.5 4.5 0 0 0-4.5 4.5V9H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-6a2 2 0 0 0-2-2h-.5V5.5A4.5 4.5 0 0 0 10 1Zm3 8V5.5a3 3 0 1 0-6 0V9h6Z" clip-rule="evenodd" />
                                </svg>
                            </span>
                            <span class="entries">Admin</span>
                        </button>
                        <!-- close admin section -->
                        <button id="closeAdminBtn" onclick="closeAdmin()">
                            ✕
                        </button>
                    </div>
                    <div id="adminEntries">
                        <a href="<%= request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
                        <a href="<%= request.getContextPath()%>/admin/requests.jsp">Requests</a>
                        <a href="<%= request.getContextPath()%>/admin/permissions.jsp">Permissions</a>
                        <a href="<%= request.getContextPath()%>/admin/employees.jsp">Employees</a>
                        <a href="<%= request.getContextPath()%>/admin/calendar.jsp">Calendar</a>
                    </div>
                </div>


            </aside>

            <main class="panel">
                <iframe id = "contentFrame" name="contentFrame" title="Main Content Frame" src="main_overview.jsp"> </iframe>
            </main>
        </div>
        <script>
            document.querySelectorAll("#adminEntries a").forEach(link => {
                link.addEventListener("click", function (e) {
                    e.preventDefault();
                    const url = this.getAttribute("href");
                    if (!url || url === "#")
                        return;

                    const mainFrame = document.getElementById("contentFrame"); // ton id exact ici
                    mainFrame.contentWindow.postMessage({adminNav: url}, "*");
                });
            });
        </script>
        <script>
            window.addEventListener('message', function (e) {
                console.log('message received:', e.data);
            });
        </script>
        <script>
            function setActiveTab(tabName) {
                // Remove active from all tabs
                document.querySelectorAll('.tab').forEach(li => {
                    li.classList.remove('active');
                });
                // Add active to the matching one
                const target = document.querySelector(`.sidebar li[data-tab="${tabName}"]`);
                if (target)
                    target.classList.add('active');
            }
        </script>
        <script>
            function setActiveTab(tabId) {
                tabs.forEach(t => t.classList.remove("active"));
                var tab = document.getElementById(tabId);
                if (tab)
                    tab.classList.add("active");
            }
        </script>
        <script src="scripts/utils.js"></script>

        <!-- Animation when clicking admin -->
        <script>

            function openAdmin(button) {
                loadPage('admin/admin_section.jsp', button);

                const sidebar = document.querySelector(".sidebar");
                const normalMenu = document.getElementById("normalMenu");
                const adminContainer = document.getElementById("adminContainer");
                const adminEntries = document.getElementById("adminEntries");
                const closeBtn = document.getElementById("closeAdminBtn");

                normalMenu.classList.add("hidden");

                setTimeout(() => {

                    normalMenu.style.display = "none";

                    sidebar.insertBefore(adminContainer, sidebar.children[2]);

                    closeBtn.style.display = "block";

                    // animate admin entries
                    requestAnimationFrame(() => {

                        adminEntries.classList.add("show");

                    });
                    sidebar.scrollTo({
                        top: 0,
                        behavior: "smooth"
                    });
                }, 350);
            }


            function closeAdmin() {

                const normalMenu = document.getElementById("normalMenu");
                const adminContainer = document.getElementById("adminContainer");
                const adminAnchor = document.getElementById("adminAnchor");
                const adminEntries = document.getElementById("adminEntries");
                const closeBtn = document.getElementById("closeAdminBtn");

                // hide entries smoothly
                adminEntries.classList.remove("show");

                closeBtn.style.display = "none";

                setTimeout(() => {

                    adminAnchor.parentNode.insertBefore(
                            adminContainer,
                            adminAnchor.nextSibling
                            );

                    normalMenu.style.display = "block";

                    requestAnimationFrame(() => {

                        normalMenu.classList.remove("hidden");
                    });
                }, 450);
            }

        </script>

        <script>
            const content = document.querySelector(".content");
            document.querySelectorAll(".topnav a").forEach(link => {
                link.addEventListener("click", function (e) {
                    e.preventDefault();
                    const url = this.getAttribute("href");
                    if (!url || url === "#")
                        return;
                    loader.style.display = "block";
                    iframe.classList.remove("loaded");
                    iframe.style.opacity = 0;
                    iframe.src = url;
                });
            });

            iframe.onload = function () {
                loader.style.display = "none";
                iframe.classList.add("visible");
            };
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const tab = document.getElementById("homeTab");
                if (tab) {
                    setActiveTab("homeTab");
                    console.log("Tab 'homeTab' activated successfully.");
                } else {
                    console.error("Tab 'homeTab' not found in the DOM.");
                }
            });
        </script>
    </body>
</html>
