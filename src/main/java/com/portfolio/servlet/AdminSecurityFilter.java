package com.portfolio.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;

/**
 * Server-side authentication and ROLE_ADMIN authorization filter protecting
 * all admin dashboard pages and admin backend endpoints.
 */
@WebFilter(urlPatterns = {"/admin", "/admin/*", "/admin.jsp", "/admin-login.jsp"})
public class AdminSecurityFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Apply strict no-cache and security headers to all admin endpoints
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        resp.setHeader("X-Frame-Options", "SAMEORIGIN");
        resp.setHeader("X-Content-Type-Options", "nosniff");
        resp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

        String servletPath = req.getServletPath();
        String method = req.getMethod();
        String action = req.getParameter("action");

        HttpSession session = req.getSession(false);
        boolean isAuthenticated = (session != null && session.getAttribute("adminUser") != null);
        boolean hasAdminRole = (isAuthenticated && "ROLE_ADMIN".equals(session.getAttribute("adminRole")));

        if ("/admin-login.jsp".equalsIgnoreCase(servletPath)) {
            if (hasAdminRole && req.getParameter("logout") == null) {
                resp.sendRedirect(req.getContextPath() + "/admin");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Allow login POST and logout GET to proceed to AdminServlet
        if ("/admin".equalsIgnoreCase(servletPath)) {
            if ("POST".equalsIgnoreCase(method) && "login".equalsIgnoreCase(action)) {
                chain.doFilter(request, response);
                return;
            }
            if ("GET".equalsIgnoreCase(method) && "logout".equalsIgnoreCase(action)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Require both authentication and ROLE_ADMIN authorization
        if (!isAuthenticated || !hasAdminRole) {
            int statusCode = isAuthenticated ? HttpServletResponse.SC_FORBIDDEN : HttpServletResponse.SC_UNAUTHORIZED;
            if (isApiOrMutatingRequest(req, method, action)) {
                resp.setStatus(statusCode);
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().print("{\"success\":false,\"error\":\"Unauthorized: Administrator authentication and ROLE_ADMIN authorization required.\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin-login.jsp");
            }
            return;
        }

        // Ensure a session-bound CSRF token exists for the authorized admin session
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }

        chain.doFilter(request, response);
    }

    private boolean isApiOrMutatingRequest(HttpServletRequest req, String method, String action) {
        if (!"GET".equalsIgnoreCase(method) && !"HEAD".equalsIgnoreCase(method)) {
            return true;
        }
        if (action != null && !action.trim().isEmpty()) {
            return true;
        }
        String accept = req.getHeader("Accept");
        String xrw = req.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(xrw)) {
            return true;
        }
        if (accept != null && accept.toLowerCase().contains("application/json")
                && !accept.toLowerCase().contains("text/html")) {
            return true;
        }
        return false;
    }
}
