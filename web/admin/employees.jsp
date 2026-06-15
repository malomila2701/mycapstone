<%-- 
    Document   : employees
    Created on : 15 déc. 2025, 14:33:00
    Author     : HP
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javafiles.userdataDAO"%>
<%@page import="javafiles.EmployeeInfo"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

        <title>JSP Page</title>
        <link rel="stylesheet" href="../css/admin/adm_employees_styles.css">

    </head>
    <body>
        <script>
            const contextPath = '<%= request.getContextPath()%>';
        </script>
        <%
            userdataDAO dao = new userdataDAO();
            List<EmployeeInfo> v2 = dao.getEmployeeInfo();

            String selectedAvatar = "../images/avatar1.jpg";
        %>

        <div id="leaveModal" class="modal">
            <div class="modal-content">
                <!--Bouton close-->
                <button class="modal-close-btn" onclick="closeEmployeeModal()">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                    <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
                    </svg>
                </button>
                <!--Section de details (Nom, email) (Période de congés) (Boutons)-->
                <div class="details-section">
                    <div style="
                         background: #f3f6fa;
                         padding: 10px;
                         border: 1px solid #E2E8F0;
                         border-radius: 20px;
                         ">
                        <span style="display:flex; flex-direction:row;">
                            <img id="modalAvatar"
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
                </div>
            </div>
        </div>





        <div class="layout">
            <!-- ── Main ──────────────────────────────────── -->
            <main class="main">

                <div style="display:flex; flex-direction: row; justify-content: space-between; margin-top: 10px;">
                    <div style="display:flex; flex-direction: column;">
                        <span style="padding-left: 20px;
                              font-size: 1rem;
                              font-weight: 600;
                              color: #333;">Employees Section</span>
                        <span style="padding-left: 20px;
                              font-size: 0.8rem;
                              font-weight: lighter;">HR Management</span>
                    </div>
                    <div style="display:flex; flex-direction: row; gap: 15px; margin-right: 2%;">
                        <button class="toolbarBtn addEmployee" style="display:flex; flex-direction: row; background:">
                            <span class="icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                <path d="M10.75 4.75a.75.75 0 0 0-1.5 0v4.5h-4.5a.75.75 0 0 0 0 1.5h4.5v4.5a.75.75 0 0 0 1.5 0v-4.5h4.5a.75.75 0 0 0 0-1.5h-4.5v-4.5Z" />
                                </svg>
                            </span>
                            ADD EMPLOYEE
                        </button>
                    </div>
                </div> 

                <div class="cards-section">
                    <div class="card" id="total_card">
                        <p>Total Staff</p>
                        <h2><%= (v2 != null) ? v2.size() : 0%></h2>
                    </div>

                    <div class="card" id="pending_card">
                        <p>On leave</p>
                        <h2>-</h2>
                    </div>

                    <div class="card" id="approved_card">
                        <p>Approved</p>
                        <h2>6</h2>
                    </div>

                    <div class="card" id="rejected_card">
                        <p>MAX LEAVE</p>
                        <h2>24 days<span style="font-weight: 300">/year</span></h2>
                    </div>
                </div>

                <!-- Toolbar -->
                <div class="toolbar">
                    <div class="search-wrap">
                        <i class="ti ti-search"></i>
                        <input type="text" id="searchInput" placeholder="Search by name, role or ID…" oninput="filterCards()">
                    </div>
                    <div class="count-label" id="countLabel"></div>
                </div>

                <!-- Employee grid -->
                <div class="emp-grid" id="empGrid">

                    <%
                        if (v2 == null || v2.isEmpty()) {
                    %>
                    <div class="empty-state">
                        <i class="ti ti-users-off"></i>
                        <p>No employees found.</p>
                    </div>
                    <%
                    } else {
                        int cardIndex = 0;
                        for (EmployeeInfo e : v2) {
                            int userId = e.getUserId();
                            String value = dao.getInfo(userId);
                            if (value == null || value.trim().isEmpty()) {
                                value = "—";
                            }

                            double animDelay = cardIndex * 0.05;
                            cardIndex++;
                    %>

                    <!-- Card for: <%= e.getFullName()%> -->
                    <div class="emp-card"
                         style="animation-delay:<%= animDelay%>s"
                         data-name="<%= e.getFullName().toLowerCase()%>"
                         data-role="<%= e.getRole() != null ? e.getRole().toLowerCase() : ""%>"
                         data-id="<%= userId%>">

                        <div class="card-top">
                            <!-- Avatar -->
                            <img src="<%= request.getContextPath()%>/AvatarServlet?userId=<%= userId%>"
                                 style="width:25%; height:25%; border-radius:50%; background:#eef; margin-left:15px;"
                                 title="" alt="" />

                            <div class="card-meta">
                                <div class="emp-id"># <%= String.format("%06d", userId)%></div>
                                <div class="emp-name"><%= e.getFullName()%></div>
                                <span class="emp-role-pill"><%= e.getRole() != null ? e.getRole() : "—"%></span>
                            </div>

                            <div class="card-actions">
                                <!-- Edit -->
                                <a href="#"
                                   class="act-btn"
                                   data-userid="<%= userId%>"
                                   data-name="<%= e.getFullName()%>"
                                   data-email="<%= e.getEmail() != null ? e.getEmail() : ""%>"
                                   data-role="<%= e.getRole() != null ? e.getRole() : ""%>"
                                   data-latestleave="<%= value%>"
                                   onclick="openEmployeeModal(this); return false;"
                                   title="Edit employee">
                                    <span class="icon-home icon-btn-td">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="black" class="size-5">
                                        <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                                        <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                                        </svg>
                                    </span>
                                </a>
                            </div>
                        </div>

                        <div class="card-divider"></div>

                        <div class="card-details">
                            <div class="detail-item">
                                <span class="detail-label">Entrance</span>
                                <span class="detail-val">2024-03-21</span><%-- TODO: e.getEntrance() --%>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Seniority</span>
                                <span class="detail-val">2 year(s)</span><%-- TODO: e.getSeniority() --%>
                            </div>
                            <div class="detail-item" style="grid-column:1/-1">
                                <span class="detail-label">Email</span>
                                <span class="detail-val email"><%= e.getEmail() != null ? e.getEmail() : "—"%></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Latest leave</span>
                                <span class="detail-val"><%= value%></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Phone</span>
                                <span class="detail-val">(+225) 000-000-00</span><%-- TODO: e.getPhone() --%>
                            </div>
                        </div>

                        <div class="card-divider"></div>

                        <div class="card-footer">
                            <div class="leave-bar-wrap">
                                <div class="leave-bar-label">
                                    <span>Leave balance</span>
                                    <span id="balance-<%= userId%>">...</span>
                                </div>
                                <div class="leave-bar">
                                    <%-- TODO: replace 24 with e.getLeaveBalance() --%>
                                    <div class="leave-bar-fill" style="width:<%= Math.round((24.0 / 30) * 100)%>%"></div>
                                </div>
                            </div>
                            <div class="card-cb">
                                <input type="checkbox" name="selectedUsers"
                                       value="<%= userId%>"
                                       aria-label="Select <%= e.getFullName()%>">
                            </div>
                        </div>

                    </div>

                    <%
                            } // end for
                        }   // end else
%>

                </div><!-- /emp-grid -->

            </main>
        </div>

        <script>
            document.querySelectorAll('input[name="selectedUsers"]').forEach(input => {
                const userId = input.value;
                fetch('<%= request.getContextPath()%>/LeaveBalanceServlet?user_id=' + userId)
                        .then(res => res.json())
                        .then(data => {
                            document.getElementById('balance-' + userId).textContent
                                    = data.leaveBalance.toFixed(1) + ' / 24 days';
                            document.getElementById('bar-' + userId).style.width
                                    = Math.min((data.leaveBalance / 24) * 100, 100) + '%';
                        });
            });
        </script>
        <script>
            function openEmployeeModal(btn) {

                const userId = btn.dataset.userid;
                const name = btn.dataset.name;
                const email = btn.dataset.email;
                const d = btn.dataset;

                currentUserId = userId;

                document.getElementById("modalUsername").textContent = name;
                document.getElementById("modalUserEmail").textContent = email;
                document.getElementById('modalUserId').value = d.userid;
                document.getElementById('inputName').value = d.name;
                document.getElementById('inputRole').value = d.role;
                document.getElementById('inputEmail').value = d.email;
                document.getElementById('inputPhone').value = d.phone;
                document.getElementById('inputEntrance').value = d.entrance;   // format YYYY-MM-DD
                document.getElementById('inputLatestLeave').value = d.latestleave;

                document.getElementById("modalAvatar").src =
                        "<%= request.getContextPath()%>/AvatarServlet?userId=" + userId;

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
            function closeEmployeeModal() {
                const modal = document.getElementById('leaveModal');
                modal.classList.remove('visible');
                document.body.style.overflow = '';
                modal.addEventListener('transitionend', () => {
                    modal.classList.remove('active');
                }, {once: true});
            }
        </script>
        <script>
            /* ── Search / filter ───────────────────────── */
            function filterCards() {
                const q = document.getElementById('searchInput').value.toLowerCase().trim();
                document.querySelectorAll('.emp-card').forEach(c => {
                    const match = !q
                            || c.dataset.name.includes(q)
                            || c.dataset.role.includes(q)
                            || String(c.dataset.id).includes(q);
                    c.style.display = match ? '' : 'none';
                });
                updateCount();
            }

            function updateCount() {
                var all = document.querySelectorAll('.emp-card');
                var total = all.length;
                var visible = 0;
                for (var i = 0; i < all.length; i++) {
                    if (all[i].style.display !== 'none')
                        visible++;
                }
                var label = document.getElementById('countLabel');
                if (label) {
                    label.textContent = visible === total
                            ? total + ' employee' + (total !== 1 ? 's' : '')
                            : visible + ' of ' + total + ' employees';
                }
            }

            /* ── Delete confirmation ───────────────────── */
            function confirmDelete(userId, name) {
                if (confirm('Delete employee "' + name + '"?\nThis action cannot be undone.')) {
                    document.getElementById('deleteForm-' + userId).submit();
                }
            }

            /* ── Init ──────────────────────────────────── */
            updateCount();
        </script>

        <script src="../scripts/utils.js"></script>

        <%@ include file="/employeeEditModal.jspf" %>
    </body>
</html>

