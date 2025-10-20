package crm.contract;

import crm.common.URLConstants;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "CreateContract", value = URLConstants.CUSTOMER_SUPPORTER_CREATE_CONTRACT)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 10,   // 10MB
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

        // Tạo thư mục lưu file nếu chưa có
        String uploadPath = getServletContext().getRealPath("") + File.separator + "assets";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        // Lưu file
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        Contract contract = new Contract();
        Customer customer = em.find(Customer.class,1);
        contract.setContractID(IDGeneratorService.generateID(Contract.class));
        contract.setContractImage(fileName);
        contract.setStartDate(Date.valueOf(LocalDate.now()));
        contract.setExpiredDate(Date.valueOf(LocalDate.now().plusYears(1)));

        contract.setCustomer(customer);
        System.out.println("contract.getContractID(): " + contract.getContractID());
        System.out.println("contract.getContractImage(): " + contract.getContractImage());
        System.out.println("contract.getStartDate(): " + contract.getStartDate());
        System.out.println("contract.getExpiredDate(): " + contract.getExpiredDate());
        System.out.println(contract.getCustomer().getCustomerID());
        em.persist(contract,Contract.class);

        // Gửi phản hồi hiển thị ảnh đã upload
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><body style='font-family:Arial;text-align:center;'>");
        response.getWriter().println("<h2>Upload Successful!</h2>");
        response.getWriter().println("<img src='assets/" + fileName + "' style='max-width:400px;border-radius:8px;'><br><br>");
        response.getWriter().println("<a href='create_contract.jsp'>← Back to Upload</a>");
        response.getWriter().println("</body></html>");
    }
}