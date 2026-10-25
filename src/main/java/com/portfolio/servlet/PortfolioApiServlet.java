package com.portfolio.servlet;

import com.portfolio.dao.PortfolioDAO;
import com.portfolio.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.List;

@WebServlet("/api/portfolio-data")
public class PortfolioApiServlet extends HttpServlet {
    private static final String STATIC_JSON_PATH = "D:/PROJECTdATA/PROJECTdATA/SmartCareerRecommendationSystem/Portfolio/src/main/webapp/data/portfolio-data.json";
    private final PortfolioDAO dao = new PortfolioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");

        String jsonString = buildPortfolioJson(dao);

        try (PrintWriter out = resp.getWriter()) {
            out.print(jsonString);
        }
    }

    public static String buildPortfolioJson(PortfolioDAO dao) {
        Profile pf = dao.getProfile();
        List<Project> projects = dao.getAllProjects();
        List<Skill> skills = dao.getAllSkills();
        List<Certificate> certs = dao.getAllCertificates();
        List<Education> edus = dao.getAllEducation();
        List<Experience> exps = dao.getAllExperience();

        StringBuilder json = new StringBuilder();
        json.append("{\n");

        // Profile object
        json.append("  \"profile\": {\n");
        json.append("    \"logoInitials\": \"").append(esc(pf.getLogoInitials())).append("\",\n");
        json.append("    \"shortName\": \"").append(esc(pf.getShortName())).append("\",\n");
        json.append("    \"navSubtitle\": \"").append(esc(pf.getNavSubtitle())).append("\",\n");
        json.append("    \"fullName\": \"").append(esc(pf.getFullName())).append("\",\n");
        json.append("    \"greetingText\": \"").append(esc(pf.getGreetingText())).append("\",\n");
        json.append("    \"roleTitle\": \"").append(esc(pf.getRoleTitle())).append("\",\n");
        json.append("    \"bio\": \"").append(esc(pf.getBio())).append("\",\n");
        json.append("    \"statusText\": \"").append(esc(pf.getStatusText())).append("\",\n");
        json.append("    \"location\": \"").append(esc(pf.getLocation())).append("\",\n");
        json.append("    \"highlightBadge1\": \"").append(esc(pf.getHighlightBadge1())).append("\",\n");
        json.append("    \"highlightBadge2\": \"").append(esc(pf.getHighlightBadge2())).append("\",\n");
        json.append("    \"topCardBadgeTitle\": \"").append(esc(pf.getTopCardBadgeTitle())).append("\",\n");
        json.append("    \"topCardBadgeSub\": \"").append(esc(pf.getTopCardBadgeSub())).append("\",\n");
        json.append("    \"bottomCardBadgeTitle\": \"").append(esc(pf.getBottomCardBadgeTitle())).append("\",\n");
        json.append("    \"bottomCardBadgeSub\": \"").append(esc(pf.getBottomCardBadgeSub())).append("\",\n");
        json.append("    \"profilePicUrl\": \"").append(esc(pf.getProfilePicUrl())).append("\",\n");
        json.append("    \"resumeUrl\": \"").append(esc(pf.getResumeUrl())).append("\",\n");
        json.append("    \"goldProofUrl\": \"").append(esc(pf.getGoldProofUrl())).append("\",\n");
        json.append("    \"githubUrl\": \"").append(esc(pf.getGithubUrl())).append("\",\n");
        json.append("    \"linkedinUrl\": \"").append(esc(pf.getLinkedinUrl())).append("\",\n");
        json.append("    \"leetcodeUrl\": \"").append(esc(pf.getLeetcodeUrl())).append("\",\n");
        json.append("    \"email\": \"").append(esc(pf.getEmail())).append("\",\n");
        json.append("    \"phone\": \"").append(esc(pf.getPhone())).append("\"\n");
        json.append("  },\n");

        // 1. Projects JSON Array
        json.append("  \"projects\": [\n");
        for (int i = 0; i < projects.size(); i++) {
            Project p = projects.get(i);
            json.append("    {\n");
            json.append("      \"id\": ").append(p.getId()).append(",\n");
            json.append("      \"title\": \"").append(esc(p.getTitle())).append("\",\n");
            json.append("      \"category\": \"").append(esc(p.getCategory())).append("\",\n");
            json.append("      \"buildMethod\": \"").append(esc(p.getBuildMethod())).append("\",\n");
            json.append("      \"featured\": ").append(p.isFeatured()).append(",\n");
            json.append("      \"description\": \"").append(esc(p.getDescription())).append("\",\n");
            json.append("      \"architectureDetails\": \"").append(esc(p.getArchitectureDetails())).append("\",\n");
            json.append("      \"githubUrl\": \"").append(esc(p.getGithubUrl())).append("\",\n");
            json.append("      \"liveUrl\": \"").append(esc(p.getLiveUrl())).append("\",\n");
            json.append("      \"proofUrl\": \"").append(esc(p.getProofUrl())).append("\",\n");
            json.append("      \"techStack\": [");
            String[] techs = p.getTechArray();
            for (int t = 0; t < techs.length; t++) {
                json.append("\"").append(esc(techs[t])).append("\"");
                if (t < techs.length - 1) json.append(", ");
            }
            json.append("]\n");
            json.append("    }").append(i < projects.size() - 1 ? "," : "").append("\n");
        }
        json.append("  ],\n");

        // 2. Education JSON Array
        json.append("  \"educations\": [\n");
        for (int i = 0; i < edus.size(); i++) {
            Education ed = edus.get(i);
            json.append("    {\n");
            json.append("      \"id\": ").append(ed.getId()).append(",\n");
            json.append("      \"degree\": \"").append(esc(ed.getDegree())).append("\",\n");
            json.append("      \"institution\": \"").append(esc(ed.getInstitution())).append("\",\n");
            json.append("      \"university\": \"").append(esc(ed.getUniversity())).append("\",\n");
            json.append("      \"duration\": \"").append(esc(ed.getDuration())).append("\",\n");
            json.append("      \"statusText\": \"").append(esc(ed.getStatusText())).append("\",\n");
            json.append("      \"description\": \"").append(esc(ed.getDescription())).append("\",\n");
            json.append("      \"proof1Title\": \"").append(esc(ed.getProof1Title())).append("\",\n");
            json.append("      \"proof1Url\": \"").append(esc(ed.getProof1Url())).append("\",\n");
            json.append("      \"proof2Title\": \"").append(esc(ed.getProof2Title())).append("\",\n");
            json.append("      \"proof2Url\": \"").append(esc(ed.getProof2Url())).append("\",\n");
            json.append("      \"proof3Title\": \"").append(esc(ed.getProof3Title())).append("\",\n");
            json.append("      \"proof3Url\": \"").append(esc(ed.getProof3Url())).append("\"\n");
            json.append("    }").append(i < edus.size() - 1 ? "," : "").append("\n");
        }
        json.append("  ],\n");

        // 3. Certificates JSON Array
        json.append("  \"certificates\": [\n");
        for (int i = 0; i < certs.size(); i++) {
            Certificate c = certs.get(i);
            json.append("    {\n");
            json.append("      \"id\": ").append(c.getId()).append(",\n");
            json.append("      \"title\": \"").append(esc(c.getTitle())).append("\",\n");
            json.append("      \"issuer\": \"").append(esc(c.getIssuer())).append("\",\n");
            json.append("      \"issueDate\": \"").append(esc(c.getIssueDate())).append("\",\n");
            json.append("      \"scoreBadge\": \"").append(esc(c.getScoreBadge())).append("\",\n");
            json.append("      \"category\": \"").append(esc(c.getCategory())).append("\",\n");
            json.append("      \"eliteGold\": ").append(c.isEliteGold()).append(",\n");
            json.append("      \"topRibbonText\": \"").append(esc(c.getTopRibbonText())).append("\",\n");
            json.append("      \"description\": \"").append(esc(c.getDescription())).append("\",\n");
            json.append("      \"skillTags\": \"").append(esc(c.getSkillTags())).append("\",\n");
            json.append("      \"credentialId\": \"").append(esc(c.getCredentialId())).append("\",\n");
            json.append("      \"proofUrl\": \"").append(esc(c.getProofUrl())).append("\"\n");
            json.append("    }").append(i < certs.size() - 1 ? "," : "").append("\n");
        }
        json.append("  ],\n");

        // 4. Experience JSON Array
        json.append("  \"experiences\": [\n");
        for (int i = 0; i < exps.size(); i++) {
            Experience ex = exps.get(i);
            json.append("    {\n");
            json.append("      \"id\": ").append(ex.getId()).append(",\n");
            json.append("      \"roleTitle\": \"").append(esc(ex.getRoleTitle())).append("\",\n");
            json.append("      \"company\": \"").append(esc(ex.getCompany())).append("\",\n");
            json.append("      \"expType\": \"").append(esc(ex.getExpType())).append("\",\n");
            json.append("      \"trackName\": \"").append(esc(ex.getTrackName())).append("\",\n");
            json.append("      \"duration\": \"").append(esc(ex.getDuration())).append("\",\n");
            json.append("      \"location\": \"").append(esc(ex.getLocation())).append("\",\n");
            json.append("      \"description\": \"").append(esc(ex.getDescription())).append("\",\n");
            json.append("      \"techStack\": \"").append(esc(ex.getTechStack())).append("\",\n");
            json.append("      \"proof1Title\": \"").append(esc(ex.getProof1Title())).append("\",\n");
            json.append("      \"proof1Url\": \"").append(esc(ex.getProof1Url())).append("\",\n");
            json.append("      \"proof2Title\": \"").append(esc(ex.getProof2Title())).append("\",\n");
            json.append("      \"proof2Url\": \"").append(esc(ex.getProof2Url())).append("\",\n");
            json.append("      \"proof3Title\": \"").append(esc(ex.getProof3Title())).append("\",\n");
            json.append("      \"proof3Url\": \"").append(esc(ex.getProof3Url())).append("\"\n");
            json.append("    }").append(i < exps.size() - 1 ? "," : "").append("\n");
        }
        json.append("  ],\n");

        // 5. Skills JSON Array
        json.append("  \"skills\": [\n");
        for (int i = 0; i < skills.size(); i++) {
            Skill s = skills.get(i);
            json.append("    {\n");
            json.append("      \"id\": ").append(s.getId()).append(",\n");
            json.append("      \"category\": \"").append(esc(s.getCategory())).append("\",\n");
            json.append("      \"skillName\": \"").append(esc(s.getSkillName())).append("\",\n");
            json.append("      \"proficiency\": ").append(s.getProficiency()).append(",\n");
            json.append("      \"badgeText\": \"").append(esc(s.getBadgeText())).append("\"\n");
            json.append("    }").append(i < skills.size() - 1 ? "," : "").append("\n");
        }
        json.append("  ],\n");

        // 6. Counts summary
        json.append("  \"counts\": {\n");
        json.append("    \"projects\": ").append(projects.size()).append(",\n");
        json.append("    \"skills\": ").append(skills.size()).append(",\n");
        json.append("    \"certificates\": ").append(certs.size()).append(",\n");
        json.append("    \"education\": ").append(edus.size()).append(",\n");
        json.append("    \"experience\": ").append(exps.size()).append("\n");
        json.append("  }\n");

        json.append("}");
        return json.toString();
    }

    public static void syncStaticJsonFile(String jsonContent) {
        String[] paths = {
            STATIC_JSON_PATH,
            "D:/PROJECTdATA/PROJECTdATA/SmartCareerRecommendationSystem/Portfolio/data/portfolio-data.json"
        };
        for (String p : paths) {
            try {
                File f = new File(p);
                if (!f.getParentFile().exists()) {
                    f.getParentFile().mkdirs();
                }
                Files.writeString(f.toPath(), jsonContent, StandardCharsets.UTF_8);
            } catch (Exception ignored) {
            }
        }
        pushToGitHubLiveAsync();
    }

    public static boolean pushToGitHubLiveSync() {
        try {
            File repoDir = new File("D:/PROJECTdATA/PROJECTdATA/SmartCareerRecommendationSystem/Portfolio");
            if (!new File(repoDir, ".git").exists()) return false;

            runGitCmd(repoDir, "git", "add", "-A");
            runGitCmd(repoDir, "git", "commit", "-m", "Auto-sync portfolio updates from Admin CMS");
            int code = runGitCmd(repoDir, "git", "push", "origin", "main");
            return code == 0;
        } catch (Exception e) {
            return false;
        }
    }

    public static void pushToGitHubLiveAsync() {
        new Thread(() -> {
            pushToGitHubLiveSync();
        }).start();
    }

    private static int runGitCmd(File dir, String... cmd) throws Exception {
        ProcessBuilder pb = new ProcessBuilder(cmd);
        pb.directory(dir);
        pb.redirectErrorStream(true);
        Process p = pb.start();
        return p.waitFor();
    }

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ");
    }

    public static void main(String[] args) {
        PortfolioDAO dao = new PortfolioDAO();
        String json = buildPortfolioJson(dao);
        syncStaticJsonFile(json);
        System.out.println("Synced portfolio-data.json (" + json.length() + " bytes)");
    }
}
