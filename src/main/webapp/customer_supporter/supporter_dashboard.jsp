<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Customer Supporter Dashboard</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      :root {
        --primary: #4f46e5;
        --primary-dark: #4338ca;
        --primary-light: #818cf8;
        --success: #10b981;
        --warning: #f59e0b;
        --danger: #ef4444;
        --info: #3b82f6;
        --gray-50: #f9fafb;
        --gray-100: #f3f4f6;
        --gray-200: #e5e7eb;
        --gray-300: #d1d5db;
        --gray-400: #9ca3af;
        --gray-500: #6b7280;
        --gray-600: #4b5563;
        --gray-700: #374151;
        --gray-900: #111827;
        --shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
      }
      * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
      }
      body {
        font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI",
          sans-serif;
        background: var(--gray-50);
        color: var(--gray-900);
        line-height: 1.6;
      }
      .container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 2rem 1rem;
      }
      .page-header {
        background: #fff;
        padding: 2rem;
        border-radius: 12px;
        box-shadow: var(--shadow);
        margin-bottom: 1.5rem;
      }
      .header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 1rem;
        flex-wrap: wrap;
      }
      .header-left {
        display: flex;
        align-items: center;
        gap: 1rem;
      }
      .header-icon {
        width: 56px;
        height: 56px;
        border-radius: 12px;
        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-light)
        );
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
      }
      .header-text h1 {
        font-weight: 700;
        font-size: 1.75rem;
      }
      .header-text p {
        color: var(--gray-600);
      }
      .quick-actions {
        display: flex;
        gap: 0.75rem;
        flex-wrap: wrap;
      }
      .btn {
        padding: 0.625rem 1.25rem;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        display: inline-flex;
        gap: 0.5rem;
        align-items: center;
        font-weight: 600;
        font-size: 0.875rem;
        text-decoration: none;
        transition: all 0.2s;
      }
      .btn-primary {
        background: var(--primary);
        color: #fff;
      }
      .btn-primary:hover {
        background: var(--primary-dark);
      }
      .btn-success {
        background: var(--success);
        color: #fff;
      }
      .btn-success:hover {
        background: #059669;
      }
      .btn-outline {
        background: #fff;
        color: var(--primary);
        border: 1px solid var(--primary);
      }
      .btn-outline:hover {
        background: var(--primary);
        color: #fff;
      }
      .grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
        gap: 1rem;
      }
      .card {
        background: #fff;
        border-radius: 12px;
        box-shadow: var(--shadow);
        padding: 1.25rem;
      }
      .card-title {
        font-weight: 700;
        font-size: 1.125rem;
        display: flex;
        gap: 0.5rem;
        align-items: center;
        margin-bottom: 1rem;
      }
      .stat {
        background: var(--gray-50);
        border: 1px solid var(--gray-200);
        border-radius: 10px;
        padding: 1rem;
        display: flex;
        gap: 0.75rem;
        align-items: center;
      }
      .stat .icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
      }
      .icon-pending {
        background: linear-gradient(135deg, #6b7280, #374151);
      }
      .icon-approved {
        background: linear-gradient(135deg, var(--success), #059669);
      }
      .icon-processing {
        background: linear-gradient(135deg, var(--info), #2563eb);
      }
      .icon-rejected {
        background: linear-gradient(135deg, var(--danger), #dc2626);
      }
      .icon-finished {
        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-light)
        );
      }
      .icon-tech-finish {
        background: linear-gradient(135deg, #8b5cf6, #7c3aed);
      }
      .stat-content {
        display: flex;
        flex-direction: column;
      }
      .stat-number {
        font-weight: 700;
        font-size: 1.4rem;
      }
      .stat-label {
        font-size: 0.8125rem;
        color: var(--gray-600);
        font-weight: 600;
      }
      @media (max-width: 768px) {
        .container {
          padding: 1rem 0.75rem;
        }
        .grid {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </head>
  <body>
    <jsp:include page="../components/header.jsp" />
    <jsp:include page="../components/sidebar.jsp" />

    <div class="container">
      <div class="page-header">
        <div class="header-content">
          <div class="header-left">
            <div class="header-icon"><i class="fas fa-headset"></i></div>
            <div class="header-text">
              <h1>Customer Supporter Dashboard</h1>
              <p>Overview of service requests by status and quick actions</p>
            </div>
          </div>
          <div class="quick-actions">
            <a
              href="${pageContext.request.contextPath}/customer_supporter/customers_list"
              class="btn btn-outline"
              ><i class="fas fa-file-signature"></i> Customer List</a
            >

            <a
              href="${pageContext.request.contextPath}/customer_supporter/requests/dashboard"
              class="btn btn-success"
              ><i class="fas fa-gauge-high"></i> Request Dashboard</a
            >
            <a
              href="${pageContext.request.contextPath}/customer_supporter/requests/list"
              class="btn btn-primary"
              ><i class="fas fa-list"></i> Request List</a
            >
            <a
              href="${pageContext.request.contextPath}/customer_supporter/feedback/management"
              class="btn btn-outline"
              ><i class="fas fa-comments"></i> Feedback Management</a
            >
          </div>
        </div>
      </div>

      <div class="grid">
        <div class="card">
          <div class="card-title">
            <i class="fas fa-clipboard-list"></i> Requests by Status
          </div>
          <div class="grid">
            <!-- Render known statuses with icons -->
            <div class="stat">
              <div class="icon icon-pending">
                <i class="fas fa-hourglass-half"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">${requestStats.Pending}</div>
                <div class="stat-label">Pending</div>
              </div>
            </div>
            <div class="stat">
              <div class="icon icon-approved">
                <i class="fas fa-circle-check"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">${requestStats.Approved}</div>
                <div class="stat-label">Approved</div>
              </div>
            </div>
            <div class="stat">
              <div class="icon icon-processing">
                <i class="fas fa-spinner"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">${requestStats.Processing}</div>
                <div class="stat-label">Processing</div>
              </div>
            </div>
            <div class="stat">
              <div class="icon icon-tech-finish">
                <i class="fas fa-wrench"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">${requestStats.Tech_Finished}</div>
                <div class="stat-label">Tech Finished</div>
              </div>
            </div>
            <div class="stat">
              <div class="icon icon-rejected"><i class="fas fa-ban"></i></div>
              <div class="stat-content">
                <div class="stat-number">${requestStats.Rejected}</div>
                <div class="stat-label">Rejected</div>
              </div>
            </div>
            <div class="stat">
              <div class="icon icon-finished">
                <i class="fas fa-flag-checkered"></i>
              </div>
              <div class="stat-content">
                <div class="stat-number">${requestStats.Finished}</div>
                <div class="stat-label">Finished</div>
              </div>
            </div>
          </div>
          <div
            style="margin-top: 1rem; color: var(--gray-600); font-weight: 600"
          >
            Total: <span style="color: var(--gray-900)">${totalRequests}</span>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
