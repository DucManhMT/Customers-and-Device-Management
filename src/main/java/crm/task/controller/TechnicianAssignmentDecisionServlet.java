package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.AccountRequest;
import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet(name = "TechnicianAssignmentDecisionServlet", urlPatterns = { URLConstants.TASK_ASSIGNMENT_DECISION })
public class TechnicianAssignmentDecisionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdStr = request.getParameter("requestId");
        String decision = request.getParameter("decision"); 

        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing requestId");
            return;
        }

        if (decision == null || decision.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing decision");
            return;
        }

        Account account = (Account) request.getSession().getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + URLConstants.AUTH_STAFF_LOGIN);
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(requestIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid requestId");
            return;
        }

        Connection conn = null;
        try {
            conn = DBcontext.getConnection();
            conn.setAutoCommit(false);
            EntityManager em = new EntityManager(conn);

            List<AccountRequest> allAccountRequests = em.findAll(AccountRequest.class);
            AccountRequest matched = null;
            for (AccountRequest ar : allAccountRequests) {
                if (ar.getRequest() != null && ar.getRequest().getRequestID() != null
                        && ar.getRequest().getRequestID().equals(requestId)
                        && ar.getAccount() != null && ar.getAccount().getUsername() != null
                        && ar.getAccount().getUsername().equals(account.getUsername())) {
                    matched = ar;
                    break;
                }
            }

            if (matched == null) {
                request.getSession().setAttribute("errorMessage", "No assignment found for this task.");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            Request req = matched.getRequest();
            if (req == null) {
                em.remove(matched, AccountRequest.class);
                conn.commit();
                request.getSession().setAttribute("errorMessage", "Assignment was invalid and has been cleared.");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            String comment = request.getParameter("comment");

            if ("accept".equalsIgnoreCase(decision)) {
                req.setRequestStatus(RequestStatus.Processing);
                em.merge(req, Request.class);

                for (AccountRequest ar : allAccountRequests) {
                    if (ar.getRequest() != null && ar.getRequest().getRequestID() != null
                            && ar.getRequest().getRequestID().equals(requestId)
                            && ar.getAccount() != null && !ar.getAccount().getUsername().equals(account.getUsername())) {
                        try {
                            em.remove(ar, AccountRequest.class);
                        } catch (Exception ignore) {
                        }
                    }
                }

                conn.commit();
                System.out.println("AssignmentDecision: user=" + account.getUsername() + " accepted request=" + requestId + " comment=" + comment);
                request.getSession().setAttribute("successMessage", "You have accepted the task. Status is now Processing.");
            } else {
                em.remove(matched, AccountRequest.class);
                conn.commit();
                System.out.println("AssignmentDecision: user=" + account.getUsername() + " declined request=" + requestId + " comment=" + comment);
                request.getSession().setAttribute("successMessage", "You declined the assigned task. It remains pending for reassignment.");
            }

            response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing assignment decision: " + e.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignore) {}
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestIdStr = request.getParameter("requestId");
        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Missing requestId");
            response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(requestIdStr);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid requestId");
            response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
            return;
        }

        try (Connection conn = DBcontext.getConnection()) {
            EntityManager em = new EntityManager(conn);
            Request req = em.find(Request.class, requestId);
            if (req == null) {
                request.getSession().setAttribute("errorMessage", "Task not found");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            request.setAttribute("requestItem", req);
            request.setAttribute("action", request.getParameter("action"));
            request.getRequestDispatcher("/technician_employee/assignment_decision.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading assignment decision page: " + e.getMessage());
        }
    }
}
