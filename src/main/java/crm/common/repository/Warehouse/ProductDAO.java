package crm.common.repository.Warehouse;

import crm.common.model.Product;
import crm.common.model.ProductSpecification;
import crm.common.repository.FuntionalityDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDAO extends FuntionalityDAO<Product> {

    EntityManager em = new EntityManager(DBcontext.getConnection());

    public ProductDAO() {
        super(Product.class);
    }

    public Product findIncludeSpec(int productID) {
        Product product = em.find(Product.class, productID);

        Map<String, Object> productConditions = new HashMap<>();

        productConditions.put("product", product.getProductID());
        List<ProductSpecification> specs = em.findWithConditions(ProductSpecification.class, productConditions);
        product.setProductSpecifications(specs);

        return product;
    }

}
