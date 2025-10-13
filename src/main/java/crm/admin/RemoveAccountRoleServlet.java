//package crm.admin;
//
//import crm.common.model.Account;
//import crm.core.config.DBcontext;
//import crm.core.repository.hibernate.entitymanager.EntityManager;
//import jakarta.servlet.*;
//import jakarta.servlet.http.*;
//import jakarta.servlet.annotation.*;
//import java.io.IOException;
//
//@WebServlet(name = "RemoveAccountRoleServlet", value = "/RemoveAccountRole")
//public class RemoveAccountRoleServlet extends HttpServlet {
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String username = request.getParameter("username");
//        int roleId = Integer.parseInt(request.getParameter("roleID"));
//        System.out.println("Removing role from user: " + username + " for role ID: " + roleId);
//        try (EntityManager em = new EntityManager(DBcontext.getConnection())) {
//            // Tìm account
//            Account acc = em.find(Account.class, username);
//            if (acc != null && acc.getRole() != null && acc.getRole().getRoleID().equals(roleId)) {
//                acc.setRole(null);
//                em.merge(acc, Account.class);
//            }
//        } catch (Exception e) {
//            throw new ServletException(e);
//        }
//        System.out.println("Removing role from user: " + username + " for role ID: " + roleId);
//        // Quay về lại trang EditRole với thông báo
//        response.sendRedirect(request.getContextPath() + "/EditRole?id=" + roleId + "&remove=1");
//    }
//}