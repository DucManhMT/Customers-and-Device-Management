<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/10/2025
  Time: 8:16 AM
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Admin Action Center</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>


        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Roboto, sans-serif;
            background: #f3f4f6;
            color: #1e293b;
        }

        .main-content {
            padding: 2rem 3rem;
            background: #f8fafc;
            min-height: 100vh;
        }

        .main-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 1rem;
            margin-bottom: 2rem;
        }

        .main-header h1 {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(90deg, #6d28d9, #3b82f6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .main-header .btn {
            border-radius: 25px;
            font-weight: 500;
            background: linear-gradient(135deg, #6366f1, #3b82f6);
            color: #fff;
            border: none;
            padding: 8px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 6px rgba(99,102,241,0.3);
        }

        .main-header .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(99,102,241,0.4);
        }

        /* Specific "Create Account" button style can be applied via a class instead of attribute selector */
        .main-header .btn.create-account {
            background: linear-gradient(135deg, #10b981, #059669);
        }

        .content-box {
            background: #fff;
            border-radius: 16px;
            padding: 1.75rem 2rem;
            box-shadow: 0 8px 24px rgba(0,0,0,0.06);
            margin-bottom: 2rem;
            transition: transform 0.2s ease;
        }

        .content-box:hover {
            transform: translateY(-3px);
        }

        .content-box h3 {
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 0.75rem;
        }

        .overview-list li {
            margin: 6px 0;
            color: #334155;
            font-size: 0.95rem;
        }

        /* === Stats Section === */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 1.25rem;
            margin-top: 1.5rem;
        }

        .stat-card {
            background: #fff;
            border-radius: 14px;
            padding: 1.25rem 1.5rem;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: all 0.25s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        }

        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            color: #fff;
            flex-shrink: 0;
            margin-right: 1rem;
        }

        .stat-body .value {
            font-size: 1.8rem;
            font-weight: 700;
            color: #111827;
            margin-bottom: 0.25rem;
        }

        .stat-body .label {
            font-size: 0.95rem;
            color: #6b7280;
        }

        /* === Role Section === */
        .role-cards {
            margin-top: 2rem;
        }

        .role-cards h4 {
            font-weight: 600;
            color: #1e3a8a;
            margin-bottom: 1.25rem;
        }

        .role-grid {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.25rem;
        }

        .role-card {
            background: #fff;
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 4px 10px rgba(0,0,0,0.06);
            transition: all 0.25s ease;
            height: 200px; /* keep uniform height */
        }

        .role-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(99,102,241,0.12);
        }

        .role-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #312e81;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .role-name {
            font-weight: 600;
            font-size: 1rem;
            color: #2563eb;
        }

        .role-meta-sub {
            font-size: 0.9rem;
            color: #64748b;
        }

        .role-count {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0f172a;
        }

        .role-count-label {
            color: #64748b;
            font-size: 0.9rem;
        }

        .role-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: auto;
        }

        .role-actions .btn {
            border-radius: 8px;
            font-size: 0.85rem;
            padding: 6px 12px;
            font-weight: 500;
            transition: all 0.25s ease;
        }

        /* Outline button variations */
        .btn-outline-primary {
            border-color: #6366f1;
            color: #6366f1;
        }

        .btn-outline-primary:hover {
            background: #eef2ff;
        }

        .btn-outline-danger {
            border-color: #ef4444;
            color: #ef4444;
        }

        .btn-outline-danger:hover {
            background: #fee2e2;
        }

        .btn-outline-success {
            border-color: #10b981;
            color: #10b981;
        }

        .btn-outline-success:hover {
            background: #d1fae5;
        }

        @media (max-width: 768px) {
            .main-content { padding: 1.5rem; }
        }
    </style>
</head>

<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="main-content">
    <div class="main-header">
        <h1>Welcome, Admin</h1>

    </div>

    <div class="content-box">
        <h3>Overview</h3>
        <p>Manage your users, roles, and configurations efficiently. Use the sidebar on the left to navigate between sections.</p>
        <ul class="overview-list">
            <li><strong>Role Management:</strong> View and edit user roles.</li>
            <li><strong>Account Management:</strong> Manage user accounts and permissions.</li>
            <li><strong>Quick stats:</strong> See total users, total roles, and users per role below.</li>
        </ul>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon" style="background: linear-gradient(135deg,#6d28d9,#7c3aed);">
                <i class="bi bi-people-fill"></i>
            </div>
            <div class="stat-body">
                <p class="value"><c:out value="${totalUsers}" default="0"/></p>
                <p class="label">Total Users</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: linear-gradient(135deg,#0ea5a4,#14b8a6);">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <div class="stat-body">
                <p class="value"><c:out value="${totalRoles}" default="0"/></p>
                <p class="label">Total Roles</p>
            </div>
        </div>
    </div>

    <!-- Role cards -->
    <div class="role-cards">
        <div class="role-grid">
            <c:forEach var="r" items="${roles}">
                <c:if test="${r.roleID != 1}">
                    <div class="role-card">
                        <div>
                            <div class="role-name"><c:out value="${r.roleName}"/></div>
                        </div>
                        <div>
                            <div class="role-count"><c:out value="${userCountPerRole[r.roleID]}" default="0"/></div>
                            <div class="role-count-label">Users</div>
                        </div>


                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>
    <div class="content-box" style="margin-top:2rem;">
        <h3>Users by Role</h3>
        <div style="display:flex; flex-wrap:wrap; align-items:center; gap:1.25rem;">
            <canvas id="rolesPieChart" style="max-width:520px; width:100%; height:320px;"></canvas>
            <div style="min-width:160px;">
                <p style="margin:0; font-weight:700; font-size:1.25rem;">Total users</p>
                <p id="rolesTotalUsers" style="margin:4px 0 0 0; font-size:1.5rem; color:#111827;">0</p>
                <p style="margin-top:0.5rem; color:#64748b; font-size:0.9rem;">Distribution across roles</p>
            </div>
        </div>
    </div>

</div>

<script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<script>

    var roleLabels = [];
    var roleData = [];
    <c:forEach var="r" items="${roles}">
        <c:if test="${r.roleID != 1}">
            roleLabels.push("<c:out value='${r.roleName}'/>");
            roleData.push(<c:out value="${userCountPerRole[r.roleID]}" default="0"/>);
        </c:if>
    </c:forEach>


    // Fallback: ensure arrays are non-empty
    if (!roleLabels || roleLabels.length === 0) {
        roleLabels = ["No roles"];
        roleData = [0];
    }

    // Generate a color palette (cycled if more roles than colors)
    var baseColors = [
        "#6366f1", "#3b82f6", "#06b6d4", "#10b981", "#f97316",
        "#ef4444", "#ec4899", "#8b5cf6", "#f59e0b", "#14b8a6"
    ];
    var backgroundColors = roleLabels.map(function(_, i){
        return baseColors[i % baseColors.length] + "cc"; // add light alpha
    });
    var borderColors = roleLabels.map(function(_, i){
        return baseColors[i % baseColors.length];
    });

    // compute total users
    var totalUsers = roleData.reduce(function(acc, v){ return acc + Number(v||0); }, 0);
    document.getElementById('rolesTotalUsers').innerText = totalUsers;

    // create doughnut chart
    const ctx = document.getElementById('rolesPieChart').getContext('2d');

    // Destroy existing chart instance if re-rendered (helps when partial reload)
    if (window._rolesPieChart instanceof Chart) {
        window._rolesPieChart.destroy();
    }

    window._rolesPieChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: roleLabels,
            datasets: [{
                data: roleData,
                backgroundColor: backgroundColors,
                borderColor: borderColors,
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '50%', // donut thickness
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        boxWidth: 14,
                        padding: 8
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            var value = Number(context.raw || 0);
                            var pct = totalUsers ? (value / totalUsers * 100).toFixed(1) : 0;
                            return context.label + ': ' + value + ' (' + pct + '%)';
                        }
                    }
                }
            }
        }
    });
</script>
</body>
</html>
