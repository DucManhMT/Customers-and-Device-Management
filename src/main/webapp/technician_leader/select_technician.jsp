<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<jsp:include page="../components/header.jsp"/>
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
                                <c:forEach var="req" items="${selectedRequests}">
                                    <div class="card mb-2">
                                        <div class="card-body py-2">
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <strong>Request #${req.requestID}</strong><br>
                                                    <small class="text-muted">
                                                        Customer: ${req.contract != null ? req.contract.customer.customerName : 'N/A'} | 
                                                        Phone: ${req.contract != null ? req.contract.customer.phone : 'N/A'}
                                                    </small>
                                                </div>
                                                <div class="col-md-4 text-end">
                                                    <span class="badge bg-success">Approved</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="col-md-8">
                            <!-- Weekly calendar showing technicians' schedules -->
                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h6 class="mb-0"><i class="bi bi-calendar-week"></i> Weekly Schedule</h6>
                                        <div>
                                            <a class="btn btn-sm btn-outline-secondary me-2" href="#" onclick="goToWeek('${prevWeekStart}'); return false;">Prev</a>
                                            <a class="btn btn-sm btn-outline-secondary" href="#" onclick="goToWeek('${nextWeekStart}'); return false;">Next</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body p-2">
                                    <c:if test="${not empty weekDays}">
                                        <div style="overflow-x:auto;">
                                            <table class="table table-sm table-bordered mb-0 align-middle schedule-table">
                                                <thead class="table-light">
                                                <tr>
                                                    <th style="min-width:200px">Technician</th>
                                                    <c:forEach var="day" items="${weekDays}">
                                                        <th style="min-width:120px">${day}</th>
                                                    </c:forEach>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="tech" items="${technicians}">
                                                    <tr>
                                                        <td><strong>${tech.staffName}</strong><br/><small>${tech.account.username}</small></td>
                                                        <c:forEach var="i" begin="0" end="${fn:length(weekDays) - 1}">
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty techSchedules[tech.account.username] and techSchedules[tech.account.username][i] != null}">
                                                                        <div class="schedule-cell" data-full="${techSchedules[tech.account.username][i]}">
                                                                            <c:out value="${techSchedules[tech.account.username][i]}" escapeXml="false" />
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="schedule-cell schedule-empty">—</div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </c:forEach>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty weekDays}">
                                        <div class="text-muted small">No schedule data for the selected week.</div>
                                    </c:if>
                                </div>
                            </div>
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
                                <c:forEach var="taskId" items="${selectedTaskIds}">
                                    <input type="hidden" name="selectedTasks" value="${taskId}">
                                </c:forEach>

                                <div class="technician-list" style="max-height: 400px; overflow-y: auto;">
                                    <c:choose>
                                        <c:when test="${not empty technicians}">
                                            <table class="table table-bordered table-hover align-middle">
                                                <thead class="table-light">
                                                <tr>
                                                    <th width="50">
                                                        <input class="form-check-input" type="checkbox" id="selectAllTechs">
                                                    </th>
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
                                                <c:forEach var="tech" items="${technicians}">
                                                    <tr>
                                                        <td class="text-center">
                                                            <input class="form-check-input tech-checkbox" type="checkbox" 
                                                                   name="selectedTechnicians" 
                                                                   value="${tech.account.username}"
                                                                   id="tech_${tech.staffID}">
                                                        </td>
                                                        <td>${tech.staffID}</td>
                                                        <td>${tech.staffName}</td>
                                                        <td><a href="tel:${tech.phone}">${tech.phone}</a></td>
                                                        <td><a href="mailto:${tech.email}">${tech.email}</a></td>
                                                        <td>${tech.address != null ? tech.address : ''}</td>
                                                        <td>${tech.dateOfBirth != null ? tech.dateOfBirth : ''}</td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-sm btn-outline-primary"
                                                                    onclick="viewTech('${tech.staffID}')">
                                                                View
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-warning text-center py-4">
                                                <i class="bi bi-exclamation-triangle fs-1 text-warning mb-3"></i>
                                                <h5 class="alert-heading">No Technicians Available</h5>
                                                <p class="mb-0">There are currently no technicians available for task assignment.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <div id="selectedCount" class="text-muted">
                                        <i class="bi bi-check-square"></i> Selected: <strong>0</strong> technician(s)
                                    </div>
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                                            <i class="bi bi-arrow-left"></i> Back
                                        </button>
                                        <button type="submit" class="btn btn-primary" id="assignBtn">
                                            <i class="bi bi-check-circle"></i> Assign Tasks
                                        </button>
                                    </div>
                                </div>
                            </form>

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
<script src="${pageContext.request.contextPath}/js/select_technician.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const clearBtn = document.getElementById('clearFilterBtn');
        const form = document.getElementById('filterForm');
        if (!clearBtn || !form) return;

        clearBtn.addEventListener('click', function () {
            const searchName = document.getElementById('searchName');
            const filterLocation = document.getElementById('filterLocation');
            const filterAge = document.getElementById('filterAge');

            if (searchName) searchName.value = '';
            if (filterLocation) filterLocation.selectedIndex = 0;
            if (filterAge) filterAge.selectedIndex = 0;

            const pageInput = form.querySelector('input[name="page"]');
            if (pageInput) pageInput.value = '1';

            form.submit();
        });
    });

    // Validate form - require at least one technician selected
    document.getElementById('assignBtn').addEventListener('click', function(e) {
        const selectedTechs = document.querySelectorAll('input[name="selectedTechnicians"]:checked');
        if (selectedTechs.length === 0) {
            e.preventDefault();
            alert('Please select at least one technician to assign the tasks.');
            return false;
        }
    });
    
    // Select All / Deselect All functionality
    document.addEventListener('DOMContentLoaded', function() {
        const selectAllCheckbox = document.getElementById('selectAllTechs');
        const techCheckboxes = document.querySelectorAll('.tech-checkbox');
        const selectedCountSpan = document.querySelector('#selectedCount strong');
        
        // Update selected count
        function updateSelectedCount() {
            const checkedCount = document.querySelectorAll('.tech-checkbox:checked').length;
            selectedCountSpan.textContent = checkedCount;
        }
        
        // Select All functionality
        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', function() {
                techCheckboxes.forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
                updateSelectedCount();
            });
        }
        
        // Individual checkbox change
        techCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                // Update Select All checkbox state
                const allChecked = Array.from(techCheckboxes).every(cb => cb.checked);
                const someChecked = Array.from(techCheckboxes).some(cb => cb.checked);
                
                if (selectAllCheckbox) {
                    selectAllCheckbox.checked = allChecked;
                    selectAllCheckbox.indeterminate = someChecked && !allChecked;
                }
                
                updateSelectedCount();
            });
        });
        
        // Initial count
        updateSelectedCount();
    });
        
        function clearFilters() {
            document.getElementById('searchName').value = '';
            document.getElementById('filterLocation').value = '';
            document.getElementById('filterAge').value = '';
            document.getElementById('filterForm').submit();
        }
        
        function applyFilters() {
            document.getElementById('filterForm').submit();
        }
        
        function updatePageSize() {
            const pageSize = document.getElementById('pageSize').value;
            const form = document.getElementById('filterForm');
            
            let pageSizeInput = document.querySelector('input[name="recordsPerPage"]');
            if (!pageSizeInput) {
                pageSizeInput = document.createElement('input');
                pageSizeInput.type = 'hidden';
                pageSizeInput.name = 'recordsPerPage';
                form.appendChild(pageSizeInput);
            }
            pageSizeInput.value = pageSize;
            
            let pageInput = document.querySelector('input[name="page"]');
            if (!pageInput) {
                pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'page';
                form.appendChild(pageInput);
            }
            pageInput.value = '1';
            
            form.submit();
        }
        
        function goToPage(page) {
            const searchName = document.getElementById('searchName').value;
            const location = document.getElementById('filterLocation').value;
            const ageRange = document.getElementById('filterAge').value;
            const recordsPerPage = document.getElementById('pageSize').value;
            
            let url = '${pageContext.request.contextPath}/task/selectTechnician?page=' + page;
            
            <c:forEach var="taskId" items="${selectedTaskIds}">
                url += '&selectedTasks=${taskId}';
            </c:forEach>
            <c:if test="${not empty param.weekStart}">
                url += '&weekStart=${param.weekStart}';
            </c:if>
            
            if (searchName) url += '&searchName=' + encodeURIComponent(searchName);
            if (location) url += '&location=' + encodeURIComponent(location);
            if (ageRange) url += '&ageRange=' + encodeURIComponent(ageRange);
            if (recordsPerPage) url += '&recordsPerPage=' + encodeURIComponent(recordsPerPage);
            
            window.location.href = url;
            return false;
        }

        function goToWeek(weekStart) {
            const searchName = document.getElementById('searchName').value;
            const location = document.getElementById('filterLocation').value;
            const ageRange = document.getElementById('filterAge').value;
            const recordsPerPage = document.getElementById('pageSize').value;

            let url = '${pageContext.request.contextPath}/task/selectTechnician?weekStart=' + encodeURIComponent(weekStart);

            <c:forEach var="taskId" items="${selectedTaskIds}">
                url += '&selectedTasks=${taskId}';
            </c:forEach>

            if (searchName) url += '&searchName=' + encodeURIComponent(searchName);
            if (location) url += '&location=' + encodeURIComponent(location);
            if (ageRange) url += '&ageRange=' + encodeURIComponent(ageRange);
            if (recordsPerPage) url += '&recordsPerPage=' + encodeURIComponent(recordsPerPage);

            // reset to first page for new week
            url += '&page=1';

            window.location.href = url;
            return false;
        }
        
        function buildPaginationUrl(page) {
            const searchName = document.getElementById('searchName').value;
            const location = document.getElementById('filterLocation').value;
            const ageRange = document.getElementById('filterAge').value;
            const recordsPerPage = document.getElementById('pageSize').value;
            
            let url = '${pageContext.request.contextPath}/task/selectTechnician?page=' + page;
            
            <c:forEach var="taskId" items="${selectedTaskIds}">
                url += '&selectedTasks=${taskId}';
            </c:forEach>
            <c:if test="${not empty param.weekStart}">
                url += '&weekStart=${param.weekStart}';
            </c:if>
            
            if (searchName) url += '&searchName=' + encodeURIComponent(searchName);
            if (location) url += '&location=' + encodeURIComponent(location);
            if (ageRange) url += '&ageRange=' + encodeURIComponent(ageRange);
            if (recordsPerPage) url += '&recordsPerPage=' + encodeURIComponent(recordsPerPage);
            
            return url;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Technicians loaded: ${totalCount}');
            
            document.getElementById('clearFilterBtn').addEventListener('click', clearFilters);
            document.getElementById('applyFilterBtn').addEventListener('click', applyFilters);
            
            const pageSizeSelector = document.getElementById('pageSize');
            if (pageSizeSelector) {
                pageSizeSelector.addEventListener('change', updatePageSize);
                
                <c:if test="${not empty recordsPerPage}">
                    pageSizeSelector.value = '${recordsPerPage}';
                </c:if>
            }
            
            const paginationLinks = document.querySelectorAll('.pagination .page-link[data-page]');
            paginationLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const page = this.getAttribute('data-page');
                    goToPage(parseInt(page));
                });
            });
            
            showFilterSummary();
        });
        
     
        function viewTech(staffId) {
            const form = document.createElement('form');
            form.method = 'post';
            form.action = '${pageContext.request.contextPath}/tech/employees/view';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'id';
            input.value = staffId;
            form.appendChild(input);

            document.body.appendChild(form);
            form.submit();
        }


        function showFilterSummary() {
            const searchName = document.getElementById('searchName').value;
            const location = document.getElementById('filterLocation').value;
            const ageRange = document.getElementById('filterAge').value;
            
            if (searchName || location || ageRange) {
                let summary = 'Active filters: ';
                const filters = [];
                
                if (searchName) filters.push('Search: "' + searchName + '"');
                if (location) filters.push('Location: "' + location + '"');
                if (ageRange) {
                    const ageText = document.querySelector('#filterAge option[value="' + ageRange + '"]').textContent;
                    filters.push('Age: "' + ageText + '"');
                }
                
                summary += filters.join(', ');
                
                let filterSummary = document.getElementById('filterSummary');
                if (!filterSummary) {
                    filterSummary = document.createElement('div');
                    filterSummary.id = 'filterSummary';
                    filterSummary.className = 'alert alert-info alert-dismissible fade show mt-2';
                    filterSummary.innerHTML = '<i class="bi bi-info-circle me-2"></i><span id="filterSummaryText"></span>';
                    document.querySelector('.filter-section').appendChild(filterSummary);
                }
                
                document.getElementById('filterSummaryText').textContent = summary;
                filterSummary.style.display = 'block';
            } else {
                const filterSummary = document.getElementById('filterSummary');
                if (filterSummary) {
                    filterSummary.style.display = 'none';
                }
            }
        }
</script>
</body>
</html>