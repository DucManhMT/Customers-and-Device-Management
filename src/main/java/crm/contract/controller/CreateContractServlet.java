package crm.contract.controller;

import crm.common.URLConstants;
import crm.common.model.*;
import crm.contract.service.ContractCodeGenerator;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
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
        fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 10,   // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CreateContractServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        String username = request.getParameter("id");
        Account account = em.find(Account.class, username);

        Map<String, Object> cond = new HashMap<>();
        cond.put("account", username);
        List<Customer> customers = em.findWithConditions(Customer.class, cond);

        if (customers != null && !customers.isEmpty()) {
            request.setAttribute("customerName", customers.get(0).getCustomerName());
        }
        request.setAttribute("account", account);

        // Load all inventory items
        List<InventoryItem> inventoryItems = em.findAll(InventoryItem.class);
        List<ProductContract> productContracts = em.findAll(ProductContract.class);
        Set<Integer> usedItemIds = new HashSet<>();
        if (productContracts != null) {
            for (ProductContract pc : productContracts) {
                InventoryItem it = pc.getInventoryItem();
                if (it != null) {
                    usedItemIds.add(it.getItemId());
                }
            }
        }

        if (inventoryItems != null && !usedItemIds.isEmpty()) {
            inventoryItems.removeIf(item -> item != null && usedItemIds.contains(item.getItemId()));
        }

        request.setAttribute("inventoryItems", inventoryItems);

        request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Part filePart = request.getPart("contractImage");

        // ===== Validate PDF =====
        if (filePart == null || filePart.getSubmittedFileName() == null || filePart.getSubmittedFileName().isEmpty()) {
            request.setAttribute("error", "Please select a PDF file to upload.");
            doGet(request, response);
            return;
        }

        String fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
        String mimeType = getServletContext().getMimeType(fileName);
        if (mimeType == null || !mimeType.equals("application/pdf") || !fileName.toLowerCase().endsWith(".pdf")) {
            request.setAttribute("error", "Invalid file. Only PDF allowed.");
            doGet(request, response);
            return;
        }

        // Lưu file PDF
        String uploadPath = getServletContext().getRealPath("/assets");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // ===== Tạo contract =====
        String customerUsername = request.getParameter("userName");
        Customer customer = null;
        if (customerUsername != null && !customerUsername.isEmpty()) {
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", customerUsername);
            List<Customer> found = em.findWithConditions(Customer.class, cond);
            if (found != null && !found.isEmpty()) customer = found.get(0);
        }

        if (customer == null) {
            request.setAttribute("error", "Customer not found for username: " + customerUsername);
            doGet(request, response);
            return;
        }

        Contract contract = new Contract();
        int contractId = IDGeneratorService.generateID(Contract.class);
        contract.setContractID(contractId);
        contract.setCustomer(customer);
        contract.setContractImage(fileName);
        contract.setContractCode(ContractCodeGenerator.generateContractCode("CTR", String.valueOf(contractId)));

        // Ngày bắt đầu + kết thúc
        try {
            LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
            LocalDate expireDate = LocalDate.parse(request.getParameter("expireDate"));
            if (expireDate.isBefore(startDate)) {
                request.setAttribute("error", "Expire date must be after start date.");
                doGet(request, response);
                return;
            }
            contract.setStartDate(startDate);
            contract.setExpiredDate(expireDate);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid date format.");
            doGet(request, response);
            return;
        }

        // Persist contract
        em.persist(contract, Contract.class);

        // ===== Thêm sản phẩm (ProductContract) =====
        String[] inventoryItemIds = request.getParameterValues("inventoryItemId[]"); // hidden field
        if (inventoryItemIds != null) {
            for (String itemIdStr : inventoryItemIds) {
                if (itemIdStr == null || itemIdStr.isEmpty()) continue;

                int itemId = Integer.parseInt(itemIdStr);
                InventoryItem item = em.find(InventoryItem.class, itemId);
                if (item != null) {
                    ProductContract pc = new ProductContract();
                    pc.setContract(contract);
                    System.out.println(contract.getContractID());
                    pc.setInventoryItem(item);
                    System.out.println(item.getItemId());
                    em.persist(pc, ProductContract.class);
                }
            }
        }else{
            System.out.println("no item selected");
        }

        // Redirect thành công
        String pdfURL = request.getContextPath() + "/assets/" + fileName;
        String redirectUrl = request.getContextPath()
                + "/customer_supporter/create_contract"
                + "?id=" + URLEncoder.encode(customerUsername == null ? "" : customerUsername, "UTF-8")
                + "&success=1"
                + "&contractPDF=" + URLEncoder.encode(pdfURL, "UTF-8");
        response.sendRedirect(redirectUrl);
    }
}
