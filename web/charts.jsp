<%-- 
    Document   : charts
    Created on : 23 janv. 2026, 08:12:00
    Author     : HP
--%>

<%@page import="javafiles.UserPending"%>
<%@page import="java.util.List"%>
<%@page import="javafiles.userdataDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <title>JSP Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: white;
                margin:0 0 0 17%;
            }

            header {
                position: relative;
                width: 37%;
                top:0;
                left:0;
                padding: 15px;
                background: #34495e;
                border-bottom-left-radius: 0px;
                border-bottom-right-radius: 20px;
            }
            header h1 {
                justify-content:center;
                font-weight: bold;
                font-size: 17px;
                color: white;
            }

            .dashboard {
                display: grid;
                grid-template-columns: 250px 250px 200px;
                margin-top: 15px;
                margin-left: 20px;
                justify-content: left;
            }
            .card {
                background: whitesmoke;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                padding: 20px;
                width: 200px;
                text-align: center;
            }

            .card h2 {
                margin: 0;
                font-size: 24px;
                color: #333;
            }
            .card p {
                margin: 10px 0 0;
                font-size: 16px;
                color: #777;
            }
            
            .card_c {
                margin-top: 15px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                padding: 35px;
                width: 225px;
                text-align: center;
            }



        </style>
        
        <script>
            <%
                Integer userId = (Integer) session.getAttribute("user_id");

                if (userId != null) {
            %>
            User ID: <%= userId%>
            <%
                } else {
                    response.sendRedirect("login.jsp");
                }

                userdataDAO dao = new userdataDAO();
                String value = dao.getInfo(userId);
                List<UserPending> v2 = dao.getPending(userId);
            %>
        </script>
        
    </head>
    <body>

        <header>
            <h1>Charts</h1>
        </header>


        <div class="dashboard">
            <div class="card">
                <h2>24</h2>
                <p>Total leave</p>
            </div>

            <div class="card"> 
                <h2>3</h2> 
                <p>Leave Taken</p>
            </div>


            <div class="card"> 
                <h2>3,250</h2> 
                <p>Total Students</p>
            </div>
            
            <div class="card_c">
                    <canvas id="attendanceChart" width="300" height="300"></canvas>
            </div>
        </div>
        
        
        
         <!-- Buttons -->
        <div class="dropdowns">
            <!-- Check balance -->
            <div class="item">
                <input type="checkbox" id="acc1" checked>
                <label for="acc1" class="title">
                    <span>View my balance</span>
                    <span class="drop_icon"></span>
                </label>
                <div class="content">
                    User ID: <%= userId%>
                    <p> Latest leave: 
                        <%= value%>
                    </p>
                </div>
            </div>

            <!-- Ask for a leave-->
            <div class="item">
                <input type="checkbox" id="acc2">
                <label for="acc2" class="title">
                    <span>Make a request</span>
                    <span class="drop_icon"></span></label>
                <div class="content">
                    <button id="askLeave_btn" onclick ="parent.document.getElementById('contentFrame').src = 'main_requests.jsp'" data-url="main_requests.jsp"> 
                        <span>Ask for a leave</span>
                    </button>  
                    <button id="askPermission_btn" onclick ="parent.document.getElementById('contentFrame').src = 'main_requests.jsp'" data-url="main_requests.jsp"> 
                        <span>Ask for a permission</span>
                    </button>
                </div>
            </div>

            <!-- Pending requests -->        
            <div class="item">
                <input type="checkbox" id="acc3">
                <label for="acc3" class="title">
                    <span>Pending Requests</span>
                    <span class="drop_icon"></span></label>
            </div>
        </div>
        

            <script> const ctx = document.getElementById('attendanceChart').getContext('2d'); 
            const attendanceChart = new Chart(ctx, { 
            type: 'doughnut', 
                    data: { 
                        labels: ['Total Leave', 'Leave teaken'], 
                        datasets: [{ data: [80, 20], 
                        backgroundColor: ['#eef', '#F6CE71'], 
                        borderWidth: 2 }] 
                    }, 
                    options: { 
                        cutout: '70%', 
                plugins: { 
                    title: { 
                        display: true, 
                        text: 'User Leave Pie Chart', 
                        font: { size: 16, weight: 'bold' } }, 
                    legend: { position: 'bottom', 
                        labels: { 
                            usePointStyle: true,
                            pointStyle: 'cirle',
                            font: { 
                                size: 14 
                            } 
                        } 
                    }, 
                    tooltip: { 
                        callbacks: { 
                            label: function(context) { 
                                let label = context.label || ''; let value = context.raw; return label + ': ' + value + '%'; } } } } } });
        </script>
    </body>
</html>
