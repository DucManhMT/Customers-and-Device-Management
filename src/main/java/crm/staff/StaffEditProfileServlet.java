package crm.staff;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.validator.Validator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "StaffEditProfileServlet", value = URLConstants.STAFF_EDIT_PROFILE)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 5,         // 5MB
        maxRequestSize = 1024 * 1024 * 10      // 10MB
)
public class StaffEditProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/images/profiles";
    private static final String DEFAULT_IMAGE = "assets/images/profiles/default-avatar.png";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        EntityManager em = new EntityManager(DBcontext.getConnection());
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/auth/staff_login");
            return;
        }
        Map<String, Object> cond = new HashMap<>();
        cond.put("account", account.getUsername());
        Staff staff = em.findWithConditions(Staff.class, cond).get(0);
        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/staff/staff_edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        String accountName = request.getParameter("accountName");
        String accountEmail = request.getParameter("accountEmail");
        String accountPhone = request.getParameter("accountPhone");
        String accountAddress = request.getParameter("accountAddress");

        // Validate fields
        if (!Validator.isValidName(accountName)) {
            session.setAttribute("error", "Account name contains invalid characters.");
            response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
            return;
        }

        if (!Validator.isValidEmail(accountEmail)) {
            session.setAttribute("error", "Invalid email format.");
            response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
            return;
        }

        if (!Validator.isValidPhone(accountPhone)) {
            session.setAttribute("error", "Invalid phone number format.");
            response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
            return;
        }

        // Find current staff
        Map<String, Object> cond = new HashMap<>();
        cond.put("account", account.getUsername());
        Staff currentStaff = em.findWithConditions(Staff.class, cond).get(0);

        // Check duplicate phone
        List<Staff> existingPhones = em.findWithConditions(Staff.class, Map.of("phone", accountPhone))
                .stream()
                .filter(s -> !s.getStaffID().equals(currentStaff.getStaffID()))
                .toList();

        if (!existingPhones.isEmpty()) {
            session.setAttribute("error", "Phone number already in use by another staff.");
            response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
            return;
        }

        // Process image upload (NEW)
        String oldImagePath = currentStaff.getImage();
        String newImagePath = processImageUpload(request, currentStaff.getAccount().getUsername());

        // Update Staff
        currentStaff.setStaffName(accountName);
        currentStaff.setEmail(accountEmail);
        currentStaff.setPhone(accountPhone);
        currentStaff.setAddress(accountAddress);
        currentStaff.setImage(newImagePath);

        em.merge(currentStaff, Staff.class);

        // If uploaded new image → delete old
        if (!newImagePath.equals(DEFAULT_IMAGE) && oldImagePath != null && !oldImagePath.equals(DEFAULT_IMAGE)) {
            deleteUploadedImage(request, oldImagePath);
        }

        session.setAttribute("success", "Account updated successfully.");
        response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
    }

    private String processImageUpload(HttpServletRequest request, String username) throws IOException, ServletException {
        Part filePart = request.getPart("profileImage");
        if (filePart == null || filePart.getSize() == 0) {
            return DEFAULT_IMAGE;
        }

        String fileName = getFileName(filePart);
        String contentType = filePart.getContentType();

        if (!isValidImageType(contentType)) {
            throw new ServletException("Invalid file type (only JPG, PNG, GIF allowed)");
        }

        String extension = getFileExtension(fileName);
        String uniqueFileName = username + "_profile" + extension;

        String uploadPath = getUploadPath(request);
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        Path filePath = Paths.get(uploadPath, uniqueFileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        return UPLOAD_DIR + "/" + uniqueFileName;
    }

    private String getUploadPath(HttpServletRequest request) {
        String appPath = request.getServletContext().getRealPath("");
        return appPath + File.separator + UPLOAD_DIR;
    }

    private String getFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        for (String token : cd.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 1).replace("\"", "").trim();
            }
        }
        return null;
    }

    private boolean isValidImageType(String type) {
        return type != null &&
                (type.equals("image/jpeg") ||
                        type.equals("image/png") ||
                        type.equals("image/jpg") ||
                        type.equals("image/gif"));
    }

    private String getFileExtension(String fileName) {
        if (fileName == null) return "";
        int lastDot = fileName.lastIndexOf(".");
        return (lastDot == -1) ? "" : fileName.substring(lastDot);
    }

    private void deleteUploadedImage(HttpServletRequest request, String imagePath) {
        try {
            String appPath = request.getServletContext().getRealPath("");
            Path deletePath = Paths.get(appPath, imagePath);
            Files.deleteIfExists(deletePath);
        } catch (Exception ignored) {}
    }
}
