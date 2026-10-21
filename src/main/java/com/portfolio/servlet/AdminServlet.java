package com.portfolio.servlet;

import com.portfolio.dao.PortfolioDAO;
import com.portfolio.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@WebServlet("/admin")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 25,       // 25 MB
        maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class AdminServlet extends HttpServlet {
    private final PortfolioDAO dao = new PortfolioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String action = req.getParameter("action");

        if ("logout".equalsIgnoreCase(action)) {
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/admin-login.jsp?logout=1");
            return;
        }

        if (session == null || session.getAttribute("adminUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin-login.jsp");
            return;
        }

        if ("deleteProject".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            dao.deleteProject(id);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=projects&status=deleted");
            return;
        } else if ("deleteEducation".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            dao.deleteEducation(id);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=education&status=deleted");
            return;
        } else if ("deleteCertificate".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            dao.deleteCertificate(id);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=certificates&status=deleted");
            return;
        } else if ("deleteExperience".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            dao.deleteExperience(id);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=experience&status=deleted");
            return;
        } else if ("deleteSkill".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            dao.deleteSkill(id);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=skills&status=deleted");
            return;
        } else if ("markRead".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            dao.markMessageRead(id);
            resp.sendRedirect(req.getContextPath() + "/admin?tab=messages&status=updated");
            return;
        } else if ("deleteMessage".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            dao.deleteMessage(id);
            resp.sendRedirect(req.getContextPath() + "/admin?tab=messages&status=deleted");
            return;
        } else if ("publishLive".equalsIgnoreCase(action)) {
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            PortfolioApiServlet.pushToGitHubLiveSync();
            resp.sendRedirect(req.getContextPath() + "/admin?tab=overview&status=published_to_live_github");
            return;
        }

        req.setAttribute("profile", dao.getProfile());
        req.setAttribute("projects", dao.getAllProjects());
        req.setAttribute("educations", dao.getAllEducation());
        req.setAttribute("certificates", dao.getAllCertificates());
        req.setAttribute("experiences", dao.getAllExperience());
        req.setAttribute("skills", dao.getAllSkills());
        req.setAttribute("messages", dao.getAllMessages());

        req.getRequestDispatcher("/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("login".equalsIgnoreCase(action)) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            if (dao.validateAdmin(username, password)) {
                HttpSession session = req.getSession(true);
                session.setAttribute("adminUser", username);
                resp.sendRedirect(req.getContextPath() + "/admin?tab=overview");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin-login.jsp?error=1");
            }
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin-login.jsp");
            return;
        }

        if ("updateProfile".equalsIgnoreCase(action)) {
            Profile existing = dao.getProfile();
            Profile p = new Profile();
            p.setId(1);
            p.setLogoInitials(defaultIfEmpty(req.getParameter("logoInitials"), existing.getLogoInitials()));
            p.setShortName(defaultIfEmpty(req.getParameter("shortName"), existing.getShortName()));
            p.setNavSubtitle(defaultIfEmpty(req.getParameter("navSubtitle"), existing.getNavSubtitle()));
            p.setFullName(defaultIfEmpty(req.getParameter("fullName"), existing.getFullName()));
            p.setGreetingText(defaultIfEmpty(req.getParameter("greetingText"), existing.getGreetingText()));
            p.setRoleTitle(defaultIfEmpty(req.getParameter("roleTitle"), existing.getRoleTitle()));
            p.setBio(defaultIfEmpty(req.getParameter("bio"), existing.getBio()));
            p.setStatusText(defaultIfEmpty(req.getParameter("statusText"), existing.getStatusText()));
            p.setLocation(defaultIfEmpty(req.getParameter("location"), existing.getLocation()));
            p.setHighlightBadge1(defaultIfEmpty(req.getParameter("highlightBadge1"), existing.getHighlightBadge1()));
            p.setHighlightBadge2(defaultIfEmpty(req.getParameter("highlightBadge2"), existing.getHighlightBadge2()));
            p.setTopCardBadgeTitle(defaultIfEmpty(req.getParameter("topCardBadgeTitle"), existing.getTopCardBadgeTitle()));
            p.setTopCardBadgeSub(defaultIfEmpty(req.getParameter("topCardBadgeSub"), existing.getTopCardBadgeSub()));
            p.setBottomCardBadgeTitle(defaultIfEmpty(req.getParameter("bottomCardBadgeTitle"), existing.getBottomCardBadgeTitle()));
            p.setBottomCardBadgeSub(defaultIfEmpty(req.getParameter("bottomCardBadgeSub"), existing.getBottomCardBadgeSub()));
            p.setGithubUrl(req.getParameter("githubUrl"));
            p.setLinkedinUrl(req.getParameter("linkedinUrl"));
            p.setLeetcodeUrl(req.getParameter("leetcodeUrl"));
            p.setEmail(req.getParameter("email"));
            p.setPhone(req.getParameter("phone"));

            String uploadedPic = saveUploadedFile(req, "profilePicFile", "profile");
            p.setProfilePicUrl(uploadedPic != null ? uploadedPic : defaultIfEmpty(req.getParameter("profilePicUrl"), existing.getProfilePicUrl()));

            String uploadedResume = saveUploadedFile(req, "resumeFile", "resume");
            p.setResumeUrl(uploadedResume != null ? uploadedResume : defaultIfEmpty(req.getParameter("resumeUrl"), existing.getResumeUrl()));

            String uploadedGold = saveUploadedFile(req, "goldProofFile", "goldproof");
            p.setGoldProofUrl(uploadedGold != null ? uploadedGold : defaultIfEmpty(req.getParameter("goldProofUrl"), existing.getGoldProofUrl()));

            dao.updateProfile(p);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=profile&status=saved");
            return;

        } else if ("saveProject".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            Project existing = id > 0 ? dao.getProjectById(id) : null;
            Project pr = new Project();
            pr.setId(id);
            pr.setTitle(req.getParameter("title"));
            pr.setCategory(req.getParameter("category"));
            pr.setBuildMethod(req.getParameter("buildMethod"));
            pr.setFeatured("on".equalsIgnoreCase(req.getParameter("featured")) || "true".equalsIgnoreCase(req.getParameter("featured")));
            pr.setDescription(req.getParameter("description"));
            pr.setArchitectureDetails(req.getParameter("architectureDetails"));
            pr.setTechStack(req.getParameter("techStack"));
            pr.setGithubUrl(req.getParameter("githubUrl"));
            pr.setLiveUrl(req.getParameter("liveUrl"));
            pr.setDisplayOrder(parseInt(req.getParameter("displayOrder"), 1));

            String uploadedProof = saveUploadedFile(req, "proofFile", "project");
            if (uploadedProof != null) {
                pr.setProofUrl(uploadedProof);
            } else if (req.getParameter("proofUrl") != null && !req.getParameter("proofUrl").trim().isEmpty()) {
                pr.setProofUrl(req.getParameter("proofUrl").trim());
            } else if (existing != null) {
                pr.setProofUrl(existing.getProofUrl());
            } else {
                pr.setProofUrl("");
            }

            dao.saveProject(pr);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=projects&status=saved");
            return;

        } else if ("saveEducation".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            Education existing = id > 0 ? dao.getEducationById(id) : null;
            Education ed = new Education();
            ed.setId(id);
            ed.setDegree(req.getParameter("degree"));
            ed.setInstitution(req.getParameter("institution"));
            ed.setUniversity(req.getParameter("university"));
            ed.setDuration(req.getParameter("duration"));
            ed.setStatusText(req.getParameter("statusText"));
            ed.setDescription(req.getParameter("description"));
            ed.setProof1Title(req.getParameter("proof1Title"));
            ed.setProof2Title(req.getParameter("proof2Title"));
            ed.setProof3Title(req.getParameter("proof3Title"));
            ed.setDisplayOrder(parseInt(req.getParameter("displayOrder"), 1));

            String up1 = saveUploadedFile(req, "proof1File", "edu1");
            ed.setProof1Url(up1 != null ? up1 : defaultIfEmpty(req.getParameter("proof1Url"), existing != null ? existing.getProof1Url() : ""));

            String up2 = saveUploadedFile(req, "proof2File", "edu2");
            ed.setProof2Url(up2 != null ? up2 : defaultIfEmpty(req.getParameter("proof2Url"), existing != null ? existing.getProof2Url() : ""));

            String up3 = saveUploadedFile(req, "proof3File", "edu3");
            ed.setProof3Url(up3 != null ? up3 : defaultIfEmpty(req.getParameter("proof3Url"), existing != null ? existing.getProof3Url() : ""));

            dao.saveEducation(ed);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=education&status=saved");
            return;

        } else if ("saveCertificate".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            Certificate existing = id > 0 ? dao.getCertificateById(id) : null;
            Certificate c = new Certificate();
            c.setId(id);
            c.setTitle(req.getParameter("title"));
            c.setIssuer(req.getParameter("issuer"));
            c.setIssueDate(req.getParameter("issueDate"));
            c.setScoreBadge(req.getParameter("scoreBadge"));
            c.setCategory(req.getParameter("category"));
            c.setEliteGold("on".equalsIgnoreCase(req.getParameter("eliteGold")) || "true".equalsIgnoreCase(req.getParameter("eliteGold")));
            c.setTopRibbonText(req.getParameter("topRibbonText"));
            c.setDescription(req.getParameter("description"));
            c.setSkillTags(req.getParameter("skillTags"));
            c.setCredentialId(req.getParameter("credentialId"));
            c.setDisplayOrder(parseInt(req.getParameter("displayOrder"), 1));

            String upCert = saveUploadedFile(req, "proofFile", "cert");
            c.setProofUrl(upCert != null ? upCert : defaultIfEmpty(req.getParameter("proofUrl"), existing != null ? existing.getProofUrl() : ""));

            dao.saveCertificate(c);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=certificates&status=saved");
            return;

        } else if ("saveExperience".equalsIgnoreCase(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            Experience existing = id > 0 ? dao.getExperienceById(id) : null;
            Experience ex = new Experience();
            ex.setId(id);
            ex.setRoleTitle(req.getParameter("roleTitle"));
            ex.setCompany(req.getParameter("company"));
            ex.setExpType(req.getParameter("expType"));
            ex.setTrackName(req.getParameter("trackName"));
            ex.setDuration(req.getParameter("duration"));
            ex.setLocation(req.getParameter("location"));
            ex.setDescription(req.getParameter("description"));
            ex.setTechStack(req.getParameter("techStack"));
            ex.setProof1Title(req.getParameter("proof1Title"));
            ex.setProof2Title(req.getParameter("proof2Title"));
            ex.setProof3Title(req.getParameter("proof3Title"));
            ex.setDisplayOrder(parseInt(req.getParameter("displayOrder"), 1));

            String up1 = saveUploadedFile(req, "proof1File", "exp1");
            ex.setProof1Url(up1 != null ? up1 : defaultIfEmpty(req.getParameter("proof1Url"), existing != null ? existing.getProof1Url() : ""));

            String up2 = saveUploadedFile(req, "proof2File", "exp2");
            ex.setProof2Url(up2 != null ? up2 : defaultIfEmpty(req.getParameter("proof2Url"), existing != null ? existing.getProof2Url() : ""));

            String up3 = saveUploadedFile(req, "proof3File", "exp3");
            ex.setProof3Url(up3 != null ? up3 : defaultIfEmpty(req.getParameter("proof3Url"), existing != null ? existing.getProof3Url() : ""));

            dao.saveExperience(ex);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=experience&status=saved");
            return;

        } else if ("saveSkill".equalsIgnoreCase(action)) {
            Skill s = new Skill();
            s.setId(parseInt(req.getParameter("id"), 0));
            s.setCategory(req.getParameter("category"));
            s.setSkillName(req.getParameter("skillName"));
            s.setProficiency(parseInt(req.getParameter("proficiency"), 90));
            s.setBadgeText(req.getParameter("badgeText"));
            s.setDisplayOrder(parseInt(req.getParameter("displayOrder"), 1));

            dao.saveSkill(s);
            PortfolioApiServlet.syncStaticJsonFile(PortfolioApiServlet.buildPortfolioJson(dao));
            resp.sendRedirect(req.getContextPath() + "/admin?tab=skills&status=saved");
            return;

        } else if ("updateAdminAuth".equalsIgnoreCase(action)) {
            String newUser = req.getParameter("newUsername");
            String newPass = req.getParameter("newPassword");
            if (newUser != null && !newUser.trim().isEmpty() && newPass != null && !newPass.trim().isEmpty()) {
                dao.updateAdminCredentials(newUser.trim(), newPass.trim());
                session.setAttribute("adminUser", newUser.trim());
            }
            resp.sendRedirect(req.getContextPath() + "/admin?tab=profile&status=authUpdated");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin");
    }

    private String saveUploadedFile(HttpServletRequest req, String partName, String prefix) {
        try {
            Part part = req.getPart(partName);
            if (part != null && part.getSize() > 0) {
                String submitted = part.getSubmittedFileName();
                if (submitted != null && !submitted.trim().isEmpty()) {
                    String cleanName = new File(submitted).getName().replaceAll("[^a-zA-Z0-9._-]", "_");
                    String finalName = prefix + "_" + System.currentTimeMillis() + "_" + cleanName;
                    File dir = new File(UploadServlet.UPLOAD_DIR);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }
                    File target = new File(dir, finalName);
                    try (InputStream in = part.getInputStream()) {
                        Files.copy(in, target.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                    // Also copy into src/main/webapp/uploads so Git push includes uploaded files
                    try {
                        File webDir = new File("D:/PROJECTdATA/PROJECTdATA/SmartCareerRecommendationSystem/Portfolio/src/main/webapp/uploads");
                        if (!webDir.exists()) webDir.mkdirs();
                        Files.copy(target.toPath(), new File(webDir, finalName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception ignored) {}
                    return "uploads/" + finalName;
                }
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    private int parseInt(String val, int fallback) {
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return fallback;
        }
    }

    private String defaultIfEmpty(String val, String fallback) {
        if (val == null || val.trim().isEmpty()) {
            return fallback != null ? fallback : "";
        }
        return val.trim();
    }
}
