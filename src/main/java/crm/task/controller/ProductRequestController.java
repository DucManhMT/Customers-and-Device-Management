package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.*;
import crm.common.repository.Warehouse.*;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.validator.Validator;
import crm.task.service.TechEmpProductRequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = URLConstants.TECHEM_CREATE_PRODUCT_REQUEST)
public class ProductRequestController extends HttpServlet {

    EntityManager em = new EntityManager(DBcontext.getConnection());
    ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String taskIdStr = req.getParameter("taskID");


        try {
            int taskId = Integer.parseInt(taskIdStr);
            Task task = em.find(Task.class, taskId);

            if (task.getStatus().name().equalsIgnoreCase("Finished")) {
                req.getSession().setAttribute("errorMessage", "Cannot create product request for a finished task.");
                resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_VIEW_PRODUCT_REQUESTS);
                return;
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        String productNameFilter = req.getParameter("productName");

        String productTypeFilter = req.getParameter("productType");


        List<Type> types = em.findAll(Type.class);
        List<Product> products = productDAO.findAllIncludeSpec();

        if (productNameFilter != null && !productNameFilter.isEmpty()) {
            products = products.stream()
                    .filter(p -> p.getProductName().toLowerCase().contains(productNameFilter.toLowerCase()))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        if (productTypeFilter != null && !productTypeFilter.isEmpty()) {
            products = products.stream()
                    .filter(p -> p.getType().getTypeID() == Integer.parseInt(productTypeFilter))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        req.setAttribute("taskIdStr", taskIdStr);
        req.setAttribute("uniqueProductTypes", types);
        req.setAttribute("products", products);
        req.setAttribute("productName", productNameFilter);
        req.setAttribute("productType", productTypeFilter);
        req.getRequestDispatcher("/technician_employee/create_product_request.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String taskIdStr = req.getParameter("taskIdStr");

        if (taskIdStr != null) {
            try {
                int taskId = Integer.parseInt(taskIdStr);

                Task task = em.find(Task.class, taskId);
                if (task == null) {
                    req.getSession().setAttribute("errorMessage", "Task not found.");
                    resp.sendRedirect(req.getContextPath() + "/technician_employee/createProductRequest?taskID=" + taskIdStr);
                    return;
                }

                String allSelectedItemIDs = req.getParameter("allSelectedItemIDs");
                String allSelectedItemQuantities = req.getParameter("allSelectedItemQuantities");
                String note = req.getParameter("note");

                if (allSelectedItemIDs == null || allSelectedItemIDs.length() == 0) {
                    req.getSession().setAttribute("errorMessage", "Please select at least one product to export.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_CREATE_PRODUCT_REQUEST + "?taskID=" + taskIdStr);
                    return;
                }

                if (allSelectedItemQuantities == null || allSelectedItemQuantities.length() == 0) {
                    req.getSession().setAttribute("errorMessage", "Please provide quantities for the selected products.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_CREATE_PRODUCT_REQUEST + "?taskID=" + taskIdStr);
                    return;
                }

                if (!Validator.isValidText(note)) {
                    req.getSession().setAttribute("errorMessage", "Please enter a valid note.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_CREATE_PRODUCT_REQUEST + "?taskID=" + taskIdStr);
                    return;
                }

                String[] selectedProductIds = allSelectedItemIDs.split(",");
                String[] quantities = allSelectedItemQuantities.split(",");

                boolean isCreated = TechEmpProductRequestService.createProductRequest(task, selectedProductIds, quantities, note);

                if (isCreated) {
                    req.getSession().setAttribute("successMessage", "Product request created successfully.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_CREATE_PRODUCT_REQUEST + "?taskID=" + taskIdStr);
                    return;
                } else {
                    req.getSession().setAttribute("errorMessage", "Failed to create product request. Please try again.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_CREATE_PRODUCT_REQUEST + "?taskID=" + taskIdStr);
                    return;
                }

            } catch (Exception e) {
                req.getSession().setAttribute("errorMessage", "Invalid task ID.");
                resp.sendRedirect(req.getContextPath() + URLConstants.TECHEM_CREATE_PRODUCT_REQUEST + "?taskID=" + taskIdStr);
                return;
            }
        }
    }


}
