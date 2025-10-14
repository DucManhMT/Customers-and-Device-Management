package crm.auth.controller;

import crm.common.model.Account;
import crm.common.repository.account.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CheckUsername", value = "/api/check_username")
public class CheckUsername extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        AccountDAO accountDAO = new AccountDAO();
        String username = req.getParameter("username");
        Account account = accountDAO.find(username);
        boolean exists = account != null;

        if (exists){
            String jsonResponse = String.format("{\"exists\": true}" );
            resp.getWriter().write(jsonResponse);
        }
        else {
            String jsonResponse = String.format("{\"exists\": false}" );
            resp.getWriter().write(jsonResponse);
        }
    }
}
