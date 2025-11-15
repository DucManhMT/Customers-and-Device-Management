package crm.warehousekeeper.controller;

import crm.common.URLConstants;
import crm.common.model.*;
import crm.common.model.enums.ProductStatus;
import crm.common.model.enums.TransactionStatus;
import crm.common.model.enums.WarehouseRequestStatus;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(urlPatterns = URLConstants.WAREHOUSE_EXPORT_INTERNAL)
public class ExportInternalController extends HttpServlet {
    EntityManager em = new EntityManager(DBcontext.getConnection());
    WarehouseDAO warehouseDAO = new WarehouseDAO();
    ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Account account = (Account) req.getSession().getAttribute("account");

        List<WarehouseRequest> warehouseRequests = em.findAll(WarehouseRequest.class);


        Warehouse userWarehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        List<ProductWarehouse> availableProducts = productWarehouseDAO.getAvailableProductsByWarehouse(userWarehouse.getWarehouseID());

        warehouseRequests = warehouseRequests.stream()
                .filter(wr -> wr.getSourceWarehouse() != null)
                .filter(wr -> wr.getSourceWarehouse().getWarehouseID() == userWarehouse.getWarehouseID())
                .toList();

        req.setAttribute("warehouseRequests", warehouseRequests);
        req.setAttribute("availableProducts", availableProducts);

        req.getRequestDispatcher("/warehouse_keeper/export_internal.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String warehouseRequestIDStr = req.getParameter("warehouseRequestID");
        String[] selectedProducts = req.getParameterValues("selectedProducts");

        if (warehouseRequestIDStr != null && selectedProducts != null) {
            try {
                em.beginTransaction();
                int warehouseRequestID = Integer.parseInt(warehouseRequestIDStr);
                WarehouseRequest warehouseRequest = em.find(WarehouseRequest.class, warehouseRequestID);

                if (warehouseRequest != null) {
                    warehouseRequest.setWarehouseRequestStatus(WarehouseRequestStatus.Transporting);
                    em.merge(warehouseRequest, WarehouseRequest.class);

                    int actualQuantity = warehouseRequest.getActualQuantity();

                    for (String productWarehouseIDStr : selectedProducts) {
                        int productWarehouseID = Integer.parseInt(productWarehouseIDStr);
                        ProductWarehouse productToUpdate = em.find(ProductWarehouse.class, productWarehouseID);

                        if (productToUpdate.getProductStatus().name().equals(ProductStatus.Exported.name())) {
                            req.getSession().setAttribute("errorMessage", "Some selected products have already been exported.");
                            em.rollback();
                            resp.sendRedirect(req.getContextPath() + URLConstants.WAREHOUSE_EXPORT_INTERNAL);
                            return;
                        }


                        if (productToUpdate != null) {
                            productToUpdate.setProductStatus(ProductStatus.Exported);
                            em.merge(productToUpdate, ProductWarehouse.class);
                        }

                        ProductTransaction transaction = new ProductTransaction();
                        transaction.setTransactionID(IDGeneratorService.generateID(ProductTransaction.class));
                        transaction.setTransactionDate(LocalDateTime.now());
                        transaction.setTransactionStatus(TransactionStatus.Export);
                        transaction.setWarehouseRequest(warehouseRequest);
                        transaction.setInventoryItem(productToUpdate.getInventoryItem());
                        transaction.setDestinationWarehouseEntity(warehouseRequest.getDestinationWarehouse());
                        transaction.setSourceWarehouseEntity(warehouseRequest.getSourceWarehouse());

                        actualQuantity += 1;

                        em.persist(transaction, ProductTransaction.class);
                    }
                    warehouseRequest.setActualQuantity(actualQuantity);

                }

                em.commit();
                resp.sendRedirect(req.getContextPath() + URLConstants.WAREHOUSE_EXPORT_INTERNAL);

            } catch (NumberFormatException | SQLException e) {
                em.rollback();
                // Log error or handle invalid ID format
                e.printStackTrace();
            } catch (Exception e) {
                em.rollback();
            }
        }

    }
}

