package crm.router.technicianemployee;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Staff;
import crm.common.model.Task;
import crm.common.model.enums.TaskStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "toTechnicianEmployeeActionCenter", value = "/technician_employee/techemployee_actioncenter")
public class toTechnicianEmployeeActionCenter extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Connection connection = null;
        try {
            connection = DBcontext.getConnection();
            EntityManager entityManager = new EntityManager(connection);

            Account account = (Account) req.getSession().getAttribute("account");
            if (account == null) {
                resp.sendRedirect(req.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
                return;
            }

            String username = account.getUsername();
            if (username == null || username.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
                return;
            }

            // Get current user's staff record
            List<Staff> allStaff = entityManager.findAll(Staff.class);
            Staff currentStaff = allStaff.stream()
                    .filter(s -> s.getAccount() != null && username.equals(s.getAccount().getUsername()))
                    .findFirst()
                    .orElse(null);

            if (currentStaff == null) {
                req.setAttribute("errorMessage", "Staff record not found for current user.");
                req.setAttribute("totalTasks", 0);
                req.setAttribute("processingTasks", 0);
                req.setAttribute("finishedTasks", 0);
                req.setAttribute("nearDueTasks", 0);
                req.setAttribute("overdueTasks", 0);
                req.setAttribute("todayTasks", 0);
                req.setAttribute("recentTasks", Collections.emptyList());
                req.getRequestDispatcher("/technician_employee/techemployee_actioncenter.jsp").forward(req, resp);
                return;
            }

            // Get all tasks assigned to current technician
            List<Task> allTasks = entityManager.findAll(Task.class);
            List<Task> myTasks = allTasks.stream()
                    .filter(task -> task != null)
                    .filter(task -> task.getAssignTo() != null)
                    .filter(task -> currentStaff.getStaffID().equals(task.getAssignTo().getStaffID()))
                    .filter(task -> task.getStatus() == TaskStatus.Processing || task.getStatus() == TaskStatus.Finished)
                    .collect(Collectors.toList());

            // Calculate statistics
            int totalTasks = myTasks.size();
            int processingTasks = (int) myTasks.stream()
                    .filter(task -> task.getStatus() == TaskStatus.Processing)
                    .count();
            int finishedTasks = (int) myTasks.stream()
                    .filter(task -> task.getStatus() == TaskStatus.Finished)
                    .count();

            // Calculate near due and overdue tasks
            LocalDate today = LocalDate.now();
            int nearDueTasks = (int) myTasks.stream()
                    .filter(task -> task.getStatus() == TaskStatus.Processing)
                    .filter(task -> task.getDeadline() != null)
                    .filter(task -> {
                        LocalDate deadline = task.getDeadline().toLocalDate();
                        long daysUntilDeadline = java.time.temporal.ChronoUnit.DAYS.between(today, deadline);
                        return daysUntilDeadline >= 0 && daysUntilDeadline <= 3;
                    })
                    .count();

            int overdueTasks = (int) myTasks.stream()
                    .filter(task -> task.getStatus() == TaskStatus.Processing)
                    .filter(task -> task.getDeadline() != null)
                    .filter(task -> task.getDeadline().toLocalDate().isBefore(today))
                    .count();

            // Today's tasks (tasks with deadline today)
            int todayTasks = (int) myTasks.stream()
                    .filter(task -> task.getStatus() == TaskStatus.Processing)
                    .filter(task -> task.getDeadline() != null)
                    .filter(task -> task.getDeadline().toLocalDate().equals(today))
                    .count();

            // Get recent tasks (last 5 processing tasks sorted by start date)
            List<Task> recentTasks = myTasks.stream()
                    .filter(task -> task.getStatus() == TaskStatus.Processing)
                    .sorted((t1, t2) -> {
                        LocalDateTime dt1 = t1.getStartDate();
                        LocalDateTime dt2 = t2.getStartDate();
                        if (dt1 == null && dt2 == null) return 0;
                        if (dt1 == null) return 1;
                        if (dt2 == null) return -1;
                        return dt2.compareTo(dt1); // Descending order
                    })
                    .limit(5)
                    .collect(Collectors.toList());

            // Set attributes
            req.setAttribute("totalTasks", totalTasks);
            req.setAttribute("processingTasks", processingTasks);
            req.setAttribute("finishedTasks", finishedTasks);
            req.setAttribute("nearDueTasks", nearDueTasks);
            req.setAttribute("overdueTasks", overdueTasks);
            req.setAttribute("todayTasks", todayTasks);
            req.setAttribute("recentTasks", recentTasks);

            req.getRequestDispatcher("/technician_employee/techemployee_actioncenter.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred while loading dashboard data: " + e.getMessage());
            req.setAttribute("totalTasks", 0);
            req.setAttribute("processingTasks", 0);
            req.setAttribute("finishedTasks", 0);
            req.setAttribute("nearDueTasks", 0);
            req.setAttribute("overdueTasks", 0);
            req.setAttribute("todayTasks", 0);
            req.setAttribute("recentTasks", Collections.emptyList());
            req.getRequestDispatcher("/technician_employee/techemployee_actioncenter.jsp").forward(req, resp);
        } finally {
            if (connection != null) {

            }
        }
    }
}
