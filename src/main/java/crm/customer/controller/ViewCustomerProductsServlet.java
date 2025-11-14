package crm.customer.controller;

import crm.common.URLConstants;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.common.model.InventoryItem;
import crm.common.model.Product;
import crm.common.model.ProductContract;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(urlPatterns = URLConstants.CUSTOMER_SUPPORTER_VIEW_ALL_PRODUCTS, name = "ViewCustomerProductsServlet")
public class ViewCustomerProductsServlet extends HttpServlet {
    private static final String ATTR_ERROR = "error";
    private static final String VIEW = "/customer/customer_products.jsp";

    public static class CustomerProductRow {
        private final Integer contractId;
        private final String contractCode;
        private final Integer productId;
        private final String productName;
        private final String itemSerial;

        public CustomerProductRow(Integer contractId, String contractCode, Integer productId, String productName,
                String itemSerial) {
            this.contractId = contractId;
            this.contractCode = contractCode;
            this.productId = productId;
            this.productName = productName;
            this.itemSerial = itemSerial;
        }

        public Integer getContractId() {
            return contractId;
        }

        public String getContractCode() {
            return contractCode;
        }

        public Integer getProductId() {
            return productId;
        }

        public String getProductName() {
            return productName;
        }

        public String getItemSerial() {
            return itemSerial;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String customerIdParam = req.getParameter("customerId");
        String usernameParam = req.getParameter("username");
        String productNameParam = req.getParameter("productName");
        String serialParam = req.getParameter("serial");

        String productNameFilter = productNameParam != null ? productNameParam.trim().toLowerCase() : null;
        String serialFilter = serialParam != null ? serialParam.trim().toLowerCase() : null;
        Integer customerId = null;
        // Resolve customer via username if provided
        if (usernameParam != null && !usernameParam.isBlank()) {
            try {
                crm.service_request.repository.CustomerRepository customerRepo = new crm.service_request.repository.CustomerRepository();
                Customer found = customerRepo.findByUsername(usernameParam.trim());
                if (found != null) {
                    customerId = found.getCustomerID();
                } else {
                    req.setAttribute(ATTR_ERROR, "Customer not found by username");
                }
            } catch (Exception ignored) {
                req.setAttribute(ATTR_ERROR, "Error resolving username");
            }
        }
        // Fallback to explicit customerId param if available
        if (customerId == null && customerIdParam != null && !customerIdParam.isBlank()) {
            try {
                customerId = Integer.parseInt(customerIdParam.trim());
            } catch (NumberFormatException e) {
                req.setAttribute(ATTR_ERROR, "Invalid customerId");
            }
        }
        if (customerId == null) {
            // Missing both username and valid customerId
            forward(req, resp);
            return;
        }

        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<CustomerProductRow> rows = new ArrayList<>();
        Customer customer = null;
        try {
            List<ProductContract> pcs = em.findAll(ProductContract.class);
            if (pcs != null) {
                Set<Integer> seenItemIds = new HashSet<>();
                for (ProductContract pc : pcs) {
                    boolean valid = true;

                    Contract c;
                    try {
                        c = pc.getContract();
                    } catch (Exception e) {
                        c = null;
                    }
                    if (c == null)
                        valid = false;

                    Customer cus = null;
                    if (valid) {
                        try {
                            cus = c.getCustomer();
                        } catch (Exception e) {
                            cus = null;
                        }
                        if (cus == null || cus.getCustomerID() == null || !cus.getCustomerID().equals(customerId)) {
                            valid = false;
                        }
                    }

                    InventoryItem item = null;
                    if (valid) {
                        try {
                            item = pc.getInventoryItem();
                        } catch (Exception e) {
                            item = null;
                        }
                        if (item == null || item.getItemId() == null) {
                            valid = false;
                        }
                    }

                    if (valid && !seenItemIds.add(item.getItemId())) {
                        valid = false; // duplicate item row
                    }

                    Product product = null;
                    if (valid) {
                        try {
                            product = item.getProduct();
                        } catch (Exception e) {
                            product = null;
                        }
                    }

                    if (valid) {
                        String pName = product != null ? product.getProductName() : null;
                        String serial = item.getSerialNumber();
                        boolean nameOk = (productNameFilter == null || productNameFilter.isBlank())
                                || (pName != null && pName.toLowerCase().contains(productNameFilter));
                        boolean serialOk = (serialFilter == null || serialFilter.isBlank())
                                || (serial != null && serial.toLowerCase().contains(serialFilter));
                        valid = nameOk && serialOk;
                    }

                    if (!valid) {
                        continue;
                    }

                    if (customer == null) {
                        customer = cus; // keep for header
                    }

                    rows.add(new CustomerProductRow(
                            c.getContractID(),
                            c.getContractCode(),
                            product != null ? product.getProductID() : null,
                            product != null ? product.getProductName() : null,
                            item.getSerialNumber()));
                }
            }
        } catch (Exception e) {
            // keep empty rows on failure
        }

        req.setAttribute("customer", customer);
        req.setAttribute("products", rows);
        req.setAttribute("totalProducts", rows.size());
        req.setAttribute("searchUsername", usernameParam);
        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.getRequestDispatcher(VIEW).forward(req, resp);
        } catch (Exception ignored) {
            // swallow
        }
    }
}
