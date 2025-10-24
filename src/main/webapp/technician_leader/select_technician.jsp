<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="crm.common.model.Staff" %>
<%@ page import="crm.common.model.Request" %>
<%@ page import="crm.common.model.Customer" %>
<%@ page import="crm.common.model.Contract" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Technician - Task Assignment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/task/select-technician.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../components/teach_lead_header.jsp"/>
<div class="container-fluid mt-4">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-person-plus"></i> Assign Tasks to Technician
                    </h5>
                </div>
                <div class="card-body">

                    <div class="filter-section mb-4">
                        <h5 class="mb-3">
                            <i class="bi bi-funnel"></i> Search & Filter Technicians
                        </h5>
                        <form id="filterForm" method="post"
                              action="${pageContext.request.contextPath}/task/selectTechnician">
                            <c:forEach var="taskId" items="${selectedTaskIds}">
                                <input type="hidden" name="selectedTasks" value="${taskId}">
                            </c:forEach>

                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label for="searchName" class="form-label">Search by Name/ID</label>
                                    <input type="text" class="form-control" id="searchName" name="searchName"
                                           value="${searchName}" placeholder="Enter name or Staff ID...">
                                </div>
                                <div class="col-md-3">
                                    <label for="filterLocation" class="form-label">Location</label>
                                    <select class="form-select" id="filterLocation" name="location">
                                        <option value="">All Locations</option>
                                        <c:forEach var="loc" items="${availableLocations}">
                                            <option value="${loc}" ${selectedLocation == loc ? 'selected' : ''}>${loc}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="filterAge" class="form-label">Age Range</label>
                                    <select class="form-select" id="filterAge" name="ageRange">
                                        <option value="">All Ages</option>
                                        <option value="18-25" ${selectedAgeRange == '18-25' ? 'selected' : ''}>18-25
                                            years old
                                        </option>
                                        <option value="26-35" ${selectedAgeRange == '26-35' ? 'selected' : ''}>26-35
                                            years old
                                        </option>
                                        <option value="36-45" ${selectedAgeRange == '36-45' ? 'selected' : ''}>36-45
                                            years old
                                        </option>
                                        <option value="46-55" ${selectedAgeRange == '46-55' ? 'selected' : ''}>46-55
                                            years old
                                        </option>
                                        <option value="56+" ${selectedAgeRange == '56+' ? 'selected' : ''}>56+ years
                                            old
                                        </option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">&nbsp;</label>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary" id="applyFilterBtn">
                                            <i class="bi bi-search"></i> Apply Filter
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary" id="clearFilterBtn">
                                            <i class="bi bi-arrow-clockwise"></i> Clear Filter
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-4">
                            <h6 class="text-muted">Selected Tasks (${selectedRequests.size()} tasks)</h6>
                            <div class="selected-tasks-list" style="max-height: 300px; overflow-y: auto;">
                                <%
                                    List<Request> selectedRequests = (List<Request>) request.getAttribute("selectedRequests");
                                    if (selectedRequests != null) {
                                        for (Request req : selectedRequests) {
                                            Customer customer = req.getContract() != null ? req.getContract().getCustomer() : null;
                                            String customerName = customer != null ? customer.getCustomerName() : "N/A";
                                            String customerPhone = customer != null ? customer.getPhone() : "N/A";
                                %>
                                <div class="card mb-2">
                                    <div class="card-body py-2">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <strong>Request #<%= req.getRequestID() %>
                                                </strong><br>
                                                <small class="text-muted">
                                                    Customer: <%= customerName %> | Phone: <%= customerPhone %>
                                                </small>
                                            </div>
                                            <div class="col-md-4 text-end">
                                                <span class="badge bg-success">Approved</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        </div>

                        <div class="col-md-8">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="text-muted mb-0">Available Technicians (${totalCount} total)</h6>
                                <div class="d-flex align-items-center gap-2">
                                    <label class="form-label mb-0 me-2">Show:</label>
                                    <select class="form-select page-size-selector" id="pageSize" style="width: auto;">
                                        <option value="5">5</option>
                                        <option value="10" selected>10</option>
                                        <option value="15">15</option>
                                        <option value="20">20</option>
                                    </select>
                                    <span class="text-muted ms-2">per page</span>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/task/processAssignment" method="post">
                                <%
                                    String[] selectedTaskIds = (String[]) request.getAttribute("selectedTaskIds");
                                    if (selectedTaskIds != null) {
                                        for (String taskId : selectedTaskIds) {
                                %>
                                <input type="hidden" name="selectedTasks" value="<%= taskId %>">
                                <%
                                        }
                                    }
                                %>

                                <div class="technician-list" style="max-height: 400px; overflow-y: auto;">
                                    <%
                                        List<Staff> technicians = (List<Staff>) request.getAttribute("technicians");
                                        if (technicians != null && !technicians.isEmpty()) {
                                    %>
                                    <table class="table table-bordered table-hover align-middle">
                                        <thead class="table-light">
                                        <tr>
                                            <th>Select</th>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Phone</th>
                                            <th>Email</th>
                                            <th>Address</th>
                                            <th>Date of Birth</th>
                                            <th>Actions</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <% for (Staff tech : technicians) { %>
                                        <tr>
                                            <td class="text-center">
                                                <input class="form-check-input" type="radio" name="selectedTechnician"
                                                       value="<%= tech.getAccount().getUsername() %>"
                                                       id="tech_<%= tech.getStaffID() %>">
                                            </td>
                                            <td><%= tech.getStaffID() %>
                                            </td>
                                            <td><%= tech.getStaffName() %>
                                            </td>
                                            <td><a href="tel:<%= tech.getPhone() %>"><%= tech.getPhone() %>
                                            </a></td>
                                            <td><a href="mailto:<%= tech.getEmail() %>"><%= tech.getEmail() %>
                                            </a></td>
                                            <td><%= tech.getAddress() != null ? tech.getAddress() : "" %>
                                            </td>
                                            <td><%= tech.getDateOfBirth() != null ? tech.getDateOfBirth() : "" %>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-sm btn-outline-primary"
                                                        onclick="viewTech('<%= tech.getStaffID() %>')">
                                                    View
                                                </button>
                                            </td>

                                        </tr>
                                        <% } %>
                                        </tbody>
                                    </table>
                                    <%
                                    } else {
                                    %>
                                    <div class="alert alert-warning text-center py-4">
                                        <i class="bi bi-exclamation-triangle fs-1 text-warning mb-3"></i>
                                        <h5 class="alert-heading">No Technicians Available</h5>
                                        <p class="mb-0">There are currently no technicians available for task
                                            assignment.</p>
                                    </div>
                                    <%
                                        }
                                    %>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                                        <i class="bi bi-arrow-left"></i> Back
                                    </button>
                                    <button type="submit" class="btn btn-primary" id="assignBtn">
                                        <i class="bi bi-check-circle"></i> Assign Tasks
                                    </button>
                                </div>
                            </form>

                            <!-- Pagination -->
                            <div class="d-flex justify-content-between align-items-center mt-4">
                                <div class="text-muted">
                                    Showing <span id="showingStart">${((currentPage - 1) * recordsPerPage) + 1}</span>
                                    to
                                    <span id="showingEnd">${currentPage * recordsPerPage > totalCount ? totalCount : currentPage * recordsPerPage}</span>
                                    of
                                    <span id="showingTotal">${totalCount}</span> entries
                                </div>
                                <nav aria-label="Technician pagination">
                                    <ul class="pagination mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}" id="firstPageItem">
                                            <a class="page-link" href="#" data-page="1">
                                                <i class="bi bi-chevron-double-left"></i>
                                            </a>
                                        </li>
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}" id="prevPageItem">
                                            <a class="page-link" href="#" data-page="${currentPage - 1}">
                                                <i class="bi bi-chevron-left"></i>
                                            </a>
                                        </li>
                                        <li class="page-item active">
                                                <span class="page-link">
                                                    Page <span id="currentPageNum">${currentPage}</span> of
                                                    <span id="totalPages">${totalPages}</span>
                                                </span>
                                        </li>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}"
                                            id="nextPageItem">
                                            <a class="page-link" href="#" data-page="${currentPage + 1}">
                                                <i class="bi bi-chevron-right"></i>
                                            </a>
                                        </li>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}"
                                            id="lastPageItem">
                                            <a class="page-link" href="#" data-page="${totalPages}">
                                                <i class="bi bi-chevron-double-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/task/select-technician.js"></script>
</body>
</html>