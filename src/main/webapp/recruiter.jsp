<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.portfolio.dao.PortfolioDAO, com.portfolio.model.*" %>
<%
    PortfolioDAO dao = new PortfolioDAO();
    Profile profile = dao.getProfile();
    List<Project> projects = dao.getAllProjects();
    List<Education> educations = dao.getAllEducation();
    List<Certificate> certificates = dao.getAllCertificates();
    List<Experience> experiences = dao.getAllExperience();
    List<Skill> skills = dao.getAllSkills();
    String msgStatus = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruiter Portal — <%= profile.getFullName() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/portfolio.css">
</head>
<body>

<!-- TOP NAVBAR -->
<header class="navbar">
    <div class="navbar-inner">
        <a href="<%= request.getContextPath() %>/index.jsp" class="brand">
            <div class="brand-logo"><%= profile.getLogoInitials() %></div>
            <div class="brand-text">
                <div class="brand-name">
                    <%= profile.getShortName() %> <span class="online-dot"></span>
                </div>
                <div class="brand-sub">Recruiter Evaluation Module</div>
            </div>
        </a>

        <nav class="nav-links">
            <a href="#snapshot" class="nav-link"><i class="fa-solid fa-id-card"></i> Candidate Snapshot</a>
            <a href="#role-matcher" class="nav-link"><i class="fa-solid fa-bullseye"></i> Role-Fit Matcher</a>
            <a href="#vault" class="nav-link"><i class="fa-solid fa-file-shield"></i> Verified Document Vault</a>
            <a href="#hire-form" class="nav-link"><i class="fa-regular fa-calendar-check"></i> Shortlist / Schedule</a>
        </nav>

        <div class="nav-actions">
            <a href="<%= request.getContextPath() %>/index.jsp" class="btn-resume-nav">
                <i class="fa-solid fa-arrow-left"></i> Full Portfolio View
            </a>
            <button type="button" class="btn-recruiter" onclick="window.print()">
                <i class="fa-solid fa-print"></i> Print / Save Dossier PDF
            </button>
        </div>
    </div>
</header>

<div class="container" style="padding-top:2.5rem;padding-bottom:4rem;">

    <% if ("sent".equals(msgStatus)) { %>
    <div style="background:rgba(16,185,129,0.16);border:1px solid #10b981;color:#34d399;padding:1rem 1.4rem;border-radius:12px;margin-bottom:1.8rem;text-align:center;font-weight:600;">
        <i class="fa-solid fa-circle-check"></i> Interview Request / Recruiter Inquiry Recorded! <%= profile.getFullName() %> will respond promptly.
    </div>
    <% } %>

    <!-- 1. EXECUTIVE CANDIDATE SNAPSHOT -->
    <div id="snapshot" class="edu-card" style="margin-bottom:2rem;border-color:rgba(139,92,246,0.45);background:linear-gradient(135deg, rgba(14,21,38,0.96), rgba(19,28,51,0.92));">
        <div style="display:flex;flex-wrap:wrap;gap:2rem;align-items:center;justify-content:space-between;">
            <div style="display:flex;flex-wrap:wrap;gap:1.5rem;align-items:center;">
                <img src="<%= (profile.getProfilePicUrl() != null && !profile.getProfilePicUrl().isEmpty()) ? (request.getContextPath() + "/" + profile.getProfilePicUrl()) : (request.getContextPath() + "/assets/profile-photo.png") %>"
                     alt="<%= profile.getFullName() %>"
                     style="width:105px;height:120px;object-fit:cover;border-radius:16px;border:2px solid #00e5ff;">
                <div>
                    <div style="display:inline-flex;align-items:center;gap:0.5rem;background:rgba(16,185,129,0.15);border:1px solid rgba(16,185,129,0.4);color:#34d399;padding:0.2rem 0.7rem;border-radius:999px;font-size:0.72rem;font-weight:700;margin-bottom:0.45rem;">
                        <span class="online-dot"></span> Verified Candidate • Immediate Joiner
                    </div>
                    <h1 style="font-size:2rem;font-weight:900;color:#fff;line-height:1.15;"><%= profile.getFullName() %></h1>
                    <div style="font-size:1.05rem;font-weight:700;color:#00e5ff;margin-top:0.2rem;"><%= profile.getRoleTitle() %></div>
                    <div style="font-size:0.84rem;color:#94a3b8;margin-top:0.4rem;">
                        <i class="fa-solid fa-location-dot" style="color:#f43f5e;"></i> <%= profile.getLocation() %> &nbsp;|&nbsp;
                        <i class="fa-regular fa-envelope" style="color:#38bdf8;"></i> <%= profile.getEmail() %> &nbsp;|&nbsp;
                        <i class="fa-solid fa-phone" style="color:#10b981;"></i> <%= profile.getPhone() %>
                    </div>
                </div>
            </div>

            <div style="display:flex;flex-direction:column;gap:0.65rem;min-width:240px;">
                <a href="#hire-form" class="btn-explore" style="justify-content:center;">
                    <i class="fa-regular fa-calendar-check"></i> Shortlist / Schedule Interview
                </a>
                <% if (profile.getResumeUrl() != null && !profile.getResumeUrl().isEmpty()) { %>
                <a href="<%= request.getContextPath() + "/" + profile.getResumeUrl() %>?download=true" class="btn-dark-cta" style="justify-content:center;">
                    <i class="fa-solid fa-download" style="color:#00e5ff;"></i> Download Official Resume PDF
                </a>
                <% } else { %>
                <button type="button" onclick="window.print()" class="btn-dark-cta" style="justify-content:center;">
                    <i class="fa-solid fa-file-pdf" style="color:#00e5ff;"></i> Export Candidate Profile PDF
                </button>
                <% } %>
            </div>
        </div>

        <!-- 4 Executive Metrics -->
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:1rem;margin-top:1.75rem;padding-top:1.5rem;border-top:1px solid rgba(255,255,255,0.08);">
            <div style="background:#080d19;border:1px solid rgba(245,158,11,0.4);padding:1rem;border-radius:12px;">
                <div style="font-size:0.7rem;color:#fbbf24;font-weight:800;">IIT KHARAGPUR NPTEL</div>
                <div style="font-size:1.2rem;font-weight:900;color:#fff;margin-top:0.2rem;">91% Elite + Gold</div>
                <div style="font-size:0.75rem;color:#94a3b8;">Top 1% National Percentile in Java</div>
            </div>
            <div style="background:#080d19;border:1px solid #1e293b;padding:1rem;border-radius:12px;">
                <div style="font-size:0.7rem;color:#10b981;font-weight:800;">MASTER'S DEGREE (SPPU)</div>
                <div style="font-size:1.2rem;font-weight:900;color:#fff;margin-top:0.2rem;">MCA — 7.84 CGPA</div>
                <div style="font-size:0.75rem;color:#94a3b8;">First Class with Distinction (DYPIMCA)</div>
            </div>
            <div style="background:#080d19;border:1px solid #1e293b;padding:1rem;border-radius:12px;">
                <div style="font-size:0.7rem;color:#38bdf8;font-weight:800;">INDUSTRY INTERNSHIPS</div>
                <div style="font-size:1.2rem;font-weight:900;color:#fff;margin-top:0.2rem;"><%= experiences.size() %> Verified Roles</div>
                <div style="font-size:0.75rem;color:#94a3b8;">AutoFlow Tech (MERN) &amp; Infotact (Java)</div>
            </div>
            <div style="background:#080d19;border:1px solid #1e293b;padding:1rem;border-radius:12px;">
                <div style="font-size:0.7rem;color:#c084fc;font-weight:800;">PRODUCTION ENGINEERING</div>
                <div style="font-size:1.2rem;font-weight:900;color:#fff;margin-top:0.2rem;"><%= projects.size() %> Flagship Builds</div>
                <div style="font-size:0.75rem;color:#94a3b8;">Spring Boot Microservices &amp; MERN</div>
            </div>
        </div>
    </div>

    <!-- 2. INTERACTIVE ROLE-FIT MATCHER FOR RECRUITERS -->
    <div id="role-matcher" class="edu-card" style="margin-bottom:2rem;">
        <div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:1rem;margin-bottom:1.25rem;">
            <div>
                <span class="section-badge" style="margin-bottom:0.3rem;"><i class="fa-solid fa-bullseye"></i> Interactive Role-Fit Filter</span>
                <h2 style="font-size:1.45rem;font-weight:800;color:#fff;">Select the Role You Are Hiring For</h2>
            </div>
            <div class="filter-group" id="recruiterRoleTabs">
                <button type="button" class="filter-btn active" onclick="HighlightRoleFit('ALL', this)">All Roles (Polyglot)</button>
                <button type="button" class="filter-btn" onclick="HighlightRoleFit('JAVA', this)">☕ Java / Spring Boot Backend</button>
                <button type="button" class="filter-btn" onclick="HighlightRoleFit('MERN', this)">⚛️ MERN / React Full-Stack</button>
                <button type="button" class="filter-btn" onclick="HighlightRoleFit('MICRO', this)">☁️ Microservices &amp; AI</button>
            </div>
        </div>

        <div id="roleSummaryBanner" style="background:#080d19;border-left:4px solid #00e5ff;padding:1rem 1.25rem;border-radius:10px;margin-bottom:1.4rem;font-size:0.88rem;color:#e2e8f0;">
            <strong>Polyglot Full-Stack Fit:</strong> Strong command over both Java Enterprise (Java 17/21, Spring Boot 3, Microservices, Kafka, Hibernate/JPA) and MERN Stack (React.js, Node.js, Express, MongoDB), backed by IIT Kharagpur 91% Gold Medal and 2 completed industry internships.
        </div>

        <div class="projects-grid">
            <% for (Project pr : projects) { %>
            <div class="project-card role-project-item"
                 data-role-tags="<%= (pr.getCategory() + " " + pr.getTechStack() + " " + pr.getTitle()).toUpperCase() %>">
                <div>
                    <div class="project-top-badges">
                        <span class="badge-method solo"><%= pr.getCategory() %></span>
                        <span class="badge-featured">VERIFIED BUILD</span>
                    </div>
                    <h3 class="project-title" style="margin-bottom:0.5rem;"><%= pr.getTitle() %></h3>
                    <p class="project-desc"><%= pr.getDescription() %></p>
                    <div class="tech-tags">
                        <% for (String t : pr.getTechArray()) { %>
                        <span class="tech-tag"><%= t %></span>
                        <% } %>
                    </div>
                </div>
                <div class="project-footer">
                    <span style="font-size:0.75rem;color:#10b981;font-weight:700;"><i class="fa-solid fa-check-circle"></i> Architecture Ready</span>
                    <a href="<%= pr.getGithubUrl() %>" target="_blank" class="repo-icon-btn"><i class="fa-brands fa-github"></i></a>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- 3. CENTRALIZED VERIFIED DOCUMENT VAULT -->
    <div id="vault" class="edu-card" style="margin-bottom:2rem;">
        <div style="margin-bottom:1.25rem;">
            <span class="section-badge emerald" style="margin-bottom:0.3rem;"><i class="fa-solid fa-shield-check"></i> 100% Authentic Verification Vault</span>
            <h2 style="font-size:1.45rem;font-weight:800;color:#fff;">All Academic Marksheets, Internship Letters &amp; Certifications</h2>
            <p style="font-size:0.85rem;color:#94a3b8;">One-click document inspection for HR background verification.</p>
        </div>

        <div style="overflow-x:auto;">
            <table style="width:100%;border-collapse:collapse;font-size:0.84rem;">
                <thead>
                    <tr style="border-bottom:1px solid #1e293b;text-align:left;color:#94a3b8;">
                        <th style="padding:0.75rem;">Category</th>
                        <th style="padding:0.75rem;">Credential / Role / Degree</th>
                        <th style="padding:0.75rem;">Issuing Authority / Company</th>
                        <th style="padding:0.75rem;">Score / Timeline</th>
                        <th style="padding:0.75rem;">Verified Proofs</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Experience ex : experiences) { %>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.05);">
                        <td style="padding:0.85rem;"><span class="badge-intern">Experience</span></td>
                        <td style="padding:0.85rem;font-weight:700;color:#fff;"><%= ex.getRoleTitle() %></td>
                        <td style="padding:0.85rem;color:#cbd5e1;"><%= ex.getCompany() %></td>
                        <td style="padding:0.85rem;color:#22d3ee;"><%= ex.getDuration() %></td>
                        <td style="padding:0.85rem;">
                            <div class="proof-pills">
                                <% if (ex.getProof1Title() != null && !ex.getProof1Title().isEmpty()) { %>
                                <a href="<%= (ex.getProof1Url() != null && !ex.getProof1Url().isEmpty()) ? (request.getContextPath() + "/" + ex.getProof1Url()) : (request.getContextPath() + "/index.jsp#experience") %>"
                                   target="_blank" class="proof-pill-btn">
                                    <i class="fa-regular fa-file-lines doc-ic"></i> <%= ex.getProof1Title() %>
                                </a>
                                <% } %>
                                <% if (ex.getProof2Title() != null && !ex.getProof2Title().isEmpty()) { %>
                                <a href="<%= (ex.getProof2Url() != null && !ex.getProof2Url().isEmpty()) ? (request.getContextPath() + "/" + ex.getProof2Url()) : (request.getContextPath() + "/index.jsp#experience") %>"
                                   target="_blank" class="proof-pill-btn">
                                    <i class="fa-regular fa-file-lines doc-ic"></i> <%= ex.getProof2Title() %>
                                </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>

                    <% for (Education ed : educations) { %>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.05);">
                        <td style="padding:0.85rem;"><span class="edu-duration-pill">Education</span></td>
                        <td style="padding:0.85rem;font-weight:700;color:#fff;"><%= ed.getDegree() %></td>
                        <td style="padding:0.85rem;color:#cbd5e1;"><%= ed.getInstitution() %></td>
                        <td style="padding:0.85rem;color:#34d399;"><%= ed.getStatusText() %> (<%= ed.getDuration() %>)</td>
                        <td style="padding:0.85rem;">
                            <div class="proof-pills">
                                <% if (ed.getProof1Title() != null && !ed.getProof1Title().isEmpty()) { %>
                                <a href="<%= (ed.getProof1Url() != null && !ed.getProof1Url().isEmpty()) ? (request.getContextPath() + "/" + ed.getProof1Url()) : (request.getContextPath() + "/index.jsp#education") %>"
                                   target="_blank" class="proof-pill-btn">
                                    <i class="fa-regular fa-file-lines doc-ic"></i> <%= ed.getProof1Title() %>
                                </a>
                                <% } %>
                                <% if (ed.getProof2Title() != null && !ed.getProof2Title().isEmpty()) { %>
                                <a href="<%= (ed.getProof2Url() != null && !ed.getProof2Url().isEmpty()) ? (request.getContextPath() + "/" + ed.getProof2Url()) : (request.getContextPath() + "/index.jsp#education") %>"
                                   target="_blank" class="proof-pill-btn">
                                    <i class="fa-regular fa-file-lines doc-ic"></i> <%= ed.getProof2Title() %>
                                </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>

                    <% for (Certificate c : certificates) { %>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.05);">
                        <td style="padding:0.85rem;"><span class="cert-score-pill" style="margin:0;">Certificate</span></td>
                        <td style="padding:0.85rem;font-weight:700;color:#fff;"><%= c.getTitle() %></td>
                        <td style="padding:0.85rem;color:#00e5ff;"><%= c.getIssuer() %></td>
                        <td style="padding:0.85rem;color:#fbbf24;"><%= c.getScoreBadge() %></td>
                        <td style="padding:0.85rem;">
                            <a href="<%= (c.getProofUrl() != null && !c.getProofUrl().isEmpty()) ? (request.getContextPath() + "/" + c.getProofUrl()) : (request.getContextPath() + "/index.jsp#certificates") %>"
                               target="_blank" class="proof-pill-btn">
                                <i class="fa-solid fa-award doc-ic"></i> Inspect (<%= c.getCredentialId() %>)
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 4. DIRECT SHORTLIST / INTERVIEW INVITATION FORM -->
    <div id="hire-form" class="edu-card">
        <span class="section-badge emerald" style="margin-bottom:0.4rem;"><i class="fa-regular fa-paper-plane"></i> Direct Hiring Action</span>
        <h2 style="font-size:1.45rem;font-weight:800;color:#fff;margin-bottom:0.35rem;">Shortlist <%= profile.getFullName() %> / Schedule Technical Round</h2>
        <p style="font-size:0.85rem;color:#94a3b8;margin-bottom:1.4rem;">
            Submissions go straight to the candidate's Admin Dashboard with high priority.
        </p>

        <form action="<%= request.getContextPath() %>/contact" method="post">
            <input type="hidden" name="source" value="recruiter">
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Recruiter / Hiring Manager Name *</label>
                    <input type="text" name="recruiterName" class="form-control" required placeholder="Enter your name">
                </div>
                <div class="form-group">
                    <label class="form-label">Company Name *</label>
                    <input type="text" name="companyName" class="form-control" required placeholder="Enter company name">
                </div>
            </div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Official Email *</label>
                    <input type="email" name="recruiterEmail" class="form-control" required placeholder="name@company.com">
                </div>
                <div class="form-group">
                    <label class="form-label">Contact Number</label>
                    <input type="text" name="recruiterPhone" class="form-control" placeholder="+91 ...">
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Role &amp; CTC / Location Details *</label>
                <input type="text" name="roleOffered" class="form-control" required placeholder="e.g. Software Engineer (Java / MERN) — Pune / Hybrid">
            </div>
            <div class="form-group">
                <label class="form-label">Interview Slot / Next Steps *</label>
                <textarea name="message" rows="3" class="form-control" required placeholder="Share interview date/time or assessment link..."></textarea>
            </div>
            <button type="submit" class="btn-explore">
                <i class="fa-solid fa-check-double"></i> Send Interview Invitation
            </button>
        </form>
    </div>

</div>

<script>
    function HighlightRoleFit(mode, btn) {
        var btns = document.querySelectorAll('#recruiterRoleTabs .filter-btn');
        for (var i = 0; i < btns.length; i++) btns[i].classList.remove('active');
        btn.classList.add('active');
        var banner = document.getElementById('roleSummaryBanner');
        if (mode === 'JAVA') {
            banner.innerHTML = '<strong>☕ Java Enterprise Backend Fit:</strong> IIT Kharagpur 91% Gold Medalist in Java + Java Developer Intern at Infotact Solutions + Enterprise WMS, Shipment Tracking & Pharmacy Inventory systems built with Java 17, Spring Boot 3, Hibernate/JPA, PostgreSQL & MySQL.';
        } else if (mode === 'MERN') {
            banner.innerHTML = '<strong>⚛️ MERN Stack Full-Stack Fit:</strong> MERN Stack Developer Intern at AutoFlow Technologies Pvt. Ltd. + Lead developer of ThirthaOne VIP Temple Pass Portal using React.js, Node.js, Express.js, MongoDB, JWT & Tailwind CSS.';
        } else if (mode === 'MICRO') {
            banner.innerHTML = '<strong>☁️ Microservices & AI Engineering Fit:</strong> Engineered AI-Powered Fitness Microservices Platform with Spring Cloud Eureka, API Gateway, Apache Kafka event streaming, Keycloak OAuth2, and AI/Prompt-Engineered automation pipelines.';
        } else {
            banner.innerHTML = '<strong>Polyglot Full-Stack Fit:</strong> Strong command over both Java Enterprise (Java 17/21, Spring Boot 3, Microservices, Kafka, Hibernate/JPA) and MERN Stack (React.js, Node.js, Express, MongoDB), backed by IIT Kharagpur 91% Gold Medal and 2 completed industry internships.';
        }

        var cards = document.querySelectorAll('.role-project-item');
        for (var j = 0; j < cards.length; j++) {
            var card = cards[j];
            var tags = card.getAttribute('data-role-tags') || '';
            if (mode === 'ALL') {
                card.style.display = 'flex';
            } else if (mode === 'JAVA') {
                card.style.display = (tags.indexOf('JAVA') !== -1 || tags.indexOf('SPRING') !== -1) ? 'flex' : 'none';
            } else if (mode === 'MERN') {
                card.style.display = (tags.indexOf('MERN') !== -1 || tags.indexOf('REACT') !== -1 || tags.indexOf('NODE') !== -1) ? 'flex' : 'none';
            } else if (mode === 'MICRO') {
                card.style.display = (tags.indexOf('MICRO') !== -1 || tags.indexOf('AI') !== -1 || tags.indexOf('KAFKA') !== -1) ? 'flex' : 'none';
            }
        }
    }
</script>
</body>
</html>
