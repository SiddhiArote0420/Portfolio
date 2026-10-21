package com.portfolio.servlet;

import com.portfolio.dao.PortfolioDAO;
import com.portfolio.model.RecruiterMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private final PortfolioDAO dao = new PortfolioDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        RecruiterMessage msg = new RecruiterMessage();
        msg.setRecruiterName(req.getParameter("recruiterName"));
        msg.setCompanyName(req.getParameter("companyName"));
        msg.setRecruiterEmail(req.getParameter("recruiterEmail"));
        msg.setRecruiterPhone(req.getParameter("recruiterPhone"));
        msg.setRoleOffered(req.getParameter("roleOffered"));
        msg.setMessage(req.getParameter("message"));

        boolean saved = dao.saveMessage(msg);
        String source = req.getParameter("source");
        if ("recruiter".equalsIgnoreCase(source)) {
            resp.sendRedirect(req.getContextPath() + "/recruiter.jsp?msg=" + (saved ? "sent" : "error") + "#hire-form");
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp?msg=" + (saved ? "sent" : "error") + "#contact");
        }
    }
}
