package crm.warehousekeeper.controller;

import crm.common.URLConstants;
import crm.common.model.*;
import crm.common.model.enums.ProductStatus;
import crm.common.repository.Warehouse.TypeDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import crm.core.validator.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = URLConstants.WAREHOUSE_ADD_PRODUCT)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 10,   // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AddProductController extends HttpServlet {

    EntityManager em = new EntityManager(DBcontext.getConnection());

    TypeDAO typeDAO = new TypeDAO();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<Type> types = typeDAO.findAll();


        if (types.isEmpty()) {
            req.setAttribute("errorMessage", "Please ensure that at least one product type exist before adding a product.");
            req.getRequestDispatcher("/warehouse_keeper/add_product.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("types", types);

        String typeIDStr = req.getParameter("typeID");

        int typeID = -1;
        if (typeIDStr != null) {
            try {
                typeID = Integer.parseInt(typeIDStr);
            } catch (NumberFormatException e) {
                // Ignore invalid typeID parameter
            }
        }

        if (typeID != -1) {
            Type selectedType = em.find(Type.class, typeID);

            selectedType.setSpecificationTypes(typeDAO.getSpecificationTypes(selectedType.getTypeID()));

            req.setAttribute("selectedType", selectedType);
        }

        req.getRequestDispatcher("/warehouse_keeper/add_product.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            em.beginTransaction();

            Product product = new Product();

            String productName = req.getParameter("productName");

            if (!Validator.isValidName(productName)) {
                req.setAttribute("errorMessage", "Invalid product name.");
                doGet(req, resp);
                return;
            }

            String productDescription = req.getParameter("productDescription");

            if (!Validator.isValidText(productDescription)) {
                req.setAttribute("errorMessage", "Invalid product description.");
                doGet(req, resp);
                return;
            }

            String typeIDStr = req.getParameter("typeID");

            if(typeIDStr == null || typeIDStr.isEmpty()){
                req.setAttribute("errorMessage", "Product type is required.");
                doGet(req, resp);
                return;
            }

            int typeID = Integer.parseInt(typeIDStr);


            String[] specIDs = req.getParameterValues("specIDs");

            Part filePart = req.getPart("productImage");
            if (filePart != null && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                String fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();

                String lowerName = fileName.toLowerCase();
                if (lowerName.endsWith(".png") || lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg")) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "assets";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();

                    String filePath = uploadPath + File.separator + fileName;
                    filePart.write(filePath);
                    product.setProductImage(fileName);
                } else {
                    req.setAttribute("errorMessage", "Invalid image file.");
                    doGet(req, resp);
                    return;
                }
            }

            product.setProductID(IDGeneratorService.generateID(Product.class));
            product.setProductName(productName);
            product.setProductDescription(productDescription);


            Type productType = em.find(Type.class, typeID);
            product.setType(productType);

            em.persist(product, Product.class);

            List<ProductSpecification> productSpecifications = new ArrayList<>();

            if (specIDs != null) {
                for (String specIDStr : specIDs) {
                    if (specIDStr != null && !specIDStr.isEmpty()) {
                        ProductSpecification productSpecification = new ProductSpecification();

                        int specID = Integer.parseInt(specIDStr);
                        Specification specification = em.find(Specification.class, specID);

                        productSpecification.setProductSpecificationID(IDGeneratorService.generateID(ProductSpecification.class));
                        productSpecification.setProduct(product);
                        productSpecification.setSpecification(specification);
                        em.persist(productSpecification, ProductSpecification.class);
                        productSpecifications.add(productSpecification);
                    }
                }
                product.setProductSpecifications(productSpecifications);
                em.merge(product, Product.class);
            } else{
                req.setAttribute("errorMessage", "Please provide at least one specification for the product.");
                doGet(req, resp);
                return;
            }

            em.commit();

            req.setAttribute("successMessage", "Product added successfully.");
            doGet(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid data submitted. Please check type or specification.");
            em.rollback();
            doGet(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred while creating the request.");
            em.rollback();
            doGet(req, resp);
        }
    }
}
