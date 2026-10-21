package com.portfolio.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBConnection {
    private static final String BASE_URL = "jdbc:mysql://localhost:3306/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/portfolio_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASS = "MySql_Sid@20";
    private static volatile boolean initialized = false;

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        if (!initialized) {
            synchronized (DBConnection.class) {
                if (!initialized) {
                    initializeDatabase();
                    initialized = true;
                }
            }
        }
        return DriverManager.getConnection(DB_URL, USER, PASS);
    }

    private static void initializeDatabase() {
        try (Connection rootConn = DriverManager.getConnection(BASE_URL, USER, PASS);
             Statement rootStmt = rootConn.createStatement()) {
            rootStmt.executeUpdate("CREATE DATABASE IF NOT EXISTS portfolio_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
        } catch (Exception e) {
            e.printStackTrace();
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             Statement stmt = conn.createStatement()) {

            // 1. Admin Users Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS admin_users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(100) UNIQUE NOT NULL, " +
                    "password VARCHAR(255) NOT NULL" +
                    ")");

            // 2. Profile Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS profile (" +
                    "id INT PRIMARY KEY, " +
                    "logo_initials VARCHAR(10), " +
                    "short_name VARCHAR(100), " +
                    "nav_subtitle VARCHAR(150), " +
                    "full_name VARCHAR(150), " +
                    "greeting_text VARCHAR(100), " +
                    "role_title VARCHAR(200), " +
                    "bio TEXT, " +
                    "status_text VARCHAR(255), " +
                    "location VARCHAR(150), " +
                    "highlight_badge1 VARCHAR(255), " +
                    "highlight_badge2 VARCHAR(255), " +
                    "top_card_badge_title VARCHAR(100), " +
                    "top_card_badge_sub VARCHAR(150), " +
                    "bottom_card_badge_title VARCHAR(100), " +
                    "bottom_card_badge_sub VARCHAR(150), " +
                    "profile_pic_url VARCHAR(500), " +
                    "resume_url VARCHAR(500), " +
                    "gold_proof_url VARCHAR(500), " +
                    "github_url VARCHAR(500), " +
                    "linkedin_url VARCHAR(500), " +
                    "leetcode_url VARCHAR(500), " +
                    "email VARCHAR(150), " +
                    "phone VARCHAR(50)" +
                    ")");

            // 3. Projects Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS projects (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "title VARCHAR(255) NOT NULL, " +
                    "category VARCHAR(100), " +
                    "build_method VARCHAR(100), " +
                    "featured BOOLEAN DEFAULT TRUE, " +
                    "description TEXT, " +
                    "architecture_details TEXT, " +
                    "tech_stack VARCHAR(500), " +
                    "github_url VARCHAR(500), " +
                    "live_url VARCHAR(500), " +
                    "proof_url VARCHAR(500), " +
                    "display_order INT DEFAULT 0" +
                    ")");

            // 4. Education Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS education (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "degree VARCHAR(255) NOT NULL, " +
                    "institution VARCHAR(255), " +
                    "university VARCHAR(255), " +
                    "duration VARCHAR(100), " +
                    "status_text VARCHAR(255), " +
                    "description TEXT, " +
                    "proof1_title VARCHAR(200), " +
                    "proof1_url VARCHAR(500), " +
                    "proof2_title VARCHAR(200), " +
                    "proof2_url VARCHAR(500), " +
                    "proof3_title VARCHAR(200), " +
                    "proof3_url VARCHAR(500), " +
                    "display_order INT DEFAULT 0" +
                    ")");

            // 5. Certificates Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS certificates (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "title VARCHAR(255) NOT NULL, " +
                    "issuer VARCHAR(255), " +
                    "issue_date VARCHAR(100), " +
                    "score_badge VARCHAR(200), " +
                    "category VARCHAR(100), " +
                    "elite_gold BOOLEAN DEFAULT FALSE, " +
                    "top_ribbon_text VARCHAR(100), " +
                    "description TEXT, " +
                    "skill_tags VARCHAR(500), " +
                    "credential_id VARCHAR(150), " +
                    "proof_url VARCHAR(500), " +
                    "display_order INT DEFAULT 0" +
                    ")");

            // 6. Experience Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS experience (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "role_title VARCHAR(255) NOT NULL, " +
                    "company VARCHAR(255), " +
                    "exp_type VARCHAR(100), " +
                    "track_name VARCHAR(150), " +
                    "duration VARCHAR(100), " +
                    "location VARCHAR(150), " +
                    "description TEXT, " +
                    "tech_stack VARCHAR(500), " +
                    "proof1_title VARCHAR(200), " +
                    "proof1_url VARCHAR(500), " +
                    "proof2_title VARCHAR(200), " +
                    "proof2_url VARCHAR(500), " +
                    "proof3_title VARCHAR(200), " +
                    "proof3_url VARCHAR(500), " +
                    "display_order INT DEFAULT 0" +
                    ")");

            // 7. Skills Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS skills (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "category VARCHAR(150), " +
                    "skill_name VARCHAR(150), " +
                    "proficiency INT DEFAULT 90, " +
                    "badge_text VARCHAR(100), " +
                    "display_order INT DEFAULT 0" +
                    ")");

            // 8. Recruiter Messages Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS recruiter_messages (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "recruiter_name VARCHAR(150), " +
                    "company_name VARCHAR(150), " +
                    "recruiter_email VARCHAR(150), " +
                    "recruiter_phone VARCHAR(50), " +
                    "role_offered VARCHAR(200), " +
                    "message TEXT, " +
                    "is_read BOOLEAN DEFAULT FALSE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")");

            seedDefaultAdminAndSiddhiProfile(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void seedDefaultAdminAndSiddhiProfile(Connection conn) throws Exception {
        // Default Admin Login: admin / admin123
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM admin_users")) {
            if (rs.next() && rs.getInt(1) == 0) {
                st.executeUpdate("INSERT INTO admin_users (username, password) VALUES ('admin', 'admin123')");
            }
        }

        // Default Profile for Siddhi Arote (Editable anytime in Admin Panel)
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM profile")) {
            if (rs.next() && rs.getInt(1) == 0) {
                String sql = "INSERT INTO profile (id, logo_initials, short_name, nav_subtitle, full_name, greeting_text, " +
                        "role_title, bio, status_text, location, highlight_badge1, highlight_badge2, " +
                        "top_card_badge_title, top_card_badge_sub, bottom_card_badge_title, bottom_card_badge_sub, " +
                        "profile_pic_url, resume_url, gold_proof_url, github_url, linkedin_url, leetcode_url, email, phone) " +
                        "VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, "SA");
                    ps.setString(2, "Siddhi Arote");
                    ps.setString(3, "Full-Stack Developer");
                    ps.setString(4, "Siddhi Arote");
                    ps.setString(5, "HELLO, I AM");
                    ps.setString(6, "Java Full Stack Developer, Junior Java Developer, Software Development Engineer");
                    ps.setString(7, "Welcome to my portfolio! Update this bio, upload your photo & resume, and add your own skills, projects, education, certificates, and work experience directly from the Admin CMS panel.");
                    ps.setString(8, "Open to Full-Time & Internship Opportunities");
                    ps.setString(9, "Pune, Maharashtra, India");
                    ps.setString(10, "Verified Academic & Project Credentials");
                    ps.setString(11, "Full-Stack Software Engineer");
                    ps.setString(12, "Verified");
                    ps.setString(13, "Top Credentials");
                    ps.setString(14, "Portfolio");
                    ps.setString(15, "Flagship Projects");
                    ps.setString(16, "");
                    ps.setString(17, "");
                    ps.setString(18, "");
                    ps.setString(19, "https://github.com/");
                    ps.setString(20, "https://linkedin.com/");
                    ps.setString(21, "https://leetcode.com/");
                    ps.setString(22, "siddhiarote@gmail.com");
                    ps.setString(23, "+91 ");
                    ps.executeUpdate();
                }
            }
        }
    }

    /**
     * Resets the database to clean Siddhi Arote profile with empty tables ready for Admin entry
     */
    public static void resetToCleanSiddhiProfile() {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("DELETE FROM projects");
            stmt.executeUpdate("DELETE FROM education");
            stmt.executeUpdate("DELETE FROM certificates");
            stmt.executeUpdate("DELETE FROM experience");
            stmt.executeUpdate("DELETE FROM skills");
            stmt.executeUpdate("DELETE FROM profile");
            seedDefaultAdminAndSiddhiProfile(conn);
            System.out.println("Reset portfolio_db to clean Siddhi Arote profile (0 dummy items)!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        if (args.length > 0 && "reset".equalsIgnoreCase(args[0])) {
            resetToCleanSiddhiProfile();
        } else {
            try (Connection c = getConnection()) {
                System.out.println("Database portfolio_db connected successfully!");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
