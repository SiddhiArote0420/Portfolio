-- Portfolio Database Schema & Public Portfolio Seed Data (No credentials or secrets)
CREATE DATABASE IF NOT EXISTS portfolio_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE portfolio_db;

CREATE TABLE IF NOT EXISTS admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS profile (
    id INT PRIMARY KEY,
    logo_initials VARCHAR(10),
    short_name VARCHAR(100),
    nav_subtitle VARCHAR(150),
    full_name VARCHAR(150),
    greeting_text VARCHAR(100),
    role_title VARCHAR(200),
    bio TEXT,
    status_text VARCHAR(255),
    location VARCHAR(150),
    highlight_badge1 VARCHAR(255),
    highlight_badge2 VARCHAR(255),
    top_card_badge_title VARCHAR(100),
    top_card_badge_sub VARCHAR(150),
    bottom_card_badge_title VARCHAR(100),
    bottom_card_badge_sub VARCHAR(150),
    profile_pic_url VARCHAR(500),
    resume_url VARCHAR(500),
    gold_proof_url VARCHAR(500),
    github_url VARCHAR(500),
    linkedin_url VARCHAR(500),
    leetcode_url VARCHAR(500),
    email VARCHAR(150),
    phone VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    build_method VARCHAR(100),
    featured BOOLEAN DEFAULT TRUE,
    description TEXT,
    architecture_details TEXT,
    tech_stack VARCHAR(500),
    github_url VARCHAR(500),
    live_url VARCHAR(500),
    proof_url VARCHAR(500),
    display_order INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS education (
    id INT AUTO_INCREMENT PRIMARY KEY,
    degree VARCHAR(255) NOT NULL,
    institution VARCHAR(255),
    university VARCHAR(255),
    duration VARCHAR(100),
    status_text VARCHAR(255),
    description TEXT,
    proof1_title VARCHAR(200),
    proof1_url VARCHAR(500),
    proof2_title VARCHAR(200),
    proof2_url VARCHAR(500),
    proof3_title VARCHAR(200),
    proof3_url VARCHAR(500),
    display_order INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS certificates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    issuer VARCHAR(255),
    issue_date VARCHAR(100),
    score_badge VARCHAR(200),
    category VARCHAR(100),
    elite_gold BOOLEAN DEFAULT FALSE,
    top_ribbon_text VARCHAR(100),
    description TEXT,
    skill_tags VARCHAR(500),
    credential_id VARCHAR(150),
    proof_url VARCHAR(500),
    display_order INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS experience (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_title VARCHAR(255) NOT NULL,
    company VARCHAR(255),
    exp_type VARCHAR(100),
    track_name VARCHAR(150),
    duration VARCHAR(100),
    location VARCHAR(150),
    description TEXT,
    tech_stack VARCHAR(500),
    proof1_title VARCHAR(200),
    proof1_url VARCHAR(500),
    proof2_title VARCHAR(200),
    proof2_url VARCHAR(500),
    proof3_title VARCHAR(200),
    proof3_url VARCHAR(500),
    display_order INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(150),
    skill_name VARCHAR(150),
    proficiency INT DEFAULT 90,
    badge_text VARCHAR(100),
    display_order INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS recruiter_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recruiter_name VARCHAR(150),
    company_name VARCHAR(150),
    recruiter_email VARCHAR(150),
    recruiter_phone VARCHAR(50),
    role_offered VARCHAR(200),
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT IGNORE INTO profile (
    id, logo_initials, short_name, nav_subtitle, full_name, greeting_text,
    role_title, bio, status_text, location, highlight_badge1, highlight_badge2,
    top_card_badge_title, top_card_badge_sub, bottom_card_badge_title, bottom_card_badge_sub,
    profile_pic_url, resume_url, gold_proof_url, github_url, linkedin_url, leetcode_url, email, phone
) VALUES (
    1, 'SA', 'Siddhi Arote', 'Full-Stack Developer', 'Siddhi Arote', 'HELLO, I AM',
    'Full-Stack Software Engineer',
    'Java Full Stack Developer skilled in Core Java, Spring Boot, Spring MVC, Spring JDBC, Servlets, JSP, RESTful APIs, MySQL, PL/SQL, HTML5, CSS3, JavaScript, and Bootstrap. Passionate about building scalable enterprise web applications and clean architectures.',
    'Open to Full-Time & Internship Opportunities', 'Pune, Maharashtra, India',
    'Verified Academic & Project Credentials', 'Full-Stack Software Engineer',
    'Verified', 'Top Credentials', 'Portfolio', 'Flagship Projects',
    'uploads/profile_1792514562348_pic.jpeg',
    'uploads/resume_1792514562377_JAVA_DEVELOPER__2_.pdf',
    '',
    'https://github.com/SiddhiArote0420',
    'https://linkedin.com/in/siddhi-arote-3b6bb731a',
    'https://leetcode.com/u/Arote_Siddhi',
    'siddhiarote5@gmail.com',
    '+91 9822076804'
);

INSERT IGNORE INTO projects (
    id, title, category, build_method, featured, description, architecture_details,
    tech_stack, github_url, live_url, proof_url, display_order
) VALUES
(9, 'RESTAURANT MANAGEMENT SYSTEM', 'Java Full Stack', 'Solo Handcrafted', 1,
 'A full-stack, role-based restaurant management web application built to streamline daily restaurant operations, table management, order tracking, and billing with responsive staff dashboards',
 'Role-Based Access Control (RBAC): Designed customized UI workflows and access levels for 4 distinct user roles: Admin, Receptionist, Waiter, and Chef.    RESTful Backend: Developed secure REST APIs using Spring Boot and Spring JDBC to execute optimized CRUD operations for tables, categories, food items, orders, and payments.    Database & Testing: Structured relational data models in MySQL and rigorously tested API endpoints using Postman for reliable error handling and smooth data flow.    Frontend UI: Built responsive, interactive staff interfaces using JSP, HTML5, CSS3, JavaScript, and Bootstrap.',
 'Spring Boot, Spring JDBC, REST APIs, MySQL, JSP, HTML5, CSS3, JavaScript, Bootstrap, Postman',
 'https://github.com/SiddhiArote0420/RestaurantManagementSystem',
 'https://foodhubserver.co.in',
 '', 1),
(10, 'ONLINE EXAMINATION SYSTEM', 'Java Full Stack', 'Solo Handcrafted', 1,
 'A dynamic online assessment portal featuring admin question-bank management, timed student exams, session handling, and instant automated result calculation',
 'Core Java & Servlet Architecture: Implemented MVC-style backend architecture using Java Servlets and JDBC to handle HTTP requests, session validation, and database connections.    Exam Engine & Automation: Engineered a timed test environment that automatically submits exams upon timer expiration and processes student scores instantly.    Database Management: Designed normalized MySQL database schemas to manage users, subjects, question banks, active tests, and student score history.    Responsive Frontend: Created clean, student-friendly interfaces with HTML5, CSS3, JavaScript, and Bootstrap.',
 'Core Java, Servlets, JDBC, MySQL, HTML5, CSS3, Bootstrap, JavaScript, Apache Tomcat',
 'https://github.com/SiddhiArote0420/Online-Examination-System',
 'https://online-examination-system-3cvc.onrender.com/',
 '', 2);

INSERT IGNORE INTO education (
    id, degree, institution, university, duration, status_text, description,
    proof1_title, proof1_url, proof2_title, proof2_url, proof3_title, proof3_url, display_order
) VALUES
(5, 'Master of Computer Science (MCS)', 'Modern College of Arts, Science & Commerce, Ganeshkhind, Pune',
 'Savitribai Phule Pune University (SPPU)', '2024 - 2026', '78.50%',
 'Specialization in Advanced Computer Science, Object-Oriented Software Engineering, Database Systems, Web Technologies, and Software Architecture',
 '', 'uploads/edu1_1792518720519_finalYear.pdf', '', '', '', '', 1),
(6, 'Bachelor of Computer Science (BCS) ', 'BacheloAgasti Arts, Commerce and Dadasaheb Rupwate Science College, Akole ',
 'Savitribai Phule Pune University (SPPU)', '2021 - 2026', '74%',
 '', '', 'uploads/edu1_1792559795167_UG-resut.jpeg', '', '', '', '', 2);

INSERT IGNORE INTO certificates (
    id, title, issuer, issue_date, score_badge, category, elite_gold, top_ribbon_text,
    description, skill_tags, credential_id, proof_url, display_order
) VALUES
(6, 'Programming in Java - Elite Certification', 'NPTEL & IIT Kharagpur (Swayam)', 'Jan - Apr 2026',
 '75% (Elite)', 'Java & DSA (IIT NPTEL)', 0, 'ELITE + GOLD MEDALIST',
 'Successfully completed a rigorous 12-week proctored certification course in Programming in Java with Elite standing, achieving a consolidated score of 75%',
 'Core Java, OOP, Multithreading, Collections Framework, Exception Handling, Java Streams, Servlets, JDBC, Java Swing',
 'NPTEL26CS36S1251802290', 'uploads/cert_1792518285256_NPTEL26CS36S125180229004916999.pdf', 1),
(7, 'Fundamentals of Object Oriented Programming', 'NPTEL & IIT Roorkee', 'Jan-Apr 2026',
 '65%', 'Java & DSA (IIT NPTEL)', 0, 'ELITE CERTIFIED',
 'Successfully completed a 12-week proctored certification course in Fundamentals of Object Oriented Programming conducted by IIT Roorkee with an Elite badge and a consolidated score of 65%',
 'Object-Oriented Programming (OOP), Classes & Objects, Inheritance, Polymorphism, Encapsulation, Abstraction, Problem Solving',
 'NPTEL26CS87S1551801791', 'uploads/cert_1792518502325_NPTL_Certificate.pdf', 2);

INSERT IGNORE INTO experience (
    id, role_title, company, exp_type, track_name, duration, location, description,
    tech_stack, proof1_title, proof1_url, proof2_title, proof2_url, proof3_title, proof3_url, display_order
) VALUES
(4, 'Java Full Stack Developer Intern', 'Creazione Software, Pune', 'Internship',
 'Full Stack Java Engineering', 'Apr 2026 – Oct 2026', 'Pune',
 'Developed and maintained robust Java backend components using Spring Boot, Spring JDBC, and RESTful APIs under senior developer guidance.    Wrote and optimized complex SQL queries and managed MySQL databases for efficient CRUD operations and data handling.    Conducted API testing using Postman, debugged application errors, and fixed critical backend bugs to improve system stability.    Managed source code and collaborated effectively with the engineering team using Git & GitHub, following standardized SDLC practices',
 'Java, Spring Boot, Spring JDBC, REST APIs, MySQL, SQL, Postman, Git, GitHub, SDLC',
 '', '', '', '', '', '', 1);

INSERT IGNORE INTO skills (id, category, skill_name, proficiency, badge_text, display_order) VALUES
(30, 'Java Enterprise & Backend', 'Core Java', 90, '', 1),
(31, 'Java Enterprise & Backend', 'servlet', 85, '', 2),
(32, 'Java Enterprise & Backend', 'JDBC', 90, '', 3),
(33, 'Java Enterprise & Backend', 'Spring MVC', 90, '', 4),
(34, 'Java Enterprise & Backend', 'Spring JDBC', 90, '', 5),
(35, 'Java Enterprise & Backend', 'Spring Boot', 90, '', 6),
(36, 'Java Enterprise & Backend', 'HTML5', 90, '', 7),
(37, 'Java Enterprise & Backend', 'CSS3', 90, '', 8),
(38, 'Java Enterprise & Backend', 'PL/SQL', 90, '', 9),
(39, 'Java Enterprise & Backend', 'Git/GitHub', 80, '', 10);
