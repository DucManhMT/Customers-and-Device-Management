package crm.admin;

import crm.common.model.*;
import crm.common.model.enums.AccountStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;

@WebServlet(name = "AdminCreateAccountController", value = "/admin/create_account_controller")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 5,         // 5MB
        maxRequestSize = 1024 * 1024 * 10      // 10MB
)
public class AdminCreateAccountController extends HttpServlet {
    private static final String UPLOAD_DIR = "assets/images/profiles";
    private static final String DEFAULT_IMAGE = "assets/images/profiles/default-avatar.png";
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String phone = req.getParameter("phone");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String address = req.getParameter("address");
        int roleID = Integer.parseInt(req.getParameter("role"));
        String provinceID = req.getParameter("province");
        String villageID = req.getParameter("village");
        LocalDate dateOfBirth = LocalDate.parse(req.getParameter("dateOfBirth"));
        HttpSession session = req.getSession();


        try{
            EntityManager em = new EntityManager(DBcontext.getConnection());
            em.beginTransaction();

            //Create Account
            Account newAccount = new Account();
            Role role = em.find(Role.class, roleID);
            newAccount.setUsername(username);
            newAccount.setPasswordHash(password);
            newAccount.setRole(role);
            newAccount.setAccountStatus(AccountStatus.Active);
            boolean createAccountSuccess = em.persist(newAccount, Account.class);


            //Create Staff
            if (createAccountSuccess) {
                String provinceName = em.find(Province.class, Integer.parseInt(provinceID)).getProvinceName();
                String villageName = em.find(Village.class, Integer.parseInt(villageID)).getVillageName();
                String fullName = firstName + " " + lastName;
                String fullAddress = address + ", " + villageName + ", " + provinceName;
                String imagePath = processImageUpload(req);

                Staff newStaff = new Staff();
                newStaff.setStaffID(IDGeneratorService.generateID(Staff.class));
                newStaff.setStaffName(fullName);
                newStaff.setPhone(phone);
                newStaff.setAddress(fullAddress);
                newStaff.setEmail(email);
                newStaff.setImage(imagePath);
                newStaff.setDateOfBirth(dateOfBirth);
                newStaff.setAccount(newAccount);
                boolean createStaffSuccess = em.persist(newStaff, Staff.class);
                if (createStaffSuccess) {
                    em.commit();
                    session.setAttribute("successMessage", "Staff account created successfully.");
                    session.removeAttribute("errorMessage");
                    resp.sendRedirect(req.getContextPath() + "/admin/create_account");
                } else {
                    deleteUploadedImage(req, newStaff.getImage());
                    em.rollback();
                    session.setAttribute("errorMessage", "Failed to create staff profile.");
                    session.removeAttribute("successMessage");
                    resp.sendRedirect(req.getContextPath() + "/admin/create_account");
                }
            }
        }catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            session.removeAttribute("successMessage");
            resp.sendRedirect(req.getContextPath() + "/admin/create_account");
        }
    }
    private String processImageUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("profileImage");
        String username = request.getParameter("username");
        // If no file uploaded, return default image path
        if (filePart == null || filePart.getSize() == 0) {
            return DEFAULT_IMAGE;
        }

        // get file name
        String fileName = getFileName(filePart);

        // validate file type
        String contentType = filePart.getContentType();
        if (!isValidImageType(contentType)) {
            throw new ServletException("Invalid file type. Only JPG, JPEG, PNG, GIF are allowed.");
        }

        // Validate file size (5MB)
        if (filePart.getSize() > 5 * 1024 * 1024) {
            throw new ServletException("File size exceeds 5MB limit.");
        }

        // Tạo tên file unique
        String fileExtension = getFileExtension(fileName);
        String uniqueFileName = username + "_profileImage" + fileExtension;

        // get real upload path
        String uploadPath = getUploadPath(request);
        //
        System.out.println(uploadPath);

        // Tạo thư mục nếu chưa tồn tại
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Lưu file
        Path filePath = Paths.get(uploadPath, uniqueFileName);
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        // get relative path to save in DB
        return UPLOAD_DIR + "/" + uniqueFileName;
    }

    //get upload path
    private String getUploadPath(HttpServletRequest request) {
        String applicationPath = request.getServletContext().getRealPath("");
        return applicationPath + File.separator + UPLOAD_DIR;
    }

    //get file name from part
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    //get file extension
    private String getFileExtension(String fileName) {
        if (fileName == null) return "";
        int lastDotIndex = fileName.lastIndexOf('.');
        return (lastDotIndex == -1) ? "" : fileName.substring(lastDotIndex);
    }

    //check valid image type
    private boolean isValidImageType(String contentType) {
        return contentType != null &&
                (contentType.equals("image/jpeg") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/png") ||
                        contentType.equals("image/gif"));
    }

    //delete uploaded image if needed
    private void deleteUploadedImage(HttpServletRequest request, String imagePath) {
        if (imagePath == null || imagePath.isEmpty()) return;

        try {
            String applicationPath = request.getServletContext().getRealPath("");
            Path fileToDelete = Paths.get(applicationPath, imagePath);
            Files.deleteIfExists(fileToDelete);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
