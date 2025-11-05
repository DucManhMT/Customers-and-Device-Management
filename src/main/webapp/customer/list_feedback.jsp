<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>My Feedbacks</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feedback/list_feedback.css" />
    <style>
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body{
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
        }
        body::before{
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 50%, rgba(99, 102, 241, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(139, 92, 246, 0.3) 0%, transparent 50%);
            pointer-events: none;
        }
        .container{
            position: relative;
            z-index: 1;
            max-width: 1400px;
        }
        .page-hero{
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 32px 40px;
            margin-bottom: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: slideDown 0.5s ease-out;
        }
        @keyframes slideDown{
            from{ opacity: 0; transform: translateY(-20px); }
            to{ opacity: 1; transform: translateY(0); }
        }
        .page-hero h2{
            color: #1e293b;
            font-size: 2.25rem;
            font-weight: 800;
            margin: 0 0 8px 0;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .page-hero .lead{
            color: #64748b;
            font-size: 1rem;
            margin: 0;
        }
        .filter-card{
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 28px 32px;
            margin-bottom: 24px;
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: fadeIn 0.6s ease-out 0.2s both;
        }
        .filter-card .row{
            display: flex;
            flex-wrap: wrap;
            align-items: flex-end;
            gap: 12px;
        }
        .filter-card .col-md-3,
        .filter-card .col-md-2,
        .filter-card .col-md-1{
            flex: 1;
            min-width: 140px;
        }
        .filter-card .col-md-3{
            min-width: 200px;
        }
        .filter-card .col-12{
            flex: 0 0 100%;
            width: 100%;
            margin-top: 12px !important;
        }
        @keyframes fadeIn{
            from{ opacity: 0; }
            to{ opacity: 1; }
        }
        .form-label{
            font-weight: 700;
            color: #334155;
            font-size: 0.85rem;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-control, .form-select{
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: white;
        }
        .form-control:focus, .form-select:focus{
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.1);
            outline: none;
        }
        .btn{
            padding: 10px 24px;
            font-weight: 700;
            font-size: 0.95rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            text-decoration: none;
            cursor: pointer;
        }
        .btn i{
            font-size: 1rem;
        }
        .btn-primary{
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white;
            box-shadow: 0 6px 16px rgba(99,102,241,0.35);
        }
        .btn-primary:hover{
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(99,102,241,0.45);
        }
        .btn-outline-primary{
            background: white;
            border: 2px solid #6366f1;
            color: #6366f1;
        }
        .btn-outline-primary:hover{
            background: #6366f1;
            color: white;
            transform: translateY(-2px);
        }
        .btn-secondary{
            background: #e2e8f0;
            color: #475569;
        }
        .btn-secondary:hover{
            background: #cbd5e1;
            color: #334155;
        }
        .btn-warning{
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            color: white;
            box-shadow: 0 4px 12px rgba(251,191,36,0.3);
        }
        .btn-warning:hover{
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(251,191,36,0.4);
        }
        .results-card{
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: fadeIn 0.6s ease-out 0.4s both;
        }
        .feedback-grid{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(500px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }
        .feedback-card{
            background: white;
            border-radius: 16px;
            padding: 24px;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .feedback-card::before{
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, #6366f1, #8b5cf6);
        }
        .feedback-card:hover{
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(99, 102, 241, 0.15);
            border-color: #6366f1;
        }
        .feedback-header{
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }
        .feedback-id{
            font-size: 0.85rem;
            font-weight: 800;
            color: #6366f1;
            background: rgba(99, 102, 241, 0.1);
            padding: 6px 12px;
            border-radius: 8px;
        }
        .feedback-date{
            font-size: 0.85rem;
            color: #64748b;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .feedback-date i{
            color: #6366f1;
        }
        .feedback-content{
            margin-bottom: 12px;
        }
        .feedback-content .label{
            font-size: 0.75rem;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .feedback-content .value{
            color: #334155;
            font-size: 0.95rem;
            line-height: 1.6;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            cursor: pointer;
        }
        .feedback-content .value:hover{
            color: #6366f1;
        }
        .feedback-meta{
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 16px;
            padding-top: 12px;
            border-top: 1px solid #f1f5f9;
        }
        .meta-item{
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.85rem;
        }
        .meta-item i{
            color: #6366f1;
        }
        .request-info-box{
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            border: 2px solid #3b82f6;
            border-left: 6px solid #2563eb;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 16px;
        }
        .request-info-header{
            font-weight: 800;
            color: #1e40af;
            font-size: 0.9rem;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .request-info-header i{
            color: #3b82f6;
            font-size: 1rem;
        }
        .request-info-grid{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }
        .info-item{
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .info-label{
            font-size: 0.75rem;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value{
            font-size: 0.9rem;
            color: #1e293b;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .info-value i{
            color: #3b82f6;
            font-size: 0.85rem;
        }
        .badge-status{
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }
        .badge-status.pending-req{
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: #92400e;
        }
        .badge-status.approved-req{
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
        }
        .badge-status.processing-req{
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
        }
        .badge-status.finished-req{
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            color: #166534;
        }
        .badge-status.rejected-req{
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
        }
        .rating-section{
            display: flex;
            align-items: center;
            gap: 12px;
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            padding: 10px 16px;
            border-radius: 10px;
            border: 2px solid #fbbf24;
        }
        .rating-label{
            font-weight: 700;
            color: #92400e;
            font-size: 0.85rem;
        }
        .rating-display{
            display: flex;
            gap: 3px;
        }
        .rating-display i{
            color: #f59e0b;
            font-size: 1.1rem;
            filter: drop-shadow(0 1px 2px rgba(245, 158, 11, 0.3));
        }
        .rating-display i.far{
            color: #d1d5db;
        }
        .rating-number{
            font-weight: 800;
            color: #92400e;
            font-size: 1rem;
        }
        .status-badge{
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .status-badge.pending{
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            color: white;
        }
        .status-badge.responded{
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }
        .status-badge.deleted{
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }
        .feedback-actions{
            display: flex;
            gap: 8px;
        }
        .btn-sm{
            padding: 6px 16px;
            font-size: 0.85rem;
        }
        .alert{
            border-radius: 12px;
            padding: 20px;
            border: none;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1rem;
        }
        .alert-info{
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
            border-left: 4px solid #3b82f6;
        }
        .alert-info i{
            color: #3b82f6;
            font-size: 1.5rem;
        }
        .pagination-wrapper{
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 24px;
            border-top: 2px solid #f1f5f9;
        }
        .pagination{
            display: flex;
            gap: 6px;
        }
        .page-item{
            list-style: none;
        }
        .page-link{
            padding: 8px 14px;
            border-radius: 8px;
            background: white;
            border: 2px solid #e2e8f0;
            color: #475569;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .page-link:hover{
            background: #f8fafc;
            border-color: #6366f1;
            color: #6366f1;
        }
        .page-item.active .page-link{
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-color: #6366f1;
            color: white;
        }
        @media (max-width: 768px){
            .page-hero{
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
                padding: 24px;
            }
            .page-hero h2{
                font-size: 1.75rem;
            }
            .feedback-grid{
                grid-template-columns: 1fr;
            }
            .pagination-wrapper{
                flex-direction: column;
                gap: 16px;
            }
        }
    </style>
</head>
<body>
<c:set var="activePage" value="myFeedback" scope="request" />
<jsp:include page="../components/header.jsp" />
<jsp:include page="../components/customer_sidebar.jsp"/>
<div class="container mt-4">
    <div class="page-hero">
        <div>
            <h2><i class="fas fa-comments"></i> Feedback History</h2>
            </div>
    </div>

    <div class="filter-card filter-form">
    <form method="get" action="${pageContext.request.contextPath}/feedback/list" class="row g-2 align-items-end">
        <div class="col-md-3">
            <label class="form-label">Search</label>
            <input type="text" name="q" class="form-control" value="${fn:escapeXml(q)}" placeholder="search content or description" />
        </div>
        <div class="col-md-2">
            <label class="form-label">From</label>
            <input type="date" name="fromDate" class="form-control" value="${fromDate}" />
        </div>
        <div class="col-md-2">
            <label class="form-label">To</label>
            <input type="date" name="toDate" class="form-control" value="${toDate}" />
        </div>
        <div class="col-md-2">
            <label class="form-label">Status</label>
            <select name="status" class="form-select">
                <option value="" ${empty status ? 'selected' : ''}>All</option>
                <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                <option value="Responded" ${status == 'Responded' ? 'selected' : ''}>Responded</option>
            </select>
        </div>
        <div class="col-md-1">
            <label class="form-label">Rating</label>
            <select name="rating" class="form-select">
                <option value="" ${empty rating ? 'selected' : ''}>All</option>
                <c:forEach var="r" begin="1" end="5">
                    <option value="${r}" ${rating == r.toString() ? 'selected' : ''}>${r}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <label class="form-label">Per page</label>
            <select name="recordsPerPage" class="form-select">
                <option value="5" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                <option value="20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
                <option value="50" ${recordsPerPage == 50 ? 'selected' : ''}>50</option>
            </select>
        </div>
        <div class="col-12 mt-2">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-filter"></i>
                Filter
            </button>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/feedback/list">
                <i class="fas fa-redo"></i>
                Clear
            </a>
        </div>
    </form>
    </div>

    <div class="results-card">
        <c:if test="${empty feedbacks}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                No feedbacks found. Try adjusting your filters or create your first feedback.
            </div>
        </c:if>

        <c:if test="${not empty feedbacks}">
            <div class="feedback-grid">
                <c:forEach var="fb" items="${feedbacks}">
                    <div class="feedback-card">
                        <div class="feedback-header">
                            <div class="feedback-id">
                                <i class="fas fa-hashtag"></i> ${fb.feedbackID}
                            </div>
                            <div class="feedback-date">
                                <i class="fas fa-calendar-alt"></i>
                                <c:out value="${fb.feedbackDate}" default="-" />
                            </div>
                        </div>

                        <div class="feedback-content">
                            <div class="label">
                                <i class="fas fa-file-alt"></i> Content
                            </div>
                            <div class="value preview-link" data-title="Content" data-value="<c:out value='${fb.content}' default=''/>">
                                <c:out value="${fb.content}" default="No content"/>
                            </div>
                        </div>

                        <div class="feedback-content">
                            <div class="label">
                                <i class="fas fa-comment-dots"></i> Description
                            </div>
                            <div class="value preview-link" data-title="Description" data-value="<c:out value='${fb.description}' default=''/>">
                                <c:out value="${fb.description}" default="No description"/>
                            </div>
                        </div>

                        <!-- Request Information Section -->
                        <c:catch var="requestError">
                            <c:set var="request" value="${fb.requestID.entity}" />
                        </c:catch>
                        <c:if test="${not empty request}">
                            <div class="request-info-box">
                                <div class="request-info-header">
                                    <i class="fas fa-tasks"></i> Request Information
                                </div>
                                <div class="request-info-grid">
                                    <div class="info-item">
                                        <span class="info-label">ID:</span>
                                        <span class="info-value">#${fb.requestID.foreignKeyValue}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Title:</span>
                                        <span class="info-value"><c:out value="${request.title}" default="N/A"/></span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Status:</span>
                                        <span class="info-value request-status">
                                            <c:choose>
                                                <c:when test="${request.requestStatus.name() == 'Pending'}">
                                                    <span class="badge-status pending-req"><i class="fas fa-clock"></i> Pending</span>
                                                </c:when>
                                                <c:when test="${request.requestStatus.name() == 'Approved'}">
                                                    <span class="badge-status approved-req"><i class="fas fa-check"></i> Approved</span>
                                                </c:when>
                                                <c:when test="${request.requestStatus.name() == 'Processing'}">
                                                    <span class="badge-status processing-req"><i class="fas fa-cog fa-spin"></i> Processing</span>
                                                </c:when>
                                                <c:when test="${request.requestStatus.name() == 'Finished'}">
                                                    <span class="badge-status finished-req"><i class="fas fa-check-circle"></i> Finished</span>
                                                </c:when>
                                                <c:when test="${request.requestStatus.name() == 'Rejected'}">
                                                    <span class="badge-status rejected-req"><i class="fas fa-times-circle"></i> Rejected</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${request.requestStatus}" default="N/A"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <c:if test="${not empty request.requestDate}">
                                        <div class="info-item">
                                            <span class="info-label">Request Date:</span>
                                            <span class="info-value"><i class="fas fa-calendar"></i> <c:out value="${request.requestDate}"/></span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>

                        <div class="feedback-meta">
                            <div class="meta-item rating-section">
                                <span class="rating-label">Your Rating:</span>
                                <div class="rating-display">
                                    <c:forEach var="s" begin="1" end="5">
                                        <i class="${s <= fb.rating ? 'fas' : 'far'} fa-star"></i>
                                    </c:forEach>
                                </div>
                                <span class="rating-number">${fb.rating}/5</span>
                            </div>
                            <div class="meta-item">
                                <c:choose>
                                    <c:when test="${fb.feedbackStatus != null && fb.feedbackStatus.name() == 'Pending'}">
                                        <span class="status-badge pending">
                                            <i class="fas fa-clock"></i> Pending
                                        </span>
                                    </c:when>
                                    <c:when test="${fb.feedbackStatus != null && fb.feedbackStatus.name() == 'Responded'}">
                                        <span class="status-badge responded">
                                            <i class="fas fa-check-circle"></i> Responded
                                        </span>
                                    </c:when>
                                    <c:when test="${fb.feedbackStatus != null && fb.feedbackStatus.name() == 'Deleted'}">
                                        <span class="status-badge deleted">
                                            <i class="fas fa-trash"></i> Deleted
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge"><c:out value="${fb.feedbackStatus}" default="-"/></span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <c:if test="${not empty fb.response}">
                            <div class="feedback-content" style="background: linear-gradient(135deg, #f0fdf4, #dcfce7); padding: 12px; border-radius: 8px; border-left: 3px solid #10b981;">
                                <div class="label" style="color: #166534;">
                                    <i class="fas fa-reply"></i> Support Response
                                </div>
                                <div class="value" style="color: #166534;">
                                    <c:out value="${fb.response}"/>
                                </div>
                            </div>
                        </c:if>

                        <div class="feedback-actions">
                            <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/feedback/view?requestId=${fb.requestID.foreignKeyValue}">
                                <i class="fas fa-eye"></i>
                                View
                            </a>
                            <c:if test="${fb.customerID == currentUsername}">
                                <a class="btn btn-sm btn-warning" href="${pageContext.request.contextPath}/feedback/edit?feedbackId=${fb.feedbackID}">
                                    <i class="fas fa-edit"></i>
                                    Edit
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="pagination-wrapper">
                <div>
                    <small style="color: #64748b; font-weight: 600;">
                        <i class="fas fa-list"></i> Showing ${feedbacks.size()} of ${totalRecords} results
                    </small>
                </div>
                <nav>
                    <ul class="pagination mb-0">
                        <c:forEach var="p" begin="1" end="${totalPages}">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/feedback/list?page=${p}&recordsPerPage=${recordsPerPage}&q=${fn:escapeXml(q)}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&rating=${rating}">${p}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function(){
        var previewLinks = document.querySelectorAll('.preview-link');
        previewLinks.forEach(function(link){
            link.addEventListener('click', function(ev){
                ev.preventDefault();
                var title = link.getAttribute('data-title') || 'Preview';
                var value = link.getAttribute('data-value') || '';
                var modalEl = document.getElementById('feedbackPreviewModal');
                var modalTitle = modalEl.querySelector('.modal-title');
                var modalBody = modalEl.querySelector('.modal-body');
                modalTitle.textContent = title;
                modalBody.innerHTML = '<pre style="white-space:pre-wrap; word-wrap:break-word; font-family: inherit; margin:0;">' + value + '</pre>';
                var modal = new bootstrap.Modal(modalEl);
                modal.show();
            })
        })
    });
</script>
</body>
</html>