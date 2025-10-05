<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Technician Management - View Technicians</title>
    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- Bootstrap Icons -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
      rel="stylesheet"
    />

    <style>
      body {
        background-color: #f8f9fa;
      }

      .header-section {
        background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
        color: white;
        padding: 2rem 0;
        margin-bottom: 2rem;
      }

      .dashboard-card {
        border: none;
        border-radius: 15px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s;
      }

      .dashboard-card:hover {
        transform: translateY(-2px);
      }

      .card-icon {
        font-size: 2.5rem;
        margin-bottom: 0.5rem;
      }

      .technician-avatar {
        width: 45px;
        height: 45px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #3498db;
      }

      .specialization-badge {
        background-color: #e3f2fd;
        color: #1976d2;
        font-size: 0.75rem;
        margin: 2px;
        padding: 4px 8px;
        border-radius: 12px;
      }

      .table-responsive {
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      .table thead th {
        background-color: #2c3e50;
        color: white;
        border: none;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.8rem;
        letter-spacing: 0.5px;
      }

      .table tbody tr:hover {
        background-color: #f8f9fa;
      }

      .filter-section {
        background: white;
        border-radius: 15px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        padding: 1.5rem;
        margin-bottom: 2rem;
      }

      .page-size-selector {
        max-width: 120px;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <!-- Header Section -->
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
        <!-- Assignment Mode Alert -->
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
              onclick="cancelAssignment()"
            >
              <i class="bi bi-x-lg me-1"></i>Cancel Assignment
            </button>
          </div>
        </div>

        <!-- Dashboard Cards -->
        <div class="row g-4 mb-4">
          <div class="col-md-4">
            <div class="card dashboard-card text-center">
              <div class="card-body">
                <div class="card-icon text-primary">
                  <i class="bi bi-people"></i>
                </div>
                <h3 class="fw-bold text-dark" id="totalTechnicians">12</h3>
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
                <h3 class="fw-bold text-dark" id="verifiedContacts">12</h3>
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
                <h3 class="fw-bold text-dark" id="emailContacts">12</h3>
                <p class="text-muted mb-0">Email Registered</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Search and Filter Section -->
        <div class="filter-section">
          <h5 class="mb-3">
            <i class="bi bi-funnel"></i> Search & Filter Technicians
          </h5>
          <div class="row g-3">
            <div class="col-md-3">
              <label for="searchName" class="form-label"
                >Search by Name/ID</label
              >
              <input
                type="text"
                class="form-control"
                id="searchName"
                placeholder="Enter name or Staff ID..."
              />
            </div>
            <div class="col-md-3">
              <label for="filterLocation" class="form-label">Location</label>
              <select class="form-select" id="filterLocation">
                <option value="">All Locations</option>
                <option value="hanoi">Hanoi</option>
                <option value="hochiminh">Ho Chi Minh City</option>
                <option value="danang">Da Nang</option>
                <option value="cantho">Can Tho</option>
                <option value="haiphong">Hai Phong</option>
              </select>
            </div>
            <div class="col-md-3">
              <label for="filterTime" class="form-label">Activity Period</label>
              <select class="form-select" id="filterTime">
                <option value="">All Time</option>
                <option value="1week">Last 1 Week</option>
                <option value="1month">Last 1 Month</option>
                <option value="6months">Last 6 Months</option>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">&nbsp;</label>
              <div class="d-grid gap-2">
                <button class="btn btn-primary" onclick="applyFilter()">
                  <i class="bi bi-search"></i> Apply Filter
                </button>
                <button
                  class="btn btn-outline-secondary"
                  onclick="clearFilter()"
                >
                  <i class="bi bi-arrow-clockwise"></i> Clear Filter
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Technicians Table -->
        <div class="card">
          <div
            class="card-header d-flex justify-content-between align-items-center"
          >
            <h5 class="mb-0">
              <i class="bi bi-list-ul"></i> Technician List (<span
                id="totalCount"
                >12</span
              >
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
                  <th>Account</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody id="techniciansTableBody">
                <!-- Static Sample Data -->
                <tr>
                  <td>
                    <div class="d-flex align-items-center">
                      <img
                        src="https://via.placeholder.com/45x45/3498db/ffffff?text=JS"
                        alt="John Smith"
                        class="technician-avatar me-3"
                      />
                      <div>
                        <div class="fw-bold">John Smith</div>
                        <small class="text-muted">Age: 35 years</small>
                      </div>
                    </div>
                  </td>
                  <td><span class="badge bg-primary">1001</span></td>
                  <td>
                    <div class="small">
                      <div>
                        <i class="bi bi-envelope me-1"></i
                        >john.smith@company.com
                      </div>
                      <div>
                        <i class="bi bi-telephone me-1"></i>+84-901-234-567
                      </div>
                    </div>
                  </td>
                  <td>
                    <div class="small">123 Nguyen Trai St, Hanoi</div>
                    <small class="text-muted">Hanoi</small>
                  </td>
                  <td>
                    <div class="fw-bold">May 15, 1990</div>
                    <small class="text-muted">Age: 35</small>
                  </td>
                  <td>
                    <div class="fw-bold">@johnsmith</div>
                    <small class="text-success"
                      ><i class="bi bi-check-circle me-1"></i>Active</small
                    >
                  </td>
                  <td>
                    <div class="d-flex gap-2">
                      <button
                        class="btn btn-sm btn-outline-primary"
                        onclick="viewTechnician(1001)"
                      >
                        <i class="bi bi-eye"></i> View
                      </button>
                      <button
                        class="btn btn-sm btn-outline-success"
                        id="assign-btn-1001"
                        onclick="assignToTechnician(1001)"
                      >
                        <i class="bi bi-clipboard-plus"></i>
                        <span class="assign-text">Assign</span>
                      </button>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <div class="d-flex align-items-center">
                      <img
                        src="https://via.placeholder.com/45x45/e74c3c/ffffff?text=SJ"
                        alt="Sarah Johnson"
                        class="technician-avatar me-3"
                      />
                      <div>
                        <div class="fw-bold">Sarah Johnson</div>
                        <small class="text-muted">Age: 33 years</small>
                      </div>
                    </div>
                  </td>
                  <td><span class="badge bg-primary">1002</span></td>
                  <td>
                    <div class="small">
                      <div>
                        <i class="bi bi-envelope me-1"></i
                        >sarah.johnson@company.com
                      </div>
                      <div>
                        <i class="bi bi-telephone me-1"></i>+84-902-345-678
                      </div>
                    </div>
                  </td>
                  <td>
                    <div class="small">456 Le Loi Blvd, Ho Chi Minh City</div>
                    <small class="text-muted">Ho Chi Minh City</small>
                  </td>
                  <td>
                    <div class="fw-bold">Aug 22, 1992</div>
                    <small class="text-muted">Age: 33</small>
                  </td>
                  <td>
                    <div class="fw-bold">@sarahjohnson</div>
                    <small class="text-success"
                      ><i class="bi bi-check-circle me-1"></i>Active</small
                    >
                  </td>
                  <td>
                    <div class="d-flex gap-2">
                      <button
                        class="btn btn-sm btn-outline-primary"
                        onclick="viewTechnician(1002)"
                      >
                        <i class="bi bi-eye"></i> View
                      </button>
                      <button
                        class="btn btn-sm btn-outline-success"
                        id="assign-btn-1002"
                        onclick="assignToTechnician(1002)"
                      >
                        <i class="bi bi-clipboard-plus"></i>
                        <span class="assign-text">Assign</span>
                      </button>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <div class="d-flex align-items-center">
                      <img
                        src="https://via.placeholder.com/45x45/27ae60/ffffff?text=MB"
                        alt="Michael Brown"
                        class="technician-avatar me-3"
                      />
                      <div>
                        <div class="fw-bold">Michael Brown</div>
                        <small class="text-muted">Age: 37 years</small>
                      </div>
                    </div>
                  </td>
                  <td><span class="badge bg-primary">1003</span></td>
                  <td>
                    <div class="small">
                      <div>
                        <i class="bi bi-envelope me-1"></i
                        >michael.brown@company.com
                      </div>
                      <div>
                        <i class="bi bi-telephone me-1"></i>+84-903-456-789
                      </div>
                    </div>
                  </td>
                  <td>
                    <div class="small">789 Tran Phu St, Da Nang</div>
                    <small class="text-muted">Da Nang</small>
                  </td>
                  <td>
                    <div class="fw-bold">Mar 10, 1988</div>
                    <small class="text-muted">Age: 37</small>
                  </td>
                  <td>
                    <div class="fw-bold">@michaelbrown</div>
                    <small class="text-success"
                      ><i class="bi bi-check-circle me-1"></i>Active</small
                    >
                  </td>
                  <td>
                    <div class="d-flex gap-2">
                      <button
                        class="btn btn-sm btn-outline-primary"
                        onclick="viewTechnician(1003)"
                      >
                        <i class="bi bi-eye"></i> View
                      </button>
                      <button
                        class="btn btn-sm btn-outline-success"
                        id="assign-btn-1003"
                        onclick="assignToTechnician(1003)"
                      >
                        <i class="bi bi-clipboard-plus"></i>
                        <span class="assign-text">Assign</span>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="card-footer">
            <div class="d-flex justify-content-between align-items-center">
              <div class="text-muted">
                Showing <span id="showingStart">1</span> to
                <span id="showingEnd">10</span> of
                <span id="showingTotal">12</span> entries
              </div>
              <nav aria-label="Technician pagination">
                <ul class="pagination mb-0">
                  <li class="page-item disabled" id="firstPageItem">
                    <a class="page-link" href="#">
                      <i class="bi bi-chevron-double-left"></i>
                    </a>
                  </li>
                  <li class="page-item disabled" id="prevPageItem">
                    <a class="page-link" href="#">
                      <i class="bi bi-chevron-left"></i>
                    </a>
                  </li>
                  <li class="page-item active">
                    <span class="page-link">
                      Page <span id="currentPageNum">1</span> of
                      <span id="totalPages">2</span>
                    </span>
                  </li>
                  <li class="page-item" id="nextPageItem">
                    <a class="page-link" href="#">
                      <i class="bi bi-chevron-right"></i>
                    </a>
                  </li>
                  <li class="page-item" id="lastPageItem">
                    <a class="page-link" href="#">
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      // Global variables for assignment mode
      let assignmentMode = false;
      let selectedTask = null;

      // Initialize page
      document.addEventListener("DOMContentLoaded", function () {
        checkAssignmentMode();
      });

      // Check if page is loaded in assignment mode
      function checkAssignmentMode() {
        // Check URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        const mode = urlParams.get("mode");
        const taskId = urlParams.get("taskId");

        if (mode === "assignment" && taskId) {
          // Check session storage for task details
          const storedTask = sessionStorage.getItem("selectedTask");
          if (storedTask) {
            selectedTask = JSON.parse(storedTask);
            enableAssignmentMode();
          }
        }
      }

      // Enable assignment mode
      function enableAssignmentMode() {
        if (!selectedTask) return;

        assignmentMode = true;

        // Show assignment alert
        const alertDiv = document.getElementById("assignmentModeAlert");
        alertDiv.style.display = "block";

        // Update task info in alert
        document.getElementById("selectedTaskInfo").innerHTML = `
                <strong>Task:</strong> ${selectedTask.title} <span class="badge bg-primary">${selectedTask.id}</span><br>
                <strong>Customer:</strong> ${selectedTask.customer} | <strong>Priority:</strong> ${selectedTask.priority} | <strong>Deadline:</strong> ${selectedTask.deadline}
            `;

        // Update button text
        document.querySelectorAll(".assign-text").forEach((span) => {
          span.textContent = "Assign Task";
        });
      }

      // Cancel assignment and go back
      function cancelAssignment() {
        if (confirm("Are you sure you want to cancel this assignment?")) {
          sessionStorage.removeItem("selectedTask");
          window.location.href =
            "${pageContext.request.contextPath}/task/techlead/selectTask.jsp";
        }
      }

      // Apply Filter function
      function applyFilter() {
        const searchName = document.getElementById("searchName").value;
        const location = document.getElementById("filterLocation").value;
        const timePeriod = document.getElementById("filterTime").value;

        // Show alert with filter values (demo purpose)
        let filterInfo = "Applying filters:\n";
        if (searchName) filterInfo += "- Search: " + searchName + "\n";
        if (location) {
          const locationNames = {
            hanoi: "Hanoi",
            hochiminh: "Ho Chi Minh City",
            danang: "Da Nang",
            cantho: "Can Tho",
            haiphong: "Hai Phong",
          };
          filterInfo += "- Location: " + locationNames[location] + "\n";
        }
        if (timePeriod) {
          const timeNames = {
            "1week": "Last 1 Week",
            "1month": "Last 1 Month",
            "6months": "Last 6 Months",
          };
          filterInfo += "- Activity Period: " + timeNames[timePeriod] + "\n";
        }

        if (filterInfo === "Applying filters:\n") {
          alert("No filters selected. Showing all technicians.");
        } else {
          alert(filterInfo + "\nFilter applied successfully!");
        }
      }

      // Clear Filter function
      function clearFilter() {
        document.getElementById("searchName").value = "";
        document.getElementById("filterLocation").value = "";
        document.getElementById("filterTime").value = "";

        alert("All filters cleared successfully!");
      }

      // View Technician function
      function viewTechnician(staffId) {
        // Sample technician data for demo
        const technicians = {
          1001: {
            name: "John Smith",
            email: "john.smith@company.com",
            phone: "+84-901-234-567",
            address: "123 Nguyen Trai St, Hanoi",
            dob: "May 15, 1990",
            username: "johnsmith",
          },
          1002: {
            name: "Sarah Johnson",
            email: "sarah.johnson@company.com",
            phone: "+84-902-345-678",
            address: "456 Le Loi Blvd, Ho Chi Minh City",
            dob: "Aug 22, 1992",
            username: "sarahjohnson",
          },
          1003: {
            name: "Michael Brown",
            email: "michael.brown@company.com",
            phone: "+84-903-456-789",
            address: "789 Tran Phu St, Da Nang",
            dob: "Mar 10, 1988",
            username: "michaelbrown",
          },
          1004: {
            name: "Emily Davis",
            email: "emily.davis@company.com",
            phone: "+84-904-567-890",
            address: "321 Hai Ba Trung St, Hanoi",
            dob: "Dec 5, 1995",
            username: "emilydavis",
          },
          1005: {
            name: "David Wilson",
            email: "david.wilson@company.com",
            phone: "+84-905-678-901",
            address: "654 Nguyen Hue St, Ho Chi Minh City",
            dob: "Jul 18, 1985",
            username: "davidwilson",
          },
        };

        const tech = technicians[staffId];
        if (tech) {
          const info =
            `👨‍🔧 TECHNICIAN DETAILS\n\n` +
            `📋 Staff ID: ${staffId}\n` +
            `👤 Name: ${tech.name}\n` +
            `📧 Email: ${tech.email}\n` +
            `📞 Phone: ${tech.phone}\n` +
            `🏠 Address: ${tech.address}\n` +
            `🎂 Date of Birth: ${tech.dob}\n` +
            `👤 Username: @${tech.username}`;
          alert(info);
        } else {
          alert("Technician not found!");
        }
      }

      // Main assignment function (handles both assignment mode and direct assignment)
      function assignToTechnician(staffId) {
        const technicians = {
          1001: "John Smith",
          1002: "Sarah Johnson",
          1003: "Michael Brown",
          1004: "Emily Davis",
          1005: "David Wilson",
        };

        const techName = technicians[staffId];
        if (!techName) {
          alert("Technician not found!");
          return;
        }

        if (assignmentMode && selectedTask) {
          // Assignment mode - assign selected task
          assignSelectedTask(staffId, techName);
        } else {
          // Normal mode - prompt for task title
          assignNewTask(staffId, techName);
        }
      }

      // Assign the selected task to technician
      function assignSelectedTask(staffId, techName) {
        const confirmMessage =
          `Assign Task to ${techName}?\n\n` +
          `Task: ${selectedTask.title}\n` +
          `Task ID: ${selectedTask.id}\n` +
          `Customer: ${selectedTask.customer}\n` +
          `Priority: ${selectedTask.priority}\n` +
          `Deadline: ${selectedTask.deadline}\n\n` +
          `Technician: ${techName} (ID: ${staffId})\n\n` +
          `Do you want to proceed with this assignment?`;

        if (confirm(confirmMessage)) {
          // Simulate assignment success
          alert(
            `✅ Task Assignment Successful!\n\n` +
              `📋 Task: "${selectedTask.title}"\n` +
              `🆔 Task ID: ${selectedTask.id}\n` +
              `👤 Assigned to: ${techName} (ID: ${staffId})\n` +
              `👨‍💼 Customer: ${selectedTask.customer}\n` +
              `⚠️ Priority: ${selectedTask.priority}\n` +
              `📅 Deadline: ${selectedTask.deadline}\n` +
              `⏰ Status: Assigned\n` +
              `📅 Assigned Date: ${new Date().toLocaleDateString()}`
          );

          // Clear session storage and redirect back to task selection
          sessionStorage.removeItem("selectedTask");
          window.location.href =
            "${pageContext.request.contextPath}/task/techlead/selectTask.jsp";
        }
      }

      // Assign new task (normal mode)
      function assignNewTask(staffId, techName) {
        const taskTitle = prompt(
          `📋 Assign Task to ${techName}\n\nEnter task title:`
        );
        if (taskTitle && taskTitle.trim() !== "") {
          alert(
            `✅ Task Assignment Successful!\n\n` +
              `📋 Task: "${taskTitle}"\n` +
              `👤 Assigned to: ${techName} (ID: ${staffId})\n` +
              `⏰ Status: Pending\n` +
              `📅 Date: ${new Date().toLocaleDateString()}`
          );
        } else if (taskTitle !== null) {
          alert("❌ Task title cannot be empty!");
        }
      }

      // Legacy function for backward compatibility
      function assignTask(staffId) {
        assignToTechnician(staffId);
      }
    </script>
  </body>
</html>
