<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 11/3/2025
  Time: 12:42 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    .sidebar {
        width: 260px;
        background: rgba(255, 255, 255, 0.25); /* semi-transparent white background */
        backdrop-filter: blur(12px); /* glass blur effect */
        -webkit-backdrop-filter: blur(12px);
        border-right: 1px solid rgba(0, 0, 0, 0.15); /* subtle border to separate */
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.2); /* soft shadow */
        color: #1a1a1a; /* darker text */
        position: fixed;
        height: calc(100vh - 70px);
        top: 70px;
        left: 0;
        z-index: 1020;
        overflow-y: auto;
        overflow-x: hidden;
        transition: all 0.3s ease;
    }

    .sidebar-inner {
        height: 100%;
        display: flex;
        flex-direction: column;
        padding-top: 20px;
    }

    .sidebar-nav {
        margin-top: 20px;
    }

    .sidebar-nav .nav-link {
        color: #2b2b2b; /* darker neutral text */
        padding: 10px;
        margin-left: 20px;
        margin-bottom: 5px;
        border-radius: 30px;
        display: flex;
        align-items: center;
        font-weight: 500;
        width: 75%;
        transition: all 180ms ease;
        text-decoration: none;
        background-color: transparent;
    }

    .sidebar-nav .nav-link i {
        width: 24px;
        margin-right: 15px;
        text-align: center;
        color: #3a3a3a;
    }

    .sidebar-nav .nav-link:hover {
        background-color: rgba(0, 0, 0, 0.1);
        color: #000;
    }

    .sidebar-nav .nav-link.active {
        background-color: rgba(249, 201, 65, 0.9);
        color: #1A3A4A;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }

    .sidebar-nav .nav-link.active i {
        color: #1A3A4A;
    }

    body {
        margin-left: 260px;
        padding-top: 70px;
        background-color: #f5f6f7;
    }
</style>

<div id="sidebar" class="sidebar">
    <div class="sidebar-inner">
        <ul class="nav flex-column sidebar-nav">
            <li class="nav-item">
                <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/warehouse_keeper/warehousekeeper_actioncenter"><i class="fas fa-tachometer-alt"></i><span> Dashboard</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'warehouses' ? 'active' : ''}" href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse"><i class="fas fa-warehouse"></i><span> Warehouses</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'orders' ? 'active' : ''}" href="#"><i class="fas fa-box-open"></i><span> Orders</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'shipments' ? 'active' : ''}" href="#"><i class="fas fa-truck"></i><span> Shipments</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'inventory' ? 'active' : ''}" href="${pageContext.request.contextPath}/warehouse_keeper/view_inventory"><i class="fas fa-boxes-stacked"></i><span> Inventory</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'finance' ? 'active' : ''}" href="#"><i class="fas fa-file-invoice-dollar"></i><span> Finance</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'customers' ? 'active' : ''}" href="#"><i class="fas fa-users"></i><span> Customers</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'tracking' ? 'active' : ''}" href="#"><i class="fas fa-map-marker-alt"></i><span> Tracking</span></a>
            </li>
        </ul>
    </div>
</div>
