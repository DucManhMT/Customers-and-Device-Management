<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<head>
    <title>Customer Feedback</title>
    <link href="../css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="../css/feedback/feedback.css" rel="stylesheet"/>
    
</head>
<body>

<div class="container-fluid">
        <h2 class="mt-1">Customer Feedback</h2>

        <div class="card mb-4 feedback-form">
            <div class="card-header feedback-card-header">
                <h5 class="mb-0">Create New Feedback</h5>
                <p class="mb-0 mt-2">
                    <i class="bi bi-person-circle"></i>
                    Logged in as: <strong>${currentUsername}</strong>
                </p>
            </div>
            <div class="card-body">
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle"></i> ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form method="post" action="../feedback/create">
                    <input type="hidden" name="username" value="${currentUsername}">

                    <div class="row">
                        <div class="col-md-8 mb-3">
                            <label for="feedbackType" class="form-label">Service Type Evaluation</label>
                            <select class="form-select" id="feedbackType" name="feedbackType" required onchange="toggleCustomInput()">
                                <option value="">-- Select service type to evaluate --</option>
                                <option value="repair_quality">Repair and Warranty Quality</option>
                                <option value="service_quality">Service Quality</option>
                                <option value="staff_attitude">Staff Attitude</option>
                                <option value="other">Other (custom input)</option>
                            </select>
                            <div class="form-text">
                                Select the type of service you want to evaluate.
                            </div>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label">Customer Information</label>
                            <div class="form-control-plaintext border rounded bg-light p-2">
                                <strong><i class="bi bi-person"></i> ${currentUsername}</strong><br>
                                <small class="text-muted">Current user</small>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3" id="customContentDiv" style="display: none;">
                        <label for="customContent" class="form-label">Custom Feedback Content</label>
                        <input type="text" class="form-control" id="customContent" name="customContent"
                               placeholder="Enter your feedback content..." maxlength="255">
                        <div class="form-text">
                            Enter specific content for "Other" option.
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Service Quality Rating</label>
                        <div class="star-rating">
                            <input type="radio" id="star5" name="rating" value="5" required>
                            <label for="star5" title="Excellent">★</label>

                            <input type="radio" id="star4" name="rating" value="4">
                            <label for="star4" title="Good">★</label>

                            <input type="radio" id="star3" name="rating" value="3">
                            <label for="star3" title="Average">★</label>

                            <input type="radio" id="star2" name="rating" value="2">
                            <label for="star2" title="Poor">★</label>

                            <input type="radio" id="star1" name="rating" value="1">
                            <label for="star1" title="Very Poor">★</label>
                        </div>
                        <div class="rating-text">
                            <span id="ratingText" class="text-muted">Please select rating</span>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Your Detailed Review</label>
                        <textarea class="form-control" id="description" name="description" rows="4" 
                                  placeholder="Share your detailed experience about the service: what you're satisfied with, what needs improvement, suggestions for us to serve better..." 
                                  maxlength="255"></textarea>
                        <div class="form-text">
                            <span id="charCount">0 </span>/255 characters. Share your feelings and suggestions about the service.
                        </div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/customer/customer_actioncenter" class="btn btn-outline-secondary">
                            Back to Customer Action Center
                        </a>

                        <div>
                            <button type="reset" class="btn btn-outline-warning me-2">
                                Reset Form
                            </button>
                            <button type="submit" class="btn btn-primary">
                                Submit Feedback
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-light">
                <h5 class="mb-0">Your Recent Feedbacks</h5>
                <small class="text-muted">Feedbacks submitted by ${currentUsername}</small>
            </div>
            <div class="card-body">
                <c:if test="${not empty recentFeedbacks}">
                    <table class="table table-bordered feedback-table">
                        <thead class="table-light">
                        <tr>
                            <th>No.</th>
                            <th>Service Type</th>
                            <th>Rating</th>
                            <th>Detailed Review</th>
                            <th>Response</th>
                            <th>Created Date</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${recentFeedbacks}" var="feedback" varStatus="status">
                            <tr class="fade-in">
                                <td>${status.index + 1}</td>
                                <td>
                                    <span class="badge bg-primary service-badge">${feedback.content}</span>
                                </td>
                                <td>
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="${i <= feedback.rating ? 'star-display' : 'star-muted'}">★</span>
                                    </c:forEach>
                                    (${feedback.rating}/5)
                                </td>
                                <td class="feedback-response">
                                    <c:choose>
                                        <c:when test="${not empty feedback.description}">
                                            <div class="text-truncate" title="${feedback.description}">
                                                ${feedback.description}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <em class="text-muted">No detailed review</em>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="feedback-response">
                                    <c:choose>
                                        <c:when test="${not empty feedback.response}">
                                            <div class="text-truncate" title="${feedback.response}">
                                                ${feedback.response}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <em class="text-muted">No response</em>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${feedback.feedbackDate}</td>
                                <td>
                                    <form method="get" action="../feedback/view" style="display: inline;">
                                        <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                                        <button type="submit" class="btn btn-info btn-sm">
                                            View
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Feedback pagination" class="mt-4">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <div class="d-flex align-items-center">
                                        <label for="recordsPerPage" class="form-label me-2 mb-0">Show:</label>
                                        <select id="recordsPerPage" class="form-select form-select-sm" style="width: auto;" onchange="changePageSize()">
                                            <option value="5" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                                            <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                            <option value="15" ${recordsPerPage == 15 ? 'selected' : ''}>15</option>
                                            <option value="20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
                                        </select>
                                        <span class="ms-2 text-muted">entries per page</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <ul class="pagination pagination-sm justify-content-end mb-0">
                                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${currentPage <= 1}">
                                                    <span class="page-link"><i class="bi bi-chevron-left"></i> Previous</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="page-link" href="?page=${currentPage - 1}&recordsPerPage=${recordsPerPage}">
                                                        <i class="bi bi-chevron-left"></i> Previous
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>

                                        <c:choose>
                                            <c:when test="${totalPages <= 7}">
                                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                        <a class="page-link" href="?page=${pageNum}&recordsPerPage=${recordsPerPage}">${pageNum}</a>
                                                    </li>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${currentPage <= 4}">
                                                        <c:forEach begin="1" end="5" var="pageNum">
                                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                                <a class="page-link" href="?page=${pageNum}&recordsPerPage=${recordsPerPage}">${pageNum}</a>
                                                            </li>
                                                        </c:forEach>
                                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                                        <li class="page-item">
                                                            <a class="page-link" href="?page=${totalPages}&recordsPerPage=${recordsPerPage}">${totalPages}</a>
                                                        </li>
                                                    </c:when>
                                                    <c:when test="${currentPage >= totalPages - 3}">
                                                        <li class="page-item">
                                                            <a class="page-link" href="?page=1&recordsPerPage=${recordsPerPage}">1</a>
                                                        </li>
                                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                                        <c:forEach begin="${totalPages - 4}" end="${totalPages}" var="pageNum">
                                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                                <a class="page-link" href="?page=${pageNum}&recordsPerPage=${recordsPerPage}">${pageNum}</a>
                                                            </li>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <li class="page-item">
                                                            <a class="page-link" href="?page=1&recordsPerPage=${recordsPerPage}">1</a>
                                                        </li>
                                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                                        <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="pageNum">
                                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                                <a class="page-link" href="?page=${pageNum}&recordsPerPage=${recordsPerPage}">${pageNum}</a>
                                                            </li>
                                                        </c:forEach>
                                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                                        <li class="page-item">
                                                            <a class="page-link" href="?page=${totalPages}&recordsPerPage=${recordsPerPage}">${totalPages}</a>
                                                        </li>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>

                                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${currentPage >= totalPages}">
                                                    <span class="page-link">Next <i class="bi bi-chevron-right"></i></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="page-link" href="?page=${currentPage + 1}&recordsPerPage=${recordsPerPage}">
                                                        Next <i class="bi bi-chevron-right"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                            <div class="text-center mt-3">
                                <small class="text-muted">
                                    Showing page ${currentPage} of ${totalPages}
                                    <c:if test="${not empty totalRecords}">
                                        (${totalRecords} total feedbacks)
                                    </c:if>
                                </small>
                            </div>
                        </nav>
                    </c:if>
                </c:if>

                <c:if test="${empty recentFeedbacks}">
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="bi bi-chat-dots"></i>
                        </div>
                        <div class="empty-title">No feedback yet.</div>
                        <div class="empty-description">Create your first feedback using the form above!</div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/feedback.js"></script>
    <script src="../css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.querySelector("form").addEventListener("submit", function (e) {
            const ratingChecked = document.querySelector('input[name="rating"]:checked');
            if (!ratingChecked) {
                e.preventDefault();
                alert("Vui lòng chọn mức đánh giá dịch vụ trước khi gửi phản hồi!");
            }
        });
    </script>

</body>
</html>
