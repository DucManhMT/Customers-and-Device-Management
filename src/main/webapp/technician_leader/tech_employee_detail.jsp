<html>
<head>
    <title>Tech Employee Details</title>
    <link href="../css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/tech/tech-employee-detail.css" rel="stylesheet">
</head>

<body>
<jsp:include page="../components/header.jsp"/>
<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty techEmployee}">
                <div class="employee-detail-card">
                    <div class="employee-header">
                        <c:choose>
                            <c:when test="${not empty techEmployee.image}">
                                <img src="../assets/${techEmployee.image}" alt="${techEmployee.staffName}"
                                     class="employee-image-large">
                            </c:when>

                        </c:choose>

                        <div class="employee-name-large">${techEmployee.staffName}</div>
                        <div class="employee-role">Technical Employee</div>
                    </div>

                    <div class="info-section">
                        <h5 class="mb-4">Employee Information</h5>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="bi bi-card-text"></i>
                            </div>
                            <div class="info-label">Staff ID:</div>
                            <div class="info-value">${techEmployee.staffID}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="bi bi-person"></i>
                            </div>
                            <div class="info-label">Full Name:</div>
                            <div class="info-value">${techEmployee.staffName}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="bi bi-telephone"></i>
                            </div>
                            <div class="info-label">Phone:</div>
                            <div class="info-value">
                                <a href="tel:${techEmployee.phone}"
                                   class="text-decoration-none">${techEmployee.phone}</a>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="bi bi-envelope"></i>
                            </div>
                            <div class="info-label">Email:</div>
                            <div class="info-value">
                                <a href="mailto:${techEmployee.email}"
                                   class="text-decoration-none">${techEmployee.email}</a>
                            </div>
                        </div>

                        <c:if test="${not empty techEmployee.address}">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="bi bi-geo-alt"></i>
                                </div>
                                <div class="info-label">Address:</div>
                                <div class="info-value">${techEmployee.address}</div>
                            </div>
                        </c:if>

                        <c:if test="${not empty techEmployee.dateOfBirth}">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="bi bi-calendar"></i>
                                </div>
                                <div class="info-label">Date of Birth:</div>
                                <div class="info-value">${techEmployee.dateOfBirth}</div>
                            </div>
                        </c:if>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="bi bi-shield-check"></i>
                            </div>
                            <div class="info-label">Role:</div>
                            <div class="info-value">
                                <span class="badge bg-success">Technical Employee</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- <c:if test="${empty techEmployee}">
                <div class="alert alert-warning text-center">
                    <i class="bi bi-exclamation-triangle"></i>
                    <h4>Employee Not Found</h4>
                    <p>The requested tech employee could not be found or may have been removed from the system.</p>
                </div>
            </c:if> -->

            <div class="button-container">
                <a href="../employees" class="btn back-button me-3">
                    <i class="bi bi-arrow-left"></i> Back to Employee List
                </a>
                <a href="${pageContext.request.contextPath}/technicianleader/technicianleader_actioncenter"
                   class="btn home-button">
                    <span>Back to Action Center</span>
                </a>
            </div>
        </div>
    </div>
</div>

<script src="../css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>