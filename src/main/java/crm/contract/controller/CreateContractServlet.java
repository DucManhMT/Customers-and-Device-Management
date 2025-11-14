package crm.contract.controller;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.*;
import crm.contract.service.ContractCodeGenerator;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import crm.warehousekeeper.service.SerialGenerator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.*;

@WebServlet(name = "CreateContract", value = URLConstants.CUSTOMER_SUPPORTER_CREATE_CONTRACT)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class CreateContractServlet extends HttpServlet {

    private String buildRedirectWithId(HttpServletRequest request, String userName) throws IOException {
        String id = (userName == null) ? "" : userName;
        return request.getContextPath()
                + "/customer_supporter/create_contract?id="
                + URLEncoder.encode(id, "UTF-8");
    }

    private static String sanitizeFileName(String name) {
        if (name == null) return "file";
        return name.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        EntityManager em = new EntityManager(DBcontext.getConnection());

        String username = request.getParameter("id");
        Account account = null;

        if (username != null && !username.isEmpty()) {
            account = em.find(Account.class, username);

            Map<String, Object> cond = new HashMap<>();
            cond.put("account", username);
            List<Customer> customers = em.findWithConditions(Customer.class, cond);
            if (customers != null && !customers.isEmpty()) {
                request.setAttribute("customerName", customers.get(0).getCustomerName());
            }
        }

        request.setAttribute("account", account);

        HttpSession session = request.getSession(false);
        if (session != null) {
            String flashErr = (String) session.getAttribute("flash_error");
            if (flashErr != null) {
                request.setAttribute("error", flashErr);
                session.removeAttribute("flash_error");
            }

            String flashSuccess = (String) session.getAttribute("flash_success");
            if (flashSuccess != null) {
                request.setAttribute("success", flashSuccess);
                session.removeAttribute("flash_success");
            }
        }

        List<Product> products = em.findAll(Product.class);
        request.setAttribute("products", products);

        request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = request.getSession(true);

        Part filePart = request.getPart("contractImage");
        String customerUsername = request.getParameter("userName");

        // ===== VALIDATE PDF =====
        if (filePart == null || filePart.getSubmittedFileName() == null || filePart.getSubmittedFileName().isEmpty()) {
            session.setAttribute("flash_error", MessageConst.MSG81);
            response.sendRedirect(buildRedirectWithId(request, customerUsername));
            return;
        }

        String originalFileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
        String mimeType = getServletContext().getMimeType(originalFileName);
        if (mimeType == null || !mimeType.equals("application/pdf") || !originalFileName.toLowerCase().endsWith(".pdf")) {
            session.setAttribute("flash_error", MessageConst.MSG82);
            response.sendRedirect(buildRedirectWithId(request, customerUsername));
            return;
        }

        // ===== LOAD CUSTOMER =====
        Customer customer = null;
        if (customerUsername != null && !customerUsername.isEmpty()) {
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", customerUsername);
            List<Customer> found = em.findWithConditions(Customer.class, cond);
            if (found != null && !found.isEmpty()) customer = found.get(0);
        }
        if (customer == null) {
            session.setAttribute("flash_error", MessageConst.MSG83);
            response.sendRedirect(buildRedirectWithId(request, customerUsername));
            return;
        }

        // ===== VALIDATE DATES =====
        LocalDate startDate;
        LocalDate expireDate;
        try {
            startDate = LocalDate.parse(request.getParameter("startDate"));
            expireDate = LocalDate.parse(request.getParameter("expireDate"));
            if (expireDate.isBefore(startDate)) {
                session.setAttribute("flash_error", MessageConst.MSG84);
                response.sendRedirect(buildRedirectWithId(request, customerUsername));
                return;
            }
        } catch (Exception e) {
            session.setAttribute("flash_error", MessageConst.MSG85);
            response.sendRedirect(buildRedirectWithId(request, customerUsername));
            return;
        }

        // ===== VALIDATE SERIALS =====
        String[] productIds = request.getParameterValues("productId[]");
        String[] serialNumbers = request.getParameterValues("serialNumber[]");

        List<String> errorList = new ArrayList<>();
        Set<String> serialsInRequest = new HashSet<>();

        Map<Integer, String> serialInputMap = new HashMap<>();

        if (productIds == null || productIds.length == 0) {
            errorList.add(MessageConst.MSG86);
        }

        if (productIds != null && serialNumbers != null) {
            for (int i = 0; i < productIds.length; i++) {
                String pidStr = productIds[i];
                String serialInput = serialNumbers[i];

                if (pidStr == null || pidStr.trim().isEmpty()) {
                    errorList.add("Product ID missing at row " + (i + 1));
                    continue;
                }
                if (serialInput == null || serialInput.trim().isEmpty()) {
                    errorList.add("Serial required at row " + (i + 1));
                    continue;
                }

                int productIdInt;
                try {
                    productIdInt = Integer.parseInt(pidStr.trim());
                } catch (NumberFormatException ex) {
                    errorList.add("Invalid product ID: " + pidStr);
                    continue;
                }

                Product p = em.find(Product.class, productIdInt);
                if (p == null) {
                    errorList.add("Product not found: " + productIdInt);
                    continue;
                }

                String generated = SerialGenerator.generateSerial(String.valueOf(productIdInt), serialInput.trim());

                if (!serialsInRequest.add(generated)) {
                    errorList.add("Duplicate serial in submission: " + serialInput);
                    continue;
                }

                Map<String, Object> cond = new HashMap<>();
                cond.put("serialNumber", generated);
                List<InventoryItem> exists = em.findWithConditions(InventoryItem.class, cond);
                if (exists != null && !exists.isEmpty()) {
                    errorList.add(MessageConst.MSG87);
                    continue;
                }

                serialInputMap.put(i, serialInput.trim());
            }
        }

        if (!errorList.isEmpty()) {
            session.setAttribute("flash_error", String.join("<br>", errorList));
            response.sendRedirect(buildRedirectWithId(request, customerUsername));
            return;
        }


        // ===== SAVE CONTRACT =====
        int contractId = IDGeneratorService.generateID(Contract.class);
        String contractCode = ContractCodeGenerator.generateContractCode("CTR", String.valueOf(contractId));

        String sanitizedBaseName = sanitizeFileName(originalFileName.replaceAll("(?i)\\.pdf$", ""));
        String safeFileName = sanitizeFileName(contractCode) + "_" + sanitizedBaseName + ".pdf";

        String uploadPath = getServletContext().getRealPath("/assets");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        File destFile = new File(uploadDir, safeFileName);
        if (destFile.exists()) {
            safeFileName = sanitizeFileName(contractCode) + "_" + sanitizedBaseName + "_" + System.currentTimeMillis() + ".pdf";
            destFile = new File(uploadDir, safeFileName);
        }
        filePart.write(destFile.getAbsolutePath());

        Contract contract = new Contract();
        contract.setContractID(contractId);
        contract.setCustomer(customer);
        contract.setContractImage(safeFileName);
        contract.setContractCode(contractCode);
        contract.setStartDate(startDate);
        contract.setExpiredDate(expireDate);
        em.persist(contract, Contract.class);

        // ===== SAVE INVENTORY ITEMS + PRODUCT CONTRACT =====
        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i].trim());
            Product p = em.find(Product.class, productId);
            if (p == null) continue;

            InventoryItem item = new InventoryItem();
            item.setItemId(IDGeneratorService.generateID(InventoryItem.class));
            item.setProduct(p);

            item.setSerialNumber(serialInputMap.get(i));

            em.persist(item, InventoryItem.class);

            ProductContract pc = new ProductContract();
            pc.setContract(contract);
            pc.setInventoryItem(item);
            em.persist(pc, ProductContract.class);
        }

        session.setAttribute("flash_success", MessageConst.MSG88);

        String pdfURL = request.getContextPath() + "/assets/" + URLEncoder.encode(safeFileName, "UTF-8");
        response.sendRedirect(buildRedirectWithId(request, customerUsername)
                + "&success=1&contractPDF=" + pdfURL);
    }
}