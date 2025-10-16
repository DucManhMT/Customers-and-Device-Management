package crm.task.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.stream.Collectors;

import crm.common.model.Request;
import crm.common.model.Account;
import crm.common.model.enums.RequestStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import java.util.Map;

@WebServlet("/task/viewAprovedTask")
public class viewAprovedTask extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		loadApprovedTasks(req, resp, null, null, null, null);
	}

	private void loadApprovedTasks(HttpServletRequest req, HttpServletResponse resp, 
			String phoneFilter, String customerFilter, String fromDateStr, String toDateStr) 
			throws ServletException, IOException {
		
		String pageStr = req.getParameter("page");
		String pageSizeStr = req.getParameter("pageSize");
		int page = 1;
		int pageSize = 8; 
		
		try {
			if (pageStr != null && !pageStr.isEmpty()) {
				page = Math.max(1, Integer.parseInt(pageStr));
			}
			if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
				pageSize = Math.max(1, Integer.parseInt(pageSizeStr));
			}
		} catch (NumberFormatException ex) {
		}

		try (Connection connection = DBcontext.getConnection();
			 EntityManager em = new EntityManager(connection)) {

			Map<String, Object> conditions = new java.util.HashMap<>();
			conditions.put("requestStatus", RequestStatus.Approved.name());

			boolean hasFilter = (phoneFilter != null && !phoneFilter.trim().isEmpty())
					|| (customerFilter != null && !customerFilter.trim().isEmpty())
					|| (fromDateStr != null && !fromDateStr.isEmpty())
					|| (toDateStr != null && !toDateStr.isEmpty());

			List<Request> paginated;
			int approvedCount;
			int totalPages;
			int offset;
			int startItem;
			int endItem;

			if (hasFilter) {
				List<Request> allApproved = em.findWithConditions(Request.class, conditions);

				java.util.stream.Stream<Request> stream = allApproved.stream();
				
				if (fromDateStr != null && !fromDateStr.isEmpty()) {
					try {
						java.time.LocalDate from = java.time.LocalDate.parse(fromDateStr,
								java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
						stream = stream.filter(r -> r.getStartDate() != null
								&& !r.getStartDate().toLocalDate().isBefore(from));
					} catch (Exception ex) {
					}
				}
				
				if (toDateStr != null && !toDateStr.isEmpty()) {
					try {
						java.time.LocalDate to = java.time.LocalDate.parse(toDateStr,
								java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
						stream = stream.filter(r -> r.getStartDate() != null
								&& !r.getStartDate().toLocalDate().isAfter(to));
					} catch (Exception ex) {
					}
				}
				
				String phoneLow = phoneFilter != null ? phoneFilter.trim().toLowerCase() : null;
				String custLow = customerFilter != null ? customerFilter.trim().toLowerCase() : null;
				
				if (phoneLow != null && !phoneLow.isEmpty()) {
					stream = stream.filter(r -> {
						try {
							if (r.getContract() != null && r.getContract().getCustomer() != null
									&& r.getContract().getCustomer().getPhone() != null) {
								return r.getContract().getCustomer().getPhone().toLowerCase().contains(phoneLow);
							}
						} catch (Exception e) {
							return false;
						}
						return false;
					});
				}
				
				if (custLow != null && !custLow.isEmpty()) {
					stream = stream.filter(r -> {
						try {
							if (r.getContract() != null && r.getContract().getCustomer() != null
									&& r.getContract().getCustomer().getCustomerName() != null) {
								return r.getContract().getCustomer().getCustomerName().toLowerCase().contains(custLow);
							}
						} catch (Exception e) {
							return false;
						}
						return false;
					});
				}

				List<Request> filtered = stream.collect(java.util.stream.Collectors.toList());
				approvedCount = filtered.size();
				totalPages = (int) Math.ceil((double) approvedCount / pageSize);
				if (totalPages < 1) totalPages = 1;
				if (page > totalPages) page = totalPages;
				
				offset = (page - 1) * pageSize;
				startItem = approvedCount > 0 ? offset + 1 : 0;
				endItem = Math.min(offset + pageSize, approvedCount);
				
				int fromIndex = Math.min(offset, approvedCount);
				int toIndex = Math.min(offset + pageSize, approvedCount);
				paginated = filtered.subList(fromIndex, toIndex);
			} else {
				approvedCount = em.countWithConditions(Request.class, conditions);
				totalPages = (int) Math.ceil((double) approvedCount / pageSize);
				if (totalPages < 1) totalPages = 1;
				if (page > totalPages) page = totalPages;
				
				offset = (page - 1) * pageSize;
				startItem = approvedCount > 0 ? offset + 1 : 0;
				endItem = Math.min(offset + pageSize, approvedCount);
				paginated = em.findWithConditionsAndPagination(Request.class, conditions, pageSize, offset);
			}

			List<Account> allAccounts = em.findAll(Account.class);
			List<Account> technicians = allAccounts.stream()
					.filter(a -> a.getRole() != null && a.getRole().getRoleName() != null)
					.filter(a -> {
						String rn = a.getRole().getRoleName().toLowerCase();
						return rn.contains("technician") || rn.contains("tech");
					})
					.collect(Collectors.toList());

			// Set filter values back to the form
			req.setAttribute("phoneFilter", phoneFilter);
			req.setAttribute("customerFilter", customerFilter);
			req.setAttribute("fromDate", fromDateStr);
			req.setAttribute("toDate", toDateStr);
			
			req.setAttribute("approvedRequests", paginated);
			req.setAttribute("technicians", technicians);
			req.setAttribute("totalCount", approvedCount);
			req.setAttribute("totalPages", totalPages);
			req.setAttribute("currentPage", page);
			req.setAttribute("pageSize", pageSize);
			req.setAttribute("startItem", startItem);
			req.setAttribute("endItem", endItem);

			req.getRequestDispatcher("/technician_leader/viewAprovedTask.jsp").forward(req, resp);
		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("errorMessage", "Failed to load data: " + e.getMessage());
			req.getRequestDispatcher("/technician_leader/viewAprovedTask.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");
		
		if ("filter".equals(action)) {
			// Handle filter form submission
			String phoneFilter = req.getParameter("phoneFilter");
			String customerFilter = req.getParameter("customerFilter");
			String fromDateStr = req.getParameter("fromDate");
			String toDateStr = req.getParameter("toDate");
			
			// Load tasks with filters applied
			loadApprovedTasks(req, resp, phoneFilter, customerFilter, fromDateStr, toDateStr);
		} else if ("assign".equals(action)) {
			// Handle task assignment
			String[] selected = req.getParameterValues("selectedTasks");
			if (selected == null || selected.length == 0) {
				req.setAttribute("errorMessage", "No tasks selected");
				loadApprovedTasks(req, resp, null, null, null, null);
				return;
			}

			// Store selected task IDs in session and redirect to technician selection
			req.getSession().setAttribute("selectedTaskIds", selected);
			resp.sendRedirect(req.getContextPath() + "/task/selectTechnician");
		} else {
			// Default action - load without filters
			loadApprovedTasks(req, resp, null, null, null, null);
		}
	}

}
