<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignment Decision</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/task/viewAssignedTasks.css">
    <style>
        body{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        .decision-wrapper{
            max-width: 900px;
            margin: 0 auto;
            padding: 0 16px;
        }
        .decision-card{
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(16,24,40,0.12);
            padding: 32px;
            margin-top: 24px;
        }
        .decision-header{
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 20px;
            margin-bottom: 24px;
        }
        .decision-header h3{
            color: #1e293b;
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0 0 8px 0;
        }
        .decision-header .subtitle{
            color: #64748b;
            font-size: 0.95rem;
        }
        .task-detail-section{
            background: linear-gradient(135deg, rgba(99,102,241,0.03) 0%, rgba(168,85,247,0.03) 100%);
            border: 1px solid rgba(99,102,241,0.08);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .task-detail-section h5{
            color: #1e293b;
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 12px;
        }
        .detail-grid{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 16px;
            margin-top: 16px;
        }
        .detail-item{
            background: white;
            padding: 14px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
        }
        .detail-item .label{
            color: #64748b;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .detail-item .label i{
            color: #6366f1;
        }
        .detail-item .value{
            color: #1e293b;
            font-size: 1rem;
            font-weight: 600;
        }
        .detail-item .value.secondary{
            color: #64748b;
            font-weight: 500;
        }
        .status-badge{
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .status-badge.approved{
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }
        .status-badge.pending{
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            color: white;
        }
        .info-section{
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 18px;
            margin-bottom: 20px;
        }
        .info-section h6{
            color: #1e293b;
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .info-section h6 i{
            color: #6366f1;
        }
        .info-row{
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e2e8f0;
        }
        .info-row:last-child{
            border-bottom: none;
        }
        .info-row .info-label{
            color: #64748b;
            font-size: 0.9rem;
        }
        .info-row .info-value{
            color: #1e293b;
            font-weight: 600;
            font-size: 0.9rem;
        }
        .task-meta{
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            color: #475569;
            font-size: 0.9rem;
            margin-top: 10px;
        }
        .task-meta .meta-item{
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .task-meta .meta-item i{
            color: #6366f1;
        }
        .task-meta .meta-item strong{
            color: #1e293b;
        }
        .note-box{
            background: #fef3c7;
            border: 1px solid #fbbf24;
            border-left: 4px solid #f59e0b;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
        }
        .note-box strong{
            color: #92400e;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
        }
        .note-box strong i{
            color: #f59e0b;
        }
        .note-box p{
            color: #78350f;
            margin: 0;
            line-height: 1.6;
        }
        .form-section{
            margin-bottom: 24px;
        }
        .form-label{
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
            display: block;
        }
        .form-control{
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }
        .form-control:focus{
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.1);
            outline: none;
        }
        .decision-actions{
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
            padding-top: 20px;
            border-top: 2px solid #f1f5f9;
        }
        .btn{
            padding: 12px 24px;
            font-weight: 600;
            font-size: 0.95rem;
            border-radius: 8px;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-primary{
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            border: none;
            color: white;
            box-shadow: 0 4px 12px rgba(99,102,241,0.3);
        }
        .btn-primary:hover{
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99,102,241,0.4);
        }
        .btn-outline-danger{
            border: 2px solid #ef4444;
            color: #dc2626;
            background: white;
        }
        .btn-outline-danger:hover{
            background: #ef4444;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239,68,68,0.3);
        }
        .btn-secondary{
            background: #e2e8f0;
            border: none;
            color: #475569;
        }
        .btn-secondary:hover{
            background: #cbd5e1;
            color: #334155;
        }
        .alert{
            border-radius: 8px;
            padding: 14px 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-danger{
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
        }
        .alert-success{
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
        }
        @media (max-width: 768px){
            .decision-card{
                padding: 20px;
                border-radius: 12px;
            }
            .decision-header h3{
                font-size: 1.5rem;
            }
            .decision-actions{
                flex-direction: column;
                align-items: stretch;
            }
            .btn{
                width: 100%;
                justify-content: center;
            }
            .detail-grid{
                grid-template-columns: 1fr;
            }
            .info-row{
                flex-direction: column;
                gap: 4px;
            }
        }
    </style>
</head>
<body>

<div class="decision-wrapper">
    <jsp:include page="../components/header.jsp" />
    <div class="decision-card">
        <div class="decision-header">
            <h3><i class="fas fa-clipboard-check"></i> Assignment Decision</h3>
            <p class="subtitle">Please review the task details carefully and choose whether to accept or decline this assignment.</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                ${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                ${successMessage}
            </div>
        </c:if>

        <c:set var="req" value="${requestScope.requestItem}"/>
        
        <div class="task-detail-section">
            <h5><i class="fas fa-tasks"></i> ${req.requestDescription != null ? req.requestDescription : 'Service Request'}</h5>
            
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="label">
                        <i class="fas fa-hashtag"></i>
                        Request ID
                    </div>
                    <div class="value">#${req.requestID}</div>
                </div>
                
                <div class="detail-item">
                    <div class="label">
                        <i class="fas fa-info-circle"></i>
                        Status
                    </div>
                    <div class="value">
                        <span class="status-badge ${req.requestStatus == 'Approved' ? 'approved' : 'pending'}">
                            ${req.requestStatus}
                        </span>
                    </div>
                </div>
                
                <div class="detail-item">
                    <div class="label">
                        <i class="fas fa-calendar-alt"></i>
                        Start Date
                    </div>
                    <div class="value ${empty req.startDate ? 'secondary' : ''}">
                        ${not empty req.startDate ? req.startDate : 'Not set'}
                    </div>
                </div>
                
                <div class="detail-item">
                    <div class="label">
                        <i class="fas fa-calendar-check"></i>
                        Finished Date
                    </div>
                    <div class="value ${empty req.finishedDate ? 'secondary' : ''}">
                        ${not empty req.finishedDate ? req.finishedDate : 'Not completed'}
                    </div>
                </div>
            </div>
        </div>

        <!-- Contract Information -->
        <c:if test="${not empty req.contract}">
            <c:set var="contract" value="${req.contract}" />
            <div class="info-section">
                <h6><i class="fas fa-file-contract"></i> Contract Information</h6>
                <div class="info-row">
                    <span class="info-label">Contract ID</span>
                    <span class="info-value">#${contract.contractID}</span>
                </div>
                <c:if test="${not empty contract.contractCode}">
                    <div class="info-row">
                        <span class="info-label">Contract Code</span>
                        <span class="info-value">${contract.contractCode}</span>
                    </div>
                </c:if>
                <c:if test="${not empty contract.startDate}">
                    <div class="info-row">
                        <span class="info-label">Contract Start Date</span>
                        <span class="info-value">${contract.startDate}</span>
                    </div>
                </c:if>
                <c:if test="${not empty contract.expiredDate}">
                    <div class="info-row">
                        <span class="info-label">Contract Expiry Date</span>
                        <span class="info-value">${contract.expiredDate}</span>
                    </div>
                </c:if>
                <c:catch var="customerError">
                    <c:set var="customer" value="${contract.customer}" />
                    <c:if test="${not empty customer}">
                        <div class="info-row">
                            <span class="info-label">Customer</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty customer.fullName}">
                                        ${customer.fullName}
                                    </c:when>
                                    <c:when test="${not empty customer.username}">
                                        ${customer.username}
                                    </c:when>
                                    <c:otherwise>
                                        Customer #${customer.customerID}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <c:if test="${not empty customer.phone}">
                            <div class="info-row">
                                <span class="info-label">Customer Phone</span>
                                <span class="info-value">
                                    <i class="fas fa-phone" style="color: #6366f1;"></i> ${customer.phone}
                                </span>
                            </div>
                        </c:if>
                        <c:if test="${not empty customer.address}">
                            <div class="info-row">
                                <span class="info-label">Customer Address</span>
                                <span class="info-value">
                                    <i class="fas fa-map-marker-alt" style="color: #6366f1;"></i> ${customer.address}
                                </span>
                            </div>
                        </c:if>
                    </c:if>
                </c:catch>
            </div>
        </c:if>

        <c:if test="${not empty req.note}">
            <div class="note-box">
                <strong><i class="fas fa-sticky-note"></i> Additional Notes</strong>
                <p>${req.note}</p>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/task/assignmentDecision">
            <input type="hidden" name="requestId" value="${req.requestID}" />
            
            <div class="form-section">
                <label class="form-label"><i class="fas fa-comment"></i> Optional Comment</label>
                <textarea name="comment" class="form-control" rows="3" placeholder="Add your reason for accepting or declining (optional)..."></textarea>
            </div>

            <div class="decision-actions">
                <button type="submit" name="decision" value="accept" class="btn btn-primary">
                    <i class="fas fa-check-circle"></i>
                    Accept & Start Processing
                </button>

                <button type="submit" name="decision" value="decline" class="btn btn-outline-danger" 
                        onclick="return confirm('Are you sure you want to decline this assignment?')">
                    <i class="fas fa-times-circle"></i>
                    Decline Assignment
                </button>

                <a href="${pageContext.request.contextPath}/task/viewReceivedAssignments" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Back to Assignments
                </a>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
