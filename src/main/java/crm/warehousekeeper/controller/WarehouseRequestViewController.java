package crm.warehousekeeper.controller;

import crm.common.URLConstants;
import crm.common.model.*;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.common.repository.Warehouse.WarehouseRequestDAO;
import crm.core.validator.Validator;
import crm.warehousekeeper.service.ImportInternalService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = URLConstants.WAREHOUSE_VIEW_WAREHOUSE_REQUEST)
public class WarehouseRequestViewController extends HttpServlet {
    WarehouseDAO warehouseDAO = new WarehouseDAO();

    WarehouseRequestDAO warehouseRequestDAO = new WarehouseRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Account account = (Account) req.getSession().getAttribute("account");
        Warehouse managerWarehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        List<WarehouseRequest> warehouseRequests = warehouseRequestDAO.findWithProductTransactions();

        warehouseRequests = warehouseRequests.stream()
                .filter(wr -> wr.getDestinationWarehouse().getWarehouseID() == managerWarehouse.getWarehouseID())
                .toList();

        req.setAttribute("warehouseRequests", warehouseRequests);
        req.getRequestDispatcher("/warehouse_keeper/view_warehouse_request.jsp").forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String warehouseRequestIDStr = req.getParameter("warehouseRequestId");

        if (warehouseRequestIDStr != null) {
            try {
                int warehouseRequestID = Integer.parseInt(warehouseRequestIDStr);

                WarehouseRequest warehouseRequest = warehouseRequestDAO.findWithProductTransactionsById(warehouseRequestID);

                if (warehouseRequest == null) {
                    req.getSession().setAttribute("errorMessage", "Warehouse Request with ID " + warehouseRequestID + " not found");
                    resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/view_warehouse_request");
                    return;
                }

                String[] selectedItems = req.getParameterValues("selectedItems");
                int totalItems = warehouseRequest.getTotalQuantity();

                if (selectedItems == null || selectedItems.length != totalItems) {
                    req.getSession().setAttribute("errorMessage", "You must select all " + totalItems + " items to process this request.");
                    resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/view_warehouse_request");
                    return;
                }

                String note = req.getParameter("note");

                if (!Validator.isValidText(note)) {
                    req.getSession().setAttribute("errorMessage", "Please enter a valid note");
                    resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/view_warehouse_request");
                    return;
                }

                boolean success = ImportInternalService.importInternalProducts(selectedItems, warehouseRequest, note);

                if (success) {
                    req.getSession().setAttribute("successMessage", "Warehouse Request processed successfully.");
                    resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/view_warehouse_request");
                } else {
                    req.getSession().setAttribute("errorMessage", "There was an error processing the Warehouse Request");
                    resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/view_warehouse_request");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                req.getSession().setAttribute("errorMessage", "Please enter a valid quantity");
                resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/view_warehouse_request");
            }
        } else {
            req.getSession().setAttribute("errorMessage", "Please enter a valid warehouse request ID");
            resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/view_warehouse_request");
        }

    }
}
