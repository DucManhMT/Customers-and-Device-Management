<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Phân Quyền</title>

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

        /* Success Banner */
        .success-banner {
            position: fixed;
            top: 70px;
            left: 260px;
            right: 0;
            z-index: 1025;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            text-align: center;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            animation: slideDown 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
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
            transform: translateY(-2px);
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 18px 24px;
            font-weight: 600;
            font-size: 17px;
            border-bottom: none;
        }

        /* Table */
        .table-responsive {
            max-height: calc(100vh - 420px);
            overflow-y: auto;
            overflow-x: hidden;
        }

        .table-responsive::-webkit-scrollbar {
            width: 8px;
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

        .permission-table {
            margin-bottom: 0;
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
        }

        .permission-table tbody td {
            vertical-align: middle;
            padding: 14px 15px;
            transition: all 0.2s ease;
        }

        .permission-table tbody tr {
            transition: all 0.2s ease;
        }

        .permission-table tbody tr:hover {
            background: linear-gradient(to right, #f8f9fa, #e3f2fd);
            transform: scale(1.005);
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
        }

        .feature-url {
            font-size: 11px;
            color: #6c757d;
            margin-left: 36px;
            font-family: 'Courier New', monospace;
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

            .success-banner {
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
        }
    </style>
</head>
<body>
<!-- Include Header & Sidebar -->
<c:set var="activePage" value="assignfeature" scope="request"/>
<jsp:include page="/components/header.jsp" />
<jsp:include page="/components/admin_sidebar.jsp" />

<!-- Success Banner -->
<c:if test="${not empty successMessage}">
    <div class="success-banner" id="successBanner">
        <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
    </div>
</c:if>

<div class="permission-container">
    <!-- Page Header -->
    <div class="page-header">
        <h2 class="mb-2">
            <i class="bi bi-shield-lock-fill me-2"></i>
            Quản Lý Phân Quyền
        </h2>
        <p class="mb-0">
            <i class="bi bi-info-circle me-2"></i>
            Cấu hình quyền truy cập cho các vai trò trong hệ thống (Admin luôn có toàn quyền)
        </p>
    </div>

    <!-- Permission Form -->
    <form action="${pageContext.request.contextPath}/admin/assign_feature_controller" method="post" id="permissionForm">
        <!-- Hidden container for RoleFeature submissions -->
        <div id="hiddenRoleFeaturesContainer" class="d-none"></div>

        <div class="card">
            <div class="card-header">
                <i class="bi bi-table me-2"></i>Bảng Phân Quyền Chi Tiết
            </div>

            <div class="table-responsive">
                <table class="table permission-table">
                    <thead>
                    <tr>
                        <th style="width: 40%; text-align: left;">
                            <i class="bi bi-list-task me-2"></i>Chức Năng
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
                                <th style="width: ${60 / nonAdminRoleCount}%;">
                                    <div>
                                        <span class="role-badge role-${role.roleName}">${role.roleName}</span>
                                    </div>
                                    <div class="select-all-section">
                                        <button type="button" class="btn select-all-btn"
                                                onclick="toggleColumn(${role.roleID})">
                                            <i class="bi bi-check-all me-1"></i>Chọn tất cả
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
                                    <p class="mt-3 text-muted">Không có dữ liệu feature</p>
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
                                                <c:set var="hasPermission" value="false" />
                                                <c:if test="${not empty roleFeatureMap[role]}">
                                                    <c:forEach var="roleFeature" items="${roleFeatureMap[role]}">
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
                                                       title="Click để thay đổi quyền cho ${role.roleName}">
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
                    <span>Admin luôn có toàn quyền và không hiển thị trong bảng. Các thay đổi sẽ được áp dụng ngay lập tức.</span>
                </div>
                <div class="d-flex gap-3">
                    <button type="button" class="btn btn-reset" onclick="resetForm()">
                        <i class="bi bi-arrow-counterclockwise me-2"></i>Đặt Lại
                    </button>
                    <button type="submit" class="btn btn-save">
                        <i class="bi bi-check-circle-fill me-2"></i>Xác Nhận Lưu
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto hide success banner after 3 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const banner = document.getElementById('successBanner');
        if (banner) {
            setTimeout(function() {
                banner.style.animation = 'slideUp 0.4s ease-out forwards';
                setTimeout(function() {
                    banner.remove();
                }, 400);
            }, 3000);
        }
    });

    // Toggle all checkboxes in a role column by roleID
    function toggleColumn(roleID) {
        const checkboxes = document.querySelectorAll('.role-checkbox-' + roleID);
        const allChecked = Array.from(checkboxes).every(cb => cb.checked);

        checkboxes.forEach(checkbox => {
            checkbox.checked = !allChecked;
            // Trigger animation
            const row = checkbox.closest('tr');
            row.style.background = allChecked ? '#e3f2fd' : '#fff3cd';
            setTimeout(() => {
                row.style.background = '';
            }, 300);
        });
    }

    // Reset form to original state
    function resetForm() {
        if (confirm('⚠️ Bạn có chắc muốn đặt lại tất cả thay đổi về trạng thái ban đầu?')) {
            document.getElementById('permissionForm').reset();

            // Visual feedback
            document.querySelectorAll('.permission-table tbody tr').forEach(row => {
                row.style.background = '#fff3cd';
                setTimeout(() => {
                    row.style.background = '';
                }, 500);
            });
        }
    }

    // Sync hidden inputs before form submission
    function syncHiddenInputs() {
        const container = document.getElementById('hiddenRoleFeaturesContainer');
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
    document.getElementById('permissionForm').addEventListener('submit', function(e) {
        e.preventDefault();

        if (confirm('✅ Bạn có chắc muốn lưu các thay đổi phân quyền này? Các thay đổi sẽ được áp dụng ngay lập tức.')) {
            // Sync hidden inputs before submit
            syncHiddenInputs();

            // Show loading
            const saveBtn = document.querySelector('.btn-save');
            saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang lưu...';
            saveBtn.disabled = true;

            // Submit form
            this.submit();
        }
    });

    // Add visual feedback when checking/unchecking
    document.querySelectorAll('.permission-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const row = this.closest('tr');
            const cell = this.closest('td');

            // Ripple effect
            cell.style.background = this.checked ? '#d4edda' : '#f8d7da';
            setTimeout(() => {
                cell.style.background = '';
            }, 400);

            // Row highlight
            row.style.background = this.checked ? '#e7f3ff' : '#fff3cd';
            setTimeout(() => {
                row.style.background = '';
            }, 500);
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