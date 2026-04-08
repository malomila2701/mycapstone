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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.1.0/css/all.min.css">

        <title>Main Page</title>
    </head>

    <body>

        <button id="toggleSidebar">☰</button>  <!-- mobile menu button -->

        <div class="layout">
            <aside class="sidebar">

                <img src="images/mycapstone-logo.png" alt="" class="img_small">
                <p>MENU</p>
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
                        <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                            <path fill-rule="evenodd" d="M2.106 6.447A2 2 0 0 0 1 8.237V16a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V8.236a2 2 0 0 0-1.106-1.789l-7-3.5a2 2 0 0 0-1.788 0l-7 3.5Zm1.48 4.007a.75.75 0 0 0-.671 1.342l5.855 2.928a2.75 2.75 0 0 0 2.46 0l5.852-2.927a.75.75 0 1 0-.67-1.341l-5.853 2.926a1.25 1.25 0 0 1-1.118 0l-5.856-2.928Z" clip-rule="evenodd" />
                            </svg>
                        </span>
                        <span class="entries">Make a request</span>
                    </button>
                    <div class="content"> 
                        <button onclick="loadPage('main_requests.jsp', this)" data-url="main_overview.jsp" style="cursor: pointer;">Leave</button>
                        <button onclick="loadPage('permission.jsp'), this" data-url="permission.jsp" style="cursor: pointer;" >Permission</button>
                    </div>
                </div>


                <button class="tab" id="historyTab" onclick="loadPage('history.jsp', this)" data-url="history.jsp">
                    <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                        <path d="M12 9a1 1 0 0 1-1-1V3c0-.552.45-1.007.997-.93a7.004 7.004 0 0 1 5.933 5.933c.078.547-.378.997-.93.997h-5Z" />
                        <path d="M8.003 4.07C8.55 3.994 9 4.449 9 5v5a1 1 0 0 0 1 1h5c.552 0 1.008.45.93.997A7.001 7.001 0 0 1 2 11a7.002 7.002 0 0 1 6.003-6.93Z" />
                        </svg>
                    </span>
                    <span class="entries">History</span>
                </button>·



                <button class="tab" id="chartsTab" onclick="loadPage('charts.jsp', this)" data-url="charts.jsp">
                    <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                        <path d="M12 9a1 1 0 0 1-1-1V3c0-.552.45-1.007.997-.93a7.004 7.004 0 0 1 5.933 5.933c.078.547-.378.997-.93.997h-5Z" />
                        <path d="M8.003 4.07C8.55 3.994 9 4.449 9 5v5a1 1 0 0 0 1 1h5c.552 0 1.008.45.93.997A7.001 7.001 0 0 1 2 11a7.002 7.002 0 0 1 6.003-6.93Z" />
                        </svg>
                    </span>
                    <span class="entries">Charts</span>
                </button>


                <!--Admin section -->
                <%
                    String role = (String) session.getAttribute("role");
                %>
                <button class="tab" onclick="loadPage('admin/admin_section.jsp', this)" data-url="admin/admin_section.jsp" <%= "admin".equals(role) ? "" : "disabled"%>>
                    <span class="icon-home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                        <path fill-rule="evenodd" d="M10 1a4.5 4.5 0 0 0-4.5 4.5V9H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-6a2 2 0 0 0-2-2h-.5V5.5A4.5 4.5 0 0 0 10 1Zm3 8V5.5a3 3 0 1 0-6 0V9h6Z" clip-rule="evenodd" />
                        </svg>
                    </span>
                    <span class="entries">Admin</span>
                </button>

            </aside>

            <main class="panel">
                <iframe id = "contentFrame" name="contentFrame" title="Main Content Frame" src="main_overview.jsp"> </iframe>
            </main>
        </div>

        <script src="scripts/utils.js"></script>
        <script>
                    const content = document.querySelector(.content);
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
    </body>
</html>
