<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Received Assignments</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/task/viewAssignedTasks.css">
    <style>
        body{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .main-content{
            padding: 20px 0;
        }
        .container{
            max-width: 1200px;
        }
        .page-header{
            background: white;
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 24px;
            box-shadow: 0 10px 40px rgba(16,24,40,0.08);
        }
        .page-header h2{
            color: #1e293b;
            font-size: 2rem;
            font-weight: 700;
            margin: 0 0 8px 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .page-header h2 i{
            color: #6366f1;
        }
        .page-header .subtitle{
            color: #64748b;
            font-size: 1rem;
            margin: 0;
        }
        .stats-bar{
            background: white;
            border-radius: 12px;
            padding: 16px 24px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(16,24,40,0.06);
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .stats-bar .stat-item{
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .stats-bar .stat-item i{
            color: #6366f1;
            font-size: 1.2rem;
        }
        .stats-bar .stat-item .stat-label{
            color: #64748b;
            font-size: 0.9rem;
        }
        .stats-bar .stat-item .stat-value{
            color: #1e293b;
            font-weight: 700;
            font-size: 1.1rem;
        }
        .assignment-card{
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 16px;
            box-shadow: 0 4px 16px rgba(16,24,40,0.08);
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        .assignment-card:hover{
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(16,24,40,0.12);
            border-color: #6366f1;
        }
        .assignment-header{
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }
        .assignment-title{
            color: #1e293b;
            font-size: 1.25rem;
            font-weight: 600;
            margin: 0 0 8px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .assignment-title i{
            color: #6366f1;
        }
        .assignment-meta{
            color: #64748b;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .assignment-meta i{
            color: #6366f1;
        }
        .status-badge{
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            color: white;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 2px 8px rgba(251,191,36,0.3);
        }
        .assignment-note{
            background: #f8fafc;
            border-left: 4px solid #6366f1;
            padding: 12px 16px;
            border-radius: 8px;
            color: #475569;
            margin: 12px 0;
            font-size: 0.95rem;
            line-height: 1.6;
        }
        .assignment-actions{
            margin-top: 16px;
            padding-top: 16px;
            border-top: 2px solid #f1f5f9;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn{
            padding: 10px 20px;
            font-weight: 600;
            font-size: 0.9rem;
            border-radius: 8px;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
        }
        .btn-primary{
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(16,185,129,0.3);
        }
        .btn-primary:hover{
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16,185,129,0.4);
        }
        .btn-outline-danger{
            background: white;
            border: 2px solid #ef4444;
            color: #dc2626;
        }
        .btn-outline-danger:hover{
            background: #ef4444;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239,68,68,0.3);
        }
        .btn-secondary{
            background: #e2e8f0;
            color: #475569;
        }
        .btn-secondary:hover{
            background: #cbd5e1;
            color: #334155;
        }
        .alert{
            border-radius: 12px;
            padding: 20px 24px;
            border: none;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1rem;
            box-shadow: 0 4px 12px rgba(16,24,40,0.06);
        }
        .alert-info{
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            color: #1e40af;
        }
        .alert i{
            font-size: 1.5rem;
        }
        .empty-state{
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(16,24,40,0.08);
        }
        .empty-state i{
            font-size: 4rem;
            color: #cbd5e1;
            margin-bottom: 20px;
        }
        .empty-state h4{
            color: #475569;
            font-size: 1.5rem;
            margin-bottom: 10px;
        }
        .empty-state p{
            color: #94a3b8;
            font-size: 1rem;
        }
        @media (max-width: 768px){
            .page-header{
                padding: 20px;
            }
            .page-header h2{
                font-size: 1.5rem;
            }
            .assignment-card{
                padding: 16px;
            }
            .assignment-header{
                flex-direction: column;
                gap: 12px;
            }
            .assignment-actions{
                flex-direction: column;
            }
            .btn{
                width: 100%;
                justify-content: center;
            }
            .stats-bar{
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>

<div class="main-content">
    <jsp:include page="../components/header.jsp" />
    <div class="container mt-4">
        <div class="page-header">
            <h2>
                <i class="fas fa-inbox"></i>
                Assigned to you (Approved)
            </h2>
            <p class="subtitle">These are approved tasks the leader has assigned to you. You can accept or decline them.</p>
        </div>

        <c:choose>
            <c:when test="${empty pendingRequests}">
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h4>No Pending Assignments</h4>
                    <p>You have no approved assignments waiting for your decision at the moment.</p>
                    <a href="${pageContext.request.contextPath}/task/viewAssignedTasks" class="btn btn-primary mt-3">
                        <i class="fas fa-tasks"></i>
                        View My Tasks
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="stats-bar">
                    <div style="flex:1">
                        <div class="stat-item">
                            <i class="fas fa-clipboard-list"></i>
                            <div>
                                <div class="stat-label">Total Assignments</div>
                                <div class="stat-value">${pendingRequests.size()}</div>
                            </div>
                        </div>
                    </div>
                    <div style="flex:2; text-align: right;">
                        <form method="get" action="${pageContext.request.contextPath}/task/viewReceivedAssignments" class="d-flex justify-content-end" style="gap:8px; align-items:center;">
                            <input type="text" name="customerFilter" class="form-control" placeholder="Customer name" value="${param.customerFilter != null ? param.customerFilter : ''}" style="width:220px; display:inline-block;" />
                            <input type="text" name="phoneFilter" class="form-control" placeholder="Phone number" value="${param.phoneFilter != null ? param.phoneFilter : ''}" style="width:160px; display:inline-block;" />
                            <input type="date" name="fromDate" class="form-control" value="${param.fromDate != null ? param.fromDate : ''}" style="width:140px; display:inline-block;" />
                            <input type="date" name="toDate" class="form-control" value="${param.toDate != null ? param.toDate : ''}" style="width:140px; display:inline-block;" />
                            <select name="sort" class="form-control" style="width:160px; display:inline-block;">
                                <option value="time_desc" ${param.sort == null || param.sort == 'time_desc' ? 'selected' : ''}>Newest first</option>
                                <option value="time_asc" ${param.sort == 'time_asc' ? 'selected' : ''}>Oldest first</option>
                            </select>
                            <button type="submit" class="btn btn-primary">Filter</button>
                            <a href="${pageContext.request.contextPath}/task/viewReceivedAssignments" class="btn btn-secondary">Reset</a>
                        </form>
                    </div>
                </div>

                <c:forEach var="req" items="${pendingRequests}">
                    <c:if test="${req.requestStatus == 'Approved'}">
                        <div class="assignment-card">
                            <div class="assignment-header">
                                <div>
                                    <h5 class="assignment-title">
                                        <i class="fas fa-tasks"></i>
                                        ${req.requestDescription != null ? req.requestDescription : 'Service Request'}
                                    </h5>
                                    <div class="assignment-meta">
                                        <i class="fas fa-hashtag"></i>
                                        Request ID: <strong>#${req.requestID}</strong>
                                    </div>
                                </div>
                                <div>
                                    <span class="status-badge">
                                        <i class="fas fa-check-circle"></i>
                                        ${req.requestStatus}
                                    </span>
                                </div>
                            </div>
                            
                            <c:if test="${not empty req.note}">
                                <div class="assignment-note">
                                    <i class="fas fa-sticky-note"></i> ${req.note}
                                </div>
                            </c:if>
                            
                            <div class="assignment-actions">
                                <a class="btn btn-primary" href="${pageContext.request.contextPath}/task/assignmentDecision?requestId=${req.requestID}&amp;action=accept">
                                    <i class="fas fa-check-circle"></i>
                                    Review & Accept
                                </a>
                                <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/task/assignmentDecision?requestId=${req.requestID}&amp;action=decline">
                                    <i class="fas fa-times-circle"></i>
                                    Review & Decline
                                </a>
                                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/task/viewAssignedTasks">
                                    <i class="fas fa-arrow-left"></i>
                                    My Tasks
                                </a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
