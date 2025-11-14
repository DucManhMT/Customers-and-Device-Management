package crm.router.warehousekeeper;

import crm.common.model.*;
import crm.common.model.enums.TransactionStatus;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "toViewProductTransaction", value = "/product/view_product_transaction")
public class toViewProductTransaction extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = req.getSession();
        List<ProductTransaction> productTransactions = em.findAll(ProductTransaction.class);

        Account account = (Account) session.getAttribute("account");
        Role role = account.getRole();
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        Warehouse warehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        if (role.getRoleName().equals("WarehouseKeeper")) {
            productTransactions = productTransactions.stream()
                    .filter(pt ->  pt.getTransactionStatus().equals(TransactionStatus.Import) && pt.getDestinationWarehouse().getWarehouseID() == warehouse.getWarehouseID() ||
                                  pt.getTransactionStatus().equals(TransactionStatus.Export) && pt.getSourceWarehouse().getWarehouseID() == warehouse.getWarehouseID())
                    .toList();
        }

        req.setAttribute("productTransactions", productTransactions);
        req.getRequestDispatcher("/warehouse_keeper/view_product_transaction.jsp").forward(req, resp);
    }
}
