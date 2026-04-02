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
                <h1>---
                    <img src="images/company_logo.png" alt="" style="padding-top: 70px; height: auto;"> ---</h1>
                <div class="signin-content">
                    <h1>OUTIL HR <br> GESTION DES CONGES <br> DU PERSONNEL</h1>

                    <div class="signin-form">
                        <h2 class="form-title">Login</h2>
                        <form action="FirstServlet" method="post">
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


                            <%
                                String error = (String) request.getAttribute("login_error");
                                if (error != null) {
                            %>
                            <p style="color:red;"><%= error %></p>
                            <%
                                }
                            %>


                            <button type="submit" id="form-submit"> Log in</button>

                        </form>
                    </div>             
                </div>
            </div>
        </div>


        <script>

        </script>
    </body>
</html>
