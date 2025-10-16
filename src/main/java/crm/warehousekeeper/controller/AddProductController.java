package crm.warehousekeeper.controller;

import crm.common.model.Product;
import crm.common.model.ProductSpecification;
import crm.common.model.Specification;
import crm.common.model.Type;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = "/warehouse/addProduct")
@MultipartConfig
public class AddProductController extends HttpServlet {

    EntityManager em = new EntityManager(DBcontext.getConnection());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<Type> types = em.findAll(Type.class);
        List<Specification> specifications = em.findAll(Specification.class);

        req.setAttribute("types", types);
        req.setAttribute("specifications", specifications);


        req.getRequestDispatcher("/warehouse_keeper/add_product.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            String productName = req.getParameter("productName");
            String productDescription = req.getParameter("productDescription");
            String typeIDStr = req.getParameter("typeID");
            int typeID = Integer.parseInt(typeIDStr);
            String[] specIDs = req.getParameterValues("specIDs");

            Part filePart = req.getPart("productImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "product";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            filePart.write(uploadPath + File.separator + fileName);

            System.out.println(uploadPath + File.separator + fileName);

            String imageUrl = "assets/product/" + fileName;

            Product product = new Product();
            product.setProductID(IDGeneratorService.generateID(Product.class));
            product.setProductName(productName);
            product.setProductDescription(productDescription);
            product.setProductImage(imageUrl);


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
            }

            resp.sendRedirect(req.getContextPath() + "/warehouse/viewInventory");

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid data submitted. Please check type or specification.");
            doGet(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An error occurred while creating the request.");
            doGet(req, resp);
        }
    }
}
