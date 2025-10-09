<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Technician Management - View Technicians</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link
      href="${pageContext.request.contextPath}/css/viewTechnicianList.css"
      rel="stylesheet"
    />
  </head>
  <body>
    <div class="container-fluid">
      <div class="header-section">
        <div class="container">
          <div class="text-center">
            <h1 class="display-4 fw-bold mb-2">
              <i class="bi bi-people-fill"></i> Technician Management
            </h1>
          </div>
        </div>
      </div>

      <div class="container">
        <div
          class="alert alert-info mb-4"
          id="assignmentModeAlert"
          style="display: none"
        >
          <div class="d-flex align-items-center">
            <i class="bi bi-info-circle me-3 fs-4"></i>
            <div class="flex-grow-1">
              <h5 class="alert-heading mb-1">Assignment Mode</h5>
              <div id="selectedTaskInfo">
                You are assigning a task to a technician
              </div>
            </div>
            <button
              class="btn btn-outline-secondary btn-sm"
            >
              <i class="bi bi-x-lg me-1"></i>Cancel Assignment
            </button>
          </div>
        </div>

        <c:choose>
          <c:when test="${techEmployees != null}">
            
        <div class="row g-4 mb-4">
          <div class="col-md-4">
            <div class="card dashboard-card text-center">
              <div class="card-body">
                <div class="card-icon text-primary">
                  <i class="bi bi-people"></i>
                </div>
                <h3 class="fw-bold text-dark" id="totalTechnicians">
                  <c:choose>
                    <c:when test="${not empty totalCount}">${totalCount}</c:when>
                    <c:otherwise>0</c:otherwise>
                  </c:choose>
                </h3>
                <p class="text-muted mb-0">Total Technicians</p>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card dashboard-card text-center">
              <div class="card-body">
                <div class="card-icon text-success">
                  <i class="bi bi-telephone"></i>
                </div>
                <h3 class="fw-bold text-dark" id="verifiedContacts">
                  <c:choose>
                    <c:when test="${not empty totalCount}">${totalCount}</c:when>
                    <c:otherwise>0</c:otherwise>
                  </c:choose>
                </h3>
                <p class="text-muted mb-0">Verified Contacts</p>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card dashboard-card text-center">
              <div class="card-body">
                <div class="card-icon text-warning">
                  <i class="bi bi-envelope"></i>
                </div>
                <h3 class="fw-bold text-dark" id="emailContacts">
                  <c:choose>
                    <c:when test="${not empty totalCount}">${totalCount}</c:when>
                    <c:otherwise>0</c:otherwise>
                  </c:choose>
                </h3>
                <p class="text-muted mb-0">Email Registered</p>
              </div>
            </div>
          </div>
        </div>

        <div class="filter-section">
          <h5 class="mb-3">
            <i class="bi bi-funnel"></i> Search & Filter Technicians
          </h5>
          <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/tech/employees">
          <div class="row g-3">
            <div class="col-md-3">
              <label for="searchName" class="form-label"
                >Search by Name/ID</label
              >
              <input
                type="text"
                class="form-control"
                id="searchName"
                name="searchName"
                value="${searchName}"
                placeholder="Enter name or Staff ID..."
              />
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
                <option value="18-25" ${selectedAgeRange == '18-25' ? 'selected' : ''}>18-25 years old</option>
                <option value="26-35" ${selectedAgeRange == '26-35' ? 'selected' : ''}>26-35 years old</option>
                <option value="36-45" ${selectedAgeRange == '36-45' ? 'selected' : ''}>36-45 years old</option>
                <option value="46-55" ${selectedAgeRange == '46-55' ? 'selected' : ''}>46-55 years old</option>
                <option value="56+" ${selectedAgeRange == '56+' ? 'selected' : ''}>56+ years old</option>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">&nbsp;</label>
              <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary" id="applyFilterBtn">
                  <i class="bi bi-search"></i> Apply Filter
                </button>
                <button
                  type="button"
                  class="btn btn-outline-secondary"
                  id="clearFilterBtn"
                >
                  <i class="bi bi-arrow-clockwise"></i> Clear Filter
                </button>
              </div>
            </div>
          </div>
          </form>
        </div>

        <div class="card">
          <div
            class="card-header d-flex justify-content-between align-items-center"
          >
            <h5 class="mb-0">
              <i class="bi bi-list-ul"></i> Technician List (<span
                id="totalCount"
                ><c:choose>
                  <c:when test="${not empty totalCount}">${totalCount}</c:when>
                  <c:otherwise>0</c:otherwise>
                </c:choose></span>
              technicians)
            </h5>
            <div class="d-flex align-items-center gap-2">
              <label class="form-label mb-0 me-2">Show:</label>
              <select class="form-select page-size-selector" id="pageSize">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="15">15</option>
                <option value="20">20</option>
              </select>
              <span class="text-muted ms-2">per page</span>
            </div>
          </div>

          <div class="table-responsive">
            <table class="table table-hover mb-0">
              <thead>
                <tr>
                  <th>Technician</th>
                  <th>Staff ID</th>
                  <th>Contact Info</th>
                  <th>Address</th>
                  <th>Date of Birth</th>
                  <th>Role</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody id="techniciansTableBody">
                <c:choose>
                  <c:when test="${not empty techEmployees}">
                    <c:forEach items="${techEmployees}" var="employee" varStatus="status">
                      <tr>
                        <td>
                          <div class="d-flex align-items-center">
                            <c:choose>
                              <c:when test="${not empty employee.image}">
                                <img
                                  src="../assets/${employee.image}"
                                  alt="${employee.staffName}"
                                  class="technician-avatar me-3"
                                />
                              </c:when>
                              <c:otherwise>
                                <div class="technician-avatar me-3 d-flex align-items-center justify-content-center bg-primary text-white">
                                  <i class="bi bi-person-fill"></i>
                                </div>
                              </c:otherwise>
                            </c:choose>
                            <div>
                              <div class="fw-bold">${employee.staffName}</div>
                              <small class="text-muted">Tech Employee</small>
                            </div>
                          </div>
                        </td>
                        <td><span class="badge bg-primary">${employee.staffID}</span></td>
                        <td>
                          <div class="small">
                            <div>
                              <i class="bi bi-envelope me-1"></i>
                              <a href="mailto:${employee.email}" class="text-decoration-none">${employee.email}</a>
                            </div>
                            <div>
                              <i class="bi bi-telephone me-1"></i>
                              <a href="tel:${employee.phone}" class="text-decoration-none">${employee.phone}</a>
                            </div>
                          </div>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty employee.address}">
                              <div class="small">${employee.address}</div>
                              <small class="text-muted">Address</small>
                            </c:when>
                            <c:otherwise>
                              <small class="text-muted">No address</small>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty employee.dateOfBirth}">
                              <div class="fw-bold">${employee.dateOfBirth}</div>
                              <small class="text-muted">Date of Birth</small>
                            </c:when>
                            <c:otherwise>
                              <small class="text-muted">Not provided</small>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <div class="fw-bold">Tech Employee</div>
                          <small class="text-success">
                            <i class="bi bi-check-circle me-1"></i>ROLE
                          </small>
                        </td>
                        <td>
                          <div class="d-flex gap-2">
                            <button
                              class="btn btn-sm btn-outline-primary"
                              onclick="viewEmployeeDetail('${employee.staffID}')"
                            >
                              <i class="bi bi-eye"></i> View
                            </button>
                            <button
                              class="btn btn-sm btn-outline-success"
                              id="assign-btn-${employee.staffID}"
                            >
                              <i class="bi bi-clipboard-plus"></i>
                              <span class="assign-text">Assign</span>
                            </button>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr>
                      <td colspan="7" class="text-center py-4">
                        <div class="text-muted">
                          <i class="bi bi-people fs-1"></i>
                          <h5 class="mt-2">No Tech Employees Found</h5>
                          <p>There are currently no employees with role ID 5 in the system.</p>
                        </div>
                      </td>
                    </tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>

          <div class="card-footer">
            <div class="d-flex justify-content-between align-items-center">
              <div class="text-muted">
                Showing <span id="showingStart">${((currentPage - 1) * pageSize) + 1}</span> to
                <span id="showingEnd">${currentPage * pageSize > totalCount ? totalCount : currentPage * pageSize}</span> of
                <span id="showingTotal">${totalCount}</span> entries
              </div>
              <nav aria-label="Technician pagination">
                <ul class="pagination mb-0">
                  <li class="page-item ${currentPage == 1 ? 'disabled' : ''}" id="firstPageItem">
                    <a class="page-link" href="${currentPage > 1 ? '?page=1' : '#'}">
                      <i class="bi bi-chevron-double-left"></i>
                    </a>
                  </li>
                  <li class="page-item ${currentPage == 1 ? 'disabled' : ''}" id="prevPageItem">
                    <a class="page-link" href="${currentPage > 1 ? '?page='.concat(currentPage - 1) : '#'}">
                      <i class="bi bi-chevron-left"></i>
                    </a>
                  </li>
                  <li class="page-item active">
                    <span class="page-link">
                      Page <span id="currentPageNum">${currentPage}</span> of
                      <span id="totalPages">${totalPages}</span>
                    </span>
                  </li>
                  <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}" id="nextPageItem">
                    <a class="page-link" href="${currentPage < totalPages ? '?page='.concat(currentPage + 1) : '#'}">
                      <i class="bi bi-chevron-right"></i>
                    </a>
                  </li>
                  <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}" id="lastPageItem">
                    <a class="page-link" href="${currentPage < totalPages ? '?page='.concat(totalPages) : '#'}">
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
    
          </c:when>
          <c:otherwise>
            <div class="row justify-content-center">
              <div class="col-md-8">
                <div class="card">
                  <div class="card-body text-center py-5">
                    <div class="text-primary mb-3">
                      <i class="bi bi-info-circle" style="font-size: 3rem;"></i>
                    </div>
                    <h4 class="card-title">Data Not Loaded</h4>
                    <p class="card-text text-muted">
                      Please use the proper navigation to access the tech employee list.
                    </p>
                    <div class="mt-4">
                      <a href="${pageContext.request.contextPath}/tech/employees" class="btn btn-primary">
                        <i class="bi bi-arrow-right me-2"></i>
                        Load Tech Employees
                      </a>
                      <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary ms-2">
                        <i class="bi bi-house me-2"></i>
                        Back to Home
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </c:otherwise>
        </c:choose>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
      function viewEmployeeDetail(staffID) {
        window.location.href = '${pageContext.request.contextPath}/tech/employees/view?id=' + staffID;
      }
      
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
      
      function updatePaginationLinks() {
        const searchName = document.getElementById('searchName').value;
        const location = document.getElementById('filterLocation').value;
        const ageRange = document.getElementById('filterAge').value;
        const recordsPerPage = document.getElementById('pageSize').value;
        
        let filterParams = '';
        if (searchName) filterParams += '&searchName=' + encodeURIComponent(searchName);
        if (location) filterParams += '&location=' + encodeURIComponent(location);
        if (ageRange) filterParams += '&ageRange=' + encodeURIComponent(ageRange);
        if (recordsPerPage) filterParams += '&recordsPerPage=' + encodeURIComponent(recordsPerPage);
        
        const paginationLinks = document.querySelectorAll('.pagination .page-link');
        paginationLinks.forEach(link => {
          if (link.href && link.href.includes('?page=')) {
            const url = new URL(link.href);
            if (searchName) url.searchParams.set('searchName', searchName);
            if (location) url.searchParams.set('location', location);
            if (ageRange) url.searchParams.set('ageRange', ageRange);
            if (recordsPerPage) url.searchParams.set('recordsPerPage', recordsPerPage);
            link.href = url.toString();
          }
        });
      }
      
      document.addEventListener('DOMContentLoaded', function() {
        console.log('Tech employees loaded: ${totalCount}');
        
        // Remove automatic search input filtering - only filter when Apply Filter button is clicked
        document.getElementById('clearFilterBtn').addEventListener('click', clearFilters);
        document.getElementById('applyFilterBtn').addEventListener('click', applyFilters);
        
        const pageSizeSelector = document.getElementById('pageSize');
        if (pageSizeSelector) {
          pageSizeSelector.addEventListener('change', updatePageSize);
          
          <c:if test="${not empty recordsPerPage}">
            pageSizeSelector.value = '${recordsPerPage}';
          </c:if>
        }
        
        updatePaginationLinks();
        
        // Remove automatic filtering - only filter when Apply Filter button is clicked
        
        showFilterSummary();
      });
      
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
      
      function clearFilters() {
        document.getElementById('searchName').value = '';
        document.getElementById('filterLocation').value = '';
        document.getElementById('filterAge').value = '';
        
        document.getElementById('filterForm').submit();
      }
    </script>
  </body>
</html>
