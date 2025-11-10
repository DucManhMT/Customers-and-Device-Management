<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="crm.common.URLConstants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Management</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/feedback/viewFeedback.css" rel="stylesheet"/>
    <style>
        .filters {
            margin-bottom: 1rem;
        }

        .table-actions form {
            display: inline;
        }

        .stats {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
<c:set var="activePage" value="feedbackManagement" scope="request"/>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container my-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Feedback Management</h2>
        <div>
            <a href="${pageContext.request.contextPath}/customer_supporter/customersupporter_actioncenter"
               class="btn btn-secondary">Back to Action Center</a>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
    </c:if>

    <div class="card filters">
        <div class="card-body">
            <form id="filterForm" method="post"
                  action="${pageContext.request.contextPath}/customer_supporter/feedback/management" class="row g-2">
                <div class="col-md-3">
                    <span>Customer Username:</span>
                    <input type="text" name="username" class="form-control" placeholder="Customer username"
                           value="${usernameFilter}"/>
                </div>
                <div class="col-md-2">
                    <span>Rating:</span>
                    <select name="rating" class="form-control">
                        <option value="">All ratings</option>
                        <option value="5" ${ratingFilter == '5' ? 'selected' : ''}>5</option>
                        <option value="4" ${ratingFilter == '4' ? 'selected' : ''}>4</option>
                        <option value="3" ${ratingFilter == '3' ? 'selected' : ''}>3</option>
                        <option value="2" ${ratingFilter == '2' ? 'selected' : ''}>2</option>
                        <option value="1" ${ratingFilter == '1' ? 'selected' : ''}>1</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <span>Status:</span>
                    <select name="status" class="form-control">
                        <option value="">All status</option>
                        <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Responded" ${statusFilter == 'Responded' ? 'selected' : ''}>Responded</option>
                        <option value="Deleted" ${statusFilter == 'Deleted' ? 'selected' : ''}>Deleted</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <span>Page Size:</span>
                    <select name="pageSize" class="form-control">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                    </select>
                </div>

                <div class="col-md-2 text-end">
                    <div class="d-flex justify-content-end gap-2">
                        <button class="btn btn-outline-secondary" type="button" id="clearFiltersBtn">Clear</button>
                        <button class="btn btn-primary" type="submit">Apply</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="row stats">
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <strong>Total feedbacks</strong>
                    <div class="display-6">${totalCount != null ? totalCount : 0}</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <strong>Responded</strong>
                    <div class="display-6">${respondedCount != null ? respondedCount : 0}</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <strong>Pending</strong>
                    <div class="display-6">${pendingCount != null ? pendingCount : 0}</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-danger">
                <div class="card-body">
                    <strong>Deleted</strong>
                    <div class="display-6 text-danger">${deletedCount != null ? deletedCount : 0}</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card mt-3">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped mb-0">
                    <thead>
                    <tr>
                        <th>Feedback ID</th>
                        <th>Request ID</th>
                        <th>Customer</th>
                        <th>Rating</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty feedbacks}">
                                <c:forEach var="f" items="${feedbacks}">
                                    <tr>
                                        <td>#${f.feedbackID}</td>
                                        <td>
                                            <form method="get" action="${pageContext.request.contextPath}${URLConstants.CUSTOMER_SUPPORTER_REQUEST_DETAIL}" style="display:inline;">
                                                <input type="hidden" name="requestId" value="${f.requestID.foreignKeyValue}"/>
                                                <button class="btn btn-link p-0">#${f.requestID.foreignKeyValue}</button>
                                            </form>
                                        </td>
                                        <td>${f.customerID}</td>
                                        <td>${f.rating}</td>
                                        <td>${f.feedbackDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${f.feedbackStatus.name() == 'Pending'}">
                                                    <span class="badge bg-warning">Pending</span>
                                                </c:when>
                                                <c:when test="${f.feedbackStatus.name() == 'Responded'}">
                                                    <span class="badge bg-success">Responded</span>
                                                </c:when>
                                                <c:when test="${f.feedbackStatus.name() == 'Deleted'}">
                                                    <span class="badge bg-danger">Deleted</span>
                                                </c:when>
                                                <c:otherwise>
                                                    ${f.feedbackStatus}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="table-actions">
                                            <form method="get" action="${pageContext.request.contextPath}${URLConstants.CUSTOMER_VIEW_FEEDBACK}">
                                                <input type="hidden" name="requestId" value="${f.requestID.foreignKeyValue}"/>
                                                <button type="submit" class="btn btn-sm btn-info">View</button>
                                            </form>
                                            <form method="get" action="${pageContext.request.contextPath}/feedback/respond">
                                                <input type="hidden" name="requestId" value="${f.requestID.foreignKeyValue}"/>
                                                <button type="submit" class="btn btn-sm btn-success">Respond</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td>#${f.feedbackID}</td>
                                    <td>
                                        <form method="get"
                                              action="${pageContext.request.contextPath}${URLConstants.CUSTOMER_SUPPORTER_REQUEST_DETAIL}"
                                              style="display:inline;">
                                            <input type="hidden" name="requestId"
                                                   value="${f.requestID.foreignKeyValue}"/>
                                            <button class="btn btn-link p-0">#${f.requestID.foreignKeyValue}</button>
                                        </form>
                                    </td>
                                    <td>${f.customerID}</td>
                                    <td>${f.rating}</td>
                                    <td>${f.feedbackDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${f.feedbackStatus.name() == 'Pending'}">
                                                <span class="badge bg-warning">Pending</span>
                                            </c:when>
                                            <c:when test="${f.feedbackStatus.name() == 'Responded'}">
                                                <span class="badge bg-success">Responded</span>
                                            </c:when>
                                            <c:when test="${f.feedbackStatus.name() == 'Deleted'}">
                                                <span class="badge bg-danger">Deleted</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${f.feedbackStatus}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="table-actions">
                                        <form method="get"
                                              action="${pageContext.request.contextPath}${URLConstants.CUSTOMER_VIEW_FEEDBACK}">
                                            <input type="hidden" name="requestId"
                                                   value="${f.requestID.foreignKeyValue}"/>
                                            <button type="submit" class="btn btn-sm btn-info">View</button>
                                        </form>
                                        <form method="get"
                                              action="${pageContext.request.contextPath}/customer_supporter/feedback/respond">
                                            <input type="hidden" name="requestId"
                                                   value="${f.requestID.foreignKeyValue}"/>
                                            <button type="submit" class="btn btn-sm btn-success">Respond</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center">No feedback found.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-3">
        <div>
            Showing page ${currentPage != null ? currentPage : 1} of ${totalPages != null ? totalPages : 1}
        </div>
        <div>
            <c:if test="${currentPage > 1}">
                <form method="post" action="${pageContext.request.contextPath}/customer_supporter/feedback/management"
                      style="display:inline;">
                    <input type="hidden" name="page" value="${currentPage - 1}"/>
                    <input type="hidden" name="username" value="${usernameFilter}"/>
                    <input type="hidden" name="rating" value="${ratingFilter}"/>
                    <input type="hidden" name="status" value="${statusFilter}"/>
                    <input type="hidden" name="pageSize" value="${pageSize}"/>
                    <button class="btn btn-outline-secondary">Previous</button>
                </form>
            </c:if>
            <span class="btn btn-primary">${currentPage != null ? currentPage : 1} </span>
            <c:if test="${currentPage < totalPages}">
                <form method="post" action="${pageContext.request.contextPath}/customer_supporter/feedback/management"
                      style="display:inline;">
                    <input type="hidden" name="page" value="${currentPage + 1}"/>
                    <input type="hidden" name="username" value="${usernameFilter}"/>
                    <input type="hidden" name="rating" value="${ratingFilter}"/>
                    <input type="hidden" name="status" value="${statusFilter}"/>
                    <input type="hidden" name="pageSize" value="${pageSize}"/>
                    <button class="btn btn-outline-secondary">Next</button>
                </form>
            </c:if>
        </div>
    </div>

</div>

</script>
<script>
    (function () {
        var clearBtn = document.getElementById('clearFiltersBtn');
        if (!clearBtn) return;
        clearBtn.addEventListener('click', function () {
            var form = document.getElementById('filterForm');
            if (!form) return;
            var fields = ['username', 'rating', 'status'];
            fields.forEach(function (name) {
                var el = form.querySelector('[name="' + name + '"]');
                if (el) {
                    if (el.tagName.toLowerCase() === 'select') {
                        el.selectedIndex = 0;
                    } else {
                        el.value = '';
                    }
                }
            });
            var ps = form.querySelector('[name="pageSize"]');
            if (ps) ps.value = '10';
            var pageInput = form.querySelector('[name="page"]');
            if (pageInput) pageInput.value = '1';
            form.submit();
        });
    })();
</script>
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
