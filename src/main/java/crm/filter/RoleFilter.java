package crm.filter;

import crm.common.model.Account;
import crm.common.model.Feature;
import crm.filter.service.PermissionService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebFilter("/*")
public class RoleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;

        String context = req.getContextPath();
        String uri = req.getRequestURI().substring(context.length());

        Map<Integer, List<Feature>> roleFeatureMap = PermissionService.getRoleFeatureMap();
        Account acc = (Account) req.getSession().getAttribute("account");

        if (acc != null) {
            if (acc.getRole().getRoleName().equals("Admin")) {
                filterChain.doFilter(servletRequest, servletResponse);
                return;
            }
            if (PermissionService.isProtectedUrl(uri)) {
                List<Feature> features = roleFeatureMap.get(acc.getRole().getRoleID());
                boolean hasPermission = features != null && features.stream()
                        .anyMatch(feature -> uri.equals(feature.getFeatureURL()));
                if (!hasPermission) {
                    resp.sendRedirect(context + "/unauthorized");
                    return;
                }
            }
        }
        filterChain.doFilter(servletRequest, servletResponse);

    }
}
