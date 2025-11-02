<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 11/3/2025
  Time: 12:42 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .sidebar {
        width: 260px;
        background-color: var(--sidebar-bg);
        color: white;
        position: fixed;
        height: 100%;
        z-index: 1030;
        /* NO PADDING HERE */
    }

    .sidebar-inner {
        height: 100%;
        display: flex;
        flex-direction: column;
    }

    .sidebar .logo {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        padding: 22px;
        border-bottom: 2px solid rgba(255, 255, 255, 0.15);
    }

    .sidebar .logo i {
        font-size: 2rem;
        color: var(--sidebar-active-bg);
    }

    .sidebar .logo span {
        font-size: 1.5rem;
        font-weight: bold;
        margin-left: 10px;
    }

    .sidebar-nav {
        margin-top: 20px;
    }

    .sidebar-nav .nav-link {
        color: var(--sidebar-link-color);
        padding: 10px 15px;
        margin-bottom: 5px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        font-weight: 500;
    }

    .sidebar-nav .nav-link i {
        width: 24px;
        margin-right: 15px;
        text-align: center;
    }

    .sidebar-nav .nav-link:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: var(--sidebar-active-link-color);
    }

    .sidebar-nav .nav-link.active {
        background-color: var(--sidebar-active-bg);
        color: var(--sidebar-bg);
    }

    .sidebar-nav .nav-link.active i {
        color: var(--sidebar-bg);
    }
</style>
<div class="sidebar">
    <div class="sidebar-inner">
        <div class="logo">
            <i class="fas fa-cubes"></i>
            <span>Warehouse</span>
        </div>
        <ul class="nav flex-column sidebar-nav">
            <li class="nav-item">
                <a class="nav-link" href="#"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse"><i class="fas fa-warehouse"></i> Warehouses</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#"><i class="fas fa-box-open"></i> Orders</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#"><i class="fas fa-truck"></i> Shipments</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="#"><i class="fas fa-inventory"></i> Inventory</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#"><i class="fas fa-file-invoice-dollar"></i> Finance</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#"><i class="fas fa-users"></i> Customers</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#"><i class="fas fa-map-marker-alt"></i> Tracking</a>
            </li>
        </ul>
    </div>
</div>