<%-- 
    Document   : hello
    Created on : 16 oct. 2025, 09:15:20
    Author     : HP
--%>


<%@ page contentType="text/html;charset=UTF-8"%>

<html>
    <head>
        <title>Welcome Page</title>

        <!-- Responsiveness -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

            <link rel="stylesheet" 
                  href="css/hello_styles.css">
                <link rel="stylesheet" 
                      href="https://cdn.jsdelivr.net/npm/material-design-iconic-font@2.2.0/dist/css/material-design-iconic-font.min.css">


                    </head>
                    <body>

                        <div class="main">

                            <div class="container">

                                <main class="main-section">
                                    <img src="${pageContext.request.contextPath}/images/logo_welcome.png" alt="" class="img_small"/>
                                    <h1>
                                        <br>STAFF LEAVE<br> MANAGEMENT TOOL 
                                                </h1>
                                                </main>

                                                <aside class="side-section">
                                                    <div class="signin-form">
                                                        <h2 class="form-title">Login</h2>
                                                        <form action="FirstServlet" id="loginForm" method="post">
                                                            <div class="form-group">
                                                                <div class="input-wrapper">
                                                                    <span class="icon-form">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                                                            <path d="M10 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM3.465 14.493a1.23 1.23 0 0 0 .41 1.412A9.957 9.957 0 0 0 10 18c2.31 0 4.438-.784 6.131-2.1.43-.333.604-.903.408-1.41a7.002 7.002 0 0 0-13.074.003Z" />
                                                                        </svg>
                                                                    </span>        
                                                                    <input type="text" name="username" id="username" 
                                                                           placeholder="Your Name" required />
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="input-wrapper">
                                                                    <span class="icon-form"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                                                            <path fill-rule="evenodd" d="M10 1a4.5 4.5 0 0 0-4.5 4.5V9H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-6a2 2 0 0 0-2-2h-.5V5.5A4.5 4.5 0 0 0 10 1Zm3 8V5.5a3 3 0 1 0-6 0V9h6Z" clip-rule="evenodd" />
                                                                        </svg> </span>
                                                                    <input type="password" name="password" id="password"
                                                                           placeholder="Password" required />
                                                                </div>
                                                            </div>

                                                            <span style="display:flex; flex-direction: row; align-items: center;">
                                                                <input type="checkbox" id="rememberMe" name="rememberMe" style="margin-right: 5px; width: 10px; height:10px;">
                                                                    <label for="rememberMe" style="font-size:0.8rem; color: #999;">Remember me</label><br><br>
                                                                            </span>

                                                                            <%
                                                                                String error = (String) request.getAttribute("login_error");
                                                                                if (error != null) {
                                                                            %>
                                                                            <p style="color:red;"><%= error%></p>
                                                                            <%
                                                                                }
                                                                            %>
                                                                            <button type="submit" id="form-submit"> Log in</button>

                                                                            </form>
                                                                            </div> 
                                                                            </aside>
                                                                            </div>
                                                                            </div>



                                                                            <script>
                                                                                const loginForm = document.getElementById('loginForm');
                                                                                const usernameInput = document.getElementById('username');
                                                                                const rememberMeCheckbox = document.getElementById('rememberMe');

                                                                                // Check on page load if username is stored
                                                                                window.addEventListener('load', () => {
                                                                                    const savedUsername = localStorage.getItem('username');
                                                                                    if (savedUsername) {
                                                                                        usernameInput.value = savedUsername;
                                                                                        rememberMeCheckbox.checked = true;
                                                                                    }
                                                                                });

                                                                                // Handle form submission
                                                                                loginForm.addEventListener('submit', (e) => {
                                                                                    if (rememberMeCheckbox.checked) {
                                                                                        localStorage.setItem('username', usernameInput.value);
                                                                                    } else {
                                                                                        localStorage.removeItem('username');
                                                                                    }
                                                                                });
                                                                            </script>
                                                                            </body>
                                                                            </html>
