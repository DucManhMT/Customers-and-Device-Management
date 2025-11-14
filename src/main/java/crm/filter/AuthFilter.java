package crm.filter;

import crm.common.URLConstants;
import crm.filter.service.PermissionService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;

        String context = req.getContextPath();
        String uri = req.getRequestURI().substring(context.length());

        // Cho qua file tĩnh
        if (uri.matches(".*(\\.css|\\.js|\\.png|\\.jpg|\\.jpeg|\\.gif|\\.woff|\\.ttf)$")) {
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }

        // Nếu là public URL -> cho qua
        if (PermissionService.isPublicUrl(uri)) {
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }

        if (PermissionService.isProtectedUrl(uri)) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("account") == null) {
                resp.sendRedirect(context + URLConstants.HOME);
                return;
            }
        }

        // Mặc định cho qua (nếu không khớp bất kỳ rule nào)
        filterChain.doFilter(servletRequest, servletResponse);
    }
}
