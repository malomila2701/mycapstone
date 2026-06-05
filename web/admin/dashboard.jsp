<%-- 
    Document   : admin_dashboard
    Created on : 9 déc. 2025, 17:23:25
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="" />
    </head>
    <body>
        <style>
            body {
                margin: 0;
                background: #F1F5F9;
                font-family: sans-serif;
            }

            .welcome-wrap {
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100vh;
            }

            .welcome-card {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 12px;
                background: white;
                border: 1px solid #E2E8F0;
                border-radius: 16px;
                padding: 48px 64px;
            }

            .welcome-avatar {
                width: 56px;
                height: 56px;
                border-radius: 50%;
                background: #EFF6FF;
                color: #2563eb;
                font-size: 1.4rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .welcome-title {
                margin: 0;
                font-size: 1.4rem;
                font-weight: 600;
                color: #1E293B;
            }

            .welcome-sub {
                margin: 0;
                font-size: 0.9rem;
                color: #94A3B8;
            }
        </style>
        <div class="welcome-wrap">
            <div class="welcome-card">
                <div class="welcome-avatar">A</div>
                <h1 class="welcome-title">Welcome back, Admin</h1>
                <p class="welcome-sub">Manage your team from the sidebar.</p>
            </div>
        </div>
    </body>
</html>
