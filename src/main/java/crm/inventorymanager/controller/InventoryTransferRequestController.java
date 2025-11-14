package crm.inventorymanager.controller;

import crm.common.URLConstants;
import crm.common.model.Warehouse;
import crm.common.model.WarehouseRequest;
import crm.common.model.enums.WarehouseRequestStatus;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = URLConstants.INVENTORY_VIEW_TRANSFER_REQUESTS)
public class InventoryTransferRequestController extends HttpServlet {

    EntityManager em = new EntityManager(DBcontext.getConnection());
    WarehouseDAO warehouseDAO = new WarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<WarehouseRequest> warehouseRequests = em.findAll(WarehouseRequest.class);

        List<Map<String, Object>> inventorySummary = warehouseDAO.getInventorySummary();


        req.setAttribute("warehouseRequests", warehouseRequests);
        req.setAttribute("inventorySummary", inventorySummary);
        req.getRequestDispatcher("/inventory_manager/view_transfer_requests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String warehouseRequestIdStr = req.getParameter("warehouseRequestID");
        String sourceWarehouseIdStr = req.getParameter("sourceWarehouseID");

        String rejectReason = req.getParameter("rejectReason");

        if (rejectReason != null && !rejectReason.isEmpty() &&
                warehouseRequestIdStr != null && !warehouseRequestIdStr.isEmpty()) {
            try {
                em.beginTransaction();
                int warehouseRequestId = Integer.parseInt(warehouseRequestIdStr);

                WarehouseRequest requestToUpdate = em.find(WarehouseRequest.class, warehouseRequestId);

                if(requestToUpdate.getWarehouseRequestStatus().equals(WarehouseRequestStatus.Rejected)){
                    req.getSession().setAttribute("errorMessage", "Warehouse request has already been rejected.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.INVENTORY_VIEW_TRANSFER_REQUESTS);
                    return;
                }

                if (requestToUpdate != null) {
                    requestToUpdate.setWarehouseRequestStatus(WarehouseRequestStatus.Rejected);
                    requestToUpdate.setNote(rejectReason);

                    em.merge(requestToUpdate, WarehouseRequest.class);
                    em.commit();

                    req.getSession().setAttribute("successMessage", "Warehouse request has been updated successfully");
                    resp.sendRedirect(req.getContextPath() + URLConstants.INVENTORY_VIEW_TRANSFER_REQUESTS);
                    return;
                }

            } catch (NumberFormatException | SQLException e) {
                em.rollback();
                e.printStackTrace();
            }
        }

        if (warehouseRequestIdStr != null && !warehouseRequestIdStr.isEmpty() &&
                sourceWarehouseIdStr != null && !sourceWarehouseIdStr.isEmpty()) {
            try {
                int warehouseRequestId = Integer.parseInt(warehouseRequestIdStr);
                int sourceWarehouseId = Integer.parseInt(sourceWarehouseIdStr);

                WarehouseRequest requestToUpdate = em.find(WarehouseRequest.class, warehouseRequestId);

                if(requestToUpdate.getWarehouseRequestStatus().equals(WarehouseRequestStatus.Rejected)){
                    req.getSession().setAttribute("errorMessage", "Warehouse request has been rejected.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.INVENTORY_VIEW_TRANSFER_REQUESTS);
                    return;
                }

                Warehouse sourceWarehouse = em.find(Warehouse.class, sourceWarehouseId);

                if (requestToUpdate != null && sourceWarehouse != null) {
                    requestToUpdate.setSourceWarehouse(sourceWarehouse);
                    requestToUpdate.setWarehouseRequestStatus(WarehouseRequestStatus.Accepted);

                    em.merge(requestToUpdate, WarehouseRequest.class);
                }
            } catch (NumberFormatException e) {
                // Handle error if IDs are not valid numbers
                e.printStackTrace();
            }
        } else {
            req.getSession().setAttribute("errorMessage", "Invalid warehouse request or source warehouse ID.");
            resp.sendRedirect(req.getContextPath() + URLConstants.INVENTORY_VIEW_TRANSFER_REQUESTS);
            return;
        }

        resp.sendRedirect(req.getContextPath() + URLConstants.INVENTORY_VIEW_TRANSFER_REQUESTS);
    }
}
