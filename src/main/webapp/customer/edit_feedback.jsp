<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Edit Feedback</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feedback/edit_feedback.css" />
    <style>
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body{
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
           min-height: 100vh;
            padding: 40px 20px;
            position: relative;
            overflow-x: hidden;
        }
        body::before{
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 50%, rgba(168, 85, 247, 0.4) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(236, 72, 153, 0.4) 0%, transparent 50%),
                radial-gradient(circle at 40% 20%, rgba(99, 102, 241, 0.3) 0%, transparent 50%);
            pointer-events: none;
        }
        .feedback-edit-container{
            max-width: 1200px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }
        .feedback-edit-card{
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.15),
                0 0 1px rgba(0, 0, 0, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.6);
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: slideUp 0.6s ease-out;
        }
        @keyframes slideUp{
            from{
                opacity: 0;
                transform: translateY(30px);
            }
            to{
                opacity: 1;
                transform: translateY(0);
            }
        }
        .card-header{
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
            padding-bottom: 24px;
            margin-bottom: 32px;
            position: relative;
        }
        .card-header::after{
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 120px;
            height: 2px;
            background: linear-gradient(90deg, #6366f1, #8b5cf6, transparent);
        }
        .card-header h3{
            color: #1e293b;
            font-size: 2rem;
            font-weight: 800;
            margin: 0 0 10px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .card-header h3 i{
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 1.8rem;
        }
        .subtle{
            color: #64748b;
            font-size: 1rem;
            font-weight: 500;
        }
        .meta-info{
            background: linear-gradient(135deg, rgba(99,102,241,0.08), rgba(139,92,246,0.08));
            padding: 16px 20px;
            border-radius: 12px;
            border: 1px solid rgba(99,102,241,0.15);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.08);
        }
        .meta-info div{
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            color: #475569;
            font-weight: 500;
        }
        .meta-info div:last-child{
            margin-bottom: 0;
        }
        .meta-info i{
            color: #6366f1;
            font-size: 1rem;
        }
        .alert{
            border-radius: 12px;
            padding: 16px 20px;
            border: none;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1rem;
            font-weight: 500;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            animation: slideIn 0.3s ease-out;
        }
        @keyframes slideIn{
            from{
                opacity: 0;
                transform: translateX(-20px);
            }
            to{
                opacity: 1;
                transform: translateX(0);
            }
        }
        .alert i{
            font-size: 1.3rem;
        }
        .alert-danger{
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            color: #991b1b;
            border-left: 4px solid #dc2626;
        }
        .alert-danger i{
            color: #dc2626;
        }
        .alert-success{
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            color: #166534;
            border-left: 4px solid #16a34a;
        }
        .alert-success i{
            color: #16a34a;
        }
        .form-section{
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            padding: 24px;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            margin-bottom: 20px;
        }
        .form-row-flex{
            display: flex;
            gap: 24px;
            margin-bottom: 20px;
        }
        .form-section-left{
            flex: 1;
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            padding: 24px;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
        }
        .form-section-left .form-control{
            flex: 1;
            min-height: 300px;
        }
        .form-section-right{
            width: 320px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .form-label{
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1rem;
        }
        .form-label i{
            color: #6366f1;
            font-size: 1.1rem;
        }
        .original-content{
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px;
            color: #475569;
            font-size: 0.95rem;
            line-height: 1.7;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }
        .original-content::before{
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, #6366f1, #8b5cf6);
        }
        .original-content::after{
            content: 'Original';
            position: absolute;
            top: 8px;
            right: 12px;
            font-size: 0.7rem;
            font-weight: 700;
            color: #6366f1;
            background: rgba(99, 102, 241, 0.1);
            padding: 4px 10px;
            border-radius: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-control, .form-select{
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 14px 16px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
            font-family: inherit;
        }
        .form-control:focus, .form-select:focus{
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99,102,241,0.1);
            outline: none;
            transform: translateY(-1px);
        }
        .form-control{
            min-height: 180px;
            resize: vertical;
            line-height: 1.6;
        }
        .form-select{
            cursor: pointer;
            font-weight: 600;
            color: #1e293b;
        }
        .rating-interactive{
            display: flex;
            gap: 12px;
            margin-top: 16px;
            padding: 20px;
            background: white;
            border-radius: 12px;
            justify-content: center;
            border: 2px solid #e2e8f0;
        }
        .rating-interactive .star{
            font-size: 2.5rem;
            color: #e2e8f0;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
        }
        .rating-interactive .star:hover{
            transform: scale(1.3) rotate(15deg);
            filter: drop-shadow(0 4px 8px rgba(251, 191, 36, 0.4));
        }
        .rating-interactive .star.active{
            color: #fbbf24;
            transform: scale(1.1);
            filter: drop-shadow(0 4px 8px rgba(251, 191, 36, 0.5));
        }
        .rating-interactive .star.active:hover{
            transform: scale(1.3) rotate(-15deg);
        }
        .rating-text{
            text-align: center;
            margin-top: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            color: #475569;
            padding: 8px;
            background: linear-gradient(135deg, rgba(251,191,36,0.1), rgba(245,158,11,0.1));
            border-radius: 8px;
        }
        .rating-text .rating-value{
            color: #f59e0b;
            font-size: 1.5rem;
            font-weight: 800;
        }
        .tips-card{
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            border: 2px solid #fbbf24;
            border-left: 6px solid #f59e0b;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 4px 16px rgba(251, 191, 36, 0.15);
        }
        .tips-card h6{
            color: #92400e;
            font-weight: 800;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }
        .tips-card h6 i{
            color: #f59e0b;
            font-size: 1.2rem;
        }
        .tips-card p{
            color: #78350f;
            font-size: 0.9rem;
            line-height: 1.6;
            margin: 0;
        }
        .btn{
            padding: 14px 28px;
            font-weight: 700;
            font-size: 1rem;
            border-radius: 12px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            position: relative;
            overflow: hidden;
        }
        .btn::before{
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.2);
            transition: left 0.5s ease;
        }
        .btn:hover::before{
            left: 100%;
        }
        .btn i{
            font-size: 1.1rem;
        }
        .btn-primary{
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white;
            box-shadow: 0 8px 20px rgba(99,102,241,0.35);
        }
        .btn-primary:hover{
            transform: translateY(-3px);
            box-shadow: 0 12px 28px rgba(99,102,241,0.45);
        }
        .btn-primary:active{
            transform: translateY(-1px);
        }
        .btn-outline-secondary{
            background: white;
            border: 2px solid #cbd5e1;
            color: #475569;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        .btn-outline-secondary:hover{
            background: #f8fafc;
            border-color: #94a3b8;
            color: #334155;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        }
        .action-buttons{
            display: flex;
            gap: 16px;
            justify-content: center;
        }
        .action-buttons .btn{
            min-width: 180px;
        }
        @media (max-width: 992px){
            .form-row-flex{
                flex-direction: column;
            }
            .form-section-right{
                width: 100%;
            }
            .form-section-left .form-control{
                min-height: 200px;
            }
        }
        @media (max-width: 768px){
            body{
                padding: 20px 12px;
            }
            .feedback-edit-card{
                padding: 24px 20px;
                border-radius: 20px;
            }
            .card-header{
                flex-direction: column;
                gap: 16px;
            }
            .card-header h3{
                font-size: 1.5rem;
            }
            .meta-info{
                width: 100%;
            }
            .action-buttons{
                flex-direction: column;
            }
            .btn{
                width: 100%;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp" />
<jsp:include page="../components/customer_sidebar.jsp"/>
<div class="feedback-edit-container">
    <div class="feedback-edit-card">
        <div class="card-header">
            <div>
                <h3>
                    <i class="fas fa-edit"></i>
                    Edit Feedback
                </h3>
                <p class="subtle">Update your feedback for request <strong>#${feedback.requestID.foreignKeyValue}</strong></p>
            </div>
            <div class="meta-info">
                <div>
                    <i class="fas fa-user"></i>
                    By <strong><c:out value="${feedback.customerID}" default="-"/></strong>
                </div>
                <div>
                    <i class="fas fa-clock"></i>
                    Posted: <c:out value="${feedback.feedbackDate}" default="-"/>
                </div>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger mt-2" role="alert">
                <i class="fas fa-exclamation-circle"></i>
                ${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success mt-2" role="alert">
                <i class="fas fa-check-circle"></i>
                ${successMessage}
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/feedback/edit">
            <input type="hidden" name="feedbackId" value="${feedback.feedbackID}" />

            <!-- Original Content Section - Full Width -->
            <div class="form-section">
                <label class="form-label">
                    <i class="fas fa-file-alt"></i>
                    Original Feedback Content
                </label>
                <div class="original-content">
                    <c:out value="${feedback.content}" default="No content provided"/>
                </div>
            </div>

            <div class="form-row-flex">
                <div class="form-section-left">
                    <label for="description" class="form-label">
                        <i class="fas fa-comment-dots"></i>
                        Your Feedback
                    </label>
                    <textarea id="description" name="description" class="form-control" placeholder="Share your detailed feedback here..."><c:out value="${feedback.description}" default=""/></textarea>
                </div>

                <div class="form-section-right">
                    <div class="form-section">
                        <label for="rating" class="form-label">
                            <i class="fas fa-star"></i>
                            Rating
                        </label>
                        <input type="hidden" id="rating" name="rating" value="${feedback.rating}" />
                        <div class="rating-interactive" id="ratingInteractive">
                            <c:forEach var="s" begin="1" end="5">
                                <i class="fas fa-star star ${s <= feedback.rating ? 'active' : ''}" data-rating="${s}" onclick="setRating(${s})"></i>
                            </c:forEach>
                        </div>
                        <div class="rating-text" id="ratingText">
                            <span class="rating-value">${feedback.rating}</span> / 5 stars
                        </div>
                    </div>

                    <div class="tips-card">
                        <h6>
                            <i class="fas fa-lightbulb"></i>
                            Helpful tips
                        </h6>
                        <p>Be specific about the issue, include steps to reproduce and expected behavior so our team can help faster.</p>
                    </div>
                </div>
            </div>

            <div class="action-buttons">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i>
                    Save Changes
                </button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/customer/feedback/view?requestId=${feedback.requestID.foreignKeyValue}">
                    <i class="fas fa-times"></i>
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
    let currentRating = ${feedback.rating};
    
    function setRating(rating) {
        currentRating = rating;
        document.getElementById('rating').value = rating;
        document.getElementById('ratingText').querySelector('.rating-value').textContent = rating;
        
        const stars = document.querySelectorAll('#ratingInteractive .star');
        stars.forEach((star, index) => {
            if (index < rating) {
                star.classList.add('active');
            } else {
                star.classList.remove('active');
            }
        });
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        const stars = document.querySelectorAll('#ratingInteractive .star');
        const ratingContainer = document.getElementById('ratingInteractive');
        
        stars.forEach((star, index) => {
            star.addEventListener('mouseenter', function() {
                const hoverRating = index + 1;
                stars.forEach((s, i) => {
                    if (i < hoverRating) {
                        s.style.color = '#fbbf24';
                    } else {
                        s.style.color = '#e2e8f0';
                    }
                });
            });
        });
        
        ratingContainer.addEventListener('mouseleave', function() {
            stars.forEach((star, index) => {
                if (index < currentRating) {
                    star.style.color = '#fbbf24';
                } else {
                    star.style.color = '#e2e8f0';
                }
            });
        });
    });
</script>
</body>
</html>