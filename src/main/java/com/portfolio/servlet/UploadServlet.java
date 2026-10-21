package com.portfolio.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

@WebServlet("/uploads/*")
public class UploadServlet extends HttpServlet {
    public static final String UPLOAD_DIR = "D:/PROJECTdATA/PROJECTdATA/SmartCareerRecommendationSystem/Portfolio/uploads";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String fileName = new File(pathInfo).getName();
        File file = new File(UPLOAD_DIR, fileName);
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = Files.probeContentType(file.toPath());
        }
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        resp.setContentType(contentType);
        resp.setContentLengthLong(file.length());

        String download = req.getParameter("download");
        if ("true".equalsIgnoreCase(download)) {
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
        } else {
            resp.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
        }

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = resp.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int length;
            while ((length = in.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
        }
    }
}
