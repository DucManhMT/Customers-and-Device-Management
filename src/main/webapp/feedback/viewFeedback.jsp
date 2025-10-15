<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<head>
    <title>Feedback Details</title>
    <link href="../css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="../css/feedback/viewFeedback.css" rel="stylesheet"/>
</head>
<body>

<div class="container-fluid">
    
    <c:set var="feedback" value="${{
        'feedbackID': 1,
        'requestID': 1001,
        'username': 'john_doe',
        'rating': 5,
        'content': 'Excellent service, very professional staff! The team was responsive and solved my issue quickly. I was impressed by the attention to detail and the follow-up communication. The technician arrived on time and completed the work efficiently. Highly recommend this service to anyone looking for reliable and professional support.',
        'response': 'Thank you for your wonderful feedback! We are delighted to hear that you had such a positive experience with our service. Your kind words about our team and their professionalism mean a lot to us. We will make sure to share your feedback with the technician who assisted you.',
        'feedbackDate': '2025-10-06 14:30:00',
        'responseDate': '2025-10-07 09:15:00'
    }}"/>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mt-1">Feedback Details</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="../">Home</a></li>
                        <li class="breadcrumb-item"><a href="../feedback/list">Feedback List</a></li>
                        <li class="breadcrumb-item active">Feedback #${param.feedbackId}</li>
                    </ol>
                </nav>
            </div>
            <div>
                <a href="../feedback/list" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to List
                </a>
            </div>
        </div>

        <div class="row">
            <!-- Main Feedback Details -->
            <div class="col-lg-8">
                <div class="card feedback-detail-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-chat-square-text"></i>
                            Feedback #${feedback.feedbackID}
                        </h5>
                    </div>
                    <div class="card-body">
                        <!-- Basic Information -->
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
                                        <a href="../requests/view?requestId=${feedback.requestID}" class="text-decoration-none">
                                            <span class="badge bg-info fs-6">#${feedback.requestID}</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Customer Username</div>
                                    <div class="info-value">
                                        <strong>${feedback.username}</strong>
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

                        <!-- Feedback Content -->
                        <div class="info-item">
                            <div class="info-label">Customer Feedback</div>
                            <div class="feedback-content">
                                <i class="bi bi-quote text-primary fs-3 opacity-50"></i>
                                <p class="mb-0 mt-2">${feedback.content}</p>
                            </div>
                        </div>

                        <!-- Response Section -->
                        <c:if test="${not empty feedback.response}">
                            <div class="info-item">
                                <div class="info-label">Our Response</div>
                                <div class="response-section">
                                    <div class="d-flex align-items-center mb-2">
                                        <i class="bi bi-reply-fill text-success me-2"></i>
                                        <small class="text-muted">Responded on: ${feedback.responseDate}</small>
                                    </div>
                                    <p class="mb-0">${feedback.response}</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="card">
                    <div class="card-body">
                        <h6 class="card-title">Actions</h6>
                        <div class="d-flex gap-2 flex-wrap">
                            <form method="get" action="../feedback/edit" style="display: inline;">
                                <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                                <button type="submit" class="btn btn-warning">
                                    <i class="bi bi-pencil"></i> Edit Feedback
                                </button>
                            </form>
                            
                            <form method="get" action="../feedback/delete" style="display: inline;">
                                <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                                <button type="submit" class="btn btn-danger">
                                    <i class="bi bi-trash"></i> Delete Feedback
                                </button>
                            </form>
                            
                            <c:if test="${empty feedback.response}">
                                <form method="get" action="../feedback/respond" style="display: inline;">
                                    <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-reply"></i> Add Response
                                    </button>
                                </form>
                            </c:if>
                            
                            <c:if test="${not empty feedback.response}">
                                <form method="get" action="../feedback/respond" style="display: inline;">
                                    <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                                    <button type="submit" class="btn btn-outline-success">
                                        <i class="bi bi-pencil-square"></i> Edit Response
                                    </button>
                                </form>
                            </c:if>
                            
                            <button class="btn btn-info" onclick="window.print()">
                                <i class="bi bi-printer"></i> Print
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Quick Stats -->
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">Quick Information</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="text-muted">Status:</span>
                            <span class="badge bg-success">Completed</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="text-muted">Response Status:</span>
                            <span class="badge ${not empty feedback.response ? 'bg-success' : 'bg-warning'}">
                                ${not empty feedback.response ? 'Responded' : 'Pending'}
                            </span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">Priority:</span>
                            <span class="badge ${feedback.rating <= 2 ? 'bg-danger' : feedback.rating == 3 ? 'bg-warning' : 'bg-info'}">
                                ${feedback.rating <= 2 ? 'High' : feedback.rating == 3 ? 'Medium' : 'Low'}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Related Information -->
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">Related Links</h6>
                    </div>
                    <div class="card-body">
                        <div class="list-group list-group-flush">
                            <a href="../requests/view?requestId=${feedback.requestID}" class="list-group-item list-group-item-action">
                                <i class="bi bi-file-text me-2"></i>
                                View Original Request
                            </a>
                            <a href="../customer/profile?username=${feedback.username}" class="list-group-item list-group-item-action">
                                <i class="bi bi-person me-2"></i>
                                Customer Profile
                            </a>
                            <a href="../feedback/list?username=${feedback.username}" class="list-group-item list-group-item-action">
                                <i class="bi bi-chat-dots me-2"></i>
                                All Feedbacks by ${feedback.username}
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Navigation -->
                <div class="card">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">Navigation</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="../feedback/create" class="btn btn-success btn-sm">
                                <i class="bi bi-plus-circle"></i> Create New Feedback
                            </a>
                            <a href="../feedback/list" class="btn btn-primary btn-sm">
                                <i class="bi bi-list"></i> All Feedbacks
                            </a>
                            <a href="../" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-house"></i> Dashboard
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- Add print styles -->
    <style media="print">
        .btn, .breadcrumb, .card:last-child { 
            display: none !important; 
        }
        .card { 
            break-inside: avoid; 
        }
        body { 
            font-size: 12pt; 
        }
    </style>

</body>
</html>