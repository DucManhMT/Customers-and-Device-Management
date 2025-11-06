<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 11/7/2025
  Time: 4:45 AM
  To change this template use File | Settings | File Templates.
--%>
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

        <!-- Bộ lọc & sắp xếp -->
        <form method="get" action="${pageContext.request.contextPath}/technician_leader/tasks/list">
            <div class="d-flex align-items-center gap-3 bg-light p-3 mb-1">
                <!-- Sort -->
                <div class="d-flex align-items-center gap-2">
                    <label class="form-label mb-0" for="sortDir">Sort Deadline:</label>
                    <select id="sortDir" name="sortDir" class="form-select" style="width: 140px;">
                        <option value="asc" ${sortDir == 'asc' ? 'selected' : ''}>ASC</option>
                        <option value="desc" ${sortDir == 'desc' ? 'selected' : ''}>DESC</option>
                    </select>
                </div>

                <!-- Status filter -->
                <div class="d-flex align-items-center gap-2">
                    <label class="form-label mb-0" for="status">Status:</label>
                    <select id="status" name="status" class="form-select" style="width: 180px;">
                        <option value="">All</option>
                        <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="InProgress" ${status == 'InProgress' ? 'selected' : ''}>InProgress</option>
                        <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Completed</option>
                        <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                    </select>
                </div>

                <!-- StaffName search -->
                <div class="d-flex align-items-center gap-2">
                    <label for="staffName" class="form-label mb-0">AssignTo:</label>
                    <input class="form-control" type="text" name="staffName" id="staffName"
                           placeholder="Search by Staff Name" value="${staffName}"
                           style="width: 240px; display: inline-block;">
                </div>


                <!-- Near due & Overdue (nearDueDays) -->
                <div class="d-flex align-items-center gap-2">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="nearDue"
                               name="nearDue" ${nearDue ? 'checked' : ''}>
                        <label class="form-check-label" for="nearDue">
                            Near Due</label>
                    </div>
                    <label class="form-label mb-0" for="nearDueDays">(Day):</label>
                    <input type="number" class="form-control" id="nearDueDays" name="nearDueDays" placeholder="days"
                           min="1" max="30"
                           value="${empty nearDueHours ? 1 : nearDueHours}" style="width: 90px;">
                </div>
                <div class="d-flex align-items-center gap-2">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="overdue"
                               name="overdue" ${overdue ? 'checked' : ''}>
                        <label class="form-check-label" for="overdue">Overdue</label>
                    </div>
                </div>

                <div class="ms-auto d-flex align-items-center gap-2 flex-column">
                    <button type="submit" class="btn btn-primary">Filter</button>
                    <a href="${pageContext.request.contextPath}/technician_leader/tasks/list" class="btn btn-danger">Rest</a>
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

            <table class="table table-bordered">
                <thead class="table-light">
                <tr>
                    <th>No</th>
                    <th>Task ID</th>
                    <th>Request ID</th>
                    <th>Assign To</th>
                    <th>Status</th>
                    <th>Start Date</th>
                    <th>Deadline</th>
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
                                <td>${task.taskID}</td>
                                <td><c:out value="${task.request != null ? task.request.requestID : '-'}"/></td>
                                <td><c:out value="${task.assignTo != null ? task.assignTo.staffName : '-'}"/></td>
                                <td>${task.status}</td>
                                <td><c:out value="${empty task.startDate ? '-' : task.startDate}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty task.deadline}">
                                            ${task.deadline}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center text-muted">Không có dữ liệu.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>

            <jsp:include page="../components/paging-bottom.jsp"/>
        </form>

        <jsp:include page="../components/scroll-button.jsp"/>
    </div>

</div>

</body>
</html>
