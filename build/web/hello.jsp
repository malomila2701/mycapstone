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
                    <img src="images/capstone_logo_main.png" alt="" class="img_small">
                    <h1><br>STAFF LEAVE<br> MANAGEMENT TOOL </h1>
                </main>

                <aside class="side-section">
                    <div class="signin-form">
                        <h2 class="form-title">Login</h2>
                        <form action="FirstServlet" id="loginForm" method="post">
                            <div class="form-group">
                                <label for="username">
                                    <i class="zmdi zmdi-account"></i></label> 
                                <input type="text" name="username" id="username" 
                                       placeholder="Your Name" required />
                            </div>
                            <div class="form-group">
                                <label for="password"><i class="zmdi zmdi-lock"></i></label>  
                                <input type="password" name="password" id="password"
                                       placeholder="Password" required />
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
