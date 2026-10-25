<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.portfolio.dao.PortfolioDAO, com.portfolio.model.*" %>
<%
    PortfolioDAO dao = new PortfolioDAO();
    Profile profile = (Profile) request.getAttribute("profile");
    if (profile == null) profile = dao.getProfile();

    List<Project> projects = (List<Project>) request.getAttribute("projects");
    if (projects == null) projects = dao.getAllProjects();

    List<Education> educations = (List<Education>) request.getAttribute("educations");
    if (educations == null) educations = dao.getAllEducation();

    List<Certificate> certificates = (List<Certificate>) request.getAttribute("certificates");
    if (certificates == null) certificates = dao.getAllCertificates();

    List<Experience> experiences = (List<Experience>) request.getAttribute("experiences");
    if (experiences == null) experiences = dao.getAllExperience();

    List<Skill> skills = (List<Skill>) request.getAttribute("skills");
    if (skills == null) skills = dao.getAllSkills();

    String msgStatus = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= profile.getFullName() %> — <%= profile.getRoleTitle() %></title>
    <!-- Bootstrap 5.3 CSS for Responsive Design & Dark Cards -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Custom Portfolio Dark Theme CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/portfolio.css">
</head>
<body>

<!-- ================= TOP NAVBAR ================= -->
<header class="navbar">
    <div class="navbar-inner w-100">
        <a href="#top" class="brand">
            <div class="brand-logo"><%= profile.getLogoInitials() %></div>
            <div class="brand-text">
                <div class="brand-name">
                    <%= profile.getShortName() %>
                    <span class="online-dot" title="Available for Immediate Joining"></span>
                </div>
                <div class="brand-sub"><%= profile.getNavSubtitle() %></div>
            </div>
        </a>

        <nav class="nav-links">
            <a href="#projects" class="nav-link"><i class="fa-regular fa-folder-open"></i> Projects</a>
            <a href="#education" class="nav-link"><i class="fa-solid fa-graduation-cap"></i> Education &amp; Proofs</a>
            <a href="#certificates" class="nav-link"><i class="fa-solid fa-award"></i> Certificates</a>
            <a href="#experience" class="nav-link"><i class="fa-solid fa-briefcase"></i> Experience</a>
            <a href="#skills" class="nav-link"><i class="fa-solid fa-code"></i> Skills</a>
            <a href="#contact" class="nav-link"><i class="fa-regular fa-paper-plane"></i> Contact</a>
        </nav>

        <div class="nav-actions">
            <button type="button" class="btn-recruiter" onclick="openRecruiterModal()">
                <i class="fa-solid fa-wand-magic-sparkles"></i> Recruiter Quick-View
            </button>
            <a href="#resume-section" class="btn-resume-nav">
                <i class="fa-regular fa-file-lines"></i> Resume
            </a>
        </div>
    </div>
</header>

<!-- ================= HERO SECTION ================= -->
<section id="top" class="hero-section">
    <div class="container">
        <div class="row align-items-center g-5">
            <!-- Left Column -->
            <div class="col-lg-7">
                <div class="status-pill">
                    <span class="online-dot"></span>
                    <span><%= profile.getStatusText() %></span>
                    <span class="sep">|</span>
                    <span class="loc"><i class="fa-solid fa-location-dot" style="color:#f43f5e;"></i> <%= profile.getLocation() %></span>
                </div>

                <div class="hero-greeting"><%= profile.getGreetingText() %></div>
                <h1 class="hero-name"><%= profile.getFullName() %></h1>
                <h2 class="hero-role">
                    <span id="heroRotatingRole" class="rotating-role-fade">Java Full Stack Developer</span>
                </h2>
                <p class="hero-bio"><%= profile.getBio() %></p>

                <div class="hero-highlight-bar">
                    <span class="highlight-gold">
                        <i class="fa-solid fa-medal"></i>
                        <%= profile.getHighlightBadge1() %>
                        <button type="button" class="btn-view-proof-mini"
                                onclick="openProofModal('<%= profile.getHighlightBadge1().replace("'", "\\'") %>', '<%= profile.getGoldProofUrl() != null ? profile.getGoldProofUrl() : "" %>', 'Verified Credential Proof — <%= profile.getFullName().replace("'", "\\'") %>')">
                            View Proof
                        </button>
                    </span>
                    <span style="color:#334155;">•</span>
                    <span class="highlight-mca">
                        <i class="fa-regular fa-circle-check"></i>
                        <%= profile.getHighlightBadge2() %>
                    </span>
                </div>

                <div class="hero-cta-row">
                    <a href="#projects" class="btn-explore">
                        Explore Projects <i class="fa-solid fa-arrow-right"></i>
                    </a>
                    <a href="#resume-section" class="btn-dark-cta">
                        <i class="fa-solid fa-file-arrow-down" style="color:#38bdf8;"></i> Download Resume
                    </a>
                    <a href="#education" class="btn-dark-cta">
                        <i class="fa-solid fa-shield-halved" style="color:#10b981;"></i> Academic Proofs
                    </a>
                </div>

                <div class="hero-socials">
                    <a href="<%= profile.getGithubUrl() %>" target="_blank" class="social-box" title="GitHub">
                        <i class="fa-brands fa-github"></i>
                    </a>
                    <a href="<%= profile.getLinkedinUrl() %>" target="_blank" class="social-box" title="LinkedIn">
                        <i class="fa-brands fa-linkedin-in"></i>
                    </a>
                    <a href="<%= profile.getLeetcodeUrl() %>" target="_blank" class="social-box" title="LeetCode">
                        <span style="font-size:0.76rem;font-weight:800;">LC</span>
                    </a>
                    <a href="mailto:<%= profile.getEmail() %>" class="social-box" title="Email">
                        <i class="fa-regular fa-envelope"></i>
                    </a>
                </div>
            </div>

            <!-- Right Column: Glowing Portrait Card -->
            <div class="col-lg-5">
                <div class="hero-photo-wrap">
                    <div class="photo-glow"></div>

                    <!-- Top-Right Floating Badge -->
                    <div class="floating-badge top-right">
                        <div class="fb-icon gold"><i class="fa-solid fa-award"></i></div>
                        <div>
                            <div class="fb-title gold-text"><%= profile.getTopCardBadgeTitle() %></div>
                            <div class="fb-sub"><%= profile.getTopCardBadgeSub() %></div>
                        </div>
                    </div>

                    <div class="photo-card">
                        <%
                            String avatarFallback = "https://ui-avatars.com/api/?name=" + java.net.URLEncoder.encode(profile.getFullName(), "UTF-8") + "&size=500&background=0f172a&color=00e5ff&bold=true";
                            String picSrc = (profile.getProfilePicUrl() != null && !profile.getProfilePicUrl().trim().isEmpty())
                                    ? (request.getContextPath() + "/" + profile.getProfilePicUrl())
                                    : avatarFallback;
                        %>
                        <img src="<%= picSrc %>"
                             alt="<%= profile.getFullName() %>"
                             onerror="this.src='<%= avatarFallback %>'">
                        <div class="photo-caption-overlay">
                            <div class="photo-caption-name"><%= profile.getShortName() %></div>
                            <div class="photo-caption-role rotating-role-fade" id="photoCardRotatingRole">Java Full Stack Developer</div>
                        </div>
                    </div>

                    <!-- Bottom-Left Floating Badge -->
                    <div class="floating-badge bottom-left">
                        <div class="fb-icon blue"><i class="fa-brands fa-github"></i></div>
                        <div>
                            <div class="fb-title"><%= profile.getBottomCardBadgeTitle() %></div>
                            <div class="fb-sub"><%= profile.getBottomCardBadgeSub() %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ================= DETAILED PROJECT ENGINEERING SHOWCASE ================= -->
<section id="projects">
    <div class="container">
        <div class="section-header">
            <div class="section-badge">
                <i class="fa-solid fa-code"></i> Flagship Production &amp; Open-Source Projects
            </div>
            <h2 class="section-title">Detailed Project Engineering Showcase</h2>
            <p class="section-subtitle">
                Explore complete architectural deep-dives, live codebases, and classified builds across Java
                Enterprise, MERN stacks, and AI Prompt-Engineered applications.
            </p>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar">
            <div class="filter-group" id="projectCategoryFilters">
                <button type="button" class="filter-btn active" onclick="filterProjects('category', 'ALL', this)">All Projects</button>
                <button type="button" class="filter-btn" onclick="filterProjects('category', 'Java Full Stack', this)">☕ Java Full Stack</button>
                <button type="button" class="filter-btn" onclick="filterProjects('category', 'MERN Stack', this)">⚛️ MERN Stack</button>
                <button type="button" class="filter-btn" onclick="filterProjects('category', 'AI & Microservices', this)">🤖 AI &amp; Microservices</button>
            </div>

            <div class="filter-group" id="projectMethodFilters">
                <button type="button" class="filter-btn active" onclick="filterProjects('method', 'ALL', this)">All Methods</button>
                <button type="button" class="filter-btn" onclick="filterProjects('method', 'Solo Handcrafted', this)">&lt;/&gt; 🛠️ Handcrafted Solo</button>
                <button type="button" class="filter-btn" onclick="filterProjects('method', 'AI & Prompt Engineered', this)">🤖 AI / Prompt Engineered</button>
            </div>

            <div class="search-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="projectSearchInput" class="search-input" placeholder="Search by tech or name..." oninput="applyProjectFilters()">
            </div>
        </div>

        <!-- Bootstrap 5 Row for Dark Project Cards -->
        <div class="row g-4 justify-content-center" id="projectsGrid">
            <% if (projects.isEmpty()) { %>
            <div class="col-lg-8 col-md-10 mx-auto">
                <div class="card project-card text-center p-5 border-secondary">
                    <div class="mb-3" style="font-size:2.2rem;color:#00e5ff;"><i class="fa-solid fa-folder-plus"></i></div>
                    <h4 class="text-white fw-bold mb-2">Projects Coming Soon</h4>
                    <p class="text-secondary mb-0">Flagship engineering projects and architecture deep-dives will be listed here.</p>
                </div>
            </div>
            <% } else {
                String projColClass = projects.size() == 1 ? "col-lg-8 col-md-10 mx-auto" : (projects.size() == 2 ? "col-lg-6 col-md-6" : "col-lg-4 col-md-6");
                for (Project pr : projects) {
                boolean isAiMethod = pr.getBuildMethod() != null && pr.getBuildMethod().toLowerCase().contains("ai");
                String[] techs = pr.getTechArray();
            %>
            <div class="<%= projColClass %> d-flex align-items-stretch project-col-item"
                 data-category="<%= pr.getCategory() != null ? pr.getCategory() : "" %>"
                 data-method="<%= pr.getBuildMethod() != null ? pr.getBuildMethod() : "" %>"
                 data-search="<%= (pr.getTitle() + " " + pr.getDescription() + " " + pr.getTechStack()).toLowerCase().replace("\"", "'") %>">
                <div class="card project-card w-100 border-secondary">
                    <div>
                        <div class="project-top-badges">
                            <span class="badge-method <%= isAiMethod ? "ai" : "solo" %>">
                                <%= isAiMethod ? "🤖 AI &amp; Prompt Engineered" : "&lt;/&gt; 🛠️ Solo Handcrafted" %>
                            </span>
                            <% if (pr.isFeatured()) { %>
                            <span class="badge-featured">FEATURED</span>
                            <% } %>
                        </div>

                        <div class="project-title-row">
                            <h3 class="project-title"><%= pr.getTitle() %></h3>
                            <a href="<%= (pr.getLiveUrl() != null && !pr.getLiveUrl().isEmpty()) ? pr.getLiveUrl() : (pr.getGithubUrl() != null ? pr.getGithubUrl() : "#projects") %>"
                               target="_blank" style="color:#64748b;font-size:0.85rem;" title="Open Project Link">
                                <i class="fa-solid fa-arrow-up-right-from-square"></i>
                            </a>
                        </div>

                        <p class="project-desc"><%= pr.getDescription() %></p>

                        <div class="tech-tags">
                            <%
                                int maxShow = 5;
                                for (int i = 0; i < Math.min(techs.length, maxShow); i++) {
                            %>
                            <span class="tech-tag"><%= techs[i] %></span>
                            <% }
                               if (techs.length > maxShow) { %>
                            <span class="tech-tag more">+<%= (techs.length - maxShow) %> more</span>
                            <% } %>
                        </div>
                    </div>

                    <div class="project-footer">
                        <button type="button" class="deep-dive-link"
                                data-title="<%= pr.getTitle().replace("\"", "&quot;") %>"
                                data-cat="<%= (pr.getCategory() + " • " + pr.getBuildMethod()).replace("\"", "&quot;") %>"
                                data-desc="<%= pr.getDescription().replace("\"", "&quot;") %>"
                                data-arch="<%= (pr.getArchitectureDetails() != null ? pr.getArchitectureDetails() : "").replace("\"", "&quot;") %>"
                                data-tech="<%= (pr.getTechStack() != null ? pr.getTechStack() : "").replace("\"", "&quot;") %>"
                                data-github="<%= pr.getGithubUrl() != null ? pr.getGithubUrl() : "" %>"
                                data-proof="<%= pr.getProofUrl() != null ? pr.getProofUrl() : "" %>"
                                onclick="openProjectDeepDive(this)">
                            Click for Deep Dive &amp; Architecture →
                        </button>
                        <a href="<%= pr.getGithubUrl() != null && !pr.getGithubUrl().isEmpty() ? pr.getGithubUrl() : "#" %>"
                           target="_blank" class="repo-icon-btn" title="View Source on GitHub">
                            <i class="fa-brands fa-github"></i>
                        </a>
                    </div>
                </div>
            </div>
            <% } } %>
        </div>
    </div>
</section>

<!-- ================= ACADEMIC BACKGROUND & VERIFIED DOCUMENT PROOFS ================= -->
<section id="education">
    <div class="container">
        <div class="section-header">
            <div class="section-badge emerald">
                <i class="fa-solid fa-shield-check"></i> 100% Authentic Proofs Available
            </div>
            <h2 class="section-title">Academic Background &amp; Verified Document Proofs</h2>
            <p class="section-subtitle">
                Transparent academic credentials with attached official marksheets and degree certificates.
            </p>
        </div>

        <div class="row g-4 justify-content-center">
            <% if (educations.isEmpty()) { %>
            <div class="col-lg-8 col-md-10 mx-auto">
                <div class="card edu-card text-center p-5 border-secondary">
                    <div class="mb-3" style="font-size:2.2rem;color:#10b981;"><i class="fa-solid fa-graduation-cap"></i></div>
                    <h4 class="text-white fw-bold mb-2">Academic Credentials</h4>
                    <p class="text-secondary mb-0">Academic background and verified marksheet proofs will appear here.</p>
                </div>
            </div>
            <% } else {
                String eduColClass = educations.size() == 1 ? "col-lg-8 col-md-10 mx-auto" : "col-lg-6 col-md-6";
                for (Education ed : educations) { %>
            <div class="<%= eduColClass %> d-flex align-items-stretch">
                <div class="card edu-card w-100 border-secondary">
                    <div>
                        <div class="edu-top-row">
                            <div class="edu-icon-box">
                                <i class="fa-solid fa-graduation-cap"></i>
                            </div>
                            <div class="edu-meta-right">
                                <span class="edu-duration-pill"><%= ed.getDuration() %></span>
                                <span class="edu-status-text"><%= ed.getStatusText() %></span>
                            </div>
                        </div>

                        <h3 class="edu-degree"><%= ed.getDegree() %></h3>
                        <div class="edu-inst"><%= ed.getInstitution() %></div>
                        <div class="edu-univ"><%= ed.getUniversity() %></div>
                        <p class="edu-desc"><%= ed.getDescription() %></p>
                    </div>

                    <div class="proof-section">
                        <div class="proof-heading">
                            <i class="fa-regular fa-circle-check"></i> INSPECT VERIFIED PROOFS &amp; MARKSHEETS:
                        </div>
                        <div class="proof-pills">
                            <%
                                String edP1Label = (ed.getProof1Title() != null && !ed.getProof1Title().trim().isEmpty()) ? ed.getProof1Title() : ((ed.getProof1Url() != null && !ed.getProof1Url().trim().isEmpty()) ? "Official Marksheet / Proof" : "");
                                String edP2Label = (ed.getProof2Title() != null && !ed.getProof2Title().trim().isEmpty()) ? ed.getProof2Title() : ((ed.getProof2Url() != null && !ed.getProof2Url().trim().isEmpty()) ? "Academic Certificate / Proof 2" : "");
                                String edP3Label = (ed.getProof3Title() != null && !ed.getProof3Title().trim().isEmpty()) ? ed.getProof3Title() : ((ed.getProof3Url() != null && !ed.getProof3Url().trim().isEmpty()) ? "Verified Record / Proof 3" : "");
                            %>
                            <% if (!edP1Label.isEmpty()) { %>
                            <button type="button" class="proof-pill-btn"
                                    onclick="openProofModal('<%= edP1Label.replace("'", "\\'") %>', '<%= ed.getProof1Url() != null ? ed.getProof1Url() : "" %>', '<%= ed.getDegree().replace("'", "\\'") %> — <%= ed.getStatusText().replace("'", "\\'") %>')">
                                <i class="fa-regular fa-file-lines doc-ic"></i>
                                <span><%= edP1Label %></span>
                                <i class="fa-regular fa-eye eye-ic"></i>
                            </button>
                            <% } %>

                            <% if (!edP2Label.isEmpty()) { %>
                            <button type="button" class="proof-pill-btn"
                                    onclick="openProofModal('<%= edP2Label.replace("'", "\\'") %>', '<%= ed.getProof2Url() != null ? ed.getProof2Url() : "" %>', '<%= ed.getDegree().replace("'", "\\'") %> — Verified Academic Credential')">
                                <i class="fa-regular fa-file-lines doc-ic"></i>
                                <span><%= edP2Label %></span>
                                <i class="fa-regular fa-eye eye-ic"></i>
                            </button>
                            <% } %>

                            <% if (!edP3Label.isEmpty()) { %>
                            <button type="button" class="proof-pill-btn"
                                    onclick="openProofModal('<%= edP3Label.replace("'", "\\'") %>', '<%= ed.getProof3Url() != null ? ed.getProof3Url() : "" %>', '<%= ed.getDegree().replace("'", "\\'") %> — Verified Record')">
                                <i class="fa-regular fa-file-lines doc-ic"></i>
                                <span><%= edP3Label %></span>
                                <i class="fa-regular fa-eye eye-ic"></i>
                            </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } } %>
        </div>
    </div>
</section>

<!-- ================= VERIFIED CERTIFICATIONS & HONORS ================= -->
<section id="certificates">
    <div class="container">
        <div class="section-header">
            <div class="section-badge gold">
                <i class="fa-solid fa-award"></i> Industry &amp; Academic Certifications
            </div>
            <h2 class="section-title">Verified Certifications &amp; Honors</h2>
            <p class="section-subtitle">
                Authenticated professional credentials and technical certifications with attached verification proofs.
            </p>
        </div>

        <div class="cert-filter-wrap">
            <div class="cert-filter-box" id="certFilterButtons">
                <button type="button" class="filter-btn active" onclick="filterCertificates('ALL', this)">All Certifications</button>
                <button type="button" class="filter-btn" onclick="filterCertificates('Java & DSA (IIT NPTEL)', this)">☕ Java &amp; DSA</button>
                <button type="button" class="filter-btn" onclick="filterCertificates('Web & Google Certs', this)">🌐 Web &amp; Cloud Certs</button>
            </div>
        </div>

        <div class="row g-4 justify-content-center" id="certsGrid">
            <% if (certificates.isEmpty()) { %>
            <div class="col-lg-8 col-md-10 mx-auto">
                <div class="card cert-card text-center p-5 border-secondary">
                    <div class="mb-3" style="font-size:2.2rem;color:#fbbf24;"><i class="fa-solid fa-award"></i></div>
                    <h4 class="text-white fw-bold mb-2">Certifications &amp; Honors</h4>
                    <p class="text-secondary mb-0">Professional certifications and honors will appear here.</p>
                </div>
            </div>
            <% } else {
                String certColClass = certificates.size() == 1 ? "col-lg-8 col-md-10 mx-auto" : (certificates.size() == 2 ? "col-lg-6 col-md-6" : "col-lg-4 col-md-6");
                for (Certificate c : certificates) {
                String[] cSkills = c.getSkillArray();
            %>
            <div class="<%= certColClass %> d-flex align-items-stretch cert-col-item"
                 data-category="<%= c.getCategory() != null ? c.getCategory() : "" %>">
                <div class="card cert-card w-100 <%= c.isEliteGold() ? "elite-gold" : "border-secondary" %>">
                    <% if (c.isEliteGold()) { %>
                    <div class="elite-top-ribbon">
                        ✨ <%= (c.getTopRibbonText() != null && !c.getTopRibbonText().isEmpty()) ? c.getTopRibbonText() : "ELITE + GOLD MEDALIST" %>
                    </div>
                    <% } %>

                    <div>
                        <div class="cert-top-row">
                            <div class="cert-icon-box">
                                <i class="fa-solid fa-medal"></i>
                            </div>
                            <span class="cert-date"><%= c.getIssueDate() %></span>
                        </div>

                        <h3 class="cert-title"><%= c.getTitle() %></h3>
                        <div class="cert-issuer"><%= c.getIssuer() %></div>

                        <div class="cert-score-pill">
                            Score / Recognition: <%= c.getScoreBadge() %>
                        </div>

                        <p class="cert-desc"><%= c.getDescription() %></p>

                        <div class="tech-tags">
                            <% for (String sk : cSkills) { %>
                            <span class="tech-tag"><%= sk %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="cert-footer">
                        <span class="cert-id" title="ID: <%= c.getCredentialId() %>">ID: <%= c.getCredentialId() %></span>
                        <button type="button" class="btn-view-cert"
                                onclick="openProofModal('<%= c.getTitle().replace("'", "\\'") %>', '<%= c.getProofUrl() != null ? c.getProofUrl() : "" %>', 'Issued by <%= c.getIssuer().replace("'", "\\'") %> • Score: <%= c.getScoreBadge().replace("'", "\\'") %> • Credential ID: <%= c.getCredentialId().replace("'", "\\'") %>')">
                            <i class="fa-regular fa-eye"></i> View Proof
                        </button>
                    </div>
                </div>
            </div>
            <% } } %>
        </div>
    </div>
</section>

<!-- ================= WORK EXPERIENCE & INDUSTRY CREDENTIALS ================= -->
<section id="experience">
    <div class="container">
        <div class="section-header">
            <div class="section-badge">
                <i class="fa-solid fa-briefcase"></i> Professional Engineering Work
            </div>
            <h2 class="section-title">Work Experience &amp; Industry Credentials</h2>
            <p class="section-subtitle">
                Hands-on software development roles delivering backend services, RESTful APIs, and database
                solutions in agile product teams.
            </p>
        </div>

        <div class="exp-list">
            <% if (experiences.isEmpty()) { %>
            <div class="card exp-card text-center p-5 border-secondary">
                <div class="mb-3" style="font-size:2.2rem;color:#38bdf8;"><i class="fa-solid fa-briefcase"></i></div>
                <h4 class="text-white fw-bold mb-2">Work Experience &amp; Internships</h4>
                <p class="text-secondary mb-0">Professional software development roles and internships will appear here.</p>
            </div>
            <% } else {
                for (Experience ex : experiences) {
                String[] exTechs = ex.getTechArray();
            %>
            <div class="card exp-card border-secondary">
                <div class="exp-top-row">
                    <div>
                        <div class="exp-badges">
                            <span class="badge-intern"><%= ex.getExpType() %></span>
                            <span class="exp-track">• <%= ex.getTrackName() %></span>
                        </div>
                        <h3 class="exp-role"><%= ex.getRoleTitle() %></h3>
                        <div class="exp-company">
                            <i class="fa-regular fa-building"></i> <%= ex.getCompany() %>
                        </div>
                    </div>

                    <div class="exp-meta-right">
                        <div><i class="fa-regular fa-calendar" style="color:#22d3ee;"></i> <%= ex.getDuration() %></div>
                        <div class="loc"><i class="fa-solid fa-location-dot" style="color:#f43f5e;"></i> <%= ex.getLocation() %></div>
                    </div>
                </div>

                <p class="exp-desc"><%= ex.getDescription() %></p>

                <div class="tech-tags">
                    <% for (String t : exTechs) { %>
                    <span class="tech-tag"><%= t %></span>
                    <% } %>
                </div>

                <div class="exp-proof-bar">
                    <div class="proof-heading" style="margin-bottom:0;">
                        <i class="fa-regular fa-circle-check"></i> ATTACHED PROOFS:
                    </div>
                    <div class="proof-pills">
                        <%
                            String exP1Label = (ex.getProof1Title() != null && !ex.getProof1Title().trim().isEmpty()) ? ex.getProof1Title() : ((ex.getProof1Url() != null && !ex.getProof1Url().trim().isEmpty()) ? "Experience Certificate / Proof" : "");
                            String exP2Label = (ex.getProof2Title() != null && !ex.getProof2Title().trim().isEmpty()) ? ex.getProof2Title() : ((ex.getProof2Url() != null && !ex.getProof2Url().trim().isEmpty()) ? "Offer Letter / Proof 2" : "");
                            String exP3Label = (ex.getProof3Title() != null && !ex.getProof3Title().trim().isEmpty()) ? ex.getProof3Title() : ((ex.getProof3Url() != null && !ex.getProof3Url().trim().isEmpty()) ? "Training Certificate / Proof 3" : "");
                        %>
                        <% if (!exP1Label.isEmpty()) { %>
                        <button type="button" class="proof-pill-btn"
                                onclick="openProofModal('<%= exP1Label.replace("'", "\\'") %> — <%= ex.getCompany().replace("'", "\\'") %>', '<%= ex.getProof1Url() != null ? ex.getProof1Url() : "" %>', '<%= ex.getRoleTitle().replace("'", "\\'") %> (<%= ex.getDuration().replace("'", "\\'") %>)')">
                            <i class="fa-regular fa-file-lines doc-ic"></i>
                            <span><%= exP1Label %></span>
                            <i class="fa-regular fa-eye eye-ic"></i>
                        </button>
                        <% } %>

                        <% if (!exP2Label.isEmpty()) { %>
                        <button type="button" class="proof-pill-btn"
                                onclick="openProofModal('<%= exP2Label.replace("'", "\\'") %> — <%= ex.getCompany().replace("'", "\\'") %>', '<%= ex.getProof2Url() != null ? ex.getProof2Url() : "" %>', '<%= ex.getRoleTitle().replace("'", "\\'") %> (<%= ex.getDuration().replace("'", "\\'") %>)')">
                            <i class="fa-regular fa-file-lines doc-ic"></i>
                            <span><%= exP2Label %></span>
                            <i class="fa-regular fa-eye eye-ic"></i>
                        </button>
                        <% } %>

                        <% if (!exP3Label.isEmpty()) { %>
                        <button type="button" class="proof-pill-btn"
                                onclick="openProofModal('<%= exP3Label.replace("'", "\\'") %> — <%= ex.getCompany().replace("'", "\\'") %>', '<%= ex.getProof3Url() != null ? ex.getProof3Url() : "" %>', '<%= ex.getRoleTitle().replace("'", "\\'") %> (<%= ex.getDuration().replace("'", "\\'") %>)')">
                            <i class="fa-regular fa-file-lines doc-ic"></i>
                            <span><%= exP3Label %></span>
                            <i class="fa-regular fa-eye eye-ic"></i>
                        </button>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } } %>
        </div>
    </div>
</section>

<!-- ================= COMPREHENSIVE SKILLS & ENGINEERING COMPETENCIES (NEW IMAGE 1) ================= -->
<section id="skills">
    <div class="container">
        <div class="section-header">
            <div class="section-badge">
                <i class="fa-solid fa-microchip"></i> Technical Arsenal
            </div>
            <h2 class="section-title">Comprehensive Skills &amp; Engineering<br>Competencies</h2>
            <p class="section-subtitle">
                Categorized technical capabilities across the Java Enterprise ecosystem, MERN stack, database
                design, and AI Prompt Engineering.
            </p>
        </div>

        <!-- Orange Pill Category Filter Tabs matching New Screenshot 1 -->
        <div class="d-flex justify-content-center mb-4">
            <div id="skillFilterButtons" style="background:#0b1120;border:1px solid #1e293b;padding:0.4rem;border-radius:14px;display:inline-flex;flex-wrap:wrap;justify-content:center;gap:0.45rem;">
                <button type="button" class="skill-tab-btn" onclick="filterSkillsByCat('ALL', this)"
                        style="background:linear-gradient(90deg, #ea580c, #f59e0b);color:#fff;border:none;padding:0.55rem 1.2rem;border-radius:10px;font-size:0.84rem;font-weight:700;cursor:pointer;">
                    <i class="fa-solid fa-layer-group"></i> All Skills
                </button>
                <button type="button" class="skill-tab-btn" onclick="filterSkillsByCat('Java', this)"
                        style="background:transparent;color:#94a3b8;border:none;padding:0.55rem 1.2rem;border-radius:10px;font-size:0.84rem;font-weight:700;cursor:pointer;">
                    ☕ Java Ecosystem
                </button>
                <button type="button" class="skill-tab-btn" onclick="filterSkillsByCat('MERN', this)"
                        style="background:transparent;color:#94a3b8;border:none;padding:0.55rem 1.2rem;border-radius:10px;font-size:0.84rem;font-weight:700;cursor:pointer;">
                    &lt;/&gt; ⚛️ MERN &amp; Web
                </button>
                <button type="button" class="skill-tab-btn" onclick="filterSkillsByCat('AI', this)"
                        style="background:transparent;color:#94a3b8;border:none;padding:0.55rem 1.2rem;border-radius:10px;font-size:0.84rem;font-weight:700;cursor:pointer;">
                    ✨ 🤖 AI &amp; DevOps
                </button>
            </div>
        </div>

        <!-- 2-Column Grid of Individual Skill Cards (Dynamically loaded via JavaScript + JSON) -->
        <div class="row g-3 justify-content-center" id="skillsGrid">
            <% if (skills.isEmpty()) { %>
            <div class="col-lg-8 col-md-10 mx-auto">
                <div class="card skill-cat-card text-center p-5 border-secondary">
                    <div class="mb-3" style="font-size:2.2rem;color:#f59e0b;"><i class="fa-solid fa-microchip"></i></div>
                    <h4 class="text-white fw-bold mb-2">Technical Skills</h4>
                    <p class="text-secondary mb-0">Categorized technical competencies and proficiency levels will appear here.</p>
                </div>
            </div>
            <% } else {
                String skColClass = skills.size() == 1 ? "col-lg-8 col-md-10 mx-auto" : "col-lg-6 col-md-6";
                for (Skill sk : skills) { %>
            <div class="<%= skColClass %> skill-col-item" data-category="<%= sk.getCategory() %>">
                <div class="card border-secondary h-100" style="background:#0d1323;border-radius:14px;padding:1.25rem 1.4rem;">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="d-flex align-items-center gap-2">
                            <i class="fa-regular fa-circle-check" style="color:#f59e0b;font-size:0.95rem;"></i>
                            <span style="font-weight:700;font-size:0.98rem;color:#ffffff;"><%= sk.getSkillName() %></span>
                        </div>
                        <span style="background:rgba(245,158,11,0.14);border:1px solid rgba(245,158,11,0.35);color:#fbbf24;font-size:0.7rem;font-weight:700;padding:0.2rem 0.65rem;border-radius:6px;">
                            <%= (sk.getBadgeText() != null && !sk.getBadgeText().isEmpty()) ? sk.getBadgeText() : (sk.getProficiency() + "%") %>
                        </span>
                    </div>
                    <div style="width:100%;height:6px;background:#1e293b;border-radius:999px;overflow:hidden;">
                        <div style="width:<%= sk.getProficiency() %>%;height:100%;background:linear-gradient(90deg, #ea580c, #fbbf24);border-radius:999px;"></div>
                    </div>
                </div>
            </div>
            <% } } %>
        </div>
    </div>
</section>

<!-- ================= CURRICULUM VITAE & VERIFIED RESUME PREVIEWS (NEW IMAGE 2) ================= -->
<section id="resume-section">
    <div class="container">
        <div class="section-header">
            <div class="section-badge">
                <i class="fa-regular fa-file-lines"></i> Tailored Professional Resumes
            </div>
            <h2 class="section-title">Curriculum Vitae &amp; Verified Resume<br>Previews</h2>
            <p class="section-subtitle">
                Preview and download my official resume customized with relevant internship experience,
                production projects, and verified credentials.
            </p>
        </div>

        <div class="card border-secondary" style="background:#0b1120;border-radius:18px;padding:1.6rem;">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 pb-3 mb-3" style="border-bottom:1px solid #1e293b;">
                <div class="d-flex align-items-center gap-3">
                    <div style="width:46px;height:46px;border-radius:12px;background:rgba(0,229,255,0.12);border:1px solid rgba(0,229,255,0.35);color:#00e5ff;display:flex;align-items:center;justify-content:center;font-size:1.2rem;">
                        <i class="fa-regular fa-file-pdf"></i>
                    </div>
                    <div>
                        <h3 style="font-size:1.15rem;font-weight:800;color:#fff;margin:0;"><%= profile.getFullName() %> — Official Resume</h3>
                        <div style="font-size:0.78rem;color:#94a3b8;"><%= profile.getRoleTitle() %></div>
                    </div>
                </div>

                <div class="d-flex flex-wrap gap-2">
                    <% if (profile.getResumeUrl() != null && !profile.getResumeUrl().trim().isEmpty()) {
                        String resFullUrl = request.getContextPath() + "/" + profile.getResumeUrl();
                    %>
                    <a href="<%= resFullUrl %>" target="_blank" class="btn-resume-nav">
                        <i class="fa-regular fa-eye"></i> Fullscreen
                    </a>
                    <a href="<%= resFullUrl %>?download=true" class="btn-explore" style="padding:0.55rem 1.15rem;font-size:0.82rem;background:linear-gradient(90deg,#0284c7,#2563eb);">
                        <i class="fa-solid fa-download"></i> Download PDF
                    </a>
                    <% } %>
                </div>
            </div>

            <% if (profile.getResumeUrl() != null && !profile.getResumeUrl().trim().isEmpty()) { %>
            <div style="background:#1e293b;border-radius:12px;overflow:hidden;height:580px;">
                <iframe src="<%= request.getContextPath() + "/" + profile.getResumeUrl() %>" style="width:100%;height:100%;border:none;"></iframe>
            </div>
            <% } else { %>
            <div class="text-center p-5" style="background:#070b14;border:1px dashed #334155;border-radius:12px;">
                <i class="fa-regular fa-file-pdf mb-3" style="font-size:2.6rem;color:#38bdf8;"></i>
                <h4 class="text-white fw-bold mb-2">Resume Preview</h4>
                <p class="text-secondary mb-0" style="max-width:480px;margin:0 auto;">
                    Official Resume PDF will be available for preview and download here.
                </p>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- ================= GET IN TOUCH / CONTACT SECTION (NEW IMAGE 3) ================= -->
<section id="contact">
    <div class="container">
        <div class="section-header">
            <div class="section-badge">
                <i class="fa-regular fa-envelope"></i> Get in Touch
            </div>
            <h2 class="section-title">Let's Build Something Exceptional Together</h2>
            <p class="section-subtitle">
                Available for immediate full-time software developer roles, technical interviews, and engineering
                internships. Reach out via email, phone, or LinkedIn.
            </p>
        </div>

        <% if ("sent".equals(msgStatus)) { %>
        <div class="alert alert-success text-center fw-semibold rounded-3 mb-4">
            <i class="fa-solid fa-circle-check"></i> Thank you! Your message has been delivered directly to <%= profile.getFullName() %>'s Admin Inbox.
        </div>
        <% } %>

        <div class="row g-4 align-items-stretch">
            <!-- Left Column: Stacked Info Cards matching New Screenshot 3 -->
            <div class="col-lg-5 d-flex flex-column justify-content-between gap-3">
                <!-- Card 1: Direct Email -->
                <div class="card border-secondary" style="background:#0d1323;border-radius:16px;padding:1.35rem 1.5rem;">
                    <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center gap-3">
                            <div style="width:44px;height:44px;border-radius:12px;background:rgba(59,130,246,0.12);border:1px solid rgba(59,130,246,0.3);color:#60a5fa;display:flex;align-items:center;justify-content:center;">
                                <i class="fa-regular fa-envelope"></i>
                            </div>
                            <div>
                                <div style="font-size:0.74rem;color:#94a3b8;">Direct Email</div>
                                <a href="mailto:<%= profile.getEmail() %>" style="font-size:0.98rem;font-weight:800;color:#ffffff;"><%= profile.getEmail() %></a>
                            </div>
                        </div>
                        <button type="button" class="repo-icon-btn" onclick="copyTextToClipboard('<%= profile.getEmail() %>', this)" title="Copy Email">
                            <i class="fa-regular fa-copy"></i>
                        </button>
                    </div>
                </div>

                <!-- Card 2: Phone & WhatsApp -->
                <div class="card border-secondary" style="background:#0d1323;border-radius:16px;padding:1.35rem 1.5rem;">
                    <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center gap-3">
                            <div style="width:44px;height:44px;border-radius:12px;background:rgba(16,185,129,0.12);border:1px solid rgba(16,185,129,0.3);color:#34d399;display:flex;align-items:center;justify-content:center;">
                                <i class="fa-solid fa-phone"></i>
                            </div>
                            <div>
                                <div style="font-size:0.74rem;color:#94a3b8;">Phone &amp; WhatsApp</div>
                                <div style="font-size:0.98rem;font-weight:800;color:#ffffff;"><%= profile.getPhone() %></div>
                            </div>
                        </div>
                        <button type="button" class="repo-icon-btn" onclick="copyTextToClipboard('<%= profile.getPhone() %>', this)" title="Copy Phone">
                            <i class="fa-regular fa-copy"></i>
                        </button>
                    </div>
                </div>

                <!-- Card 3: Current Location -->
                <div class="card border-secondary" style="background:#0d1323;border-radius:16px;padding:1.35rem 1.5rem;">
                    <div class="d-flex align-items-center gap-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(244,63,94,0.12);border:1px solid rgba(244,63,94,0.3);color:#fb7185;display:flex;align-items:center;justify-content:center;">
                            <i class="fa-solid fa-location-dot"></i>
                        </div>
                        <div>
                            <div style="font-size:0.74rem;color:#94a3b8;">Current Location</div>
                            <div style="font-size:0.98rem;font-weight:800;color:#ffffff;"><%= profile.getLocation() %></div>
                            <div style="font-size:0.74rem;color:#64748b;">(Open to Hybrid / Onsite / Remote roles)</div>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Social Bar -->
                <div class="card border-secondary" style="background:#0d1323;border-radius:16px;padding:1rem 1.5rem;">
                    <div class="d-flex justify-content-around align-items-center" style="font-size:0.84rem;font-weight:700;color:#cbd5e1;">
                        <a href="<%= profile.getLinkedinUrl() %>" target="_blank"><i class="fa-brands fa-linkedin-in me-1"></i> LinkedIn</a>
                        <span style="color:#334155;">•</span>
                        <a href="<%= profile.getGithubUrl() %>" target="_blank"><i class="fa-brands fa-github me-1"></i> GitHub</a>
                        <span style="color:#334155;">•</span>
                        <a href="<%= profile.getLeetcodeUrl() %>" target="_blank">LeetCode</a>
                    </div>
                </div>
            </div>

            <!-- Right Column: Send Direct Message Card matching New Screenshot 3 -->
            <div class="col-lg-7">
                <div class="card border-secondary h-100" style="background:#0d1323;border-radius:18px;padding:2rem;">
                    <h3 style="font-size:1.2rem;font-weight:800;color:#fff;margin-bottom:1.4rem;display:flex;align-items:center;gap:0.55rem;">
                        <i class="fa-regular fa-comment-dots" style="color:#00e5ff;"></i> Send Direct Message
                    </h3>

                    <form id="contactForm" action="<%= request.getContextPath() %>/contact" method="post" onsubmit="return submitPortfolioContactForm(event)">
                        <input type="hidden" name="companyName" value="Direct Portfolio Inquiry">
                        <input type="hidden" name="recruiterPhone" value="">
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label" for="contactName">Your Name *</label>
                                <input type="text" id="contactName" name="recruiterName" class="form-control" placeholder="e.g. John Doe" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="contactEmail">Your Email *</label>
                                <input type="email" id="contactEmail" name="recruiterEmail" class="form-control" placeholder="e.g. recruiter@company.com" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="contactSubject">Subject</label>
                            <input type="text" id="contactSubject" name="roleOffered" class="form-control" placeholder="e.g. Interview Invitation / Job Opportunity" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label" for="contactMessage">Your Message *</label>
                            <textarea id="contactMessage" name="message" rows="4" class="form-control" placeholder="Tell me about the role, team, or opportunity..." required></textarea>
                        </div>
                        <button type="submit" id="contactSubmitBtn" class="btn-explore w-100 justify-content-center py-3" style="background:linear-gradient(90deg, #2563eb 0%, #00d2b8 100%);">
                            <i class="fa-regular fa-paper-plane"></i> Send Email to <%= profile.getShortName() %>
                        </button>
                        <div id="contactFormStatus" role="status" aria-live="polite" style="display:none;margin-top:0.85rem;padding:0.75rem 1rem;border-radius:10px;font-size:0.86rem;font-weight:600;text-align:center;"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ================= FOOTER (MATCHING NEW IMAGE 4) ================= -->
<footer style="border-top:1px solid rgba(255,255,255,0.06);padding:2.4rem 0;background:#050811;">
    <div class="container d-flex flex-wrap justify-content-between align-items-center gap-3">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <strong style="font-size:1.02rem;color:#fff;"><%= profile.getFullName() %></strong>
                <span style="background:rgba(0,229,255,0.12);border:1px solid rgba(0,229,255,0.3);color:#00e5ff;font-size:0.68rem;font-weight:700;padding:0.15rem 0.6rem;border-radius:999px;">
                    <%= profile.getNavSubtitle() %>
                </span>
            </div>
            <div style="font-size:0.78rem;color:#64748b;">
                Crafted with HTML5, JSP, Bootstrap 5, JavaScript + JSON &amp; verified academic credentials.
            </div>
        </div>

        <div class="d-flex align-items-center gap-3" style="font-size:0.82rem;color:#94a3b8;">
            <a href="<%= profile.getGithubUrl() %>" target="_blank">GitHub</a>
            <span>•</span>
            <a href="<%= profile.getLinkedinUrl() %>" target="_blank">LinkedIn</a>
            <span>•</span>
            <a href="<%= profile.getLeetcodeUrl() %>" target="_blank">LeetCode</a>
            <span>•</span>
            <a href="mailto:<%= profile.getEmail() %>">Email</a>
        </div>

        <a href="#top" class="btn-resume-nav" style="border-radius:999px;padding:0.5rem 1.1rem;">
            Back to top <i class="fa-solid fa-arrow-up"></i>
        </a>
    </div>
</footer>

<!-- ================= MODAL 1: PROJECT DEEP DIVE & ARCHITECTURE ================= -->
<div class="modal-backdrop" id="projectModal">
    <div class="modal-window">
        <div class="modal-header">
            <div>
                <div id="pmCategory" style="font-size:0.74rem;color:#00e5ff;font-weight:700;text-transform:uppercase;"></div>
                <h3 id="pmTitle" style="font-size:1.35rem;font-weight:800;color:#fff;margin-top:0.2rem;"></h3>
            </div>
            <button type="button" class="modal-close" onclick="closeModal('projectModal')">✕</button>
        </div>
        <div class="modal-body">
            <h4 style="font-size:0.8rem;text-transform:uppercase;color:#94a3b8;margin-bottom:0.4rem;">Executive Overview</h4>
            <p id="pmDesc" style="font-size:0.92rem;color:#e2e8f0;margin-bottom:1.3rem;"></p>

            <h4 style="font-size:0.8rem;text-transform:uppercase;color:#10b981;margin-bottom:0.4rem;">
                <i class="fa-solid fa-diagram-project"></i> System Architecture &amp; Engineering Deep-Dive
            </h4>
            <div id="pmArch" style="background:#070b14;border:1px solid #1e293b;padding:1rem;border-radius:12px;font-size:0.88rem;color:#cbd5e1;margin-bottom:1.3rem;"></div>

            <h4 style="font-size:0.8rem;text-transform:uppercase;color:#94a3b8;margin-bottom:0.5rem;">Technology Stack</h4>
            <div id="pmTech" class="tech-tags" style="margin-bottom:1.4rem;"></div>

            <div class="d-flex gap-2 flex-wrap">
                <a id="pmGithub" href="#" target="_blank" class="btn-explore" style="padding:0.65rem 1.2rem;font-size:0.82rem;">
                    <i class="fa-brands fa-github"></i> View Codebase on GitHub
                </a>
                <button type="button" class="btn-dark-cta" onclick="closeModal('projectModal')" style="padding:0.65rem 1.2rem;font-size:0.82rem;">
                    Close Window
                </button>
            </div>
        </div>
    </div>
</div>

<!-- ================= MODAL 2: VERIFIED PROOF / CERTIFICATE / RESUME INSPECTOR ================= -->
<div class="modal-backdrop" id="proofModal">
    <div class="modal-window">
        <div class="modal-header">
            <div>
                <div style="font-size:0.72rem;color:#10b981;font-weight:700;text-transform:uppercase;">
                    <i class="fa-solid fa-shield-check"></i> Verified Credential &amp; Document Inspector
                </div>
                <h3 id="prfTitle" style="font-size:1.2rem;font-weight:800;color:#fff;margin-top:0.2rem;"></h3>
            </div>
            <button type="button" class="modal-close" onclick="closeModal('proofModal')">✕</button>
        </div>
        <div class="modal-body">
            <p id="prfSub" style="font-size:0.86rem;color:#94a3b8;margin-bottom:1.1rem;"></p>
            <div id="prfViewerBox" style="background:#070b14;border:1px solid #1e293b;border-radius:12px;padding:1.25rem;text-align:center;min-height:240px;display:flex;flex-direction:column;align-items:center;justify-content:center;">
            </div>
            <div class="mt-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                <a id="prfDownloadBtn" href="#" target="_blank" class="btn-explore" style="padding:0.6rem 1.15rem;font-size:0.82rem;display:none;">
                    <i class="fa-solid fa-download"></i> Open / Download Original File
                </a>
            </div>
        </div>
    </div>
</div>

<!-- ================= MODAL 3: RECRUITER QUICK-VIEW MODULE ================= -->
<div class="modal-backdrop" id="recruiterModal">
    <div class="modal-window" style="max-width:920px;">
        <div class="modal-header" style="background:linear-gradient(90deg, rgba(147,51,234,0.18), rgba(99,102,241,0.15));">
            <div>
                <div style="font-size:0.72rem;color:#c084fc;font-weight:800;text-transform:uppercase;letter-spacing:0.06em;">
                    ✨ 60-Second Executive Recruiter Dossier
                </div>
                <h3 style="font-size:1.35rem;font-weight:800;color:#fff;margin-top:0.15rem;">
                    <%= profile.getFullName() %> — Candidate Quick-View
                </h3>
            </div>
            <div class="d-flex gap-2 align-items-center">
                <a href="<%= request.getContextPath() %>/recruiter.jsp" class="btn-recruiter" style="padding:0.42rem 0.85rem;font-size:0.76rem;">
                    Open Full Recruiter Page ↗
                </a>
                <button type="button" class="modal-close" onclick="closeModal('recruiterModal')">✕</button>
            </div>
        </div>
        <div class="modal-body">
            <div class="row g-3 mb-4">
                <div class="col-md-3 col-6">
                    <div style="background:#080d19;border:1px solid rgba(245,158,11,0.4);padding:0.9rem;border-radius:12px;">
                        <div style="font-size:0.7rem;color:#fbbf24;font-weight:700;">HIGHLIGHT</div>
                        <div style="font-size:0.95rem;font-weight:800;color:#fff;margin-top:0.2rem;"><%= profile.getTopCardBadgeTitle() %></div>
                        <div style="font-size:0.74rem;color:#94a3b8;"><%= profile.getTopCardBadgeSub() %></div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div style="background:#080d19;border:1px solid #1e293b;padding:0.9rem;border-radius:12px;">
                        <div style="font-size:0.7rem;color:#10b981;font-weight:700;">QUALIFICATIONS</div>
                        <div style="font-size:0.95rem;font-weight:800;color:#fff;margin-top:0.2rem;"><%= educations.size() %> Verified Degrees</div>
                        <div style="font-size:0.74rem;color:#94a3b8;"><%= profile.getHighlightBadge2() %></div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div style="background:#080d19;border:1px solid #1e293b;padding:0.9rem;border-radius:12px;">
                        <div style="font-size:0.7rem;color:#38bdf8;font-weight:700;">EXPERIENCE</div>
                        <div style="font-size:0.95rem;font-weight:800;color:#fff;margin-top:0.2rem;"><%= experiences.size() %> Roles</div>
                        <div style="font-size:0.74rem;color:#94a3b8;">Verified Credentials</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div style="background:#080d19;border:1px solid #1e293b;padding:0.9rem;border-radius:12px;">
                        <div style="font-size:0.7rem;color:#a855f7;font-weight:700;">PROJECTS &amp; SKILLS</div>
                        <div style="font-size:0.95rem;font-weight:800;color:#fff;margin-top:0.2rem;"><%= projects.size() %> Projects • <%= skills.size() %> Skills</div>
                        <div style="font-size:0.74rem;color:#94a3b8;">Production Ready</div>
                    </div>
                </div>
            </div>

            <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center">
                <div class="d-flex gap-2 flex-wrap">
                    <a href="<%= request.getContextPath() %>/recruiter.jsp" class="btn-recruiter">
                        <i class="fa-solid fa-table-columns"></i> Open Dedicated Recruiter Portal
                    </a>
                    <a href="#contact" onclick="closeModal('recruiterModal')" class="btn-explore" style="padding:0.6rem 1.15rem;font-size:0.82rem;">
                        <i class="fa-regular fa-calendar-check"></i> Schedule Interview
                    </a>
                </div>
                <div style="font-size:0.8rem;color:#94a3b8;">
                    Direct Contact: <strong style="color:#fff;"><%= profile.getEmail() %></strong> | <strong style="color:#fff;"><%= profile.getPhone() %></strong>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5.3 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    window.PORTFOLIO_CTX = '<%= request.getContextPath() %>';
    var ctxPath = '<%= request.getContextPath() %>';

    // 3-Second Dynamic Role Rotator (Java Full Stack Developer, Junior Java Developer, Software Development Engineer)
    (function initRotatingRoles() {
        var rawAdminRoles = '<%= (profile.getRoleTitle() != null ? profile.getRoleTitle() : "").replace("'", "\\'") %>';
        var roles = [
            'Java Full Stack Developer',
            'Junior Java Developer',
            'Software Development Engineer'
        ];
        if (rawAdminRoles && rawAdminRoles.indexOf(',') !== -1) {
            var parts = rawAdminRoles.split(',');
            var parsed = [];
            for (var i = 0; i < parts.length; i++) {
                var r = parts[i].replace(/^\s+|\s+$/g, '');
                if (r) parsed.push(r);
            }
            if (parsed.length > 0) roles = parsed;
        }
        var roleIdx = 0;
        var heroRoleEl = document.getElementById('heroRotatingRole');
        var photoRoleEl = document.getElementById('photoCardRotatingRole');

        if (heroRoleEl) heroRoleEl.textContent = roles[0];
        if (photoRoleEl) photoRoleEl.textContent = roles[0];

        setInterval(function () {
            roleIdx = (roleIdx + 1) % roles.length;
            if (heroRoleEl) heroRoleEl.classList.add('fade-out');
            if (photoRoleEl) photoRoleEl.classList.add('fade-out');

            setTimeout(function () {
                if (heroRoleEl) {
                    heroRoleEl.textContent = roles[roleIdx];
                    heroRoleEl.classList.remove('fade-out');
                }
                if (photoRoleEl) {
                    photoRoleEl.textContent = roles[roleIdx];
                    photoRoleEl.classList.remove('fade-out');
                }
            }, 380);
        }, 3000);
    })();

    function filterProjects(type, value, btn) {
        var buttons, i;
        if (type === 'category') {
            activeProjectCategory = value;
            buttons = document.querySelectorAll('#projectCategoryFilters .filter-btn');
            for (i = 0; i < buttons.length; i++) buttons[i].classList.remove('active');
        } else {
            activeProjectMethod = value;
            buttons = document.querySelectorAll('#projectMethodFilters .filter-btn');
            for (i = 0; i < buttons.length; i++) buttons[i].classList.remove('active');
        }
        btn.classList.add('active');
        applyProjectFilters();
    }

    function applyProjectFilters() {
        if (portfolioJsonData && portfolioJsonData.projects && portfolioJsonData.projects.length > 0) {
            renderProjectsFromJson(portfolioJsonData.projects);
            return;
        }
        var q = (document.getElementById('projectSearchInput').value || '').toLowerCase().replace(/^\s+|\s+$/g, '');
        var items = document.querySelectorAll('#projectsGrid .project-col-item');
        var visible = 0;
        for (var i = 0; i < items.length; i++) {
            var col = items[i];
            var cat = col.getAttribute('data-category') || '';
            var method = col.getAttribute('data-method') || '';
            var search = col.getAttribute('data-search') || '';

            var matchCat = (activeProjectCategory === 'ALL') || (cat.toLowerCase() === activeProjectCategory.toLowerCase());
            var matchMethod = (activeProjectMethod === 'ALL') || (method.toLowerCase().indexOf(activeProjectMethod.toLowerCase()) !== -1);
            var matchSearch = (!q) || (search.indexOf(q) !== -1);
            var show = (matchCat && matchMethod && matchSearch);

            col.style.display = show ? 'flex' : 'none';
            if (show) visible++;
        }
        var newClass = visible === 1 ? 'col-lg-8 col-md-10 mx-auto' : (visible === 2 ? 'col-lg-6 col-md-6' : 'col-lg-4 col-md-6');
        for (var j = 0; j < items.length; j++) {
            if (items[j].style.display !== 'none') {
                items[j].className = newClass + ' d-flex align-items-stretch project-col-item';
            }
        }
    }

    function filterCertificates(cat, btn) {
        var btns = document.querySelectorAll('#certFilterButtons .filter-btn');
        for (var b = 0; b < btns.length; b++) btns[b].classList.remove('active');
        btn.classList.add('active');
        var items = document.querySelectorAll('#certsGrid .cert-col-item');
        var visible = 0;
        for (var i = 0; i < items.length; i++) {
            var col = items[i];
            var c = col.getAttribute('data-category') || '';
            var show = (cat === 'ALL' || c.toLowerCase() === cat.toLowerCase());
            col.style.display = show ? 'flex' : 'none';
            if (show) visible++;
        }
        var newClass = visible === 1 ? 'col-lg-8 col-md-10 mx-auto' : (visible === 2 ? 'col-lg-6 col-md-6' : 'col-lg-4 col-md-6');
        for (var j = 0; j < items.length; j++) {
            if (items[j].style.display !== 'none') {
                items[j].className = newClass + ' d-flex align-items-stretch cert-col-item';
            }
        }
    }

    function openProjectDeepDive(btn) {
        document.getElementById('pmTitle').textContent = btn.getAttribute('data-title');
        document.getElementById('pmCategory').textContent = btn.getAttribute('data-cat');
        document.getElementById('pmDesc').textContent = btn.getAttribute('data-desc');
        document.getElementById('pmArch').textContent = btn.getAttribute('data-arch') || 'Production-grade modular architecture with clean separation of concerns, REST API endpoints, and optimized database persistence.';
        var techWrap = document.getElementById('pmTech');
        techWrap.innerHTML = '';
        var techParts = (btn.getAttribute('data-tech') || '').split(',');
        for (var i = 0; i < techParts.length; i++) {
            var t = techParts[i].replace(/^\s+|\s+$/g, '');
            if (t) {
                var sp = document.createElement('span');
                sp.className = 'tech-tag';
                sp.textContent = t;
                techWrap.appendChild(sp);
            }
        }
        var gh = btn.getAttribute('data-github');
        document.getElementById('pmGithub').href = gh && gh.replace(/^\s+|\s+$/g, '') ? gh : '#';
        document.getElementById('projectModal').classList.add('open');
    }

    function openProofModal(title, fileUrl, subtitle) {
        document.getElementById('prfTitle').textContent = title;
        document.getElementById('prfSub').textContent = subtitle || '';
        var box = document.getElementById('prfViewerBox');
        var dlBtn = document.getElementById('prfDownloadBtn');

        if (fileUrl && fileUrl.replace(/^\s+|\s+$/g, '') !== '') {
            var fullUrl = fileUrl.indexOf('http') === 0 ? fileUrl : ((ctxPath ? ctxPath + '/' : '') + fileUrl);
            dlBtn.href = fullUrl;
            dlBtn.style.display = 'inline-flex';
            var lower = fileUrl.toLowerCase();
            if (
                lower.indexOf('.png') !== -1 ||
                lower.indexOf('.jpg') !== -1 ||
                lower.indexOf('.jpeg') !== -1 ||
                lower.indexOf('.webp') !== -1 ||
                lower.indexOf('.gif') !== -1
            ) {
                box.innerHTML = '<img src="' + fullUrl + '" style="max-width:100%;max-height:460px;border-radius:8px;border:1px solid #334155;" alt="Verified Proof">';
            } else if (lower.indexOf('.pdf') !== -1) {
                box.innerHTML = '<iframe src="' + fullUrl + '" style="width:100%;height:460px;border:none;border-radius:8px;"></iframe>';
            } else {
                box.innerHTML = '<i class="fa-solid fa-file-shield" style="font-size:3rem;color:#00e5ff;margin-bottom:0.8rem;"></i>' +
                    '<div style="font-weight:700;color:#fff;">Verified Credential Attached</div>' +
                    '<div style="font-size:0.82rem;color:#94a3b8;margin-top:0.3rem;">Click "Open / Download Original File" below to inspect the document.</div>';
            }
        } else {
            dlBtn.style.display = 'none';
            box.innerHTML = '<div style="padding:1.5rem;">' +
                '<div style="width:64px;height:64px;border-radius:50%;background:rgba(16,185,129,0.14);border:1px solid rgba(16,185,129,0.4);color:#10b981;display:inline-flex;align-items:center;justify-content:center;font-size:1.6rem;margin-bottom:1rem;"><i class="fa-solid fa-shield-halved"></i></div>' +
                '<h4 style="font-size:1.05rem;font-weight:800;color:#fff;margin-bottom:0.4rem;">' + title + '</h4>' +
                '<p style="font-size:0.84rem;color:#94a3b8;max-width:460px;margin:0 auto;">Verified credential record on file.</p>' +
                '</div>';
        }
        document.getElementById('proofModal').classList.add('open');
    }

    function openRecruiterModal() {
        document.getElementById('recruiterModal').classList.add('open');
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('open');
    }

    window.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            var modals = document.querySelectorAll('.modal-backdrop.open');
            for (var i = 0; i < modals.length; i++) {
                modals[i].classList.remove('open');
            }
        }
    });
</script>
<!-- Dynamic JavaScript + JSON Loader for Skills & Projects -->
<script src="<%= request.getContextPath() %>/assets/portfolio.js"></script>
</body>
</html>
