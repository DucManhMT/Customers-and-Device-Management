<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
import="java.util.HashMap" %> <%@ page import="java.util.Map" %><%-- Created by
IntelliJ IDEA. User: anhtu Date: 10/8/2025 Time: 10:37 AM To change this
template use File | Settings | File Templates. --%> <%@ page
contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Request Dashboard</title>
    <link
      href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <style>
      body {
        background-color: #f8f9fa;
      }

      h1 {
        font-weight: 600;
      }

      .stat-card {
        transition: all 0.2s ease;
      }

      .stat-card:hover {
        background-color: #f1f1f1;
        transform: translateY(-2px);
      }
    </style>
  </head>
  <body>
    <c:set var="activePage" value="requestDashboard" scope="request" />
    <jsp:include page="../components/header.jsp" />
    <jsp:include page="../components/sidebar.jsp" />
    <div class="container py-4">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="mb-0">Request</h1>
        <a href="./list" class="btn btn-info">View List</a>
      </div>

      <!-- Time filter -->
      <div class="card p-4 mb-4 shadow-sm">
        <form class="row g-3 align-items-end">
          <div class="col-md-4">
            <label for="toDate" class="form-label">From</label>
            <input
              type="date"
              class="form-control"
              id="fromDate"
              name="fromDate"
              value="${fromDate}"
              max="<%= java.time.LocalDate.now() %>"
            />
          </div>
          <div class="col-md-4">
            <label for="toDate" class="form-label">To</label>
            <input
              type="date"
              class="form-control"
              id="toDate"
              name="toDate"
              value="${toDate}"
              max="<%= java.time.LocalDate.now() %>"
            />
          </div>
          <div class="col-md-4 d-flex gap-2">
            <button type="submit" class="btn btn-primary flex-fill">
              Filter
            </button>
            <button
              class="btn btn-outline-secondary flex-fill"
              onclick="resetFilters(event,this)"
            >
              Reset
            </button>
          </div>
        </form>
      </div>

      <!-- Stastics -->
      <div class="card p-4 shadow-sm mb-4">
        <h4 class="mb-3">Summary</h4>

        <c:choose>
          <c:when test="${not empty error}">
            <div class="alert alert-danger mb-0" role="alert">${error}</div>
          </c:when>
          <c:otherwise>
            <div class="row g-3">
              <!-- Total -->
              <div class="col-md-3">
                <div class="stat-card p-3 border rounded bg-light text-center">
                  <h5 class="text-secondary">Total Requests</h5>
                  <p class="display-6 mb-0 fw-bold">${total}</p>
                </div>
              </div>

              <%--Other status--%>
              <c:forEach items="${stats}" var="stat">
                <c:if test="${stat.key != 'All'}">
                  <div class="col-md-3">
                    <div class="stat-card p-3 border rounded text-center">
                      <h5 class="text-secondary">${stat.key}</h5>
                      <p class="display-6 mb-0 fw-bold">${stat.value}</p>
                    </div>
                  </div>
                </c:if>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Chart -->
      <div class="mb-4">
        <div class="card p-4 shadow-sm">
          <h5 class="mb-3">Visualization</h5>
          <div class="row">
            <div class="col-md-6">
              <canvas id="pieChart" style="height: 400px; width: 100%"></canvas>
            </div>
            <div class="col-md-6 d-flex align-items-center">
              <div id="chartLegend" class="ms-3"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>

      const statsData = {
          <c:forEach var="entry" items="${stats}">
          "<c:out value='${entry.key}'/>": <c:out value='${entry.value}'/>,
          </c:forEach>
      };


      delete statsData['All'];

      const labels = Object.keys(statsData);
      const values = Object.values(statsData);


      const colors = [
          '#36A2EB', '#FF6384', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'
      ];

      const ctx = document.getElementById('pieChart').getContext('2d');
      const pieChart = new Chart(ctx, {
          type: 'pie',
          data: {
              labels: labels,
              datasets: [{
                  data: values,
                  backgroundColor: colors.slice(0, labels.length),
                  borderWidth: 1
              }]
          },
          options: {
              responsive: true,
              plugins: {
                  legend: {
                      position: 'bottom',
                      labels: {font: {size: 14}}
                  },
                  tooltip: {
                      callbacks: {
                          label: function (context) {
                              const total = context.chart._metasets[0].total;
                              const value = context.raw;
                              const percentage = ((value / total) * 100).toFixed(1);
                              return `${context.label}: ` + value + " - " + +percentage + "%"
                                  ;
                          }
                      }
                  },
                  title: {
                      display: true,
                      text: 'Status Distribution (%)',
                      font: {size: 18, weight: 'bold'}
                  }
              }
          }
      });
    </script>
    <script>
      function resetFilters(e, btn) {
        if (e) e.preventDefault();
        const form = btn.closest("form");
        form.reset();

        const action = form.getAttribute("action") || window.location.pathname;
        const baseUrl = new URL(action, window.location.href).pathname;
        window.location.href = baseUrl;
      }
    </script>
  </body>
</html>
