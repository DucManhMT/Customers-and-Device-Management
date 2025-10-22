<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="crm.common.model.Request" %>
<%@ page import="crm.common.model.Customer" %>
<%@ page import="crm.common.model.Contract" %>
<%@ page import="crm.common.model.Account" %>
<%@ page import="crm.common.model.enums.RequestStatus" %>
<%@ page import="java.time.*, java.time.format.DateTimeFormatter" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Detail</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/task/taskDetail.css">
</head>
<body>
    <%
        Request task = (Request) request.getAttribute("task");
        Customer customer = (Customer) request.getAttribute("customer");
        Contract contract = (Contract) request.getAttribute("contract");
        List<Account> assignedAccounts = (List<Account>) request.getAttribute("assignedAccounts");
    %>
    
    <div class="container">
        <div class="header">
            <h1>
                <i class="fas fa-tasks"></i>
                Task Detail
            </h1>
            <p class="subtitle">Detailed information about your assigned task</p>
        </div>
        
        <div class="content">
            <% if (task != null) { %>
                <div class="task-info-grid">
                    <div class="info-card">
                        <h3>
                            <i class="fas fa-info-circle"></i>
                            Task Information
                        </h3>
                        <div class="info-item">
                            <span class="info-label">Task ID:</span>
                            <span class="info-value">#<%= task.getRequestID() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Status:</span>
                            <span class="info-value">
                                <% 
                                    String statusClass = "status-default";
                                    if (RequestStatus.Approved.equals(task.getRequestStatus())) {
                                        statusClass = "status-approved";
                                    } else if (RequestStatus.Finished.equals(task.getRequestStatus())) {
                                        statusClass = "status-finished";
                                    }
                                %>
                                <span class="status-badge <%= statusClass %>">
                                    <%= task.getRequestStatus() %>
                                </span>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Start Date:</span>
                            <span class="info-value">
                                <%= task.getStartDate() != null ? formatter.format(task.getStartDate()) : "Not set" %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Finished Date:</span>
                            <span class="info-value">
                                <%= task.getFinishedDate() != null ? formatter.format(task.getFinishedDate()) : "Not finished" %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-card">
                        <h3>
                            <i class="fas fa-user"></i>
                            Customer & Contract
                        </h3>
                        <% if (customer != null) { %>
                            <div class="info-item">
                                <span class="info-label">Customer:</span>
                                <span class="info-value"><%= customer.getCustomerName() != null ? customer.getCustomerName() : "N/A" %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Phone:</span>
                                <span class="info-value"><%= customer.getPhone() != null ? customer.getPhone() : "N/A" %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Email:</span>
                                <span class="info-value"><%= customer.getEmail() != null ? customer.getEmail() : "N/A" %></span>
                            </div>
                        <% } %>
                        <% if (contract != null) { %>
                            <div class="info-item">
                                <span class="info-label">Contract ID:</span>
                                <span class="info-value">#<%= contract.getContractID() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Contract Start:</span>
                                <span class="info-value">
                                    <%= contract.getStartDate() != null ? contract.getStartDate().toString() : "N/A" %>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Contract End:</span>
                                <span class="info-value">
                                    <%= contract.getExpiredDate() != null ? contract.getExpiredDate().toString() : "N/A" %>
                                </span>
                            </div>
                        <% } %>
                        <% if (customer == null && contract == null) { %>
                            <div class="info-item">
                                <span class="info-value" style="color: #999; font-style: italic;">No customer/contract information available</span>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <div class="description-section">
                    <h3>
                        <i class="fas fa-file-alt"></i>
                        Task Description
                    </h3>
                    <div class="description-text">
                        <%= task.getRequestDescription() != null ? task.getRequestDescription() : "No description provided" %>
                    </div>
                </div>
                
                <% if (task.getNote() != null && !task.getNote().trim().isEmpty()) { %>
                <div class="description-section">
                    <h3>
                        <i class="fas fa-sticky-note"></i>
                        Additional Notes
                    </h3>
                    <div class="description-text">
                        <%= task.getNote() %>
                    </div>
                </div>
                <% } %>
                
                <% if (assignedAccounts != null && !assignedAccounts.isEmpty()) { %>
                <div class="info-card">
                    <h3>
                        <i class="fas fa-users"></i>
                        Assigned Technicians
                    </h3>
                    <% for (Account account : assignedAccounts) { %>
                        <div class="info-item">
                            <span class="info-label">Username:</span>
                            <span class="info-value"><%= account.getUsername() %></span>
                        </div>
                    <% } %>
                </div>
                <% } %>
                
                <div class="action-buttons">
                    
                    <% if (RequestStatus.Approved.equals(task.getRequestStatus())) { %>
                        <form method="POST" action="${pageContext.request.contextPath}/task/updateStatus" style="display: inline;" 
                              onsubmit="return confirm('Are you sure you want to mark this task as finished?')">
                            <input type="hidden" name="requestId" value="<%= task.getRequestID() %>">
                            <input type="hidden" name="status" value="finished">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check"></i>
                                Mark as Finished
                            </button>
                        </form>
                    <% } else if (RequestStatus.Finished.equals(task.getRequestStatus())) { %>
                        <button class="btn btn-secondary" disabled>
                            <i class="fas fa-check-circle"></i>
                            Task Completed
                        </button>
                    <% } %>
                    <a href="${pageContext.request.contextPath}/technician_employee/techemployee_actioncenter"
                       class="btn home-button">
                        <span>Back to Action Center</span>
                    </a>
                </div>
                
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Task Not Found</h3>
                    <p>The requested task could not be found or you don't have permission to view it.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>