<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Respond to Feedback</title>
    <link href="../css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="../css/feedback/viewFeedback.css" rel="stylesheet"/>
    <style>
        .response-textarea { min-height: 160px; }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<div class="container mt-4">
    <div class="card">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Respond to Feedback</h5>
        </div>
        <div class="card-body">
            <!-- Notifications moved to the feedback detail page to avoid showing messages on the respond form -->

            <form method="post" action="${pageContext.request.contextPath}/feedback/respond">
                <input type="hidden" name="requestId" value="${feedback.requestID.foreignKeyValue}"/>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Customer</label>
                        <div><strong><c:out value="${feedback.customerID}" default="N/A"/></strong></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Rating</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty feedback.rating}">
                                    <div class="d-inline-block">
                                        <c:forEach begin="1" end="5" var="i">
                                            <span class="${i <= feedback.rating ? 'rating-stars' : 'rating-empty'}">★</span>
                                        </c:forEach>
                                        <span class="ms-2">${feedback.rating}/5</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    N/A
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Original Feedback</label>
                    <div class="p-2 border rounded"><c:out value="${feedback.description}" default="N/A"/></div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Feedback Date</label>
                        <div><c:out value="${feedback.feedbackDate}" default="N/A"/></div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Response Date</label>
                        <div><c:out value="${feedback.responseDate}" default="N/A"/></div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="response" class="form-label">Your Response</label>
                    <textarea id="response" name="response" class="form-control response-textarea"><c:out value="${feedback.response}" default=""/></textarea>
                    <div class="form-text">Max 255 characters. Leave empty to clear response.</div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success">Save Response</button>
                    <a href="${pageContext.request.contextPath}/feedback/view?requestId=${feedback.requestID.foreignKeyValue}" class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
