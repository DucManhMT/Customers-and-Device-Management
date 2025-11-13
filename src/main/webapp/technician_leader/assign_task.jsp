<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib
        uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Assign Task</title>
    <link
            href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
            rel="stylesheet"
    />
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>
<div class="container my-3">
    <div class="row g-3">
        <!-- Info sidebar -->
        <div class="col-lg-4 order-lg-2">
            <div class="card">
                <div class="card-header">Information</div>
                <div class="card-body">
                    <h6 class="text-muted">Request</h6>
                    <div class="mb-2">
                        <div>
                            <strong>ID:</strong> ${empty requestId ? '-' : requestId}
                        </div>
                        <div>
                            <strong>Contract:</strong>
                            <c:out
                                    value="${requestObj != null && requestObj.contract != null ? requestObj.contract.contractCode : '-'}"
                            />
                        </div>
                        <div>
                            <strong>Customer:</strong>
                            <c:out
                                    value="${requestObj != null && requestObj.contract != null && requestObj.contract.customer != null ? requestObj.contract.customer.customerName : '-'}"
                            />
                        </div>
                        <div>
                            <strong>Status:</strong>
                            <c:out
                                    value="${requestObj != null ? requestObj.requestStatus : '-'}"
                            />
                        </div>
                    </div>
                    <hr/>
                    <h6 class="text-muted">Assign To (Staff)</h6>
                    <div>
                        <div>
                            <strong>ID:</strong> ${empty assignToId ? '-' : assignToId}
                        </div>
                        <div>
                            <strong>Name:</strong>
                            <c:out
                                    value="${assignTo != null ? assignTo.staffName : '-'}"
                            />
                        </div>
                        <div>
                            <strong>Phone:</strong>
                            <c:out value="${assignTo != null ? assignTo.phone : '-'}"/>
                        </div>
                        <div>
                            <strong>Email:</strong>
                            <c:out value="${assignTo != null ? assignTo.email : '-'}"/>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Existing tasks of selected technician -->
            <c:if test="${not empty assignToId}">
                <div class="card mt-3">
                    <div class="card-header">Processing Tasks</div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty assignToTasks}">
                                <div class="p-3 text-muted">No tasks found.</div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-sm mb-0">
                                        <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Request</th>
                                            <th>Start</th>
                                            <th>Deadline</th>
                                            <th>Status</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach
                                                var="t"
                                                items="${assignToTasks}"
                                                varStatus="loop"
                                        >
                                            <tr>
                                                <td>${t.taskID}</td>
                                                <td>
                                                        ${t.request != null ? t.request.requestID : '-'}
                                                </td>
                                                <td>${t.startDate}</td>
                                                <td>${t.deadline}</td>
                                                <td>
                                <span class="badge bg-secondary"
                                >${t.status}</span
                                >
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Main form -->
        <div class="col-lg-8 order-lg-1">
            <div class="card">
                <div class="card-header">Assign Task</div>
                <div class="card-body">
                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger">
                            <ul class="mb-0">
                                <c:forEach var="err" items="${errors}">
                                    <li><c:out value="${err}"/></li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <form
                            method="post"
                            action="${pageContext.request.contextPath}/technician_leader/tasks/assign"
                    >
                        <input type="hidden" name="requestId" value="${requestId}"/>
                        <input type="hidden" name="assignTo" value="${assignToId}"/>

                        <div class="mb-3">
                            <label for="startDate" class="form-label"
                            >Start Date <span style="color: red">*</span></label
                            >
                            <input
                                    type="date"
                                    id="startDate"
                                    name="startDate"
                                    class="form-control"
                                    value="${startDate}"
                                    required
                            />
                        </div>
                        <div class="mb-3">
                            <label for="deadline" class="form-label"
                            >Deadline <span style="color: red">*</span></label
                            >
                            <input
                                    type="date"
                                    id="deadline"
                                    name="deadline"
                                    class="form-control"
                                    value="${deadline}"
                                    required
                            />
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label"
                            >Description <span style="color: red">* </span></label
                            >
                            <textarea id="description" name="description" class="form-control" rows="4" required
                            >${description}</textarea
                            >
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">Assign</button>
                            <a
                                    class="btn btn-secondary"
                                    href="${pageContext.request.contextPath}/technician_leader/task/selectTechnician?selectedTasks=${requestId}"
                            >Cancel</a
                            >
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
