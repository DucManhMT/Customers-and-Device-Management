package crm.contract;

import crm.common.URLConstants;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;

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
        Part filePart = request.getPart("contractImage");
        String fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();

        // Tạo thư mục lưu file nếu chưa có
        String uploadPath = getServletContext().getRealPath("") + File.separator + "assets";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        // Lưu file
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // Gửi phản hồi hiển thị ảnh đã upload
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><body style='font-family:Arial;text-align:center;'>");
        response.getWriter().println("<h2>Upload Successful!</h2>");
        response.getWriter().println("<img src='uploads/" + fileName + "' style='max-width:400px;border-radius:8px;'><br><br>");
        response.getWriter().println("<a href='create_contract.jsp'>← Back to Upload</a>");
        response.getWriter().println("</body></html>");
    }
}