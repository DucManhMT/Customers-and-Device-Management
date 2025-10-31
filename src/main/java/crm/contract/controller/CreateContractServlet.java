package crm.contract.controller;

import crm.common.URLConstants;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.contract.service.ContractCodeGenerator;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import crm.core.validator.Validator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CreateContract", value = URLConstants.CUSTOMER_SUPPORTER_CREATE_CONTRACT)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 50,   // 50MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)

public class CreateContractServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Part filePart = request.getPart("contractImage");

        String fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
        String mimeType = getServletContext().getMimeType(fileName);
        if (mimeType == null || !mimeType.equals("application/pdf")) {
            request.setAttribute("error", "Invalid file type. Only PDF files are allowed.");
            request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
            return;
        }

        String lowerName = fileName.toLowerCase();
        if (!lowerName.endsWith(".pdf")) {
            request.setAttribute("error", "Invalid file extension. Only .pdf is allowed.");
            request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
            return;
        }

        String uploadPath = getServletContext().getRealPath("/assets");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        Contract contract = new Contract();
        String customerUsername = request.getParameter("userName");
        if(!Validator.isValidName(customerUsername)){
            request.setAttribute("error", "Customer username contains invalid characters.");
            request.setAttribute("userName", customerUsername);
            request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
            return;
        }
//        System.out.println("customerUsername: " + customerUsername);
        Customer customer = null;
        if (customerUsername != null && !customerUsername.isEmpty()) {
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", customerUsername);
            List<Customer> found = em.findWithConditions(Customer.class, cond);
            if (found != null && !found.isEmpty()) {
                customer = found.get(0);
            }
        }
        if (customer == null) {
            request.setAttribute("error", "Customer not found for username: " + (customerUsername == null ? "" : customerUsername));
            request.setAttribute("userName", customerUsername); // giữ lại giá trị đã nhập
            request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
            return;
        }
        int contractId = IDGeneratorService.generateID(Contract.class);
        contract.setContractID(contractId);
        contract.setContractImage(fileName);
        contract.setContractCode(ContractCodeGenerator.generateContractCode("CTR", "contractId"));

        String startDateStr = request.getParameter("startDate");
        if (startDateStr == null || startDateStr.isEmpty()) {
            request.setAttribute("error", "Start date is required.");
            request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
            return;
        }

        LocalDate startDate;
        try {
            startDate = LocalDate.parse(startDateStr);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid start date format.");
            request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
            return;
        }

        contract.setStartDate(startDate);
        String expireDateStr = request.getParameter("expireDate");

        if (expireDateStr == null || expireDateStr.isEmpty()) {
            request.setAttribute("error", "Expire date is required.");
            request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
            return;
        }

        try {
            LocalDate expireDate = LocalDate.parse(expireDateStr);

            if (expireDate.isBefore(LocalDate.now())) {
                request.setAttribute("error", "Expire date must be after start date.");
                request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
                return;
            }

            contract.setExpiredDate(expireDate);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid expire date format.");
            request.getRequestDispatcher("/customer_supporter/create_contract.jsp").forward(request, response);
            return;
        }

        contract.setCustomer(customer);
//        System.out.println("contract.getContractID(): " + contract.getContractID());
//        System.out.println("contract.getContractImage(): " + contract.getContractImage());
//        System.out.println("contract.getStartDate(): " + contract.getStartDate());
//        System.out.println("contract.getExpiredDate(): " + contract.getExpiredDate());
//        System.out.println(contract.getCustomer().getCustomerID());
        em.persist(contract, Contract.class);
        String pdfURL = request.getContextPath() + "/assets/" + fileName;
        request.setAttribute("contractPDF", pdfURL);
        // Gửi phản hồi hiển thị ảnh đã upload
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><body style='font-family:Arial;text-align:center;'>");
        response.getWriter().println("<h2>PDF Upload Successful!</h2>");
        response.getWriter().println("<a href='create_contract.jsp'>← Back to Upload</a>");
        response.getWriter().println("</body></html>");
    }
}