<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Request Detail</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/task/taskDetail.css"/>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header h1 {
            margin: 0;
            font-size: 28px;
        }

        .subtitle {
            color: #666;
            margin-top: 4px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 18px;
            margin-top: 20px;
        }

        .card {
            background: #fff;
            border: 1px solid #e3e3e3;
            border-radius: 10px;
            padding: 18px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, .07);
        }

        .card h3 {
            margin-top: 0;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .item {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
            border-bottom: 1px dashed #eee;
        }

        .item:last-child {
            border-bottom: none;
        }

        .label {
            font-weight: 600;
            color: #444;
        }

        .value {
            color: #222;
            text-align: right;
        }

        .muted {
            color: #999;
            font-style: italic;
        }

        .actions {
            margin-top: 20px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            background: #007bff;
            color: #fff;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-success {
            background: #28a745;
        }

        .btn-secondary {
            background: #6c757d;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #e3e3e3;
            padding: 10px;
            text-align: left;
        }

        th {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 10px;
            font-size: 12px;
            border-radius: 14px;
            font-weight: 600;
        }

        .status-Pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-Processing {
            background: #cce5ff;
            color: #004085;
        }

        .status-Finished {
            background: #d4edda;
            color: #155724;
        }

        .status-Reject, .status-Rejected {
            background: #f8d7da;
            color: #721c24;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-top: 16px;
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
<div class="container">
    <jsp:include page="../components/header.jsp"/>

    <div class="header">
        <h1><i class="fas fa-clipboard-list"></i> Request Detail</h1>
        <p class="subtitle">Full information and related tasks</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${successMessage}</div>
    </c:if>

    <c:if test="${not empty requestObj}">
        <div class="grid">
            <div class="card">
                <h3><i class="fas fa-info-circle"></i> Request Information</h3>
                <div class="item"><span class="label">Request ID:</span><span
                        class="value">#${requestObj.requestID}</span></div>
                <div class="item"><span class="label">Status:</span><span class="value"><c:choose><c:when
                        test='${not empty requestObj.requestStatus}'><span
                        class="badge status-${requestObj.requestStatus}">${requestObj.requestStatus}</span></c:when><c:otherwise><span
                        class="muted">Unknown</span></c:otherwise></c:choose></span></div>
                <div class="item"><span class="label">Start Date:</span><span class="value"><c:choose><c:when
                        test='${not empty requestObj.startDate}'>${requestObj.startDate}</c:when><c:otherwise><span
                        class="muted">Not set</span></c:otherwise></c:choose></span></div>
                <div class="item"><span class="label">Finished Date:</span><span class="value"><c:choose><c:when
                        test='${not empty requestObj.finishedDate}'>${requestObj.finishedDate}</c:when><c:otherwise><span
                        class="muted">Not finished</span></c:otherwise></c:choose></span></div>
                <div class="item"><span class="label">Note:</span><span class="value"><c:choose><c:when
                        test='${not empty requestObj.note}'>${requestObj.note}</c:when><c:otherwise><span class="muted">No note</span></c:otherwise></c:choose></span>
                </div>
            </div>
            <div class="card">
                <h3><i class="fas fa-user"></i> Customer & Contract</h3>
                <div class="item"><span class="label">Customer Name:</span><span class="value"><c:choose><c:when
                        test='${not empty customer and not empty customer.customerName}'>${customer.customerName}</c:when><c:otherwise><span
                        class="muted">N/A</span></c:otherwise></c:choose></span></div>
                <div class="item"><span class="label">Phone:</span><span class="value"><c:choose><c:when
                        test='${not empty customer and not empty customer.phone}'>${customer.phone}</c:when><c:otherwise><span
                        class="muted">N/A</span></c:otherwise></c:choose></span></div>
                <div class="item"><span class="label">Email:</span><span class="value"><c:choose><c:when
                        test='${not empty customer and not empty customer.email}'>${customer.email}</c:when><c:otherwise><span
                        class="muted">N/A</span></c:otherwise></c:choose></span></div>
                <div class="item"><span class="label">Contract ID:</span><span class="value"><c:choose><c:when
                        test='${not empty contract and not empty contract.contractID}'>#${contract.contractID}</c:when><c:otherwise><span
                        class="muted">N/A</span></c:otherwise></c:choose></span></div>
                <div class="item"><span class="label">Contract Start:</span><span class="value"><c:choose><c:when
                        test='${not empty contract and not empty contract.startDate}'>${contract.startDate}</c:when><c:otherwise><span
                        class="muted">N/A</span></c:otherwise></c:choose></span></div>
                <div class="item"><span class="label">Contract End:</span><span class="value"><c:choose><c:when
                        test='${not empty contract and not empty contract.expiredDate}'>${contract.expiredDate}</c:when><c:otherwise><span
                        class="muted">N/A</span></c:otherwise></c:choose></span></div>
            </div>
        </div>

        <div class="card" style="margin-top: 22px;">
            <h3><i class="fas fa-tasks"></i> Related Tasks</h3>
            <c:choose>
                <c:when test='${empty tasks}'>
                    <div class="muted">No tasks found for this request.</div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                        <tr>
                            <th>Task ID</th>
                            <th>Assign To</th>
                            <th>Status</th>
                            <th>Deadline</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="t" items='${tasks}'>
                            <tr>
                                <td>#${t.taskID}</td>
                                <td>
                                    <c:choose>
                                        <c:when test='${not empty t.assignTo and not empty t.assignTo.staffName}'>${t.assignTo.staffName}</c:when>
                                        <c:otherwise><span class="muted">N/A</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test='${not empty t.status}'><span
                                                class="badge status-${t.status}">${t.status}</span></c:when>
                                        <c:otherwise><span class="muted">Unknown</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test='${not empty t.deadline}'>${t.deadline}</c:when>
                                        <c:otherwise><span class="muted">Not set</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a class="btn btn-secondary"
                                       href='${pageContext.request.contextPath}/technician_leader/tasks/detail?taskId=${t.taskID}'>
                                        <i class="fas fa-eye"></i> View Detail
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="actions">
            <c:set var="canFinish" value='${requestObj.requestStatus eq "Approved" or requestObj.requestStatus eq "Processing"}'/>
            <c:choose>
                <c:when test='${canFinish}'>
                    <form method="POST" action='${pageContext.request.contextPath}/request/finish'
                          onsubmit="return confirm('Are you sure you want to mark this request as finished?');">
                        <input type="hidden" name="requestId" value='${requestObj.requestID}'/>
                        <button type="submit" class="btn btn-success"><i class="fas fa-check"></i> Mark as Finished</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-success" disabled title="Only Approved or Processing requests can be finished">
                        <i class="fas fa-check"></i> Mark as Finished
                    </button>
                </c:otherwise>
            </c:choose>
            <a href='${pageContext.request.contextPath}/technician_leader/tasks/list' class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to List
            </a>
        </div>

    </c:if>

    <c:if test='${empty requestObj}'>
        <div class="alert alert-error"><i class="fas fa-exclamation-triangle"></i> Request not found or inaccessible.
        </div>
    </c:if>
</div>
</body>
</html>
