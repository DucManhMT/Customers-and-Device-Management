<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<head>
    <title>Feedback Details</title>
    <link href="../css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="../css/feedback/viewFeedback.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<div class="container-fluid">



    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mt-1">Feedback Details</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="..">Home</a></li>
                        <li class="breadcrumb-item">
                            <form method="get" action="${pageContext.request.contextPath}/customer/requests" style="display:inline;">
                                <button type="submit" class="btn btn-link p-0 text-decoration-none">Feedback List</button>
                            </form>
                        </li>
                        <li class="breadcrumb-item active">Feedback #${feedback.feedbackID}</li>
                    </ol>
                </nav>
            </div>
            <div>
                <form method="get" action="${pageContext.request.contextPath}/customer/requests" style="display:inline;">
                    <button type="submit" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to Request List
                    </button>
                </form>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="card feedback-detail-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-chat-square-text"></i>
                            Feedback 
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Feedback ID</div>
                                    <div class="info-value">
                                        <span class="badge bg-primary fs-6">#${feedback.feedbackID}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Request ID</div>
                                    <div class="info-value">
                                        <form method="get" action="${pageContext.request.contextPath}/customer/requests/detail" style="display:inline;">
                                            <input type="hidden" name="requestId" value="${feedback.requestID.foreignKeyValue}" />
                                            <button type="submit" class="btn btn-link p-0 text-decoration-none">
                                                <span class="badge bg-info fs-6">#${feedback.requestID.foreignKeyValue}</span>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Customer Username</div>
                                    <div class="info-value">
                                        <strong>${feedback.customerID}</strong>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Rating</div>
                                    <div class="info-value">
                                        <div class="d-flex align-items-center">
                                            <div class="me-3">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span class="${i <= feedback.rating ? 'rating-stars' : 'rating-empty'}">★</span>
                                                </c:forEach>
                                            </div>
                                            <span class="badge bg-warning text-dark fs-6">${feedback.rating}/5</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Feedback Date</div>
                            <div class="info-value">
                                <i class="bi bi-calendar-event text-muted me-2"></i>
                                ${feedback.feedbackDate}
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Content</div>
                            <div class="feedback-content">
                                <i class="bi bi-quote text-primary fs-3 opacity-50"></i>
                                <p class="mb-0 mt-2">${feedback.content}</p>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Customer Feedback</div>
                            <div class="feedback-content">
                                <i class="bi bi-quote text-primary fs-3 opacity-50"></i>
                                <p class="mb-0 mt-2">${feedback.description}</p>
                            </div>
                        </div>

                        <c:if test="${not empty feedback.response}">
                            <div class="info-item">
                                <div class="info-label">Our Response</div>
                                <div class="response-section">
                                    <div class="d-flex align-items-center mb-2">
                                        <i class="bi bi-reply-fill text-success me-2"></i>
                                        <small class="text-muted">Responded
                                            <c:choose>
                                                <c:when test="${not empty feedback.responseDate}">
                                                    <c:out value="${feedback.responseDate}"/>
                                                </c:when>
                                            </c:choose>
                                        </small>
                                    </div>
                                    <p class="mb-0"><c:out value="${feedback.response}"/></p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body">
                        <h6 class="card-title">Actions</h6>
                        <div class="d-flex gap-2 flex-wrap">
                            <form method="get" action="${pageContext.request.contextPath}/feedback/edit" style="display: inline;">
                                <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                                <button type="submit" class="btn btn-warning">
                                    <i class="bi bi-pencil"></i> Edit Feedback
                                </button>
                            </form>

                            <form method="post" action="${pageContext.request.contextPath}/feedback/delete" style="display: inline;">
                                <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete (hide) this feedback?');">
                                    <i class="bi bi-trash"></i> Delete Feedback
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">Quick Information</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="text-muted">Response Status:</span>
                            <span class="badge ${not empty feedback.response ? 'bg-success' : 'bg-warning'}">
                                ${not empty feedback.response ? 'Responded' : 'Pending'}
                            </span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">Rating:</span>
                            <span class="badge ${feedback.rating <= 2 ? 'bg-danger' : feedback.rating == 3 ? 'bg-warning' : 'bg-info'}">
                                ${feedback.rating >= 4 ? 'High' : feedback.rating == 3 ? 'Medium' : 'Low'}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>