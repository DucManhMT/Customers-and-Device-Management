package crm.customer.controller;

import crm.common.URLConstants;
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

@WebServlet(urlPatterns = URLConstants.CUSTOMER_SUPPORTER_VIEW_ALL_PRODUCTS, name = "ViewStaffCustomerProductsServlet")
public class ViewStaffCustomerProductsController extends HttpServlet {
    private static final String ATTR_ERROR = "error";
    private static final String VIEW = "/customer_supporter/customer_products.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String customerIdParam = req.getParameter("customerId");
        String usernameParam = req.getParameter("username");
        String productNameParam = req.getParameter("productName");
        String serialParam = req.getParameter("serial");

        // normalize if needed later
        // Determine username for search
        String username = null;
        CustomerRepository customerRepo = new CustomerRepository();
        if (usernameParam != null && !usernameParam.isBlank()) {
            username = usernameParam.trim();
        } else if (customerIdParam != null && !customerIdParam.isBlank()) {
            try {
                Integer cid = Integer.parseInt(customerIdParam.trim());
                Customer c = customerRepo.findById(cid);
                if (c != null && c.getAccount() != null) {
                    username = c.getAccount().getUsername();
                }
            } catch (NumberFormatException ignored) {
                req.setAttribute(ATTR_ERROR, "Invalid customerId");
            }
        }

        // Fetch product contracts via service
        CustomerProductService service = new CustomerProductService();
        List<ProductContract> productContracts = service.getProductContracts(username, productNameParam, serialParam);

        // Derive customer header if available
        Customer customer = null;
        if (productContracts != null && !productContracts.isEmpty()) {
            try {
                customer = productContracts.get(0).getContract().getCustomer();
            } catch (Exception e) {
                // ignore and fallback below
            }
        } else if (username != null) {
            customer = customerRepo.findByUsername(username);
        }

        req.setAttribute("customer", customer);
        req.setAttribute("productContracts", productContracts);
        req.setAttribute("totalProducts", productContracts != null ? productContracts.size() : 0);
        req.setAttribute("searchUsername", usernameParam);
        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.getRequestDispatcher(VIEW).forward(req, resp);
        } catch (Exception e) {
            // ignore forwarding failures in this context
        }
    }
}
