package crm.customer.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Customer;
import crm.common.model.ProductContract;
import crm.customer.service.CustomerProductService;
import crm.service_request.repository.CustomerRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = URLConstants.CUSTOMER_VIEW_PRODUCTS, name = "ViewCustomerProductsServlet")
public class ViewCustomerProductsController extends HttpServlet {

    private static final String VIEW = "/customer/customer_products.jsp";
    private static final String ATTR_ERROR = "error";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            try {
                resp.sendRedirect(req.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
            } catch (IOException e) {
                // ignore
            }
            return;
        }

        String productNameParam = req.getParameter("productName");
        String serialParam = req.getParameter("serial");

        // Resolve the current customer by username
        CustomerRepository customerRepo = new CustomerRepository();
        Customer customer = customerRepo.findByUsername(account.getUsername());
        if (customer == null) {
            req.setAttribute(ATTR_ERROR, "Customer profile not found for this account");
            forward(req, resp);
            return;
        }

        CustomerProductService service = new CustomerProductService();
        List<ProductContract> productContracts = service.getProductContracts(account.getUsername(), productNameParam,
                serialParam);

        req.setAttribute("customer", customer);
        req.setAttribute("productContracts", productContracts);
        req.setAttribute("totalProducts", productContracts != null ? productContracts.size() : 0);
        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.getRequestDispatcher(VIEW).forward(req, resp);
        } catch (Exception e) {
            // ignore forwarding failure
        }
    }
}
