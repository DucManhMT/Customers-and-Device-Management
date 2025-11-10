<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Task List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
        }

        .page-header h2 {
            font-weight: 600;
            color: #343a40;
        }

        .card-custom {
            border-radius: 0.75rem;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        }

        .filter-card {
            border: 1px solid #e3e6f0;
            background-color: #ffffff;
        }

        .btn {
            border-radius: 0.5rem;
        }

        .table > :not(caption) > * > * {
            vertical-align: middle;
        }

        .table tbody tr.table-warning td,
        .table tbody tr.table-danger td {
            font-weight: 500;
        }

        .form-control, .form-select {
            border-radius: 0.5rem;
        }

        .badge {
            font-size: 0.85rem;
            padding: 0.4em 0.6em;
        }

        .alert {
            border-radius: 0.5rem;
        }

        .dashboard-card {
            border-left: 5px solid;
            border-radius: 0.75rem;
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container-fluid mt-3">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <div>
            <h2><i class="fa-solid fa-list-check me-2 text-primary"></i>Task List</h2>
        </div>
    </div>

    <!-- ALERT -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <!-- FILTER CARD -->
    <div class="card card-custom filter-card mb-4">
        <div class="card-header bg-transparent border-0 pb-0">
            <h5 class="card-title mb-0 text-primary">
                <i class="bi bi-funnel me-2"></i>Filter & Sort Tasks
            </h5>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/technician_leader/tasks/list"
                  id="filterForm" class="row g-3">

                <!-- Sort -->
                <div class="col-md-2">
                    <label class="form-label fw-semibold" for="sortDir">Sort Deadline</label>
                    <select id="sortDir" name="sortDir" class="form-select">
                        <option value="asc" ${sortDir == 'asc' ? 'selected' : ''}>ASC</option>
                        <option value="desc" ${sortDir == 'desc' ? 'selected' : ''}>DESC</option>
                    </select>
                </div>

                <!-- Status -->
                <div class="col-md-3">
                    <label class="form-label fw-semibold" for="status">Status</label>
                    <select id="status" name="status" class="form-select">
                        <option value="">All</option>
                        <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Processing" ${status == 'Processing' ? 'selected' : ''}>Processing</option>
                        <option value="Finished" ${status == 'Finished' ? 'selected' : ''}>Finished</option>
                        <option value="Reject" ${status == 'Reject' ? 'selected' : ''}>Reject</option>
                        <option value="DeActived" ${status == 'DeActived' ? 'selected' : ''}>DeActived</option>
                    </select>
                </div>

                <!-- Staff Name -->
                <div class="col-md-3">
                    <label for="staffName" class="form-label fw-semibold">Assign To</label>
                    <input type="text" name="staffName" id="staffName" class="form-control"
                           placeholder="Search by Staff Name" value="${staffName}">
                </div>

                <!-- Near Due -->
                <div class="col-md-2 d-flex align-items-center gap-2">
                    <div class="form-check">
                        <input type="checkbox" id="nearDue" name="nearDue" class="form-check-input"
                        ${nearDue ? 'checked' : ''}>
                        <label for="nearDue" class="form-check-label fw-semibold">Near Due</label>
                    </div>
                    <input type="number" class="form-control" id="nearDueDays" name="nearDueDays"
                           placeholder="Days" min="1" max="30"
                           value="${empty nearDueHours ? 1 : nearDueHours}" style="width: 80px;">
                </div>

                <!-- Overdue -->
                <div class="col-md-2 d-flex align-items-center">
                    <div class="form-check">
                        <input type="checkbox" id="overdue" name="overdue" class="form-check-input"
                        ${overdue ? 'checked' : ''}>
                        <label for="overdue" class="form-check-label fw-semibold">Overdue</label>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="col-12 d-flex gap-2 mt-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/technician_leader/tasks/list"
                       class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-clockwise"></i> Reset
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- DASHBOARD SUMMARY -->
    <div class="row g-3 mb-3">
        <div class="col-md-3">
            <div class="card card-custom dashboard-card border-secondary border-start border-4 border-secondary">
                <div class="card-body py-2 d-flex justify-content-between align-items-center">
                    <span class="text-secondary fw-semibold">Matched Total</span>
                    <strong>${dashboardTotalMatched}</strong>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card card-custom dashboard-card border-primary border-start border-4 border-primary">
                <div class="card-body py-2 d-flex justify-content-between align-items-center">
                    <span class="text-primary fw-semibold">On Page</span>
                    <strong>${dashboardPageCount}</strong>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card card-custom dashboard-card border-warning border-start border-4 border-warning">
                <div class="card-body py-2 d-flex justify-content-between align-items-center">
                    <span class="text-warning fw-semibold">Near Due</span>
                    <strong>${dashboardNearDueCount}</strong>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card card-custom dashboard-card border-danger border-start border-4 border-danger">
                <div class="card-body py-2 d-flex justify-content-between align-items-center">
                    <span class="text-danger fw-semibold">Overdue</span>
                    <strong>${dashboardOverdueCount}</strong>
                </div>
            </div>
        </div>
    </div>

    <!-- TASK TABLE -->
    <div class="card card-custom">
        <div class="card-body p-0">
            <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th>No</th>
                    <th>Request ID</th>
                    <th>Assign To</th>
                    <th>Status</th>
                    <th>Start Date</th>
                    <th>Deadline</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty tasks}">
                        <c:forEach items="${tasks}" var="task" varStatus="status">
                            <c:set var="isNearDue" value="${nearDueMap[task.taskID]}"/>
                            <c:set var="isOverdue" value="${overdueMap[task.taskID]}"/>
                            <tr class="${isOverdue ? 'table-danger' : (isNearDue ? 'table-warning' : '')}">
                                <td>${status.index + 1 +(currentPage-1)*recordsPerPage}</td>
                                <td><c:out value="${task.request != null ? task.request.requestID : '-'}"/></td>
                                <td><c:out value="${task.assignTo != null ? task.assignTo.staffName : '-'}"/></td>
                                <td>
                                    <span class="badge
                                        <c:choose>
                                            <c:when test='${task.status == "Pending"}'>bg-secondary-subtle text-secondary</c:when>
                                            <c:when test='${task.status == "Processing"}'>bg-info-subtle text-info-emphasis</c:when>
                                            <c:when test='${task.status == "Finished"}'>bg-success-subtle text-success</c:when>
                                            <c:when test='${task.status == "Reject"}'>bg-danger-subtle text-danger-emphasis</c:when>
                                            <c:when test='${task.status == "DeActived"}'>bg-dark text-white</c:when>
                                            <c:otherwise>bg-light text-dark</c:otherwise>
                                        </c:choose>
                                    ">
                                            ${task.status}
                                    </span>
                                </td>
                                <td><c:out value="${empty task.startDate ? '-' : task.startDate}"/></td>
                                <td><c:out value="${empty task.deadline ? '-' : task.deadline}"/></td>
                                <td class="d-flex gap-2">
                                    <a class="btn btn-sm btn-outline-primary"
                                       href="${pageContext.request.contextPath}/staff/task/detail?taskId=${task.taskID}">
                                        <i class="bi bi-eye"></i> View
                                    </a>
                                    <c:if test='${task.status == "Pending" || task.status == "Processing"}'>
                                        <button type="button" class="btn btn-sm btn-outline-danger btn-delete-task"
                                                data-task-id="${task.taskID}">
                                            <i class="bi bi-trash"></i> Deactive
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center text-muted">No data.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- PAGINATION -->
    <div class="d-flex flex-column align-items-center gap-3 mt-4">
        <!-- Items per page -->
        <form method="get" class="d-flex align-items-center gap-2">
            <input type="hidden" name="sortDir" value="${param.sortDir}">
            <input type="hidden" name="status" value="${param.status}">
            <input type="hidden" name="staffName" value="${param.staffName}">
            <input type="hidden" name="nearDue" value="${param.nearDue}">
            <input type="hidden" name="nearDueDays" value="${param.nearDueDays}">
            <input type="hidden" name="overdue" value="${param.overdue}">
            <input type="hidden" name="page" value="${currentPage}">

            <label for="recordsPerPage">Show:</label>
            <c:set var="computedRpp"
                   value="${empty totalRecords or totalRecords <= 0 ? 1 : (recordsPerPage>totalRecords?totalRecords:recordsPerPage)}"/>
            <c:set var="computedMax"
                   value="${empty totalRecords or totalRecords <= 0 ? 1 : totalRecords}"/>

            <input type="number"
                   id="recordsPerPage"
                   name="recordsPerPage"
                   class="form-control text-center"
                   step="1"
                   value="${computedRpp}"
                   min="1"
                   max="${computedMax}"
                   style="width: 70px;">
            <button type="submit" class="btn btn-primary">Set</button>
        </form>

        <!-- Paging -->
        <form method="get" class="d-flex justify-content-center align-items-center gap-3">
            <input type="hidden" name="sortDir" value="${param.sortDir}">
            <input type="hidden" name="status" value="${param.status}">
            <input type="hidden" name="staffName" value="${param.staffName}">
            <input type="hidden" name="nearDue" value="${param.nearDue}">
            <input type="hidden" name="nearDueDays" value="${param.nearDueDays}">
            <input type="hidden" name="overdue" value="${param.overdue}">
            <input type="hidden" name="recordsPerPage" value="${computedRpp}">

            <c:if test="${currentPage gt 1}">
                <button type="submit" name="page" value="${currentPage - 1}" class="btn btn-outline-primary">Previous
                </button>
            </c:if>
            <span>Page ${currentPage} of ${totalPages}</span>
            <c:if test="${currentPage lt totalPages}">
                <button type="submit" name="page" value="${currentPage + 1}" class="btn btn-outline-primary">Next
                </button>
            </c:if>
        </form>
    </div>
</div>

<!-- ERROR MODAL -->
<div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-danger">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="errorModalLabel">Delete Failed</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body" id="errorModalBody"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const deleteButtons = document.querySelectorAll('.btn-delete-task');
        const modalElement = document.getElementById('errorModal');
        const modalBody = document.getElementById('errorModalBody');
        const errorModal = new bootstrap.Modal(modalElement);

        deleteButtons.forEach(btn => {
            btn.addEventListener('click', async function () {
                if (!confirm('Are you sure you want to delete this task?')) return;
                const taskId = this.dataset.taskId;

                try {
                    const response = await fetch('${pageContext.request.contextPath}/technician_leader/tasks/delete', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({taskId})
                    });
                    const data = await response.json();

                    if (response.ok && data.success) {
                        window.location.reload();
                    } else {
                        modalBody.textContent = data.message || data.error || 'Delete failed.';
                        errorModal.show();
                    }
                } catch (err) {
                    modalBody.textContent = 'Server not responding.';
                    errorModal.show();
                }
            });
        });
    });
</script>
</body>
</html>
