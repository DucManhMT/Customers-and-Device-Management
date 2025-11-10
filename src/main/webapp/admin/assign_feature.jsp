<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feature Management - CRM System</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        /* Override body margin for this page */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        /* Alert Banners */
        .alert-banner {
            position: fixed;
            top: 70px;
            left: 260px;
            right: 0;
            z-index: 1025;
            padding: 15px 20px;
            text-align: center;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            animation: slideDown 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        .alert-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }

        .alert-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-100%);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        @keyframes slideUp {
            from {
                transform: translateY(0);
                opacity: 1;
            }
            to {
                transform: translateY(-100%);
                opacity: 0;
            }
        }

        /* Main Container */
        .permission-container {
            padding: 30px;
            max-width: 100%;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .page-header h2 {
            position: relative;
            z-index: 1;
            font-weight: 700;
            margin-bottom: 8px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .page-header p {
            position: relative;
            z-index: 1;
            opacity: 0.95;
        }

        /* Card */
        .card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            overflow: hidden;
            background: white;
            transition: all 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.16);
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 18px 24px;
            font-weight: 600;
            font-size: 17px;
            border-bottom: none;
        }

        /* Table Container - Enable Both Scrolls */
        .table-responsive {
            max-height: calc(100vh - 420px);
            overflow-y: auto;
            overflow-x: auto;
            position: relative;
        }

        /* Custom Scrollbars */
        .table-responsive::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        .table-responsive::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .table-responsive::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
        }

        .table-responsive::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
        }

        .table-responsive::-webkit-scrollbar-corner {
            background: #f1f1f1;
        }

        /* Table */
        .permission-table {
            margin-bottom: 0;
            min-width: 1000px;
            table-layout: auto;
        }

        .permission-table thead th {
            background: linear-gradient(to bottom, #f8f9fa, #e9ecef);
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 3px solid #667eea;
            padding: 18px 15px;
            vertical-align: middle;
            text-align: center;
            position: sticky;
            top: 0;
            z-index: 10;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        /* First column sticky on horizontal scroll */
        .permission-table thead th:first-child,
        .permission-table tbody td:first-child {
            position: sticky;
            left: 0;
            background: white;
            z-index: 5;
        }

        .permission-table thead th:first-child {
            z-index: 15;
            background: linear-gradient(to bottom, #f8f9fa, #e9ecef);
        }

        /* Shadow for sticky column */
        .permission-table thead th:first-child::after,
        .permission-table tbody td:first-child::after {
            content: '';
            position: absolute;
            top: 0;
            right: -10px;
            bottom: 0;
            width: 10px;
            background: linear-gradient(to right, rgba(0,0,0,0.05), transparent);
            pointer-events: none;
        }

        .permission-table tbody td {
            vertical-align: middle;
            padding: 14px 15px;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .permission-table tbody td:first-child {
            white-space: normal;
            min-width: 300px;
        }

        .permission-table tbody tr {
            transition: all 0.2s ease;
        }

        .permission-table tbody tr:hover {
            background: linear-gradient(to right, #f8f9fa, #e3f2fd);
            transform: scale(1.002);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        /* Feature Name */
        .feature-name {
            font-weight: 500;
            color: #2c3e50;
            display: flex;
            align-items: center;
        }

        .feature-name i {
            margin-right: 12px;
            color: #667eea;
            font-size: 18px;
            width: 24px;
            text-align: center;
            flex-shrink: 0;
        }

        .feature-url {
            font-size: 11px;
            color: #6c757d;
            margin-left: 36px;
            font-family: 'Courier New', monospace;
            word-break: break-all;
        }

        /* Role Badge */
        .role-badge {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 700;
            font-size: 13px;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .role-badge:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
        }

        /* Specific role colors */
        .role-Customer {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
        }

        .role-CustomerSupporter {
            background: linear-gradient(135deg, #16a085 0%, #1abc9c 100%);
            color: white;
        }

        .role-WarehouseKeeper {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            color: white;
        }

        .role-TechnicianLeader {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
        }

        .role-TechnicianEmployee {
            background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
            color: white;
        }

        /* Checkbox */
        .form-check-input {
            width: 1.8em;
            height: 1.8em;
            cursor: pointer;
            border: 2px solid #dee2e6;
            transition: all 0.3s ease;
        }

        .form-check-input:hover:not(:disabled) {
            border-color: #667eea;
            transform: scale(1.1);
        }

        .form-check-input:checked {
            background-color: #667eea;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.2);
        }

        /* Select All Button */
        .select-all-section {
            margin-top: 10px;
        }

        .select-all-btn {
            font-size: 11px;
            padding: 6px 12px;
            border-radius: 20px;
            transition: all 0.3s ease;
            background: white;
            border: 1px solid #dee2e6;
            color: #495057;
            white-space: nowrap;
        }

        .select-all-btn:hover {
            background: #667eea;
            border-color: #667eea;
            color: white;
            transform: scale(1.05);
        }

        /* Action Buttons */
        .action-buttons {
            position: sticky;
            bottom: 0;
            background: linear-gradient(to top, white, rgba(255,255,255,0.98));
            padding: 24px;
            border-top: 3px solid #e9ecef;
            box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 100;
            backdrop-filter: blur(10px);
        }

        .btn-save {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 14px 40px;
            font-weight: 600;
            border-radius: 30px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
            color: white;
        }

        .btn-save:active {
            transform: translateY(-1px);
        }

        .btn-save:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .btn-reset {
            background: linear-gradient(135deg, #95a5a6 0%, #7f8c8d 100%);
            border: none;
            color: white;
            padding: 14px 35px;
            font-weight: 600;
            border-radius: 30px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(149, 165, 166, 0.4);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-reset:hover {
            background: linear-gradient(135deg, #7f8c8d 0%, #95a5a6 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(149, 165, 166, 0.5);
            color: white;
        }

        .info-text {
            color: #6c757d;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-text i {
            color: #667eea;
            font-size: 18px;
        }

        /* Scroll hint indicator */
        .scroll-hint {
            position: absolute;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            background: linear-gradient(to left, rgba(102, 126, 234, 0.9), transparent);
            color: white;
            padding: 10px 15px;
            border-radius: 8px 0 0 8px;
            font-size: 12px;
            font-weight: 600;
            z-index: 20;
            animation: pulse 2s infinite;
            pointer-events: none;
            display: none;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }

        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            animation: fadeIn 0.5s ease;
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                margin-left: 0 !important;
            }

            .alert-banner {
                left: 0;
            }

            .permission-container {
                padding: 15px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }

            .action-buttons > div {
                width: 100%;
            }

            .btn-save, .btn-reset {
                width: 100%;
            }

            .permission-table tbody td:first-child {
                min-width: 200px;
            }
        }
    </style>
</head>
<body>
<!-- Include Header & Sidebar -->
<c:set var="activePage" value="assignfeature" scope="request"/>
<jsp:include page="/components/header.jsp" />
<jsp:include page="/components/sidebar.jsp" />

<!-- Success Banner -->
<c:if test="${not empty sessionScope.successMessage}">
    <div class="alert-banner alert-success" id="successBanner">
        <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMessage}
    </div>
    <c:remove var="successMessage" scope="session"/>
</c:if>

<!-- Error Banner -->
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="alert-banner alert-danger" id="errorBanner">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
    </div>
    <c:remove var="errorMessage" scope="session"/>
</c:if>

<div class="permission-container">
    <!-- Page Header -->
    <div class="page-header">
        <h2 class="mb-2">
            <i class="bi bi-shield-lock-fill me-2"></i>
            Feature Management
        </h2>
        <p class="mb-0">
            <i class="bi bi-info-circle me-2"></i>
            Assign or revoke feature permissions for different roles below. Admins always have full access.
        </p>
    </div>

    <!-- Permission Form -->
    <form action="${pageContext.request.contextPath}/admin/assign_feature_controller" method="post" id="permissionForm">
        <!-- Hidden container for RoleFeature submissions -->
        <div id="hiddenRoleFeaturesContainer" class="d-none"></div>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <div>
                    <i class="bi bi-table me-2"></i>Permission Assignment Table
                </div>
                <small class="opacity-75">
                    <i class="bi bi-arrow-left-right me-1"></i>Scroll horizontally to view more roles
                </small>
            </div>

            <div class="table-responsive" id="tableContainer">
                <div class="scroll-hint" id="scrollHint">
                    <i class="bi bi-arrow-right me-1"></i>Scroll →
                </div>
                <table class="table permission-table">
                    <thead>
                    <tr>
                        <th style="text-align: left;">
                            <i class="bi bi-list-task me-2"></i>Feature
                        </th>
                        <%-- Count non-Admin roles --%>
                        <c:set var="nonAdminRoleCount" value="0" />
                        <c:forEach var="role" items="${roles}">
                            <c:if test="${role.roleName != 'Admin'}">
                                <c:set var="nonAdminRoleCount" value="${nonAdminRoleCount + 1}" />
                            </c:if>
                        </c:forEach>

                        <%-- Display only non-Admin roles --%>
                        <c:forEach var="role" items="${roles}" varStatus="roleStatus">
                            <c:if test="${role.roleName != 'Admin'}">
                                <th>
                                    <div>
                                        <span class="role-badge role-${role.roleName}">${role.roleName}</span>
                                    </div>
                                    <div class="select-all-section">
                                        <button type="button" class="btn select-all-btn"
                                                onclick="toggleColumn(${role.roleID})">
                                            <i class="bi bi-check-all me-1"></i>Select All
                                        </button>
                                    </div>
                                </th>
                            </c:if>
                        </c:forEach>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- Check if data exists -->
                    <c:choose>
                        <c:when test="${empty features}">
                            <tr>
                                <td colspan="${nonAdminRoleCount + 1}" class="text-center py-5">
                                    <i class="bi bi-inbox" style="font-size: 48px; color: #ccc;"></i>
                                    <p class="mt-3 text-muted">No feature data available</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="feature" items="${features}" varStatus="featureStatus">
                                <%-- Feature row --%>
                                <tr>
                                    <td>
                                        <div class="feature-name">
                                            <i class="bi bi-link-45deg"></i>
                                            <span>${feature.description}</span>
                                        </div>
                                        <div class="feature-url">
                                            <i class="bi bi-arrow-return-right"></i> ${feature.featureURL}
                                        </div>
                                    </td>

                                        <%-- Loop through each role (skip Admin) --%>
                                    <c:forEach var="role" items="${roles}">
                                        <c:if test="${role.roleName != 'Admin'}">
                                            <td class="text-center">
                                                    <%-- Check if this role has this feature --%>
                                                    <%-- roleFeatureMap is Map<Integer, List<Feature>> --%>
                                                <c:set var="hasPermission" value="false" />

                                                    <%-- Get features list for this roleID (Integer key) --%>
                                                <c:set var="featuresForRole" value="${roleFeatureMap[role.roleID]}" />

                                                    <%-- Check if feature exists in the list --%>
                                                <c:if test="${not empty featuresForRole}">
                                                    <c:forEach var="roleFeature" items="${featuresForRole}">
                                                        <c:if test="${roleFeature.featureID == feature.featureID}">
                                                            <c:set var="hasPermission" value="true" />
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>

                                                    <%-- Checkbox --%>
                                                <input class="form-check-input permission-checkbox role-checkbox-${role.roleID}"
                                                       type="checkbox"
                                                       data-role-id="${role.roleID}"
                                                       data-feature-id="${feature.featureID}"
                                                    ${hasPermission ? 'checked' : ''}
                                                       title="Click to change permissions for ${role.roleName}">
                                            </td>
                                        </c:if>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <div class="info-text">
                    <i class="bi bi-info-circle-fill"></i>
                    <span>Admins always have full permissions and are not displayed in the table. Changes will be applied immediately.</span>
                </div>
                <div class="d-flex gap-3">
                    <button type="button" class="btn btn-reset" onclick="resetForm()">
                        <i class="bi bi-arrow-counterclockwise me-2"></i>Reset
                    </button>
                    <button type="submit" class="btn btn-save" id="saveBtn">
                        <i class="bi bi-check-circle-fill me-2"></i>Save Changes
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto hide banners after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        // Success banner
        const successBanner = document.getElementById('successBanner');
        if (successBanner) {
            setTimeout(function() {
                successBanner.style.animation = 'slideUp 0.4s ease-out forwards';
                setTimeout(() => successBanner.remove(), 400);
            }, 5000);
        }

        // Error banner
        const errorBanner = document.getElementById('errorBanner');
        if (errorBanner) {
            setTimeout(function() {
                errorBanner.style.animation = 'slideUp 0.4s ease-out forwards';
                setTimeout(() => errorBanner.remove(), 400);
            }, 5000);
        }

        // Show scroll hint if table is scrollable
        checkScrollability();
    });

    // Check if table is horizontally scrollable
    function checkScrollability() {
        const container = document.getElementById('tableContainer');
        const scrollHint = document.getElementById('scrollHint');

        if (container && scrollHint && container.scrollWidth > container.clientWidth) {
            scrollHint.style.display = 'block';

            // Hide hint when user scrolls
            container.addEventListener('scroll', function() {
                if (this.scrollLeft > 50) {
                    scrollHint.style.display = 'none';
                }
            }, { once: true });

            // Auto hide after 5 seconds
            setTimeout(() => {
                scrollHint.style.display = 'none';
            }, 5000);
        }
    }

    // Toggle all checkboxes in a role column by roleID
    function toggleColumn(roleID) {
        const checkboxes = document.querySelectorAll('.role-checkbox-' + roleID);
        const allChecked = Array.from(checkboxes).every(cb => cb.checked);

        checkboxes.forEach(checkbox => {
            checkbox.checked = !allChecked;
            // Trigger animation
            const row = checkbox.closest('tr');
            if (row) {
                row.style.background = allChecked ? '#e3f2fd' : '#fff3cd';
                setTimeout(() => {
                    row.style.background = '';
                }, 300);
            }
        });
    }

    // Reset form to original state
    function resetForm() {
        if (confirm('⚠️ Are you sure you want to reset all changes to the initial state?')) {
            const form = document.getElementById('permissionForm');
            if (form) {
                form.reset();

                // Visual feedback
                document.querySelectorAll('.permission-table tbody tr').forEach(row => {
                    row.style.background = '#fff3cd';
                    setTimeout(() => {
                        row.style.background = '';
                    }, 500);
                });
            }
        }
    }

    // Sync hidden inputs before form submission
    function syncHiddenInputs() {
        const container = document.getElementById('hiddenRoleFeaturesContainer');
        if (!container) return;

        container.innerHTML = ''; // Clear existing

        // Get all checked checkboxes
        const checkedBoxes = document.querySelectorAll('.permission-checkbox:checked');

        checkedBoxes.forEach(checkbox => {
            const roleID = checkbox.dataset.roleId;
            const featureID = checkbox.dataset.featureId;

            // Create hidden inputs for roleID
            const roleInput = document.createElement('input');
            roleInput.type = 'hidden';
            roleInput.name = 'roleIDs';
            roleInput.value = roleID;
            container.appendChild(roleInput);

            // Create hidden inputs for featureID
            const featureInput = document.createElement('input');
            featureInput.type = 'hidden';
            featureInput.name = 'featureIDs';
            featureInput.value = featureID;
            container.appendChild(featureInput);
        });
    }

    // Form submit confirmation and process
    const form = document.getElementById('permissionForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            if (confirm('✅ Are you sure you want to save these permission changes? Changes will be applied immediately.')) {
                // Sync hidden inputs before submit
                syncHiddenInputs();

                // Show loading
                const saveBtn = document.getElementById('saveBtn');
                if (saveBtn) {
                    saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
                    saveBtn.disabled = true;
                }

                // Submit form
                this.submit();
            }
        });
    }

    // Add visual feedback when checking/unchecking
    document.querySelectorAll('.permission-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const row = this.closest('tr');
            const cell = this.closest('td');

            if (cell) {
                // Ripple effect
                cell.style.background = this.checked ? '#d4edda' : '#f8d7da';
                setTimeout(() => {
                    cell.style.background = '';
                }, 400);
            }

            if (row) {
                // Row highlight
                row.style.background = this.checked ? '#e7f3ff' : '#fff3cd';
                setTimeout(() => {
                    row.style.background = '';
                }, 500);
            }
        });
    });

    // Smooth scroll for table
    const tableResponsive = document.querySelector('.table-responsive');
    if (tableResponsive) {
        tableResponsive.style.scrollBehavior = 'smooth';
    }
</script>
</body>
</html>