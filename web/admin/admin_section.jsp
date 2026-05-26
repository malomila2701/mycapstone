<%-- 
    Document   : admin_section
    Created on : 9 déc. 2025, 11:59:42
    Author     : HP
--%>

<%@page import="javafiles.EmployeeInfo"%>
<%@page import="java.util.List"%>
<%@page import="javafiles.userdataDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" 
              href="../css/admin/admin_styles.css">
        <title>Admin Dashboard</title>



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
                List<EmployeeInfo> e = dao.getEmployeeInfo();
            %>
        </script>
    </head>

    <body>
        <!-- HEADER -->
        <div class="navbar">
            <div class="navbar-left">
                <span class="header-badge">Admin</span>
                <span class="header-title">Section</span>
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
                        <span style="margin-left: 10px; font-size: 0.9rem; color: #666;">
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

        <div class="panel">
            <div class="loader-wrapper">
                <div class="loader"></div>
            </div>
            <iframe id ="adminFrame" name="adminFrame" title="Admin Content Frame" src="dashboard.jsp" scrolling="auto"> </iframe>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const navLinks = document.querySelectorAll(".topnav a");

                navLinks.forEach(link => {
                    link.addEventListener("click", function () {
                        // Retire .active de tous les liens
                        navLinks.forEach(l => l.classList.remove("active"));

                        // Ajoute .active au lien cliqué
                        this.classList.add("active");
                    });
                });
            });
        </script>
        <script>
            const iframe = document.getElementById("adminFrame");
            const loader = document.querySelector(".loader");

            document.querySelectorAll(".topnav a").forEach(link => {
                link.addEventListener("click", function (e) {
                    e.preventDefault();

                    const url = this.getAttribute("href");
                    if (!url || url === "#")
                        return;

                    loader.style.display = "block";

                    // start fade out
                    iframe.classList.add("hidden");

                    // wait until fade out is done
                    setTimeout(() => {
                        iframe.src = url;
                    }, 200);
                });
            });

            // Fade in when iframe finishes loading
            iframe.onload = function () {
                loader.style.display = "none";
                iframe.classList.remove("hidden");
            };
        </script>
    </body>
</html>
