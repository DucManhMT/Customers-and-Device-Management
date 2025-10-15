package test;

import crm.common.model.Product;
import crm.common.model.ProductSpecification;
import crm.common.repository.Warehouse.ProductDAO;


public class TestFunction {
    public static void main(String[] args) {

        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.findIncludeSpec(1);

        System.out.println(product.getProductName());
        for (ProductSpecification ps : product.getProductSpecifications()) {
            System.out.println(ps.getSpecification().getSpecificationName() + ": " + ps.getSpecification().getSpecificationValue());
        }


    }
}
