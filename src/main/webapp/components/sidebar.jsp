<%-- Created by IntelliJ IDEA. User: Master-Long-3112 Date: 11/10/2025 Time:
04:03 AM Categorized Sidebar Component for CRM System --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="crm.common.URLConstants" %>
<%@ page import="crm.filter.service.PermissionService" %>
<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet"/>
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

<style>
    .sidebar {
        width: 280px;
        background: rgba(255, 255, 255, 0.25);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border-right: 1px solid rgba(0, 0, 0, 0.15);
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.2);
        color: #1a1a1a;
        position: fixed;
        height: calc(100vh - 70px);
        top: 70px;
        left: 0;
        z-index: 1020;
        overflow-y: auto;
        overflow-x: hidden;
        transition: all 0.3s ease;
    }

    .sidebar::-webkit-scrollbar {
        width: 6px;
    }

    .sidebar::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.05);
    }

    .sidebar::-webkit-scrollbar-thumb {
        background: rgba(0, 0, 0, 0.2);
        border-radius: 3px;
    }

    .sidebar::-webkit-scrollbar-thumb:hover {
        background: rgba(0, 0, 0, 0.3);
    }

    .sidebar-inner {
        height: 100%;
        display: flex;
        flex-direction: column;
        padding: 20px 0;
    }

    .sidebar-category {
        margin-bottom: 8px;
    }

    .category-header {
        color: #2b2b2b;
        padding: 12px 20px;
        margin: 0;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-weight: 600;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        transition: all 180ms ease;
        border-radius: 0;
        background-color: transparent;
    }

    .category-header:hover {
        background-color: rgba(0, 0, 0, 0.08);
    }

    .category-header i.category-icon {
        width: 20px;
        margin-right: 12px;
        text-align: center;
        color: #3a3a3a;
    }

    .category-header .toggle-icon {
        transition: transform 0.3s ease;
        font-size: 12px;
        color: #666;
    }

    .category-header.collapsed .toggle-icon {
        transform: rotate(-90deg);
    }

    .category-items {
        max-height: 0;
        overflow: hidden;
        transition: max-height 0.3s ease;
    }

    .category-items.show {
        max-height: 1000px;
    }

    .sidebar-nav {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .sidebar-nav .nav-link {
        color: #2b2b2b;
        padding: 10px 20px 10px 52px;
        margin: 2px 15px;
        border-radius: 30px;
        display: flex;
        align-items: center;
        font-weight: 500;
        font-size: 13px;
        transition: all 180ms ease;
        text-decoration: none;
        background-color: transparent;
        position: relative;
    }

    .sidebar-nav .nav-link::before {
        content: "";
        position: absolute;
        left: 30px;
        top: 50%;
        transform: translateY(-50%);
        width: 4px;
        height: 4px;
        background-color: #666;
        border-radius: 50%;
    }

    .sidebar-nav .nav-link:hover {
        background-color: rgba(0, 0, 0, 0.1);
        color: #000;
    }

    .sidebar-nav .nav-link:hover::before {
        background-color: #000;
    }

    .sidebar-nav .nav-link.active {
        background-color: rgba(249, 201, 65, 0.9);
        color: #1a3a4a;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        font-weight: 600;
    }

    .sidebar-nav .nav-link.active::before {
        background-color: #1a3a4a;
        width: 6px;
        height: 6px;
    }

    body {
        margin-left: 280px;
        padding-top: 70px;
        background-color: #f5f6f7;
    }

    .sidebar-footer {
        margin-top: auto;
        padding: 15px 20px;
        border-top: 1px solid rgba(0, 0, 0, 0.1);
    }

    .sidebar-footer .nav-link {
        color: #dc3545;
        padding: 10px 20px;
        border-radius: 30px;
        display: flex;
        align-items: center;
        font-weight: 500;
        transition: all 180ms ease;
        text-decoration: none;
    }

    .sidebar-footer .nav-link:hover {
        background-color: rgba(220, 53, 69, 0.1);
    }

    .sidebar-footer .nav-link i {
        width: 20px;
        margin-right: 12px;
        text-align: center;
    }

    .sidebar.sidebar-hidden {
        transform: translateX(-280px);
    }
</style>

<div id="sidebar" class="sidebar">
  <div class="sidebar-inner">
    <c:if test="${not empty sessionScope.flashErrorMessage}">
      <div class="alert alert-warning" role="alert">
        <c:out value="${sessionScope.flashErrorMessage}" />
      </div>
      <c:remove var="flashErrorMessage" scope="session" />
    </c:if>
    <!-- Authentication Category -->
    <div class="sidebar-category">
      <div class="category-header" onclick="toggleCategory('auth')">
        <span><i class="fas fa-lock category-icon"></i>Authentication</span>
        <i class="fas fa-chevron-down toggle-icon"></i>
      </div>
      <div class="category-items" id="category-auth">
        <ul class="sidebar-nav">
          <li class="nav-item">
            <a
              class="nav-link ${activePage == 'staff-login' ? 'active' : ''}"
              href="${pageContext.request.contextPath}/auth/staff_login"
              ><span>Staff Login</span></a
            >
          </li>
          <li class="nav-item">
            <a
              class="nav-link ${activePage == 'customer-login' ? 'active' : ''}"
              href="${pageContext.request.contextPath}/auth/customer_login"
              ><span>Customer Login</span></a
            >
          </li>
          <li class="nav-item">
            <a
              class="nav-link ${activePage == 'customer-register' ? 'active' : ''}"
              href="${pageContext.request.contextPath}/auth/customer_register"
              ><span>Customer Register</span></a
            >
          </li>
            <li class="nav-item" style=${sessionScope.account != null ? 'display:block;' : 'display:none;'}>
                <a class="nav-link ${activePage == 'forgot-password' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/auth/change_password"
                ><span>Change Password</span></a
                >
            </li>
          <li class="nav-item">
            <a
              class="nav-link ${activePage == 'forgot-password' ? 'active' : ''}"
              href="${pageContext.request.contextPath}/auth/forgot_password"
              ><span>Forgot Password</span></a
            >
          </li>
        </ul>
      </div>
    </div>

        <!-- Admin Category -->
        <div class="sidebar-category">
            <div class="category-header" onclick="toggleCategory('admin')">
                <span><i class="fas fa-user-shield category-icon"></i>Admin</span>
                <i class="fas fa-chevron-down toggle-icon"></i>
            </div>
            <div class="category-items" id="category-admin">
                <ul class="sidebar-nav">
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'admin-action-center' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/admin/admin_actioncenter"
                        ><span>Action Center</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'role-list' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/admin/role_list"
                        ><span>Role List</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'create-role' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/admin/role_list/create_role"
                        ><span>Create Role</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'account-list' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/admin/account_list"
                        ><span>Account List</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'create-account' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/admin/create_account"
                        ><span>Create Account</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'assign-feature' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/admin/assign_feature"
                        ><span>Assign Feature</span></a
                        >
                    </li>
                </ul>
            </div>
        </div>

        <%--
        <!-- Staff Category -->--%> <%--
    <div class="sidebar-category">
      --%> <%--
      <div class="category-header" onclick="toggleCategory('staff')">
        --%> <%--
        <span><i class="fas fa-users category-icon"></i>Staff</span>--%> <%--
        <i class="fas fa-chevron-down toggle-icon"></i>--%> <%--
      </div>
      --%> <%--
      <div class="category-items" id="category-staff">
        --%> <%--
        <ul class="sidebar-nav">
          --%> <%--
        </ul>
        --%> <%--
      </div>
      --%> <%--
    </div>
    --%>

        <!-- Customer Category -->
        <div class="sidebar-category">
            <div class="category-header" onclick="toggleCategory('customer')">
                <span><i class="fas fa-user category-icon"></i>Customer</span>
                <i class="fas fa-chevron-down toggle-icon"></i>
            </div>
            <div class="category-items" id="category-customer">
                <ul class="sidebar-nav">
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'customer-action-center' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/customer_actioncenter"
                        ><span>Action Center</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'contract-history' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/contract_history"
                        ><span>Contract History</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'customer-requests' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/requests"
                        ><span>View Requests</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'request-detail' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/requests/detail"
                        ><span>Request Detail</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'create-request' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/requests/create"
                        ><span>Create Request</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'customer-profile' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/profile?id=${account.username}"
                        ><span>View Profile</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'customer-edit-profile' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/profile/edit"
                        ><span>Edit Profile</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'create-feedback' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/feedback/create"
                        ><span>Create Feedback</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'view-feedback' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/feedback/view"
                        ><span>View Feedback</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'myRequest' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/requests"
                        ><i class="bi bi-person-lines-fill"></i> My Request</a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'myFeedback' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer/feedback/list"
                        ><i class="bi bi-person-lines-fill"></i> My Feedback</a
                        >
                    </li>
                </ul>
            </div>
        </div>

        <%--
        <!-- Feedback Category -->--%> <%--
    <div class="sidebar-category">
      --%> <%--
      <div class="category-header" onclick="toggleCategory('feedback')">
        --%> <%--
        <span><i class="fas fa-comment-dots category-icon"></i>Feedback</span
        >--%> <%-- <i class="fas fa-chevron-down toggle-icon"></i>--%> <%--
      </div>
      --%> <%--
      <div class="category-items" id="category-feedback">
        --%> <%--
        <ul class="sidebar-nav">
          --%> <%--
        </ul>
        --%> <%--
      </div>
      --%> <%--
    </div>
    --%>

        <!-- Customer Supporter Category -->
        <div class="sidebar-category">
            <div class="category-header" onclick="toggleCategory('supporter')">
        <span
        ><i class="fas fa-headset category-icon"></i>Customer Supporter</span
        >
                <i class="fas fa-chevron-down toggle-icon"></i>
            </div>
            <div class="category-items" id="category-supporter">
                <ul class="sidebar-nav">
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'staff-profile' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/staff/profile"
                        ><span>View Profile</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'supporter-action-center' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer_supporter/customersupporter_actioncenter"
                        ><span>Action Center</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'customer-list' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer_supporter/customers_list"
                        ><span>Customer List</span></a
                        >
                    </li>


                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'request-dashboard' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer_supporter/requests/dashboard"
                        ><span>Request Dashboard</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'supporter-request-list' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer_supporter/requests/list"
                        ><span>Request List</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'feedback-management' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/customer_supporter/feedback/management"
                        ><span>Feedback Management</span></a
                        >
                    </li>
                </ul>
            </div>
        </div>

        <!-- Technical Leader Category -->
        <div class="sidebar-category">
            <div class="category-header" onclick="toggleCategory('techlead')">
        <span
        ><i class="fas fa-user-gear category-icon"></i>Technical Leader</span
        >
                <i class="fas fa-chevron-down toggle-icon"></i>
            </div>
            <div class="category-items" id="category-techlead">
                <ul class="sidebar-nav">
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'staff-profile' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/staff/profile"
                        ><span>View Profile</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'techlead-action-center' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/technician_leader/techlead_actioncenter"
                        ><span>Action Center</span></a
                        >
                    </li>


                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'viewTechnicanList' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/technician_leader/employees"
                        ><span> View Technician List</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'viewAprovedTask' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/technician_leader/request/viewAprovedTask"
                        ><i class="bi bi-eye"></i> View Request List</a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'taskList' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/technician_leader/tasks/list"
                        >
                            <span> View Task</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Technical Employee Category -->
        <div class="sidebar-category">
            <div class="category-header" onclick="toggleCategory('techem')">
        <span
        ><i class="fas fa-wrench category-icon"></i>Technical Employee</span
        >
                <i class="fas fa-chevron-down toggle-icon"></i>
            </div>

            <div class="category-items" id="category-techem">
                <ul class="sidebar-nav">
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'techemProfile' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/technician_employee/techemployee_actioncenter"
                        ><i class="bi bi-person-circle"></i>Action Center
                        </a>
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'techemProfile' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/staff/profile"
                        ><i class="bi bi-person-circle"></i>My Profile
                        </a>
                    </li>


                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'viewAssignTask' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks"
                        ><i class="bi bi-eye"></i> My Tasks</a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'viewReceivedAssignments' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/technician_employee/task/viewReceivedAssignments"
                        >
                            View
                            <span> Received Assignments</span></a
                        >
                    </li>

                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'viewAssignTask' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks"
                        ><span>View Assigned Tasks</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Warehouse Keeper Category -->
        <div class="sidebar-category">
            <div class="category-header" onclick="toggleCategory('warehouse')">
        <span
        ><i class="fas fa-warehouse category-icon"></i>Warehouse Keeper</span
        >
                <i class="fas fa-chevron-down toggle-icon"></i>
            </div>
            <div class="category-items" id="category-warehouse">
                <ul class="sidebar-nav">
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'warehouse-dashboard' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/warehousekeeper_dashboard"
                        ><span>Action Center</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'product-warehouse' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse"
                        ><span>Product Warehouse</span></a
                        >
                    </li>


                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'view-inventory' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/view_inventory"
                        ><span>View Inventory</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'add-product' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/add_product"
                        ><span>Add Product</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'add-product' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/import_product"
                        ><span>Import Product</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'create-transfer-request' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request"
                        ><span>Create Transfer Request</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'warehouse-detail' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_detail"
                        ><span>Warehouse Detail</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'product-requests' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests"
                        ><span>Product Requests</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'warehouse-request' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_request"
                        ><span>Warehouse Request</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'export-internal' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/export_internal"
                        ><span>Export Internal</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'imported-products' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/view_imported_product"
                        ><span>Imported Products</span></a
                        >
                    </li>
                    <li class="nav-item">
                        <a
                                class="nav-link ${activePage == 'imported-products' ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/warehouse_keeper/view_exported_product"
                        ><span>Exported Products</span></a
                        >
                    </li>
                </ul>
            </div>
        </div>

        <!-- Inventory Manager Category -->
        <div class="sidebar-category">
            <div class="category-header" onclick="toggleCategory('inventory')">
                <span><i class="fas fa-chart-line category-icon"></i>Inventory Manager</span>
                <i class="fas fa-chevron-down toggle-icon"></i>
            </div>
            <div class="category-items" id="category-inventory">
                <ul class="sidebar-nav">
                    <li class="nav-item"
                        style=${PermissionService.hasAccess(sessionScope.account.role, URLConstants.INVENTORY_DASHBOARD) ? '"display: block"' : '"display:none"'}>
                        <a class="nav-link ${activePage == 'inventory-dashboard' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/inventory_manager/inventorymanager_dashboard"><span>Dashboard</span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'transfer-requests' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/inventory_manager/view_transfer_requests"><span>Transfer Requests</span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'product-requests' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/inventory_manager/view_product_requests"><span>Product Requests</span></a>
                    </li>
                </ul>
            </div>
        </div>

        <%--
        <!-- Task Management Category -->--%> <%--
    <div class="sidebar-category">
      --%> <%--
      <div class="category-header" onclick="toggleCategory('task')">
        --%> <%--
        <span><i class="fas fa-tasks category-icon"></i>Task Management</span
        >--%> <%-- <i class="fas fa-chevron-down toggle-icon"></i>--%> <%--
      </div>
      --%> <%--
      <div class="category-items" id="category-task">
        --%> <%--
        <ul class="sidebar-nav">
          --%> <%-- --%> <%--
        </ul>
        --%> <%--
      </div>
      --%> <%--
    </div>
    --%>

        <!-- Footer with Logout -->
        <div class="sidebar-footer"></div>
    </div>
</div>

<script>
    function toggleCategory(categoryId) {
        const categoryItems = document.getElementById("category-" + categoryId);
        const categoryHeader = categoryItems.previousElementSibling;

        // Toggle the 'show' class
        categoryItems.classList.toggle("show");

        // Toggle the 'collapsed' class on header for icon rotation
        categoryHeader.classList.toggle("collapsed");
    }

    // Auto-expand category if it contains the active page
    document.addEventListener("DOMContentLoaded", function () {
        const activeLink = document.querySelector(".nav-link.active");
        if (activeLink) {
            const categoryItems = activeLink.closest(".category-items");
            if (categoryItems) {
                categoryItems.classList.add("show");
                const categoryHeader = categoryItems.previousElementSibling;
                categoryHeader.classList.remove("collapsed");
            }
        }
    });
</script>