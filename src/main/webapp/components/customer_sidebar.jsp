<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 11/5/2025
  Time: 9:28 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">

<!-- Material Icons + Font Awesome -->
<link rel="stylesheet"
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL,GRAD@24,400,0,0"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
    body {
        margin-left: 260px;
        padding-top: 70px;
        background-color: #f5f6f7;
        font-family: 'Inter', sans-serif;
    }

    .sidebar {
        width: 260px;
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

    .sidebar-inner {
        height: 100%;
        display: flex;
        flex-direction: column;
        padding-top: 20px;
    }

    .sidebar-nav {
        margin-top: 20px;
        list-style: none;
        padding: 0;
    }

    .sidebar-nav .nav-item {
        width: 100%;
    }

    .sidebar-nav .nav-link {
        color: #2b2b2b;
        padding: 10px 20px;
        margin-bottom: 8px;
        border-radius: 30px;
        display: flex;
        align-items: center;
        font-weight: 500;
        width: calc(100% - 20px);
        transition: all 180ms ease;
        text-decoration: none;
        background-color: transparent;
    }

    .sidebar-nav .nav-link i,
    .sidebar-nav .nav-link svg,
    .sidebar-nav .nav-link .material-symbols-outlined {
        flex-shrink: 0;
        width: 24px;
        height: 24px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        margin-right: 12px;
        color: #3a3a3a;
        vertical-align: middle;
    }

    .sidebar-nav .nav-link span {
        flex: 1;
        display: inline-block;
        line-height: 1.4;
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

    .sidebar-nav .nav-link.active i,
    .sidebar-nav .nav-link.active svg,
    .sidebar-nav .nav-link.active .material-symbols-outlined {
        color: #1A3A4A;
    }
</style>

<div id="sidebar" class="sidebar">
    <div class="sidebar-inner">
        <ul class="nav flex-column sidebar-nav">
            <li class="nav-item">
                <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/customer/customer_actioncenter">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link ${activePage == 'warehouses' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/customer/requests/create">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                         class="bi bi-building-fill-add" viewBox="0 0 16 16">
                        <path d="M12.5 16a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7m.5-5v1h1a.5.5 0 0 1 0 1h-1v1a.5.5 0 0 1-1 0v-1h-1a.5.5 0 0 1 0-1h1v-1a.5.5 0 0 1 1 0"/>
                        <path d="M2 1a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v7.256A4.5 4.5 0 0 0 12.5 8a4.5 4.5 0 0 0-3.59 1.787A.5.5 0 0 0 9 9.5v-1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .39-.187A4.5 4.5 0 0 0 8.027 12H6.5a.5.5 0 0 0-.5.5V16H3a1 1 0 0 1-1-1zm2 1.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5m3 0v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5m3.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zM4 5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5M7.5 5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm2.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5M4.5 8a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5z"/>
                    </svg>
                    <span>Create Request</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link ${activePage == 'orders' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/customer/requests">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                         class="bi bi-card-list" viewBox="0 0 16 16">
                        <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2z"/>
                        <path d="M5 8a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7A.5.5 0 0 1 5 8m0-2.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m0 5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m-1-5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0M4 8a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0m0 2.5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0"/>
                    </svg>
                    <span>Request History</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link ${activePage == 'shipments' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/customer/contract_history">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                         class="bi bi-file-earmark-fill" viewBox="0 0 16 16">
                        <path d="M4 0h5.293A1 1 0 0 1 10 .293L13.707 4a1 1 0 0 1 .293.707V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2m5.5 1.5v2a1 1 0 0 0 1 1h2z"/>
                    </svg>
                    <span>Contracts</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link ${activePage == 'inventory' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/customer/profile?id=${account.username}"
                >
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                         class="bi bi-person-circle" viewBox="0 0 16 16">
                        <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0"/>
                        <path fill-rule="evenodd"
                              d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8m8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1"/>
                    </svg>
                    <span>Profile</span>
                </a>
            </li>
        </ul>
    </div>
</div>
