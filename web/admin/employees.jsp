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
                    <div style="display:flex; flex-direction: row; gap: 15px; margin-right: 2%; font-weight: 600;">
                        <button class="toolbarBtn addEmployee"
                                style="display:flex; flex-direction: row;"
                                onclick="openNewEmployeeModal()">
                            <span class="icon-home">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="white" class="size-5">
                                <path d="M10 5a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM1.615 16.428a1.224 1.224 0 0 1-.569-1.175 6.002 6.002 0 0 1 11.908 0c.058.467-.172.92-.57 1.174A9.953 9.953 0 0 1 7 18a9.953 9.953 0 0 1-5.385-1.572ZM16.25 5.75a.75.75 0 0 0-1.5 0v2h-2a.75.75 0 0 0 0 1.5h2v2a.75.75 0 0 0 1.5 0v-2h2a.75.75 0 0 0 0-1.5h-2v-2Z" />
                                </svg>
                            </span>
                            New Employee
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
                                    <button class="icon-btn-td">
                                        <span class="icon-home">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M10.343 3.94c.09-.542.56-.94 1.11-.94h1.093c.55 0 1.02.398 1.11.94l.149.894c.07.424.384.764.78.93.398.164.855.142 1.205-.108l.737-.527a1.125 1.125 0 0 1 1.45.12l.773.774c.39.389.44 1.002.12 1.45l-.527.737c-.25.35-.272.806-.107 1.204.165.397.505.71.93.78l.893.15c.543.09.94.559.94 1.109v1.094c0 .55-.397 1.02-.94 1.11l-.894.149c-.424.07-.764.383-.929.78-.165.398-.143.854.107 1.204l.527.738c.32.447.269 1.06-.12 1.45l-.774.773a1.125 1.125 0 0 1-1.449.12l-.738-.527c-.35-.25-.806-.272-1.203-.107-.398.165-.71.505-.781.929l-.149.894c-.09.542-.56.94-1.11.94h-1.094c-.55 0-1.019-.398-1.11-.94l-.148-.894c-.071-.424-.384-.764-.781-.93-.398-.164-.854-.142-1.204.108l-.738.527c-.447.32-1.06.269-1.45-.12l-.773-.774a1.125 1.125 0 0 1-.12-1.45l.527-.737c.25-.35.272-.806.108-1.204-.165-.397-.506-.71-.93-.78l-.894-.15c-.542-.09-.94-.56-.94-1.109v-1.094c0-.55.398-1.02.94-1.11l.894-.149c.424-.07.765-.383.93-.78.165-.398.143-.854-.108-1.204l-.526-.738a1.125 1.125 0 0 1 .12-1.45l.773-.773a1.125 1.125 0 0 1 1.45-.12l.737.527c.35.25.807.272 1.204.107.397-.165.71-.505.78-.929l.15-.894Z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                                            </svg>
                                    </button>
                                </a>
                            </div>
                        </div>

                        <div class="card-divider"></div>

                        <div class="card-details">
                            <div class="detail-item">
                                <span class="detail-label">Entrance</span>
                                <span class="detail-val">2025-01-01</span><%-- TODO: e.getEntrance() --%>
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
                                <script>
                                    fetch('<%=request.getContextPath()%>/LeaveBalanceServlet')
                                            .then(res => res.json())
                                            .then(data => {
                                                document.getElementById('leave-balance').textContent = data.leaveBalance;
                                                document.getElementById('days-used').textContent = data.daysUsed;
                                            });
                                </script>
                                <div class="leave-bar">
                                    <%-- TODO: replace 24 with e.getLeaveBalance() --%>
                                    <div class="leave-bar">
                                        <div class="leave-bar-fill" id="bar-<%= e.getUserId()%>" style="width: 0%"></div>
                                    </div>
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
            document.querySelectorAll('[id^="bar-"]').forEach(barEl => {
                const userId = barEl.id.replace('bar-', '');
                fetch('<%= request.getContextPath()%>/LeaveBalanceServlet?user_id=' + userId)
                        .then(res => res.json())
                        .then(data => {
                            document.getElementById('balance-' + userId).textContent =
                                    data.leaveBalance > 24
                                    ? data.leaveBalance.toFixed(1) + ' days'
                                    : data.leaveBalance.toFixed(1) + ' / 24 days';
                            barEl.style.width
                                    = Math.min((data.leaveBalance / 24) * 100, 100) + '%';
                        });
            });
        </script>
        <script>
            function openEmployeeModal(btn = null) {
                const d = (btn && btn.dataset) ? btn.dataset : {};

                /* Populate fields */
                document.getElementById('em-user-id').value = d.userid || '';
                document.getElementById('em-id-display').textContent = String(d.userid || '0').padStart(6, '0');
                document.getElementById('em-name').value = d.name || '';
                document.getElementById('em-role').value = d.role || '';
                document.getElementById('em-email').value = d.email || '';
                document.getElementById('em-phone').value = d.phone || '';
                document.getElementById('em-entrance').value = d.entrance || '';
                document.getElementById('em-latest-leave').value = d.latestleave || '';

                document.getElementById('em-avatar-img').src = d.userid
                        ? contextPath + '/AvatarServlet?userId=' + d.userid
                        : '';

                const balance = parseInt(d.leavebalance) || 0;
                document.getElementById('em-leave-balance').value = balance;
                emUpdateLeaveBar(balance);

                // titre dynamique
                document.getElementById('em-title').innerHTML =
                        d.userid ? '<i class="ti ti-edit"></i> Edit employee'
                        : '<i class="ti ti-user-plus"></i> New employee';

                /* Reset feedback */
                document.getElementById('em-toast').style.display = 'none';
                document.getElementById('em-error').style.display = 'none';

                /* Show overlay */
                const overlay = document.getElementById('employeeModal');
                overlay.style.display = 'flex';
                setTimeout(() => document.getElementById('em-name').focus(), 50);

                overlay.onclick = function (e) {
                    if (e.target === overlay)
                        closeEmployeeModal();
                };
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
        <script>
            function openNewEmployeeModal() {
                // vide les champs
                ['new-em-name', 'new-em-role', 'new-em-email', 'new-em-phone', 'new-em-entrance']
                        .forEach(id => document.getElementById(id).value = '');

                document.getElementById('new-em-toast').style.display = 'none';
                document.getElementById('new-em-error').style.display = 'none';

                const overlay = document.getElementById('newEmployeeModal');
                overlay.style.display = 'flex';
                overlay.onclick = e => {
                    if (e.target === overlay)
                        closeNewEmployeeModal();
                };
                setTimeout(() => document.getElementById('new-em-name').focus(), 50);
            }

            function closeNewEmployeeModal() {
                document.getElementById('newEmployeeModal').style.display = 'none';
            }

            function newEmSave() {
                const name = document.getElementById('new-em-name').value.trim();
                if (!name) {
                    document.getElementById('new-em-error-msg').textContent = 'Full name is required.';
                    document.getElementById('new-em-error').style.display = 'flex';
                    return;
                }

                const payload = {
                    name: name,
                    role: document.getElementById('new-em-role').value.trim(),
                    email: document.getElementById('new-em-email').value.trim(),
                    phone: document.getElementById('new-em-phone').value.trim(),
                    entrance: document.getElementById('new-em-entrance').value
                };

                fetch('CreateEmployeeServlet', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(payload)
                })
                        .then(res => {
                            if (!res.ok)
                                throw new Error('Server error ' + res.status);
                            return res.json();
                        })
                        .then(() => {
                            document.getElementById('new-em-toast').style.display = 'flex';
                            setTimeout(() => {
                                closeNewEmployeeModal();
                                location.reload();
                            }, 1500);
                        })
                        .catch(err => {
                            document.getElementById('new-em-error-msg').textContent = err.message;
                            document.getElementById('new-em-error').style.display = 'flex';
                        });
            }
        </script>

        <script src="../scripts/utils.js"></script>

        <%@ include file="/newEmployeeModal.jspf" %>
        <%@ include file="/employeeEditModal.jspf" %>
    </body>
</html>

