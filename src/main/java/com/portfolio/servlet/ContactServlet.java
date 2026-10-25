package com.portfolio.servlet;

import com.portfolio.dao.PortfolioDAO;
import com.portfolio.model.Profile;
import com.portfolio.model.RecruiterMessage;
import com.portfolio.util.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = {"/contact", "/api/contact"})
public class ContactServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Set<String> DEFAULT_TRUSTED_ORIGINS = new HashSet<>(Arrays.asList(
            "http://localhost:8080",
            "http://127.0.0.1:8080",
            "https://siddhiarote0420.github.io"
    ));

    private final PortfolioDAO dao = new PortfolioDAO();

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        applyCorsHeaders(req, resp);
        resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        applyCorsHeaders(req, resp);

        boolean wantsJson = isJsonOrAjaxRequest(req);

        String name = firstNonEmpty(req.getParameter("recruiterName"), req.getParameter("name"));
        String email = firstNonEmpty(req.getParameter("recruiterEmail"), req.getParameter("email"));
        String subject = firstNonEmpty(req.getParameter("roleOffered"), req.getParameter("subject"));
        String messageText = req.getParameter("message");
        String company = req.getParameter("companyName");
        String phone = req.getParameter("recruiterPhone");
        String source = req.getParameter("source");

        if (name == null && email == null && subject == null && messageText == null) {
            String contentType = req.getContentType();
            if (contentType != null && contentType.toLowerCase().contains("application/json")) {
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = req.getReader()) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line);
                    }
                }
                String rawJson = sb.toString();
                name = firstNonEmpty(extractJsonString(rawJson, "recruiterName"), extractJsonString(rawJson, "name"));
                email = firstNonEmpty(extractJsonString(rawJson, "recruiterEmail"), extractJsonString(rawJson, "email"));
                subject = firstNonEmpty(extractJsonString(rawJson, "roleOffered"), extractJsonString(rawJson, "subject"));
                messageText = extractJsonString(rawJson, "message");
                company = extractJsonString(rawJson, "companyName");
                phone = extractJsonString(extractJsonString(rawJson, "recruiterPhone"), extractJsonString(rawJson, "phone"));
                source = extractJsonString(rawJson, "source");
            }
        }

        name = name != null ? name.trim() : "";
        email = email != null ? email.trim() : "";
        subject = subject != null ? subject.trim() : "";
        messageText = messageText != null ? messageText.trim() : "";
        company = (company != null && !company.trim().isEmpty()) ? company.trim() : "Direct Portfolio Inquiry";
        phone = phone != null ? phone.trim() : "";

        // Backend validation
        String validationError = validateFields(name, email, subject, messageText);
        if (validationError != null) {
            if (wantsJson) {
                sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false,
                        "Sorry, your message could not be sent. Please try again.", validationError);
            } else {
                redirectFallback(req, resp, source, false);
            }
            return;
        }

        RecruiterMessage msg = new RecruiterMessage();
        msg.setRecruiterName(name);
        msg.setCompanyName(company);
        msg.setRecruiterEmail(email);
        msg.setRecruiterPhone(phone);
        msg.setRoleOffered(subject);
        msg.setMessage(messageText);

        // Save to database inbox for Admin Dashboard visibility (non-destructive)
        try {
            dao.saveMessage(msg);
        } catch (Exception ignored) {
        }

        // Send email notification to configured inbox
        boolean emailSent = false;
        try {
            String recipientEmail = "siddhiarote5@gmail.com";
            try {
                Profile profile = dao.getProfile();
                if (profile != null && profile.getEmail() != null && !profile.getEmail().trim().isEmpty()) {
                    recipientEmail = profile.getEmail().trim();
                }
            } catch (Exception ignored) {
            }
            EmailService.sendContactEmail(msg, recipientEmail);
            emailSent = true;
        } catch (Exception e) {
            e.printStackTrace();
            emailSent = false;
        }

        if (wantsJson) {
            if (emailSent) {
                sendJsonResponse(resp, HttpServletResponse.SC_OK, true,
                        "Message sent successfully! Thank you for contacting me.", null);
            } else {
                sendJsonResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, false,
                        "Sorry, your message could not be sent. Please try again.", "Email delivery failed.");
            }
        } else {
            redirectFallback(req, resp, source, emailSent);
        }
    }

    private String validateFields(String name, String email, String subject, String message) {
        if (name.isEmpty() || name.length() > 150) {
            return "Please provide a valid name (1-150 characters).";
        }
        if (email.isEmpty() || email.length() > 150 || email.contains("\r") || email.contains("\n")
                || !EMAIL_PATTERN.matcher(email).matches()) {
            return "Please provide a valid email address.";
        }
        if (subject.isEmpty() || subject.length() > 200 || subject.contains("\r") || subject.contains("\n")) {
            return "Please provide a valid subject (1-200 characters).";
        }
        if (message.isEmpty() || message.length() > 5000) {
            return "Please provide a message (1-5000 characters).";
        }
        return null;
    }

    private boolean isJsonOrAjaxRequest(HttpServletRequest req) {
        String accept = req.getHeader("Accept");
        String xrw = req.getHeader("X-Requested-With");
        String ct = req.getContentType();
        String servletPath = req.getServletPath();
        return (accept != null && accept.toLowerCase().contains("application/json"))
                || "XMLHttpRequest".equalsIgnoreCase(xrw)
                || (ct != null && ct.toLowerCase().contains("application/json"))
                || "/api/contact".equalsIgnoreCase(servletPath);
    }

    private void applyCorsHeaders(HttpServletRequest req, HttpServletResponse resp) {
        String origin = req.getHeader("Origin");
        if (origin != null && isTrustedOrigin(origin)) {
            resp.setHeader("Access-Control-Allow-Origin", origin);
            resp.setHeader("Vary", "Origin");
            resp.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
            resp.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");
            resp.setHeader("Access-Control-Max-Age", "3600");
        }
    }

    private boolean isTrustedOrigin(String origin) {
        String clean = origin.trim();
        if (DEFAULT_TRUSTED_ORIGINS.contains(clean)) {
            return true;
        }
        String extra = EmailService.getConfig("ALLOWED_CORS_ORIGINS", "allowed.cors.origins", "");
        if (!extra.isEmpty()) {
            for (String allowed : extra.split(",")) {
                if (clean.equalsIgnoreCase(allowed.trim())) {
                    return true;
                }
            }
        }
        return false;
    }

    private void sendJsonResponse(HttpServletResponse resp, int status, boolean success, String message, String error) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(success).append(",");
        json.append("\"message\":\"").append(escapeJson(message)).append("\"");
        if (error != null && !error.isEmpty()) {
            json.append(",\"error\":\"").append(escapeJson(error)).append("\"");
        }
        json.append("}");
        try (PrintWriter out = resp.getWriter()) {
            out.print(json.toString());
        }
    }

    private void redirectFallback(HttpServletRequest req, HttpServletResponse resp, String source, boolean ok) throws IOException {
        if ("recruiter".equalsIgnoreCase(source)) {
            resp.sendRedirect(req.getContextPath() + "/recruiter.jsp?msg=" + (ok ? "sent" : "error") + "#hire-form");
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp?msg=" + (ok ? "sent" : "error") + "#contact");
        }
    }

    private static String firstNonEmpty(String a, String b) {
        if (a != null && !a.trim().isEmpty()) return a;
        if (b != null && !b.trim().isEmpty()) return b;
        return null;
    }

    private static String extractJsonString(String json, String key) {
        if (json == null || key == null) return null;
        Pattern p = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");
        Matcher m = p.matcher(json);
        if (m.find()) {
            return m.group(1)
                    .replace("\\\"", "\"")
                    .replace("\\n", "\n")
                    .replace("\\r", "\r")
                    .replace("\\t", "\t")
                    .replace("\\\\", "\\");
        }
        return null;
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
}
