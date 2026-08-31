<%-- 
    Document   : admin_requests
    Created on : 9 déc. 2025, 17:27:35
    Author     : HP
--%>

<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="javafiles.UserPermission"%>
<%@page import="javafiles.UserLeave"%>
<%@page import="javafiles.UserPending"%>
<%@page import="java.util.List"%>
<%@page import="javafiles.userdataDAO"%>
<%@page import="javafiles.EmployeeInfo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <link rel="stylesheet" 
              href="../css/admin/adm_permission_styles.css">

        <title>Admin Permission Page</title>

        <!-- FullCalendar script -->
        <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css' rel='stylesheet' />
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>
    </head>
    <body>

        <%
            int userId = (Integer) session.getAttribute("user_id");
            userdataDAO dao = new userdataDAO();
            List<UserPermission> daoPermission = dao.getAdminPermissionAll();
        %>

        <%
            SimpleDateFormat outFmt = new SimpleDateFormat("MMM d", Locale.ENGLISH);
            SimpleDateFormat yearFmt = new SimpleDateFormat("yyyy");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

            String selectedAvatar = "../images/avatar1.jpg";
        %> 

        <!-- Leave type modal -->
        <div id="leaveModal" class="modal">
            <div class="modal-content">
                <div style="
                     position: sticky;
                     display:flex;
                     justify-content:space-between;
                     align-items:center;
                     border-bottom:1px solid #ccc;

                     overflow: hidden;
                     ">
                    <div>
                        <h2 style="
                            margin:0;
                            font-size:18px;
                            font-weight:600;
                            color:#1E293B;
                            ">
                            Request Details
                        </h2>
                        <span style="
                              font-size:13px;
                              color:#64748B;
                              " id="modalreqID">
                            REQ-2026-00
                        </span>
                    </div>
                    <!--Boutton close-->
                    <button class="modal-close-btn" onclick="closeModal()">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                        <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
                        </svg>
                    </button>
                </div>
                <!--Section de details (Nom, email) (Période de congés) (Boutons)-->
                <main class="details-section">
                    <div style="
                         background: #f3f6fa;
                         padding: 10px;
                         border: 1px solid #E2E8F0;
                         border-radius: 20px;
                         ">
                        <span style="display:flex; flex-direction:row;">
                            <img id="modalAvatar" src=""
                                 style="width:40px; height:40px; border-radius:50%; background: #eef; margin-left: 15px;" title="" alt="" />

                            <span style="display: flex; flex-direction: column;">
                                <label class="modallabel-name" id="modalUsername">Unknown</label>
                                <span style="display: flex; flex-direction: row; text-align: center; align-items:center;">
                                    <span class="icon-btn-modal icon-home-modal" style="margin-left: 15px;">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
                                        </svg>
                                    </span>
                                    <label class="modallabel-email" id="modalUserEmail"></label>
                                </span>
                            </span>
                        </span>
                    </div>
                    <div style="
                         background: white;
                         padding: 10px;
                         border: 1px solid #ccc;
                         border-radius: 20px;
                         margin-top: 10px;
                         ">
                        <form action="FirstServlet" method="post">
                            <label style="margin-left: 10px; padding-bottom: 15px; font-size: 0.7rem; font-weight: 600; text-transform: uppercase; color: lightslategray; white-space: nowrap;">
                                Permission Period
                            </label>

                            <%-- Date row --%>
                            <div style="display: flex; flex-direction: row; justify-content: space-between; align-items:center;">
                                <div style="display:flex; align-items:center; margin-left: 5px; gap:4px; padding-bottom: 5px;">
                                    <span class="icon-btn-modal icon-home-modal">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#0078d7" class="size-5">
                                        <path fill-rule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2Zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75Z" clip-rule="evenodd" />
                                        </svg>
                                    </span>
                                    <label id="modalStartDate" style="margin-left: 0; font-size: 0.8rem; font-weight: normal; color: #333;"></label>
                                </div>
                            </div>

                            <%-- Time row --%>
                            <div style="display: flex; flex-direction: row; justify-content: space-between; align-items:center; margin-top: 4px;">
                                <div style="display:flex; align-items:center; margin-left: 5px; gap:4px;">
                                    <span class="icon-btn-modal icon-home-modal">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#0078d7" class="size-5">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clip-rule="evenodd" />
                                        </svg>
                                    </span>
                                    <label id="modalStartTime" style="margin-left: 0; font-size: 0.8rem; font-weight: normal; color: #333;"></label>
                                </div>
                                &rarr;
                                <div style="display:flex; align-items:center; gap:4px;">
                                    <span class="icon-btn-modal icon-home-modal">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#0078d7" class="size-5">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clip-rule="evenodd" />
                                        </svg>
                                    </span>
                                    <label id="modalEndTime" style="margin-left: 0; font-size: 0.8rem; font-weight: normal; color: #333;"></label>
                                </div>
                            </div>

                        </form>
                    </div>

                    <div style="display: flex; flex-direction: row; gap: 12px; margin-top: 10px;">

                        <!-- Type de congé -->
                        <div style="
                             flex: 1;
                             background: transparent;
                             padding: 10px 15px;
                             border: 1px solid #E2E8F0;
                             border-radius: 16px;">
                            <label style="font-size: 0.7rem; font-weight: 600; text-transform: uppercase; color: lightslategray;">
                                Leave Type
                            </label>
                            <div style="display: flex; align-items: center; gap: 6px; margin-top: 4px;">
                                <span class="icon-btn-modal icon-home-modal">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#0078d7" class="size-5">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25Z" />
                                    </svg>
                                </span>
                                <span id="modalLeaveType" style=" padding: 4px 12px; border: 1px solid #E2E8F0; border-radius: 9999px; font-size: 0.85rem; font-weight: 600; color: #333;"></span>
                            </div>
                        </div>

                        <!-- Statut -->
                        <div style="flex: 1; background: #f3f6fa; padding: 10px 15px; border: 1px solid #E2E8F0; border-radius: 16px;">
                            <label style="font-size: 0.7rem; font-weight: 600; text-transform: uppercase; color: lightslategray;">
                                Status
                            </label>
                            <div id="modalStatusContainer" style="margin-top: 4px;"></div>
                        </div>
                    </div>

                    <label style="
                           margin-top: 10px;
                           margin-left: 10px;
                           font-size: 0.7rem;
                           font-weight: 600;
                           text-transform: uppercase;
                           color: lightslategray;
                           white-space: nowrap;" 
                           for="modalMotif"> 
                        Reason/Motif </label> 
                    <div style="
                         background: #f3f6fa;
                         padding: 10px;
                         border: 1px solid #ccc;
                         border-radius: 20px;
                         margin-top: 5px;">
                        <textarea id="modalMotif" readonly></textarea>
                    </div>

                    <label style="
                           margin-top: 10px;
                           margin-left: 10px;
                           font-size: 0.7rem;
                           font-weight: 600;
                           text-transform: uppercase;
                           color: lightslategray;
                           white-space: nowrap;" 
                           for="modalResponseMessage"> 
                        HR Note: </label> 
                    <div style="
                         background: #f3f6fa;
                         padding: 10px;
                         border: 1px solid #ccc;
                         border-radius: 20px;
                         margin-top: 5px;">
                        <textarea id="modalResponseMessage" readonly></textarea>
                    </div>
                </main>

                <span style="border-bottom: 1px solid #ccc; width: 100%;"></span>
                <!-- Modal Actions & form with hidden data -->
                <div class="modal-actions" id="actionsDiv">
                    <!--Modal Action when status is pending-->
                    <div id="actions-pending" style="display:none">
                        <button class="modal-btn cancelLeaveBtn" onclick="closeModal()">
                            Cancel
                        </button>
                        <button class="modal-btn" id="rejectLeaveBtn" onclick="openConfirmPopup('Rejected')">
                            <span class="icon-btn-modal icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#c70036" class="size-5">
                                <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
                                </svg>
                            </span>
                            Reject
                        </button>
                        <button class="modal-btn" id="approveLeaveBtn" onclick="openConfirmPopup('Approved')">
                            <span class="icon-btn-modal icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="white" class="size-5">
                                <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z" clip-rule="evenodd" />
                                </svg>
                            </span>
                            Approve
                        </button>
                    </div>
                    <!--Modal Actions when status is approved/rejected-->
                    <div id="actions-reviewed" style="display:none">
                        <button class="modal-btn" id="resetPendingBtn" onclick="openConfirmPopup('Pending')">
                            <span class="icon-btn-modal icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                <path fill-rule="evenodd" d="M15.312 11.424a5.5 5.5 0 0 1-9.201 2.466l-.312-.311h2.433a.75.75 0 0 0 0-1.5H3.989a.75.75 0 0 0-.75.75v4.242a.75.75 0 0 0 1.5 0v-2.43l.31.31a7 7 0 0 0 11.712-3.138.75.75 0 0 0-1.449-.39Zm1.23-3.723a.75.75 0 0 0 .219-.53V2.929a.75.75 0 0 0-1.5 0V5.36l-.31-.31A7 7 0 0 0 3.239 8.188a.75.75 0 1 0 1.448.389A5.5 5.5 0 0 1 13.89 6.11l.311.31h-2.432a.75.75 0 0 0 0 1.5h4.243a.75.75 0 0 0 .53-.219Z" clip-rule="evenodd" />
                                </svg>
                            </span>
                            Put as pending
                        </button>
                        <button class="modal-btn cancelLeaveBtn" onclick="closeModal()">
                            Cancel
                        </button>
                    </div>
                    <div id="actions-none" style="display:none">
                        <button disabled>No actions available</button>
                    </div>
                </div>
                <form id="statusForm" method="POST" action="<%= request.getContextPath()%>/UpdatePermissionStatusServlet">
                    <input type="hidden" name="permission_id" id="leaveId">
                    <input type="hidden" name="user_id" id="leaveUserId">
                    <input type="hidden" name="status" id="leaveStatus">
                    <input type="hidden" name="admin_message" id="leaveAdminMessage">
                    <input type="hidden" name="returnUrl" value="<%= request.getContextPath()%>/admin/permissions.jsp">
                </form>

            </div>
        </div>
        <!--Still in modal-->
        <div id="confirmPopup" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:9999; align-items:center; justify-content:center;">
            <div style="background:#fff; border-radius:8px; padding:24px; width:340px; display:flex; flex-direction:column; gap:12px;">
                <h3 style="margin:0;">Confirm: <span id="confirmPopupStatus"></span></h3>
                <textarea id="adminMessageInput" rows="4" placeholder="Add a message (optional)..." style="resize:vertical; padding:8px; border:1px solid #ccc; border-radius:6px; font-size:14px;"></textarea>
                <input type="hidden" id="pendingStatus">
                <div style="display:flex; gap:8px; justify-content:flex-end;">
                    <button class="modal-btn" onclick="closeConfirmPopup()">Cancel</button>
                    <button class="submit modal-btn" id="submitBtnModal" onclick="submitWithMessage()">
                        <span class="btn-label">
                            Submit
                        </span>
                        <span class="btn-spinner">
                            Submitting
                            <span class="dot-pulse"><span></span><span></span><span></span></span>
                        </span>
                    </button>
                </div>
            </div>
        </div>







        <div>
            <div style="display:flex; flex-direction: row; justify-content: space-between; margin-top: 10px; margin-right: 25px;">
                <div style="display:flex; flex-direction: column;">
                    <span style="padding-left: 20px;
                          font-size: 1rem;
                          font-weight: 600;
                          color: #333;">Pending & Recent Permissions</span>
                    <span style="padding-left: 20px;
                          font-size: 0.8rem;
                          font-weight: lighter;">Permission Management & Approval Section</span>
                </div>
                <button class="exportBtn" style="display:flex; flex-direction: row;">
                    <span class="icon-home">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                        <path d="M10.75 2.75a.75.75 0 0 0-1.5 0v8.614L6.295 8.235a.75.75 0 1 0-1.09 1.03l4.25 4.5a.75.75 0 0 0 1.09 0l4.25-4.5a.75.75 0 0 0-1.09-1.03l-2.955 3.129V2.75Z" />
                        <path d="M3.5 12.75a.75.75 0 0 0-1.5 0v2.5A2.75 2.75 0 0 0 4.75 18h10.5A2.75 2.75 0 0 0 18 15.25v-2.5a.75.75 0 0 0-1.5 0v2.5c0 .69-.56 1.25-1.25 1.25H4.75c-.69 0-1.25-.56-1.25-1.25v-2.5Z" />
                        </svg>
                    </span>
                    Export CSV</button>
            </div> 

            <div class="cards-section">
                <div class="card" id="total_card">
                    <div>
                        <span class="card_change">
                            <span class="icon-btn-card icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#3B82F6" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25ZM6.75 12h.008v.008H6.75V12Zm0 3h.008v.008H6.75V15Zm0 3h.008v.008H6.75V18Z" />
                                </svg>
                            </span>
                        </span>
                    </div>
                    <div>
                        <p>Total Requests</p>
                        <h2>6</h2>
                    </div>
                </div>
                <div class="card" id="pending_card">
                    <div>
                        <span class="card_change">
                            <span class="icon-btn-card icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#e17100" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" />
                                </svg>
                            </span>
                        </span>
                    </div>
                    <div>
                        <p>Pending</p>
                        <h2>4</h2>
                    </div>
                </div>
                <div class="card" id="approved_card">
                    <div>
                        <span class="card_change">
                            <span class="icon-btn-card icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#009966" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M11.35 3.836c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m8.9-4.414c.376.023.75.05 1.124.08 1.131.094 1.976 1.057 1.976 2.192V16.5A2.25 2.25 0 0 1 18 18.75h-2.25m-7.5-10.5H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V18.75m-7.5-10.5h6.375c.621 0 1.125.504 1.125 1.125v9.375m-8.25-3 1.5 1.5 3-3.75" />
                                </svg>
                            </span>
                        </span>
                    </div>
                    <div>
                        <p>Approved</p>
                        <h2>6</h2>
                    </div>
                </div>
                <div class="card" id="rejected_card">
                    <div>
                        <span class="card_change">
                            <span class="icon-btn-card icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#ec003f" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="m9.75 9.75 4.5 4.5m0-4.5-4.5 4.5M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                                </svg>
                            </span>
                        </span>
                    </div>
                    <div>
                        <p>Rejected</p>
                        <h2>3</h2>
                    </div>
                </div>
            </div>
        </div>


        <div id="latest_banner">
            <div class="header">
                <div class="header-left"> 
                </div>
                <div class="header-right">
                    <span style="position:relative; padding-bottom: 5px;"> 
                        <span class="icon-btn icon-home" style="margin-right:0; padding-right:0;">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#666" class="size-5">
                            <path fill-rule="evenodd" d="M2.628 1.601C5.028 1.206 7.49 1 10 1s4.973.206 7.372.601a.75.75 0 0 1 .628.74v2.288a2.25 2.25 0 0 1-.659 1.59l-4.682 4.683a2.25 2.25 0 0 0-.659 1.59v3.037c0 .684-.31 1.33-.844 1.757l-1.937 1.55A.75.75 0 0 1 8 18.25v-5.757a2.25 2.25 0 0 0-.659-1.591L2.659 6.22A2.25 2.25 0 0 1 2 4.629V2.34a.75.75 0 0 1 .628-.74Z" clip-rule="evenodd" />
                            </svg>
                        </span>
                    </span>
                    <span style="position:relative; padding-top:10px; padding-right: 2px; font-size: 0.8rem;">Filter by: </span>
                    <select id="dateFilter" style="margin-right: 10px;">
                        <option value="all">All Dates</option>
                        <option value="today">Today</option>
                        <option value="yesterday">Yesterday</option>
                        <option value="last_week">Last Week</option>
                        <option value="last_month">Last Month</option>
                    </select>
                    <select id="statusFilter">
                        <option value="all">All Status</option>
                        <option value="approved">Approved</option>
                        <option value="pending">Pending</option>
                        <option value="rejected">Rejected</option>
                    </select>
                </div>
            </div>


            <!-- table for PERMISSIONS requests -->
            <table class ="reqtable" cellspacing="0" id="permissiontable">
                <thead>
                    <tr>
                        <th style="padding:12px; text-align:left; padding-left: 3%;">Description</th>
                        <th id="dateHeader" style="padding:12px; text-align:center; cursor:pointer;">Period ↓</th>
                        <th style="padding:12px; text-align:center;">Motif/Reason</th>
                        <th style="padding:12px; text-align:center;">Status</th>
                        <th style="padding:12px; text-align:center;">Action</th>
                    </tr>
                </thead>
                <%
                    if (daoPermission == null || daoPermission.isEmpty()) {
                %>
                <tbody>
                    <tr>
                        <td colspan="5" style="padding:30px; background:white; text-align:center;
                            border-bottom-left-radius:16px; border-bottom-right-radius:16px; color:red;">
                            No permission records found.
                        </td>
                    </tr>
                    <%
                    } else {
                        for (UserPermission p : daoPermission) {

                            long diffMillis = p.getEndTime().getTime() - p.getStartTime().getTime();
                            long hours = diffMillis / (1000 * 60 * 60);
                            String hourLabel = hours > 1 ? hours + " hrs" : hours + " hr";

                            String status = p.getStatus();
                            String cssClass = "";
                            String cssIconStatus = "";

                            if ("rejected".equalsIgnoreCase(status)) {
                                cssClass = "status-rejected";
                                cssIconStatus = "status-home-rejected";
                            } else if ("approved".equalsIgnoreCase(status)) {
                                cssClass = "status-approved";
                                cssIconStatus = "status-home-approved";
                            } else if ("pending".equalsIgnoreCase(status)) {
                                cssClass = "status-pending";
                                cssIconStatus = "status-home-pending";
                            }
                    %>

                    <tr>
                        <td style="padding:10px; width: 300px;">
                            <div style="display:flex; align-items:center; gap:10px;">

                                <!-- Avatar -->
                                <div style="display:flex; align-items:center; gap:10px; padding-left: 3%;">
                                    <img src="<%= request.getContextPath()%>/AvatarServlet?userId=<%= p.getUserId()%>"
                                         style="width:60px; height:60px; border-radius:50%; background: whitesmoke;" alt="<%= p.getFullName()%>" />
                                    <div style="display:flex; flex-direction:column;">
                                        <span style="font-weight:600; font-size: 0.9rem; white-space:nowrap; color: #333;">
                                            <%= p.getFullName()%>
                                        </span>
                                        <span style="font-size:0.8rem; color:lightslategray; white-space: nowrap;">
                                            Permission &bull; <%= hourLabel%>
                                        </span>
                                    </div>
                                </div>

                            </div>
                        </td>

                        <td data-date="<%= p.getStartDate().getTime()%>" style="padding:10px; text-align:center; width:150px;">
                            <div style="display:flex; flex-direction:column;">
                                <span style="font-size: 12px; font-weight: 600; color: #444; white-space:nowrap;">
                                    <%= outFmt.format(p.getStartDate())%>,
                                    <%= yearFmt.format(p.getEndDate())%>
                                </span>
                                <span style="font-family: Consolas, sans-serif; font-size:0.8rem; font-weight:lighter; color:lightslategray;">
                                    ID: REQ-2026-00<%= p.getPermissionId()%> 
                                </span>
                            </div>
                        </td>

                        <!-- REASON -->
                        <td style="padding:10px; text-align:center; width:350px;">

                            <span style="
                                  font-size:0.9rem;
                                  display:block;
                                  white-space: wrap;
                                  overflow:hidden;
                                  text-overflow:ellipsis;
                                  ">
                                <%= p.getMotif()%>
                            </span>

                        </td>

                        <!-- STATUS -->
                        <td style="padding:10px; text-align:center; width:120px;">

                            <div class="status <%=cssClass%>">
                                <div class="icon-btn-status" onclick="toggleHRTooltip(this, '<%=p.getResponseMessage() != null ? p.getResponseMessage().replace("'", "\\'") : ""%>')" style="position:relative; cursor:pointer;">
                                    <div class="icon-home <%=cssIconStatus%>">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
                                        <path fill-rule="evenodd" d="M12 3.75a6.715 6.715 0 0 0-3.722 1.118.75.75 0 1 1-.828-1.25 8.25 8.25 0 0 1 12.8 6.883c0 3.014-.574 5.897-1.62 8.543a.75.75 0 0 1-1.395-.551A21.69 21.69 0 0 0 18.75 10.5 6.75 6.75 0 0 0 12 3.75ZM6.157 5.739a.75.75 0 0 1 .21 1.04A6.715 6.715 0 0 0 5.25 10.5c0 1.613-.463 3.12-1.265 4.393a.75.75 0 0 1-1.27-.8A6.715 6.715 0 0 0 3.75 10.5c0-1.68.503-3.246 1.367-4.55a.75.75 0 0 1 1.04-.211ZM12 7.5a3 3 0 0 0-3 3c0 3.1-1.176 5.927-3.105 8.056a.75.75 0 1 1-1.112-1.008A10.459 10.459 0 0 0 7.5 10.5a4.5 4.5 0 1 1 9 0c0 .547-.022 1.09-.067 1.626a.75.75 0 0 1-1.495-.123c.041-.495.062-.996.062-1.503a3 3 0 0 0-3-3Zm0 2.25a.75.75 0 0 1 .75.75c0 3.908-1.424 7.485-3.781 10.238a.75.75 0 0 1-1.14-.975A14.19 14.19 0 0 0 11.25 10.5a.75.75 0 0 1 .75-.75Zm3.239 5.183a.75.75 0 0 1 .515.927 19.417 19.417 0 0 1-2.585 5.544.75.75 0 0 1-1.243-.84 17.915 17.915 0 0 0 2.386-5.116.75.75 0 0 1 .927-.515Z" clip-rule="evenodd" />
                                        </svg>
                                    </div>
                                    <!--Tooltip -->
                                    <div class="hr-tooltip" style="display:none; position:absolute; bottom:calc(100% + 8px); left:50%; transform:translateX(-50%); width:220px; background:#fff; border:1px solid #ddd; border-radius:8px; padding:12px; z-index:999; box-shadow:0 4px 12px rgba(0,0,0,0.12); font-size:13px; color:#333;">
                                        <div style="font-weight:600; margin-bottom:6px; color:#555;">HR Note:</div>
                                        <div class="hr-message" style="color:#222; line-height:1.5;"></div>
                                        <div style="position:absolute; top:100%; left:50%; transform:translateX(-50%); border:6px solid transparent; border-top-color:#ddd;"></div>
                                    </div>
                                </div>
                                <span>
                                    <%=p.getStatus()%>
                                </span>
                            </div>
                        </td>

                        <!-- ACTION -->
                        <td style="padding:10px; text-align:center; width:100px;">

                            <button class="icon-btn-td"
                                    data-userid="<%= p.getUserId()%>" 
                                    data-useremail="<%= p.getEmail()%>"
                                    data-type="permission"
                                    data-title="Permission"
                                    data-holidayid="<%= p.getPermissionId()%>" 
                                    data-username="<%= p.getFullName()%>"
                                    data-startdate="<%= p.getStartDate()%>"
                                    data-enddate="<%= p.getEndDate()%>"
                                    data-starttime="<%= p.getStartTime()%>"
                                    data-endtime="<%= p.getEndTime()%>"
                                    data-motif="<%= p.getMotif()%>"
                                    data-status="<%= p.getStatus()%>"
                                    data-responsemessage="<%=p.getResponseMessage()%>">

                                <span class="icon-home">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                                    </svg>
                                </span>



                            </button>

                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
        <script src="../scripts/utils.js"></script>
        <script>
                                    function openModal() {
                                        const modal = document.getElementById('leaveModal');
                                        modal.classList.add('active');
                                        document.body.style.overflow = 'hidden';
                                        requestAnimationFrame(() => {
                                            requestAnimationFrame(() => {
                                                modal.classList.add('visible');
                                            });
                                        });
                                    }

                                    // Pour fermer
                                    function closeModal() {
                                        const modal = document.getElementById('leaveModal');
                                        modal.classList.remove('visible');
                                        document.body.style.overflow = '';
                                        modal.addEventListener('transitionend', () => {
                                            modal.classList.remove('active');
                                        }, {once: true});
                                    }
        </script>
        <script>
            const ROWS_PER_PAGE = 4; // change this to whatever limit you want
            let currentPage = 1;

            function paginateTable() {
                const table = document.getElementById('permissiontable');
                // Only count rows that passed the filter
                const visibleRows = Array.from(table.querySelectorAll('tbody tr'))
                        .filter(r => r.dataset.filtered !== 'true' && !r.querySelector('td[colspan]'));

                const totalPages = Math.ceil(visibleRows.length / ROWS_PER_PAGE);

                // First hide all rows, then show only the current page slice
                table.querySelectorAll('tbody tr').forEach(r => r.style.display = 'none');
                visibleRows.forEach((row, index) => {
                    const inRange = index >= (currentPage - 1) * ROWS_PER_PAGE && index < currentPage * ROWS_PER_PAGE;
                    row.style.display = inRange ? '' : 'none';
                });

                renderPagination(totalPages);
            }

            function renderPagination(totalPages) {
                let container = document.getElementById('pagination-container');
                if (!container) {
                    container = document.createElement('div');
                    container.id = 'pagination-container';
                    document.getElementById('permissiontable').insertAdjacentElement('afterend', container);
                }

                container.innerHTML = '';
                if (totalPages <= 1)
                    return; // hide if only one page

                // Prev button
                const prev = document.createElement('button');
                prev.textContent = '←';
                prev.className = 'page-btn';
                prev.disabled = currentPage === 1;
                prev.onclick = () => {
                    currentPage--;
                    paginateTable();
                };
                container.appendChild(prev);

                // Page numbers
                for (let i = 1; i <= totalPages; i++) {
                    const btn = document.createElement('button');
                    btn.textContent = i;
                    btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
                    btn.onclick = () => {
                        currentPage = i;
                        paginateTable();
                    };
                    container.appendChild(btn);
                }

                // Next button
                const next = document.createElement('button');
                next.textContent = '→';
                next.className = 'page-btn';
                next.disabled = currentPage === totalPages;
                next.onclick = () => {
                    currentPage++;
                    paginateTable();
                };
                container.appendChild(next);
            }

            // Init on load
            document.addEventListener('DOMContentLoaded', () => {
                sortRows();
                updateDateHeader();
                paginateTable();
            });
        </script>
        <script>
            const dateHeader = document.getElementById("dateHeader");
            const tbody = document.querySelector("tbody");

            let newestFirst = true;

            function sortRows() {
                const rows = Array.from(tbody.querySelectorAll("tr"));
                rows.sort((a, b) => {

                    const dateA = Number(a.children[1].dataset.date);
                    const dateB = Number(b.children[1].dataset.date);

                    return newestFirst
                            ? dateB - dateA
                            : dateA - dateB;
                });

                rows.forEach(row => tbody.appendChild(row));
            }

            function updateDateHeader() {
                dateHeader.textContent = newestFirst
                        ? "Period ↓"
                        : "Period ↑";
            }

            dateHeader.addEventListener("click", () => {
                newestFirst = !newestFirst;
                sortRows();
                updateDateHeader();
                currentPage = 1;
                paginateTable();
            });

            window.addEventListener("load", () => {
                newestFirst = true;
                sortRows();
                updateDateHeader();
            });
        </script>
        <script>
            function applyFilters() {

                currentPage = 1;
                const selectedStatus = document.getElementById('statusFilter').value.toLowerCase();
                const selectedDate = document.getElementById('dateFilter').value.toLowerCase();
                const rows = document.querySelectorAll('#permissiontable tbody tr');

                const statusCounts = {
                    pending: 0,
                    approved: 0,
                    rejected: 0
                };

                // --- Date range boundaries --- */
                const now = new Date();
                const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                const yesterday = new Date(today);
                yesterday.setDate(today.getDate() - 1);

                const lastWeekStart = new Date(today);
                lastWeekStart.setDate(today.getDate() - 7);
                const lastMonthStart = new Date(today);
                lastMonthStart.setMonth(today.getMonth() - 1);

                rows.forEach(row => {
                    if (row.querySelector('td[colspan]'))
                        return;

                    const statusSpan = row.querySelector('td:nth-child(4) span');
                    if (!statusSpan)
                        return;

                    // --- Status ---
                    const rowStatus = statusSpan.textContent.trim().toLowerCase();
                    const statusMatch = selectedStatus === 'all' || rowStatus === selectedStatus;

                    // count matching status
                    if (statusCounts.hasOwnProperty(rowStatus)) {
                        statusCounts[rowStatus]++;
                    }

                    // --- Date ---
                    const rawDate =
                            row.querySelector('td:first-child div div span:first-of-type')
                            ?.textContent.trim() || '';
                    const rowDate = new Date(rawDate + ', ' + new Date().getFullYear());
                    rowDate.setHours(0, 0, 0, 0);

                    let dateMatch = true;
                    if (selectedDate !== 'all' && !isNaN(rowDate)) {
                        if (selectedDate === 'today') {
                            dateMatch = rowDate.getTime() === today.getTime();
                        } else if (selectedDate === 'yesterday') {
                            dateMatch = rowDate.getTime() === yesterday.getTime();
                        } else if (selectedDate === 'last_week') {
                            dateMatch = rowDate >= lastWeekStart && rowDate <= today;
                        } else if (selectedDate === 'last_month') {
                            dateMatch = rowDate >= lastMonthStart && rowDate <= today;
                        }
                    }

                    // Mark filtered rows instead of hiding directly — pagination will handle display
                    row.dataset.filtered = (statusMatch && dateMatch) ? 'false' : 'true';
                });

                // Reset to page 1 and re-paginate
                currentPage = 1;
                paginateTable();
                showEmptyMessageIfNeeded();
            }

            function showEmptyMessageIfNeeded() {
                const tbody = document.querySelector('#permissiontable tbody');
                const visibleRows = Array.from(tbody.querySelectorAll('tr')).filter(row => {
                    return !row.querySelector('td[colspan]') && row.style.display !== 'none';
                });
                // Supprimer ancien message de filtre vide
                const existing = document.getElementById('filter-empty-msg');
                if (existing)
                    existing.remove();
                if (visibleRows.length === 0) {
                    const emptyRow = document.createElement('tr');
                    emptyRow.id = 'filter-empty-msg';
                    emptyRow.innerHTML = `
            <td colspan="4" style="padding:30px; background:white; text-align:center;
                border-bottom-left-radius:16px; border-bottom-right-radius:16px; color:red;">
                No results for this filter.
            </td>`;
                    tbody.appendChild(emptyRow);
                }
            }

            document.getElementById('statusFilter').addEventListener('change', applyFilters);
            document.getElementById('dateFilter').addEventListener('change', applyFilters);

            /**Filter by cliking cards*/
            document.getElementById('pending_card').addEventListener('click', () => {
                document.getElementById('statusFilter').value = 'pending';
                applyFilters();
            });
            document.getElementById('approved_card').addEventListener('click', () => {
                document.getElementById('statusFilter').value = 'approved';
                applyFilters();
            });
            document.getElementById('rejected_card').addEventListener('click', () => {
                document.getElementById('statusFilter').value = 'rejected';
                applyFilters();
            });
        </script>
        <script>
            fetch('${pageContext.request.contextPath}/CountPermByStatus')
                    .then(res => res.json())
                    .then(data => {
                        const pending = data['Pending']  ?? 0;
                        const approved = data['Approved'] ?? 0;
                        const rejected = data['Rejected'] ?? 0;

                        document.querySelector('#pending_card h2').textContent = pending;
                        document.querySelector('#approved_card h2').textContent = approved;
                        document.querySelector('#rejected_card h2').textContent = rejected;
                        document.querySelector('#total_card h2').textContent = pending + approved + rejected;
                    });
        </script>
        <script>
            let selectedEventId = null;
            let currentUserId = null;


            const detailsAction = document.querySelector('.detailsAction');


            // Open modal for each user button
            document.querySelectorAll('.icon-btn-td').forEach(btn => {
                btn.addEventListener('click', () => {

                    // UserId
                    currentUserId = (btn.dataset.userid || "").trim();
                    selectedEventId = btn.dataset.holidayid;

                    const status = btn.dataset.status;
                    document.querySelectorAll('#actionsDiv > div').forEach(d => d.style.display = 'none');

                    if (status === "Pending") {
                        document.getElementById('actions-pending').style.display = 'flex';
                    } else if (status === "Approved" || status === "Rejected") {
                        document.getElementById('actions-reviewed').style.display = 'flex';
                    } else {
                        document.getElementById('actions-none').style.display = 'flex';
                    }

                    // Fill modal
                    document.getElementById('modalreqID').textContent = "REQ-2026-00" + btn.dataset.holidayid || "Unknown";
                    document.getElementById('modalUsername').textContent = btn.dataset.username || "Unknown";
                    document.getElementById('modalUserEmail').textContent = btn.dataset.useremail || "Unknown";
                    document.getElementById('modalMotif').textContent = btn.dataset.motif || "N/A";
                    document.getElementById('modalResponseMessage').textContent = btn.dataset.responsemessage || "WIP";
                    document.getElementById('modalStartDate').textContent = btn.dataset.startdate || "";
                    document.getElementById('modalStartTime').textContent = btn.dataset.starttime || '—';
                    document.getElementById('modalEndTime').textContent = btn.dataset.endtime || '—';
                    document.getElementById('modalLeaveType').textContent = 'Permission';

                    // Récupère la div.status de la même ligne 
                    const row = btn.closest('tr');
                    const statusDiv = row.querySelector('.status');

                    const modalStatusContainer = document.getElementById('modalStatusContainer');
                    modalStatusContainer.innerHTML = '';
                    modalStatusContainer.appendChild(statusDiv.cloneNode(true));

                    //Récupère l'avatar du selected user
                    const contextPath = '${pageContext.request.contextPath}';
                    const modalAvatar = document.getElementById('modalAvatar');
                    modalAvatar.src = '';  // ← refresh
                    modalAvatar.src = contextPath + '/AvatarServlet?userId=' + currentUserId;

                    // Show modal
                    openModal();

                });
            });

            function openConfirmPopup(newStatus) {
                document.getElementById('confirmPopupStatus').textContent = newStatus;
                document.getElementById('adminMessageInput').value = '';
                document.getElementById('pendingStatus').value = newStatus;
                document.getElementById('confirmPopup').style.display = 'flex';
            }

            function closeConfirmPopup() {
                document.getElementById('confirmPopup').style.display = 'none';
            }

            function submitWithMessage() {

                const message = document.getElementById('adminMessageInput').value.trim();
                const newStatus = document.getElementById('pendingStatus').value;

                const btn = document.getElementById("submitBtnModal");
                const form = document.getElementById("statusForm");

                document.getElementById('leaveId').value = selectedEventId;
                document.getElementById('leaveStatus').value = newStatus;
                document.getElementById('leaveUserId').value = currentUserId;
                document.getElementById('leaveAdminMessage').value = message;

                // ripple
                const ripple = document.createElement("span");
                ripple.className = "ripple";
                const rect = btn.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);

                ripple.style.cssText = `
        width:${size}px;
        height:${size}px;
        left:${rect.width / 2 - size / 2}px;
        top:${rect.height / 2 - size / 2}px;
    `;

                btn.classList.add("loading");
                btn.appendChild(ripple);
                ripple.addEventListener("animationend", () => ripple.remove());

                setTimeout(() => {
                    btn.classList.remove("loading");
                    btn.classList.add("done");

                    btn.querySelector(".btn-label").innerHTML = `
            Submitted!
            <svg xmlns="http://www.w3.org/2000/svg"
                 viewBox="0 0 20 20"
                 fill="currentColor"
                 width="16"
                 height="16"
                 style="vertical-align:-3px;margin-right:6px;">
                <path fill-rule="evenodd"
                      d="M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z"
                      clip-rule="evenodd" />
            </svg>`;

                    setTimeout(() => {
                        document.body.classList.add("fade-out");

                        setTimeout(() => {
                            form.submit(); // <- submit your actual form
                        }, 400);

                    }, 600);

                }, 800);
            }
        </script>
        <script>
            function toggleHRTooltip(btn, message) {
                const tooltip = btn.querySelector('.hr-tooltip');
                const msgDiv = btn.querySelector('.hr-message');

                // Close any other open tooltips
                document.querySelectorAll('.hr-tooltip').forEach(t => {
                    if (t !== tooltip)
                        t.style.display = 'none';
                });

                if (tooltip.style.display === 'none') {
                    msgDiv.textContent = message && message.trim() !== '' ? message : 'No message provided.';
                    tooltip.style.display = 'block';
                } else {
                    tooltip.style.display = 'none';
                }
            }

            // Close tooltip when clicking outside
            document.addEventListener('click', function (e) {
                if (!e.target.closest('.icon-btn-status')) {
                    document.querySelectorAll('.hr-tooltip').forEach(t => t.style.display = 'none');
                }
            });
        </script>
    </body>
</html>
