<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Task List</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
</head>
<body>
<c:set var="activePage" value="taskList" scope="request"/>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/techlead_sidebar.jsp"/>

<div class="container-fluid">
    <div class="container-fluid">
        <h2 class="mt-1">Task List</h2>

        <!-- Filter & Sort -->
        <div class="col-lg-12">
            <div class="card card-custom filter-card mb-4">
                <div class="card-header bg-transparent border-0">
                    <h5 class="card-title mb-0">
                        <i class="bi bi-funnel me-2"></i>Filter & Sort Tasks
                    </h5>
                </div>

                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/technician_leader/tasks/list"
                          id="filterForm">
                        <div class="row align-items-center flex-wrap gap-3 bg-light p-3 rounded">

                            <!-- Sort -->
                            <div class="col-2 gap-2">
                                <label class="form-label fw-semibold" for="sortDir">Sort Deadline</label>
                                <select id="sortDir" name="sortDir" class="form-select">
                                    <option value="asc" ${sortDir == 'asc' ? 'selected' : ''}>ASC</option>
                                    <option value="desc" ${sortDir == 'desc' ? 'selected' : ''}>DESC</option>
                                </select>
                            </div>

                            <!-- Status -->
                            <div class="col-3 gap-2">
                                <label class="form-label mb-0 fw-semibold" for="status">Status:</label>
                                <select id="status" name="status" class="form-select">
                                    <option value="">All</option>
                                    <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="Processing" ${status == 'Processing' ? 'selected' : ''}>Processing</option>
                                    <option value="Finished" ${status == 'Finished' ? 'selected' : ''}>Finished</option>
                                    <option value="Reject" ${status == 'Reject' ? 'selected' : ''}>Reject</option>
                                </select>
                            </div>

                            <!-- StaffName -->
                            <div class="col-3 gap-2">
                                <label for="staffName" class="form-label mb-0 fw-semibold">AssignTo:</label>
                                <input class="form-control" type="text" name="staffName" id="staffName"
                                       placeholder="Search by Staff Name" value="${staffName}">
                            </div>

                            <!-- Near Due -->
                            <div class="d-flex col-2 align-items-center gap-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="nearDue"
                                           name="nearDue" ${nearDue ? 'checked' : ''}>
                                    <label class="form-check-label fw-semibold" for="nearDue">Near Due</label>
                                </div>
                                <label class="form-label mb-0" for="nearDueDays">(Day):</label>
                                <input type="number" class="form-control" id="nearDueDays" name="nearDueDays"
                                       placeholder="days" min="1" max="30"
                                       value="${empty nearDueHours ? 1 : nearDueHours}" style="width: 90px;">
                            </div>

                            <!-- Overdue -->
                            <div class="col-1 align-items-center gap-1">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="overdue"
                                           name="overdue" ${overdue ? 'checked' : ''}>
                                    <label class="form-check-label" for="overdue">Overdue</label>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="row">
                                <div class="gap-2 flex-column">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-search"></i> Filter
                                    </button>
                                    <a href="${pageContext.request.contextPath}/technician_leader/tasks/list"
                                       class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-clockwise"></i> Reset
                                    </a>
                                </div>
                            </div>

                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Mini dashboard -->
        <div class="row g-3 mb-2">
            <div class="col-md-3">
                <div class="card border-secondary">
                    <div class="card-body py-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-secondary">Matched Total</span>
                            <strong>${dashboardTotalMatched}</strong>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-primary">
                    <div class="card-body py-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-primary">On Page</span>
                            <strong>${dashboardPageCount}</strong>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-warning">
                    <div class="card-body py-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-warning">Near Due</span>
                            <strong>${dashboardNearDueCount}</strong>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-danger">
                    <div class="card-body py-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-danger">Overdue</span>
                            <strong>${dashboardOverdueCount}</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Task table -->
        <table class="table table-bordered">
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
                                <span class="
                                    badge
                                    <c:choose>
                                        <c:when test='${task.status == "Pending"}'>bg-secondary</c:when>
                                        <c:when test='${task.status == "Processing"}'>bg-primary</c:when>
                                        <c:when test='${task.status == "Finished"}'>bg-success</c:when>
                                        <c:when test='${task.status == "Reject"}'>bg-danger</c:when>
                                        <c:otherwise>bg-light text-dark</c:otherwise>
                                    </c:choose>
                                ">
                                    ${task.status}
                                </span>
                            </td>
                            <td><c:out value="${empty task.startDate ? '-' : task.startDate}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty task.deadline}">
                                        ${task.deadline}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="d-flex gap-2">
                                <a class="btn btn-sm btn-outline-primary"
                                   href="${pageContext.request.contextPath}/staff/task/detail?taskId=${task.taskID}">
                                    <i class="bi bi-eye"></i> View
                                </a>

                                <!-- Delete via fetch JSON -->
                                <c:if test='${task.status == "Pending" || task.status == "Processing"}'>
                                    <button type="button"
                                            class="btn btn-sm btn-outline-danger btn-delete-task"
                                            data-task-id="${task.taskID}">
                                        <i class="bi bi-trash"></i> Delete
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

       <!-- PAGINATION SECTION -->
<div class="align-items-center d-flex flex-column gap-3 mt-3">

    <!-- Item per page -->
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
               class="form-control"
               step="1"
               value="${computedRpp}"
               min="1"
               max="${computedMax}"
               style="width: 70px; text-align: center;">
        <button type="submit" class="btn btn-primary">Set</button>
    </form>

    <!-- Paging -->
    <form method="get" class="d-flex justify-content-center align-items-center gap-3 mt-2">
        
        <input type="hidden" name="sortDir" value="${param.sortDir}">
        <input type="hidden" name="status" value="${param.status}">
        <input type="hidden" name="staffName" value="${param.staffName}">
        <input type="hidden" name="nearDue" value="${param.nearDue}">
        <input type="hidden" name="nearDueDays" value="${param.nearDueDays}">
        <input type="hidden" name="overdue" value="${param.overdue}">
        <input type="hidden" name="recordsPerPage" value="${computedRpp}">

        <div class="d-flex justify-content-center align-items-center gap-3">
            <!-- Previous -->
            <c:if test="${currentPage gt 1}">
                <button type="submit" name="page" value="${currentPage - 1}" class="btn btn-primary">
                    Previous
                </button>
            </c:if>

            <span>Page ${currentPage} of ${totalPages}</span>

            <!-- Next -->
            <c:if test="${currentPage lt totalPages}">
                <button type="submit" name="page" value="${currentPage + 1}" class="btn btn-primary">
                    Next
                </button>
            </c:if>
        </div>
    </form>

</div>

    </div>
</div>

<!-- Error Modal -->
<div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-danger">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title" id="errorModalLabel">Delete Failed</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
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
document.addEventListener('DOMContentLoaded', function() {
    const deleteButtons = document.querySelectorAll('.btn-delete-task');
    const modalElement = document.getElementById('errorModal');
    const modalBody = document.getElementById('errorModalBody');
    const errorModal = new bootstrap.Modal(modalElement);

    deleteButtons.forEach(btn => {
        btn.addEventListener('click', async function() {
            if (!confirm('Are you sure you want to delete this task?')) return;
            const taskId = this.dataset.taskId;

            try {
                const response = await fetch('${pageContext.request.contextPath}/api/technician_leader/tasks/delete', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ taskId })
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
