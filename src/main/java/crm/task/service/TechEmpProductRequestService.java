package crm.task.service;

import crm.common.model.Product;
import crm.common.model.ProductRequest;
import crm.common.model.Task;
import crm.common.model.enums.ProductRequestStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;

import java.time.LocalDate;

public class TechEmpProductRequestService {

    public static boolean createProductRequest(Task task, String[] selectedProductIds, String[] quantities,
            String note) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try {
            em.beginTransaction();

            for (int i = 0; i < selectedProductIds.length; i++) {
                String productIdStr = selectedProductIds[i];
                String quantityStr = quantities[i];

                if (quantityStr == null || quantityStr.isEmpty()) {
                    throw new IllegalArgumentException("Quantity for product ID " + productIdStr + " is missing.");
                }

                int productId = Integer.parseInt(productIdStr);
                int quantity = Integer.parseInt(quantityStr);

                if (quantity <= 0) {
                    throw new IllegalArgumentException(
                            "Quantity for product ID " + productIdStr + " must be greater than zero.");
                }

                Product product = em.find(Product.class, productId);
                if (product == null) {
                    throw new IllegalArgumentException("Product with ID " + productIdStr + " not found.");
                }

                ProductRequest productRequest = new ProductRequest();
                productRequest.setProductRequestID(IDGeneratorService.generateID(ProductRequest.class));
                productRequest.setProduct(product);
                productRequest.setTotalQuantity(quantity);
                productRequest.setActualQuantity(0);
                productRequest.setRequestDate(LocalDate.now());
                productRequest.setDescription(note);
                productRequest.setTask(task);
                productRequest.setStatus(ProductRequestStatus.Pending);

                em.persist(productRequest, ProductRequest.class);
            }
            em.commit();
        } catch (Exception e) {
            em.rollback();
            e.printStackTrace();
            return false;
        }
        return true;
    }
}
