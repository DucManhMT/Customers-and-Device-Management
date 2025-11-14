package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.*;
import crm.common.repository.staff.StaffDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.task.service.TechEmProductRequestService;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = URLConstants.TECHEM_VIEW_PRODUCT_REQUESTS)
public class ViewProductRequestController extends HttpServlet {
    EntityManager em = new EntityManager(DBcontext.getConnection());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pageSize = 6;
        int currentPage = 1;

        String pageSizeParam = req.getParameter("pageSize");
        String pageParam = req.getParameter("page");
        String taskIdStr = req.getParameter("taskID");

        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
            } catch (NumberFormatException e) {

            }
        }

        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {

            }
        }

        Account account = (Account) req.getSession().getAttribute("account");
        StaffDAO staffDAO = new StaffDAO();
        Staff currentStaff = staffDAO.findByUsername(account.getUsername());

        Task currentTask = null;
        Request currentRequest = null;
        List<ProductRequest> productRequests = em.findAll(ProductRequest.class);


        try {
            if (taskIdStr != null && !taskIdStr.isEmpty()) {
                int taskId = Integer.parseInt(taskIdStr);
                currentTask = em.find(Task.class, taskId);


                if (currentTask != null) {
                    currentRequest = currentTask.getRequest();
                    int requestId = currentRequest.getRequestID();

                    productRequests = productRequests.stream()
                            .filter(pr -> pr.getTask().getRequest().getRequestID() == requestId)
                            .sorted((pr1, pr2) -> pr2.getRequestDate().compareTo(pr1.getRequestDate()))
                            .collect(Collectors.toList());
                }
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid Task ID");
        }

        int totalRequests = productRequests.size();
        int totalPages = (int) Math.ceil((double) totalRequests / pageSize);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * pageSize;
        productRequests = productRequests.stream()
                .skip(offset)
                .limit(pageSize)
                .collect(Collectors.toList());

        req.setAttribute("productRequests", productRequests);
        req.setAttribute("currentTask", currentTask);
        req.setAttribute("currentRequest", currentRequest);
        req.setAttribute("currentStaff", currentStaff);
        req.setAttribute("taskID", taskIdStr);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalRequests", totalRequests);

        req.getRequestDispatcher("/technician_employee/view_product_requests.jsp").forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productRequestIdStr = req.getParameter("productRequestId");
        String action = req.getParameter("action");

        if (productRequestIdStr != null && !productRequestIdStr.isEmpty()) {
            try {
                int productRequestId = Integer.parseInt(productRequestIdStr);

                ProductRequest productRequest = em.find(ProductRequest.class, productRequestId);
                if (productRequest == null) {
                    req.getSession().setAttribute("errorMessage", "Product Request not found.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_VIEW_PRODUCT_REQUESTS);
                    return;
                }

                if(action.equals("finished")) {
                    if(productRequest.getActualQuantity() != productRequest.getTotalQuantity()) {
                        req.getSession().setAttribute("errorMessage", "Cannot finish the request as actual quantity does not match total quantity.");
                        resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_VIEW_PRODUCT_REQUESTS);
                        return;
                    }
                }

                if(action.equals("reject")) {
                    if(productRequest.getActualQuantity() == productRequest.getTotalQuantity()) {
                        req.getSession().setAttribute("errorMessage", "Cannot reject the request as you already receive all product.");
                        resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_VIEW_PRODUCT_REQUESTS);
                        return;
                    }
                }

                boolean isFinished = TechEmProductRequestService.isFinished(productRequest, action);

                if (isFinished) {
                    req.getSession().setAttribute("successMessage", "Product request has been " + (action.equals("finished") ? "finished." : "rejected."));
                } else {
                    req.getSession().setAttribute("errorMessage", "Failed to update product request status, please check again.");
                }
                resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_VIEW_PRODUCT_REQUESTS);
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("errorMessage", "Invalid Product Request ID.");
                resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_VIEW_PRODUCT_REQUESTS);
            }
        }
    }
}
