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
        <%
            userdataDAO dao = new userdataDAO();
            List<EmployeeInfo> v2 = dao.getEmployeeInfo();

            String selectedAvatar = "../images/avatar1.jpg";
        %>

        <div class="layout">
            <!-- ── Main ──────────────────────────────────── -->
            <main class="main">
                
                <!-- Stats -->
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-label">Total staff</div>
                        <div class="stat-value"><%= (v2 != null) ? v2.size() : 0%></div>
                        <div class="stat-meta"><span class="pill pill-green">Active</span> employees</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">On leave</div>
                        <div class="stat-value">—</div>
                        <div class="stat-meta"><span class="pill pill-amber">Pending</span> requests</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Departments</div>
                        <div class="stat-value">—</div>
                        <div class="stat-meta" style="color:var(--text-3)">Across your org</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Max leave</div>
                        <div class="stat-value">30<span style="font-size:16px;font-weight:500;letter-spacing:0;color:var(--text-3)"> days</span></div>
                        <div class="stat-meta"><span class="pill pill-blue">Per year</span></div>
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

                            /* ── Avatar initials & color (server-side) ── */
                            String fullName = e.getFullName() != null ? e.getFullName().trim() : "??";
                            String[] nameParts = fullName.split("\\s+");
                            StringBuilder iniBuilder = new StringBuilder();
                            for (int ni = 0; ni < Math.min(2, nameParts.length); ni++) {
                                if (nameParts[ni].length() > 0) {
                                    iniBuilder.append(Character.toUpperCase(nameParts[ni].charAt(0)));
                                }
                            }
                            String initials = iniBuilder.toString();

                            String[][] palette = {
                                {"#EEEDFE", "#3C3489"},
                                {"#E1F5EE", "#085041"},
                                {"#FEF3E2", "#92580A"},
                                {"#FBEAF0", "#72243E"},
                                {"#E6F1FB", "#0C447C"},
                                {"#FAECE7", "#712B13"},
                                {"#EAF3DE", "#27500A"}
                            };
                            int hash = 0;
                            for (char ch : fullName.toCharArray()) {
                                hash = (hash << 5) - hash + ch;
                            }
                            int colorIdx = Math.abs(hash) % palette.length;
                            String avatarBg = palette[colorIdx][0];
                            String avatarText = palette[colorIdx][1];

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

                            <!-- Avatar with initials -->
                            <div class="avatar" style="background:<%= avatarBg%>;color:<%= avatarText%>">
                                <%= initials%>
                            </div>

                            <div class="card-meta">
                                <div class="emp-id"># <%= String.format("%06d", userId)%></div>
                                <div class="emp-name"><%= e.getFullName()%></div>
                                <span class="emp-role-pill"><%= e.getRole() != null ? e.getRole() : "—"%></span>
                            </div>

                            <div class="card-actions">
                                <!-- Edit -->
                                <a href="editEmployee.jsp?userId=<%= userId%>" class="act-btn" title="Edit employee" aria-label="Edit <%= e.getFullName()%>">
                                    <i class="ti ti-edit" aria-hidden="true"></i>
                                </a>
                                <!-- Delete trigger -->
                                <button class="act-btn danger" title="Delete employee"
                                        onclick="confirmDelete(<%=userId%>)">
                                    <i class="ti ti-trash" aria-hidden="true"></i>
                                </button>
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
                                    <span>24 / 30 days</span><%-- TODO: e.getLeaveBalance() --%>
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
    </body>
</html>

