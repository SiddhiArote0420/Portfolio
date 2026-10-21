package com.portfolio.dao;

import com.portfolio.model.*;
import com.portfolio.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PortfolioDAO {

    // ================= ADMIN AUTH =================
    public boolean validateAdmin(String username, String password) {
        String sql = "SELECT id FROM admin_users WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "admin".equals(username) && "admin123".equals(password);
        }
    }

    public boolean updateAdminCredentials(String newUsername, String newPassword) {
        String sql = "UPDATE admin_users SET username = ?, password = ? WHERE id = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newUsername);
            ps.setString(2, newPassword);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= PROFILE =================
    public Profile getProfile() {
        Profile p = new Profile();
        String sql = "SELECT * FROM profile WHERE id = 1";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                p.setId(rs.getInt("id"));
                p.setLogoInitials(rs.getString("logo_initials"));
                p.setShortName(rs.getString("short_name"));
                p.setNavSubtitle(rs.getString("nav_subtitle"));
                p.setFullName(rs.getString("full_name"));
                p.setGreetingText(rs.getString("greeting_text"));
                p.setRoleTitle(rs.getString("role_title"));
                p.setBio(rs.getString("bio"));
                p.setStatusText(rs.getString("status_text"));
                p.setLocation(rs.getString("location"));
                p.setHighlightBadge1(rs.getString("highlight_badge1"));
                p.setHighlightBadge2(rs.getString("highlight_badge2"));
                p.setTopCardBadgeTitle(rs.getString("top_card_badge_title"));
                p.setTopCardBadgeSub(rs.getString("top_card_badge_sub"));
                p.setBottomCardBadgeTitle(rs.getString("bottom_card_badge_title"));
                p.setBottomCardBadgeSub(rs.getString("bottom_card_badge_sub"));
                p.setProfilePicUrl(rs.getString("profile_pic_url"));
                p.setResumeUrl(rs.getString("resume_url"));
                p.setGoldProofUrl(rs.getString("gold_proof_url"));
                p.setGithubUrl(rs.getString("github_url"));
                p.setLinkedinUrl(rs.getString("linkedin_url"));
                p.setLeetcodeUrl(rs.getString("leetcode_url"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Fallback default if DB not reachable
        p.setLogoInitials("SA");
        p.setShortName("Siddhi Arote");
        p.setNavSubtitle("Full-Stack Developer");
        p.setFullName("Siddhi Arote");
        p.setGreetingText("HELLO, I AM");
        p.setRoleTitle("Full-Stack Software Engineer");
        p.setBio("Welcome to my portfolio! Use the Admin Portal to add your bio, photo, resume, skills, projects, education, certificates, and work experience.");
        p.setStatusText("Open to Full-Time & Internship Opportunities");
        p.setLocation("Pune, Maharashtra, India");
        p.setHighlightBadge1("Verified Academic & Project Credentials");
        p.setHighlightBadge2("Full-Stack Software Engineer");
        p.setTopCardBadgeTitle("Verified");
        p.setTopCardBadgeSub("Top Credentials");
        p.setBottomCardBadgeTitle("Portfolio");
        p.setBottomCardBadgeSub("Flagship Projects");
        p.setProfilePicUrl("");
        p.setEmail("siddhiarote@gmail.com");
        p.setPhone("+91 ");
        return p;
    }

    public boolean updateProfile(Profile p) {
        String sql = "UPDATE profile SET logo_initials=?, short_name=?, nav_subtitle=?, full_name=?, greeting_text=?, " +
                "role_title=?, bio=?, status_text=?, location=?, highlight_badge1=?, highlight_badge2=?, " +
                "top_card_badge_title=?, top_card_badge_sub=?, bottom_card_badge_title=?, bottom_card_badge_sub=?, " +
                "profile_pic_url=?, resume_url=?, gold_proof_url=?, github_url=?, linkedin_url=?, leetcode_url=?, email=?, phone=? " +
                "WHERE id=1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getLogoInitials());
            ps.setString(2, p.getShortName());
            ps.setString(3, p.getNavSubtitle());
            ps.setString(4, p.getFullName());
            ps.setString(5, p.getGreetingText());
            ps.setString(6, p.getRoleTitle());
            ps.setString(7, p.getBio());
            ps.setString(8, p.getStatusText());
            ps.setString(9, p.getLocation());
            ps.setString(10, p.getHighlightBadge1());
            ps.setString(11, p.getHighlightBadge2());
            ps.setString(12, p.getTopCardBadgeTitle());
            ps.setString(13, p.getTopCardBadgeSub());
            ps.setString(14, p.getBottomCardBadgeTitle());
            ps.setString(15, p.getBottomCardBadgeSub());
            ps.setString(16, p.getProfilePicUrl());
            ps.setString(17, p.getResumeUrl());
            ps.setString(18, p.getGoldProofUrl());
            ps.setString(19, p.getGithubUrl());
            ps.setString(20, p.getLinkedinUrl());
            ps.setString(21, p.getLeetcodeUrl());
            ps.setString(22, p.getEmail());
            ps.setString(23, p.getPhone());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= PROJECTS =================
    public List<Project> getAllProjects() {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM projects ORDER BY display_order ASC, id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Project pr = new Project();
                pr.setId(rs.getInt("id"));
                pr.setTitle(rs.getString("title"));
                pr.setCategory(rs.getString("category"));
                pr.setBuildMethod(rs.getString("build_method"));
                pr.setFeatured(rs.getBoolean("featured"));
                pr.setDescription(rs.getString("description"));
                pr.setArchitectureDetails(rs.getString("architecture_details"));
                pr.setTechStack(rs.getString("tech_stack"));
                pr.setGithubUrl(rs.getString("github_url"));
                pr.setLiveUrl(rs.getString("live_url"));
                pr.setProofUrl(rs.getString("proof_url"));
                pr.setDisplayOrder(rs.getInt("display_order"));
                list.add(pr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Project getProjectById(int id) {
        String sql = "SELECT * FROM projects WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Project pr = new Project();
                    pr.setId(rs.getInt("id"));
                    pr.setTitle(rs.getString("title"));
                    pr.setCategory(rs.getString("category"));
                    pr.setBuildMethod(rs.getString("build_method"));
                    pr.setFeatured(rs.getBoolean("featured"));
                    pr.setDescription(rs.getString("description"));
                    pr.setArchitectureDetails(rs.getString("architecture_details"));
                    pr.setTechStack(rs.getString("tech_stack"));
                    pr.setGithubUrl(rs.getString("github_url"));
                    pr.setLiveUrl(rs.getString("live_url"));
                    pr.setProofUrl(rs.getString("proof_url"));
                    pr.setDisplayOrder(rs.getInt("display_order"));
                    return pr;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveProject(Project pr) {
        if (pr.getId() > 0) {
            String sql = "UPDATE projects SET title=?, category=?, build_method=?, featured=?, description=?, architecture_details=?, tech_stack=?, github_url=?, live_url=?, proof_url=?, display_order=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, pr.getTitle());
                ps.setString(2, pr.getCategory());
                ps.setString(3, pr.getBuildMethod());
                ps.setBoolean(4, pr.isFeatured());
                ps.setString(5, pr.getDescription());
                ps.setString(6, pr.getArchitectureDetails());
                ps.setString(7, pr.getTechStack());
                ps.setString(8, pr.getGithubUrl());
                ps.setString(9, pr.getLiveUrl());
                ps.setString(10, pr.getProofUrl());
                ps.setInt(11, pr.getDisplayOrder());
                ps.setInt(12, pr.getId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        } else {
            String sql = "INSERT INTO projects (title, category, build_method, featured, description, architecture_details, tech_stack, github_url, live_url, proof_url, display_order) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, pr.getTitle());
                ps.setString(2, pr.getCategory());
                ps.setString(3, pr.getBuildMethod());
                ps.setBoolean(4, pr.isFeatured());
                ps.setString(5, pr.getDescription());
                ps.setString(6, pr.getArchitectureDetails());
                ps.setString(7, pr.getTechStack());
                ps.setString(8, pr.getGithubUrl());
                ps.setString(9, pr.getLiveUrl());
                ps.setString(10, pr.getProofUrl());
                ps.setInt(11, pr.getDisplayOrder());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    public boolean deleteProject(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM projects WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= EDUCATION =================
    public List<Education> getAllEducation() {
        List<Education> list = new ArrayList<>();
        String sql = "SELECT * FROM education ORDER BY display_order ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Education ed = new Education();
                ed.setId(rs.getInt("id"));
                ed.setDegree(rs.getString("degree"));
                ed.setInstitution(rs.getString("institution"));
                ed.setUniversity(rs.getString("university"));
                ed.setDuration(rs.getString("duration"));
                ed.setStatusText(rs.getString("status_text"));
                ed.setDescription(rs.getString("description"));
                ed.setProof1Title(rs.getString("proof1_title"));
                ed.setProof1Url(rs.getString("proof1_url"));
                ed.setProof2Title(rs.getString("proof2_title"));
                ed.setProof2Url(rs.getString("proof2_url"));
                ed.setProof3Title(rs.getString("proof3_title"));
                ed.setProof3Url(rs.getString("proof3_url"));
                ed.setDisplayOrder(rs.getInt("display_order"));
                list.add(ed);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Education getEducationById(int id) {
        String sql = "SELECT * FROM education WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Education ed = new Education();
                    ed.setId(rs.getInt("id"));
                    ed.setDegree(rs.getString("degree"));
                    ed.setInstitution(rs.getString("institution"));
                    ed.setUniversity(rs.getString("university"));
                    ed.setDuration(rs.getString("duration"));
                    ed.setStatusText(rs.getString("status_text"));
                    ed.setDescription(rs.getString("description"));
                    ed.setProof1Title(rs.getString("proof1_title"));
                    ed.setProof1Url(rs.getString("proof1_url"));
                    ed.setProof2Title(rs.getString("proof2_title"));
                    ed.setProof2Url(rs.getString("proof2_url"));
                    ed.setProof3Title(rs.getString("proof3_title"));
                    ed.setProof3Url(rs.getString("proof3_url"));
                    ed.setDisplayOrder(rs.getInt("display_order"));
                    return ed;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveEducation(Education ed) {
        if (ed.getId() > 0) {
            String sql = "UPDATE education SET degree=?, institution=?, university=?, duration=?, status_text=?, description=?, proof1_title=?, proof1_url=?, proof2_title=?, proof2_url=?, proof3_title=?, proof3_url=?, display_order=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, ed.getDegree());
                ps.setString(2, ed.getInstitution());
                ps.setString(3, ed.getUniversity());
                ps.setString(4, ed.getDuration());
                ps.setString(5, ed.getStatusText());
                ps.setString(6, ed.getDescription());
                ps.setString(7, ed.getProof1Title());
                ps.setString(8, ed.getProof1Url());
                ps.setString(9, ed.getProof2Title());
                ps.setString(10, ed.getProof2Url());
                ps.setString(11, ed.getProof3Title());
                ps.setString(12, ed.getProof3Url());
                ps.setInt(13, ed.getDisplayOrder());
                ps.setInt(14, ed.getId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        } else {
            String sql = "INSERT INTO education (degree, institution, university, duration, status_text, description, proof1_title, proof1_url, proof2_title, proof2_url, proof3_title, proof3_url, display_order) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, ed.getDegree());
                ps.setString(2, ed.getInstitution());
                ps.setString(3, ed.getUniversity());
                ps.setString(4, ed.getDuration());
                ps.setString(5, ed.getStatusText());
                ps.setString(6, ed.getDescription());
                ps.setString(7, ed.getProof1Title());
                ps.setString(8, ed.getProof1Url());
                ps.setString(9, ed.getProof2Title());
                ps.setString(10, ed.getProof2Url());
                ps.setString(11, ed.getProof3Title());
                ps.setString(12, ed.getProof3Url());
                ps.setInt(13, ed.getDisplayOrder());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    public boolean deleteEducation(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM education WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= CERTIFICATES =================
    public List<Certificate> getAllCertificates() {
        List<Certificate> list = new ArrayList<>();
        String sql = "SELECT * FROM certificates ORDER BY display_order ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Certificate c = new Certificate();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setIssuer(rs.getString("issuer"));
                c.setIssueDate(rs.getString("issue_date"));
                c.setScoreBadge(rs.getString("score_badge"));
                c.setCategory(rs.getString("category"));
                c.setEliteGold(rs.getBoolean("elite_gold"));
                c.setTopRibbonText(rs.getString("top_ribbon_text"));
                c.setDescription(rs.getString("description"));
                c.setSkillTags(rs.getString("skill_tags"));
                c.setCredentialId(rs.getString("credential_id"));
                c.setProofUrl(rs.getString("proof_url"));
                c.setDisplayOrder(rs.getInt("display_order"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Certificate getCertificateById(int id) {
        String sql = "SELECT * FROM certificates WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Certificate c = new Certificate();
                    c.setId(rs.getInt("id"));
                    c.setTitle(rs.getString("title"));
                    c.setIssuer(rs.getString("issuer"));
                    c.setIssueDate(rs.getString("issue_date"));
                    c.setScoreBadge(rs.getString("score_badge"));
                    c.setCategory(rs.getString("category"));
                    c.setEliteGold(rs.getBoolean("elite_gold"));
                    c.setTopRibbonText(rs.getString("top_ribbon_text"));
                    c.setDescription(rs.getString("description"));
                    c.setSkillTags(rs.getString("skill_tags"));
                    c.setCredentialId(rs.getString("credential_id"));
                    c.setProofUrl(rs.getString("proof_url"));
                    c.setDisplayOrder(rs.getInt("display_order"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveCertificate(Certificate c) {
        if (c.getId() > 0) {
            String sql = "UPDATE certificates SET title=?, issuer=?, issue_date=?, score_badge=?, category=?, elite_gold=?, top_ribbon_text=?, description=?, skill_tags=?, credential_id=?, proof_url=?, display_order=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, c.getTitle());
                ps.setString(2, c.getIssuer());
                ps.setString(3, c.getIssueDate());
                ps.setString(4, c.getScoreBadge());
                ps.setString(5, c.getCategory());
                ps.setBoolean(6, c.isEliteGold());
                ps.setString(7, c.getTopRibbonText());
                ps.setString(8, c.getDescription());
                ps.setString(9, c.getSkillTags());
                ps.setString(10, c.getCredentialId());
                ps.setString(11, c.getProofUrl());
                ps.setInt(12, c.getDisplayOrder());
                ps.setInt(13, c.getId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        } else {
            String sql = "INSERT INTO certificates (title, issuer, issue_date, score_badge, category, elite_gold, top_ribbon_text, description, skill_tags, credential_id, proof_url, display_order) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, c.getTitle());
                ps.setString(2, c.getIssuer());
                ps.setString(3, c.getIssueDate());
                ps.setString(4, c.getScoreBadge());
                ps.setString(5, c.getCategory());
                ps.setBoolean(6, c.isEliteGold());
                ps.setString(7, c.getTopRibbonText());
                ps.setString(8, c.getDescription());
                ps.setString(9, c.getSkillTags());
                ps.setString(10, c.getCredentialId());
                ps.setString(11, c.getProofUrl());
                ps.setInt(12, c.getDisplayOrder());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    public boolean deleteCertificate(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM certificates WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= EXPERIENCE =================
    public List<Experience> getAllExperience() {
        List<Experience> list = new ArrayList<>();
        String sql = "SELECT * FROM experience ORDER BY display_order ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Experience ex = new Experience();
                ex.setId(rs.getInt("id"));
                ex.setRoleTitle(rs.getString("role_title"));
                ex.setCompany(rs.getString("company"));
                ex.setExpType(rs.getString("exp_type"));
                ex.setTrackName(rs.getString("track_name"));
                ex.setDuration(rs.getString("duration"));
                ex.setLocation(rs.getString("location"));
                ex.setDescription(rs.getString("description"));
                ex.setTechStack(rs.getString("tech_stack"));
                ex.setProof1Title(rs.getString("proof1_title"));
                ex.setProof1Url(rs.getString("proof1_url"));
                ex.setProof2Title(rs.getString("proof2_title"));
                ex.setProof2Url(rs.getString("proof2_url"));
                ex.setProof3Title(rs.getString("proof3_title"));
                ex.setProof3Url(rs.getString("proof3_url"));
                ex.setDisplayOrder(rs.getInt("display_order"));
                list.add(ex);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Experience getExperienceById(int id) {
        String sql = "SELECT * FROM experience WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Experience ex = new Experience();
                    ex.setId(rs.getInt("id"));
                    ex.setRoleTitle(rs.getString("role_title"));
                    ex.setCompany(rs.getString("company"));
                    ex.setExpType(rs.getString("exp_type"));
                    ex.setTrackName(rs.getString("track_name"));
                    ex.setDuration(rs.getString("duration"));
                    ex.setLocation(rs.getString("location"));
                    ex.setDescription(rs.getString("description"));
                    ex.setTechStack(rs.getString("tech_stack"));
                    ex.setProof1Title(rs.getString("proof1_title"));
                    ex.setProof1Url(rs.getString("proof1_url"));
                    ex.setProof2Title(rs.getString("proof2_title"));
                    ex.setProof2Url(rs.getString("proof2_url"));
                    ex.setProof3Title(rs.getString("proof3_title"));
                    ex.setProof3Url(rs.getString("proof3_url"));
                    ex.setDisplayOrder(rs.getInt("display_order"));
                    return ex;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveExperience(Experience ex) {
        if (ex.getId() > 0) {
            String sql = "UPDATE experience SET role_title=?, company=?, exp_type=?, track_name=?, duration=?, location=?, description=?, tech_stack=?, proof1_title=?, proof1_url=?, proof2_title=?, proof2_url=?, proof3_title=?, proof3_url=?, display_order=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, ex.getRoleTitle());
                ps.setString(2, ex.getCompany());
                ps.setString(3, ex.getExpType());
                ps.setString(4, ex.getTrackName());
                ps.setString(5, ex.getDuration());
                ps.setString(6, ex.getLocation());
                ps.setString(7, ex.getDescription());
                ps.setString(8, ex.getTechStack());
                ps.setString(9, ex.getProof1Title());
                ps.setString(10, ex.getProof1Url());
                ps.setString(11, ex.getProof2Title());
                ps.setString(12, ex.getProof2Url());
                ps.setString(13, ex.getProof3Title());
                ps.setString(14, ex.getProof3Url());
                ps.setInt(15, ex.getDisplayOrder());
                ps.setInt(16, ex.getId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        } else {
            String sql = "INSERT INTO experience (role_title, company, exp_type, track_name, duration, location, description, tech_stack, proof1_title, proof1_url, proof2_title, proof2_url, proof3_title, proof3_url, display_order) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, ex.getRoleTitle());
                ps.setString(2, ex.getCompany());
                ps.setString(3, ex.getExpType());
                ps.setString(4, ex.getTrackName());
                ps.setString(5, ex.getDuration());
                ps.setString(6, ex.getLocation());
                ps.setString(7, ex.getDescription());
                ps.setString(8, ex.getTechStack());
                ps.setString(9, ex.getProof1Title());
                ps.setString(10, ex.getProof1Url());
                ps.setString(11, ex.getProof2Title());
                ps.setString(12, ex.getProof2Url());
                ps.setString(13, ex.getProof3Title());
                ps.setString(14, ex.getProof3Url());
                ps.setInt(15, ex.getDisplayOrder());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    public boolean deleteExperience(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM experience WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= SKILLS =================
    public List<Skill> getAllSkills() {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT * FROM skills ORDER BY display_order ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Skill s = new Skill();
                s.setId(rs.getInt("id"));
                s.setCategory(rs.getString("category"));
                s.setSkillName(rs.getString("skill_name"));
                s.setProficiency(rs.getInt("proficiency"));
                s.setBadgeText(rs.getString("badge_text"));
                s.setDisplayOrder(rs.getInt("display_order"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveSkill(Skill s) {
        if (s.getId() > 0) {
            String sql = "UPDATE skills SET category=?, skill_name=?, proficiency=?, badge_text=?, display_order=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, s.getCategory());
                ps.setString(2, s.getSkillName());
                ps.setInt(3, s.getProficiency());
                ps.setString(4, s.getBadgeText());
                ps.setInt(5, s.getDisplayOrder());
                ps.setInt(6, s.getId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        } else {
            String sql = "INSERT INTO skills (category, skill_name, proficiency, badge_text, display_order) VALUES (?, ?, ?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, s.getCategory());
                ps.setString(2, s.getSkillName());
                ps.setInt(3, s.getProficiency());
                ps.setString(4, s.getBadgeText());
                ps.setInt(5, s.getDisplayOrder());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    public boolean deleteSkill(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM skills WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= RECRUITER MESSAGES =================
    public List<RecruiterMessage> getAllMessages() {
        List<RecruiterMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM recruiter_messages ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                RecruiterMessage m = new RecruiterMessage();
                m.setId(rs.getInt("id"));
                m.setRecruiterName(rs.getString("recruiter_name"));
                m.setCompanyName(rs.getString("company_name"));
                m.setRecruiterEmail(rs.getString("recruiter_email"));
                m.setRecruiterPhone(rs.getString("recruiter_phone"));
                m.setRoleOffered(rs.getString("role_offered"));
                m.setMessage(rs.getString("message"));
                m.setRead(rs.getBoolean("is_read"));
                m.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveMessage(RecruiterMessage m) {
        String sql = "INSERT INTO recruiter_messages (recruiter_name, company_name, recruiter_email, recruiter_phone, role_offered, message) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getRecruiterName());
            ps.setString(2, m.getCompanyName());
            ps.setString(3, m.getRecruiterEmail());
            ps.setString(4, m.getRecruiterPhone());
            ps.setString(5, m.getRoleOffered());
            ps.setString(6, m.getMessage());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markMessageRead(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE recruiter_messages SET is_read = TRUE WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMessage(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM recruiter_messages WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
