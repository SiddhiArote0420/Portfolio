package com.portfolio.servlet;

import com.portfolio.dao.PortfolioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = {"/portfolio", "/recruiter"})
public class PortfolioServlet extends HttpServlet {
    private final PortfolioDAO dao = new PortfolioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("profile", dao.getProfile());
        req.setAttribute("projects", dao.getAllProjects());
        req.setAttribute("educations", dao.getAllEducation());
        req.setAttribute("certificates", dao.getAllCertificates());
        req.setAttribute("experiences", dao.getAllExperience());
        req.setAttribute("skills", dao.getAllSkills());

        String servletPath = req.getServletPath();
        String view = req.getParameter("view");
        if ("/recruiter".equals(servletPath) || "recruiter".equalsIgnoreCase(view)) {
            req.getRequestDispatcher("/recruiter.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }
}
