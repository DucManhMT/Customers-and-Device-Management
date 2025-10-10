<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Task Details - Computer Warranty Service</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background: #f5f5f5;
        color: #333;
        line-height: 1.6;
        min-height: 100vh;
        display: flex;
      }

      /* Sidebar Styles */
      .sidebar {
        width: 280px;
        background: white;
        box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        z-index: 1000;
      }

      .sidebar-header {
        padding: 20px;
        background: #007bff;
        color: white;
        text-align: center;
      }

      .sidebar-header h3 {
        font-size: 18px;
        font-weight: 600;
        margin: 0;
      }

      .sidebar-header i {
        margin-right: 10px;
        font-size: 22px;
      }

      .sidebar-menu {
        list-style: none;
        padding: 20px 0;
        margin: 0;
      }

      .sidebar-menu li {
        margin: 5px 0;
      }

      .sidebar-menu li a {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: #666;
        text-decoration: none;
      }

      .sidebar-menu li a:hover {
        background: #f8f9fa;
        color: #007bff;
      }

      .sidebar-menu li.active a {
        background: #e3f2fd;
        color: #007bff;
        font-weight: 600;
      }

      .sidebar-menu li a i {
        width: 20px;
        margin-right: 12px;
        font-size: 16px;
        text-align: center;
      }

      .sidebar-menu li.logout {
        position: absolute;
        bottom: 20px;
        width: calc(100% - 20px);
        margin: 0 10px;
      }

      .sidebar-menu li.logout a {
        color: white;
        background: linear-gradient(135deg, #dc3545, #c82333);
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        border: 2px solid transparent;
      }

      .sidebar-menu li.logout a:hover {
        background: linear-gradient(135deg, #c82333, #bd2130);
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(220, 53, 69, 0.4);
        border-color: rgba(255, 255, 255, 0.2);
      }

      .sidebar-menu li.logout a:active {
        transform: translateY(0);
        box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
      }

      .sidebar-menu li.logout a i {
        color: white;
        margin-right: 8px;
      }

      /* Main Content */
      .main-content {
        flex: 1;
        margin-left: 280px;
      }

      /* Mobile Menu Button */
      .mobile-menu-btn {
        display: none;
        position: fixed;
        top: 15px;
        left: 15px;
        z-index: 1001;
        background: white;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 8px;
        color: #007bff;
        font-size: 16px;
        cursor: pointer;
      }

      .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
      }

      .header {
        text-align: center;
        margin-bottom: 30px;
        color: #333;
      }

      .header h1 {
        font-size: 32px;
        font-weight: 600;
        margin-bottom: 8px;
      }

      .header p {
        font-size: 16px;
        color: #666;
      }

      .back-button {
        margin-bottom: 20px;
      }

      .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
      }

      .btn-secondary {
        background: #6c757d;
        color: white;
      }

      .btn-secondary:hover {
        background: #545b62;
      }

      .btn-primary {
        background: #007bff;
        color: white;
      }

      .btn-primary:hover {
        background: #0056b3;
      }

      .btn-success {
        background: #28a745;
        color: white;
      }

      .btn-success:hover {
        background: #218838;
      }

      .btn-warning {
        background: #ffc107;
        color: #212529;
      }

      .btn-warning:hover {
        background: #e0a800;
      }

      .card {
        background: white;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
      }

      .card:hover {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      }

      .card-header {
        padding: 20px;
        border-bottom: 1px solid #eee;
        background: #f8f9fa;
        border-radius: 8px 8px 0 0;
      }

      .card-body {
        padding: 20px;
      }

      .task-title {
        font-size: 24px;
        font-weight: 600;
        color: #333;
        margin-bottom: 10px;
      }

      .task-status {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 15px;
      }

      .badge {
        padding: 8px 16px;
        border-radius: 15px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        white-space: nowrap;
      }

      .badge-pending {
        background: #fff3cd;
        color: #856404;
      }

      .badge-progress {
        background: #cce5ff;
        color: #004085;
      }

      .badge-review {
        background: #e6ccff;
        color: #5a1a7b;
      }

      .badge-completed {
        background: #d4edda;
        color: #155724;
      }

      .badge-high {
        background: #f8d7da;
        color: #721c24;
      }

      .badge-medium {
        background: #fff3cd;
        color: #856404;
      }

      .badge-low {
        background: #e2e3ff;
        color: #383d41;
      }

      .detail-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
      }

      .detail-item {
        display: flex;
        flex-direction: column;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 6px;
        border-left: 4px solid #007bff;
      }

      .detail-label {
        font-weight: 600;
        color: #666;
        font-size: 12px;
        text-transform: uppercase;
        margin-bottom: 5px;
      }

      .detail-value {
        font-size: 16px;
        color: #333;
        font-weight: 500;
      }

      .description-card {
        margin-bottom: 30px;
      }

      .description-card h3 {
        font-size: 18px;
        font-weight: 600;
        color: #333;
        margin-bottom: 15px;
      }

      .description-text {
        color: #666;
        line-height: 1.6;
        font-size: 15px;
      }

      .action-buttons {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
        margin-top: 20px;
      }

      .progress-section {
        margin-bottom: 30px;
      }

      .progress-bar-container {
        background: #f0f0f0;
        border-radius: 10px;
        height: 20px;
        overflow: hidden;
        margin-bottom: 10px;
      }

      .progress-bar {
        height: 100%;
        background: linear-gradient(90deg, #007bff, #0056b3);
        transition: width 0.3s ease;
        border-radius: 10px;
      }

      .progress-text {
        font-size: 14px;
        color: #666;
        text-align: center;
      }

      .form-control {
        padding: 10px 12px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 14px;
        background: white;
        width: 100%;
      }

      .form-control:focus {
        outline: none;
        border-color: #007bff;
      }

      .form-group {
        margin-bottom: 15px;
      }

      .form-group label {
        font-weight: 600;
        margin-bottom: 5px;
        color: #333;
        display: block;
      }

      @media (max-width: 768px) {
        .mobile-menu-btn {
          display: block;
        }

        .sidebar {
          transform: translateX(-100%);
          width: 260px;
        }

        .sidebar.active {
          transform: translateX(0);
        }

        .main-content {
          margin-left: 0;
        }

        .container {
          padding: 15px;
        }

        .header h1 {
          font-size: 24px;
        }

        .detail-grid {
          grid-template-columns: 1fr;
        }

        .action-buttons {
          flex-direction: column;
        }

        .btn {
          text-align: center;
          justify-content: center;
        }
      }
    </style>
  </head>
  <body>
    <!-- Mobile Menu Button -->
    <button class="mobile-menu-btn" onclick="toggleSidebar()">
      <i class="fas fa-bars"></i>
    </button>

    <!-- Sidebar Navigation -->
    <nav class="sidebar">
      <div class="sidebar-header">
        <h3><i class="fas fa-tools"></i> Tech Dashboard</h3>
      </div>
      <ul class="sidebar-menu">
        <li>
          <a
            href="${pageContext.request.contextPath}/techemployee/dashboard.jsp"
          >
            <i class="fas fa-home"></i>
            <span>Dashboard</span>
          </a>
        </li>
        <li>
          <a
            href="${pageContext.request.contextPath}/techemployee/assignedTasks.jsp"
          >
            <i class="fas fa-list-check"></i>
            <span>Assigned Tasks List</span>
          </a>
        </li>
        <li class="active">
          <a
            href="${pageContext.request.contextPath}/techemployee/taskDetail.jsp"
          >
            <i class="fas fa-clipboard-list"></i>
            <span>Task Details & Status</span>
          </a>
        </li>
        <li>
          <a
            href="${pageContext.request.contextPath}/techemployee/equipment-request.jsp"
          >
            <i class="fas fa-box"></i>
            <span>Equipment Request</span>
          </a>
        </li>
        <li class="logout">
          <a href="#" onclick="logout()">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
          </a>
        </li>
      </ul>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
      <div class="container">
        <!-- Header -->
        <div class="header">
          <h1>Task Details</h1>
        </div>

        <!-- Task Header Card -->
        <div class="card card-header">
          <!-- Back Button -->
          <div class="back-button">
            <a
              href="${pageContext.request.contextPath}/techemployee/assignedTasks.jsp"
              class="btn btn-secondary"
            >
              <i class="fas fa-arrow-left"></i> Back to Tasks List
            </a>
          </div>

          <div class="card-header">
            <div class="task-title">Laptop Screen Replacement</div>
            <div class="task-status">
              <span class="badge badge-progress">In Progress</span>
            </div>
          </div>
        </div>

        <!-- Task Details Grid -->
        <div class="detail-grid">
          <div class="detail-item">
            <div class="detail-label">Customer Name</div>
            <div class="detail-value">Nguyen Van Duc</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Phone Number</div>
            <div class="detail-value">0938-123-456</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Task ID</div>
            <div class="detail-value">#TASK-001</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Created Date</div>
            <div class="detail-value">Feb 10, 2024</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Deadline</div>
            <div class="detail-value">Feb 15, 2024 (5 days left)</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Assigned Tech</div>
            <div class="detail-value">John Smith</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Device Model</div>
            <div class="detail-value">Dell Inspiron 15 3000</div>
          </div>
        </div>

        <!-- Description -->
        <div class="card description-card">
          <div class="card-body">
            <h3>Task Description</h3>
            <div class="description-text">
              Dell Inspiron 15 laptop screen replacement due to physical damage.
              Customer dropped the laptop causing cracks across the display. The
              LCD panel needs to be completely replaced with a compatible 15.6"
              Full HD display. Customer requires urgent repair for work
              purposes. Screen has been ordered and is expected to arrive
              tomorrow. Installation should take approximately 2-3 hours
              including testing.
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="card">
          <div class="card-body">
            <h3>Task Actions</h3>
            <div class="action-buttons">
              <button class="btn btn-success" onclick="markAsFinished()">
                <i class="fas fa-check"></i> Mark as Completed
              </button>
              <button class="btn btn-primary" onclick="contactCustomer()">
                <i class="fas fa-phone"></i> Contact Customer
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      // Simple logout function
      function logout() {
        if (confirm("Are you sure you want to logout?")) {
          window.location.href = "${pageContext.request.contextPath}/login.jsp";
        }
      }

      // Mobile sidebar toggle
      function toggleSidebar() {
        document.querySelector(".sidebar").classList.toggle("active");
      }

      // Mark task as finished
      function markAsFinished() {
        if (confirm("Are you sure you want to mark this task as completed?")) {
          // Update status badge
          var statusBadge = document.querySelector(".badge-progress");
          statusBadge.className = "badge badge-completed";
          statusBadge.textContent = "Completed";

          // Update progress bar
          var progressBar = document.querySelector(".progress-bar");
          progressBar.style.width = "100%";
          document.querySelector(".progress-text").textContent =
            "100% Complete - Task finished successfully";

          alert("Task marked as completed successfully!");
        }
      }
    </script>
  </body>
</html>
