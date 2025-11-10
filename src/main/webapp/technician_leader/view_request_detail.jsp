<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Request Detail</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/task/taskDetail.css"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <style>
      .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
      }
      .header h1 {
        margin: 0;
        font-size: 28px;
      }
      .subtitle {
        color: #666;
        margin-top: 4px;
      }
      .grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
        gap: 18px;
        margin-top: 20px;
      }
      .card {
        background: #fff;
        border: 1px solid #e3e3e3;
        border-radius: 10px;
        padding: 18px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.07);
      }
      .card h3 {
        margin-top: 0;
        font-size: 18px;
        display: flex;
        align-items: center;
        gap: 8px;
      }
      .item {
        display: flex;
        justify-content: space-between;
        padding: 6px 0;
        border-bottom: 1px dashed #eee;
      }
      .item:last-child {
        border-bottom: none;
      }
      .label {
        font-weight: 600;
        color: #444;
      }
      .value {
        color: #222;
        text-align: right;
      }
      .muted {
        color: #999;
        font-style: italic;
      }
      .actions {
        margin-top: 20px;
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
      }
      .btn {
        padding: 10px 18px;
        border-radius: 6px;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        text-decoration: none;
        border: none;
      }
      .btn-success {
        background: #28a745;
        color: #fff;
      }
      .btn-secondary {
        background: #6c757d;
        color: #fff;
      }
      .btn-danger {
        background: #dc3545;
        color: #fff;
      }
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }
      th,
      td {
        border: 1px solid #e3e3e3;
        padding: 10px;
        vertical-align: middle;
        text-align: left;
      }
      th {
        background: #f8f9fa;
      }
      .badge {
        display: inline-block;
        padding: 4px 10px;
        font-size: 12px;
        border-radius: 14px;
        font-weight: 600;
      }
      .status-Pending {
        background: #fff3cd;
        color: #856404;
      }
      .status-Processing {
        background: #cce5ff;
        color: #004085;
      }
      .status-Finished {
        background: #d4edda;
        color: #155724;
      }
      .status-Reject,
      .status-Rejected {
        background: #f8d7da;
        color: #721c24;
      }
    </style>
  </head>
  <body>
    <div class="container">
        <jsp:include page="../components/header.jsp" />
        <jsp:include page="../components/sidebar.jsp"/>

        <div class="header">
        <h1><i class="fas fa-clipboard-list"></i> Request Detail</h1>
        <p class="subtitle">Full information and related tasks</p>
      </div>

      <!-- Alert Container -->
      <div id="alert-container"></div>

      <c:if test="${not empty requestObj}">
        <div class="grid">
          <!-- Request Info -->
          <div class="card">
            <h3><i class="fas fa-info-circle"></i> Request Information</h3>
            <div class="item">
              <span class="label">Request ID:</span>
              <span class="value">#${requestObj.requestID}</span>
            </div>
            <div class="item">
              <span class="label">Status:</span>
              <span class="value">
                <c:choose>
                  <c:when test="${not empty requestObj.requestStatus}">
                    <span class="badge status-${requestObj.requestStatus}"
                      >${requestObj.requestStatus}</span
                    >
                  </c:when>
                  <c:otherwise><span class="muted">Unknown</span></c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="item">
              <span class="label">Start Date:</span>
              <span class="value">
                <c:choose>
                  <c:when test="${not empty requestObj.startDate}"
                    >${requestObj.startDate}</c:when
                  >
                  <c:otherwise><span class="muted">Not set</span></c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="item">
              <span class="label">Finished Date:</span>
              <span class="value">
                <c:choose>
                  <c:when test="${not empty requestObj.finishedDate}"
                    >${requestObj.finishedDate}</c:when
                  >
                  <c:otherwise
                    ><span class="muted">Not finished</span></c:otherwise
                  >
                </c:choose>
              </span>
            </div>
          </div>

          <!-- Customer & Contract -->
          <div class="card">
            <h3><i class="fas fa-user"></i> Customer & Contract</h3>
            <div class="item">
              <span class="label">Customer Name:</span>
              <span class="value">${customer.customerName}</span>
            </div>
            <div class="item">
              <span class="label">Contract ID:</span>
              <span class="value">#${contract.contractID}</span>
            </div>
          </div>
        </div>

        <!-- Related Tasks -->
        <div class="card mt-4">
          <h3><i class="fas fa-tasks"></i> Related Tasks</h3>
          <c:choose>
            <c:when test="${empty tasks}">
              <div class="muted">No tasks found for this request.</div>
            </c:when>
            <c:otherwise>
              <table>
                <thead>
                  <tr>
                    <th>Task ID</th>
                    <th>Assign To</th>
                    <th>Status</th>
                    <th>Deadline</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="t" items="${tasks}">
                    <tr id="task-row-${t.taskID}">
                      <td>#${t.taskID}</td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty t.assignTo.staffName}"
                            >${t.assignTo.staffName}</c:when
                          >
                          <c:otherwise
                            ><span class="muted">N/A</span></c:otherwise
                          >
                        </c:choose>
                      </td>
                      <td>
                        <span class="badge status-${t.status}"
                          >${t.status}</span
                        >
                      </td>
                      <td>${t.deadline}</td>
                      <td>
                        <div class="task-actions">
                          <a
                            class="btn btn-secondary"
                            href="${pageContext.request.contextPath}/staff/task/detail?taskId=${t.taskID}"
                          >
                            <i class="fas fa-eye"></i> View
                          </a>
                          <c:if
                            test='${t.status == "Pending" || t.status == "Processing"}'
                          >
                            <button
                              class="btn btn-danger delete-btn"
                              data-task-id="${t.taskID}"
                            >
                              <i class="fas fa-trash"></i> Delete
                            </button>
                          </c:if>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </div>

        <!-- Back button -->
        <div class="actions mt-3">
          <a
            href="${pageContext.request.contextPath}/technician_leader/request/viewAprovedTask"
            class="btn btn-secondary"
          >
            <i class="fas fa-arrow-left"></i> Back to Request List
          </a>
        </div>
      </c:if>

      <!-- Error Modal -->
      <div class="modal fade" id="errorModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header bg-danger text-white">
              <h5 class="modal-title">Error</h5>
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="modal"
                aria-label="Close"
              ></button>
            </div>
            <div class="modal-body" id="modalBody"></div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        const deleteButtons = document.querySelectorAll(".delete-btn");
        const modalEl = document.getElementById("errorModal");
        const modalBody = document.getElementById("modalBody");
        const errorModal = new bootstrap.Modal(modalEl);

        deleteButtons.forEach((btn) => {
          btn.addEventListener("click", async function () {
            if (!confirm("Are you sure you want to delete this task?")) return;
            const taskId = this.dataset.taskId;
            const requestId = "${requestObj.requestID}";

            try {
              const response = await fetch(
                "${pageContext.request.contextPath}/api/technician_leader/tasks/delete",
                {
                  method: "POST",
                  headers: { "Content-Type": "application/json" },
                  body: JSON.stringify({ taskId, requestId }),
                }
              );
              const data = await response.json();

              if (response.ok && data.success) {
                window.location.reload();
              } else {
                modalBody.textContent =
                  data.message || data.error || "Delete failed.";
                errorModal.show();
              }
            } catch (err) {
              modalBody.textContent = "Server not responding.";
              errorModal.show();
            }
          });
        });
      });
    </script>
  </body>
</html>
