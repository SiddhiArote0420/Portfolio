<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.portfolio.dao.PortfolioDAO, com.portfolio.model.*" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

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

    List<RecruiterMessage> messages = (List<RecruiterMessage>) request.getAttribute("messages");
    if (messages == null) messages = dao.getAllMessages();

    String activeTab = request.getParameter("tab");
    if (activeTab == null || activeTab.trim().isEmpty()) activeTab = "overview";
    String status = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin CMS — Manage Portfolio Data</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/portfolio.css">
    <style>
        .admin-layout {
            display: grid;
            grid-template-columns: 260px 1fr;
            min-height: calc(100vh - 68px);
        }
        .admin-sidebar {
            background: #080d19;
            border-right: 1px solid #1e293b;
            padding: 1.4rem 1rem;
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }
        .admin-tab-btn {
            display: flex;
            align-items: center;
            gap: 0.7rem;
            padding: 0.72rem 0.95rem;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            color: #94a3b8;
            background: transparent;
            border: 1px solid transparent;
            cursor: pointer;
            text-align: left;
            transition: all 0.2s;
        }
        .admin-tab-btn:hover {
            color: #fff;
            background: #111a2e;
        }
        .admin-tab-btn.active {
            background: rgba(0, 229, 255, 0.12);
            color: #00e5ff;
            border-color: rgba(0, 229, 255, 0.35);
        }
        .admin-main {
            padding: 2rem 2.4rem;
            max-width: 1120px;
        }
        .tab-panel {
            display: none;
        }
        .tab-panel.active {
            display: block;
        }
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.83rem;
        }
        .admin-table th, .admin-table td {
            padding: 0.78rem 0.9rem;
            border-bottom: 1px solid #1e293b;
            text-align: left;
        }
        .admin-table th {
            color: #94a3b8;
            font-weight: 700;
            background: #080d19;
        }
        .btn-sm-edit {
            background: rgba(59, 130, 246, 0.16);
            border: 1px solid rgba(59, 130, 246, 0.4);
            color: #60a5fa;
            padding: 0.3rem 0.65rem;
            border-radius: 6px;
            font-size: 0.74rem;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-sm-del {
            background: rgba(244, 63, 94, 0.15);
            border: 1px solid rgba(244, 63, 94, 0.4);
            color: #fda4af;
            padding: 0.3rem 0.65rem;
            border-radius: 6px;
            font-size: 0.74rem;
            font-weight: 600;
            cursor: pointer;
        }
        @media (max-width: 920px) {
            .admin-layout { grid-template-columns: 1fr; }
            .admin-sidebar { flex-direction: row; flex-wrap: wrap; border-right: none; border-bottom: 1px solid #1e293b; }
        }
    </style>
</head>
<body>

<!-- TOP BAR -->
<header class="navbar">
    <div class="navbar-inner">
        <div class="brand">
            <div class="brand-logo"><%= profile.getLogoInitials() %></div>
            <div class="brand-text">
                <div class="brand-name">Portfolio Admin CMS <span class="online-dot"></span></div>
                <div class="brand-sub">Logged in as <%= session.getAttribute("adminUser") %></div>
            </div>
        </div>

        <div class="nav-actions">
            <a href="<%= request.getContextPath() %>/index.jsp" target="_blank" class="btn-resume-nav">
                <i class="fa-solid fa-up-right-from-square"></i> View Live Portfolio
            </a>
            <a href="<%= request.getContextPath() %>/recruiter.jsp" target="_blank" class="btn-recruiter">
                <i class="fa-solid fa-wand-magic-sparkles"></i> View Recruiter Module
            </a>
            <a href="<%= request.getContextPath() %>/admin?action=logout" class="btn-admin-nav" style="color:#fda4af;border-color:rgba(244,63,94,0.35);">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </div>
    </div>
</header>

<div class="admin-layout">
    <!-- SIDEBAR NAVIGATION -->
    <aside class="admin-sidebar">
        <button type="button" class="admin-tab-btn <%= "overview".equals(activeTab) ? "active" : "" %>" onclick="switchTab('overview', this)">
            <i class="fa-solid fa-gauge-high"></i> Overview &amp; Stats
        </button>
        <button type="button" class="admin-tab-btn <%= "profile".equals(activeTab) ? "active" : "" %>" onclick="switchTab('profile', this)">
            <i class="fa-solid fa-user-astronaut"></i> Profile, Pic &amp; Resume
        </button>
        <button type="button" class="admin-tab-btn <%= "projects".equals(activeTab) ? "active" : "" %>" onclick="switchTab('projects', this)">
            <i class="fa-solid fa-code-branch"></i> Projects (<%= projects.size() %>)
        </button>
        <button type="button" class="admin-tab-btn <%= "education".equals(activeTab) ? "active" : "" %>" onclick="switchTab('education', this)">
            <i class="fa-solid fa-graduation-cap"></i> Education &amp; Proofs (<%= educations.size() %>)
        </button>
        <button type="button" class="admin-tab-btn <%= "certificates".equals(activeTab) ? "active" : "" %>" onclick="switchTab('certificates', this)">
            <i class="fa-solid fa-award"></i> Certificates (<%= certificates.size() %>)
        </button>
        <button type="button" class="admin-tab-btn <%= "experience".equals(activeTab) ? "active" : "" %>" onclick="switchTab('experience', this)">
            <i class="fa-solid fa-briefcase"></i> Experience (<%= experiences.size() %>)
        </button>
        <button type="button" class="admin-tab-btn <%= "skills".equals(activeTab) ? "active" : "" %>" onclick="switchTab('skills', this)">
            <i class="fa-solid fa-microchip"></i> Skills (<%= skills.size() %>)
        </button>
        <button type="button" class="admin-tab-btn <%= "messages".equals(activeTab) ? "active" : "" %>" onclick="switchTab('messages', this)">
            <i class="fa-regular fa-envelope"></i> Recruiter Inbox (<%= messages.size() %>)
        </button>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="admin-main">

        <% if (status != null) { %>
        <div style="background:rgba(16,185,129,0.16);border:1px solid #10b981;color:#34d399;padding:0.85rem 1.2rem;border-radius:12px;margin-bottom:1.5rem;font-size:0.86rem;font-weight:600;">
            <i class="fa-solid fa-circle-check"></i> Changes saved and published to live portfolio! (<%= status %>)
        </div>
        <% } %>

        <!-- ================= TAB 1: OVERVIEW ================= -->
        <div id="tab-overview" class="tab-panel <%= "overview".equals(activeTab) ? "active" : "" %>">
            <h2 style="font-size:1.65rem;font-weight:800;margin-bottom:0.35rem;">Welcome back, <%= profile.getShortName() %>!</h2>
            <p style="color:#94a3b8;font-size:0.9rem;margin-bottom:1.6rem;">
                Manage every section of your portfolio and Recruiter Quick-View from one place.
            </p>

            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1rem;margin-bottom:2rem;">
                <div class="edu-card" style="padding:1.2rem;">
                    <div style="font-size:0.74rem;color:#00e5ff;font-weight:700;">FLAGSHIP PROJECTS</div>
                    <div style="font-size:1.9rem;font-weight:900;color:#fff;"><%= projects.size() %></div>
                </div>
                <div class="edu-card" style="padding:1.2rem;">
                    <div style="font-size:0.74rem;color:#10b981;font-weight:700;">ACADEMIC DEGREES</div>
                    <div style="font-size:1.9rem;font-weight:900;color:#fff;"><%= educations.size() %></div>
                </div>
                <div class="edu-card" style="padding:1.2rem;">
                    <div style="font-size:0.74rem;color:#fbbf24;font-weight:700;">CERTIFICATIONS</div>
                    <div style="font-size:1.9rem;font-weight:900;color:#fff;"><%= certificates.size() %></div>
                </div>
                <div class="edu-card" style="padding:1.2rem;">
                    <div style="font-size:0.74rem;color:#a855f7;font-weight:700;">EXPERIENCE ROLES</div>
                    <div style="font-size:1.9rem;font-weight:900;color:#fff;"><%= experiences.size() %></div>
                </div>
                <div class="edu-card" style="padding:1.2rem;">
                    <div style="font-size:0.74rem;color:#38bdf8;font-weight:700;">RECRUITER MESSAGES</div>
                    <div style="font-size:1.9rem;font-weight:900;color:#fff;"><%= messages.size() %></div>
                </div>
            </div>

            <div class="edu-card">
                <h3 style="font-size:1.15rem;font-weight:800;margin-bottom:0.9rem;">Quick Actions</h3>
                <div style="display:flex;flex-wrap:wrap;gap:0.75rem;">
                    <button type="button" class="btn-explore" onclick="switchTabByName('profile')">
                        <i class="fa-solid fa-camera"></i> Update Profile Pic &amp; Resume
                    </button>
                    <button type="button" class="btn-dark-cta" onclick="switchTabByName('projects')">
                        <i class="fa-solid fa-plus"></i> Add / Edit Projects
                    </button>
                    <button type="button" class="btn-dark-cta" onclick="switchTabByName('education')">
                        <i class="fa-solid fa-file-Upload"></i> Upload Marksheet Proofs
                    </button>
                    <button type="button" class="btn-dark-cta" onclick="switchTabByName('certificates')">
                        <i class="fa-solid fa-medal"></i> Manage Certificates
                    </button>
                    <button type="button" class="btn-dark-cta" onclick="switchTabByName('experience')">
                        <i class="fa-solid fa-briefcase"></i> Manage Internships &amp; Letters
                    </button>
                </div>
            </div>
        </div>

        <!-- ================= TAB 2: PROFILE, PHOTO & RESUME ================= -->
        <div id="tab-profile" class="tab-panel <%= "profile".equals(activeTab) ? "active" : "" %>">
            <h2 style="font-size:1.5rem;font-weight:800;margin-bottom:1.2rem;">Update Profile, Hero Badges, Photo &amp; Resume</h2>

            <form action="<%= request.getContextPath() %>/admin" method="post" enctype="multipart/form-data" class="edu-card" style="margin-bottom:2rem;">
                <input type="hidden" name="action" value="updateProfile">

                <h3 style="font-size:1rem;font-weight:800;color:#00e5ff;margin-bottom:1rem;">1. Upload Profile Picture, Resume PDF &amp; Gold Medal Proof</h3>
                <div class="form-grid" style="grid-template-columns:repeat(3,1fr);margin-bottom:1.2rem;">
                    <div class="form-group">
                        <label class="form-label">Upload New Profile Photo (PNG/JPG)</label>
                        <input type="file" name="profilePicFile" accept="image/*" class="form-control">
                        <small style="color:#64748b;font-size:0.72rem;">Current: <%= profile.getProfilePicUrl() %></small>
                        <input type="hidden" name="profilePicUrl" value="<%= profile.getProfilePicUrl() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Upload Official Resume (PDF)</label>
                        <input type="file" name="resumeFile" accept=".pdf,image/*" class="form-control">
                        <small style="color:#64748b;font-size:0.72rem;">Current: <%= (profile.getResumeUrl() != null && !profile.getResumeUrl().isEmpty()) ? profile.getResumeUrl() : "None uploaded yet" %></small>
                        <input type="hidden" name="resumeUrl" value="<%= profile.getResumeUrl() != null ? profile.getResumeUrl() : "" %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Upload Gold Medalist Proof (PDF/Img)</label>
                        <input type="file" name="goldProofFile" accept=".pdf,image/*" class="form-control">
                        <small style="color:#64748b;font-size:0.72rem;">Current: <%= (profile.getGoldProofUrl() != null && !profile.getGoldProofUrl().isEmpty()) ? profile.getGoldProofUrl() : "None uploaded yet" %></small>
                        <input type="hidden" name="goldProofUrl" value="<%= profile.getGoldProofUrl() != null ? profile.getGoldProofUrl() : "" %>">
                    </div>
                </div>

                <h3 style="font-size:1rem;font-weight:800;color:#00e5ff;margin-bottom:1rem;">2. Personal Identity &amp; Hero Text</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Full Name (Hero Heading)</label>
                        <input type="text" name="fullName" class="form-control" value="<%= profile.getFullName() %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Rotating Roles (Comma-separated — changes every 3 sec)</label>
                        <input type="text" name="roleTitle" class="form-control" value="<%= profile.getRoleTitle() %>" placeholder="Java Full Stack Developer, Junior Java Developer, Software Development Engineer" required>
                    </div>
                </div>

                <div class="form-grid" style="grid-template-columns:100px 1fr 1fr 1fr;">
                    <div class="form-group">
                        <label class="form-label">Logo Initials</label>
                        <input type="text" name="logoInitials" class="form-control" value="<%= profile.getLogoInitials() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Navbar Short Name</label>
                        <input type="text" name="shortName" class="form-control" value="<%= profile.getShortName() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Navbar Subtitle</label>
                        <input type="text" name="navSubtitle" class="form-control" value="<%= profile.getNavSubtitle() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Greeting Text</label>
                        <input type="text" name="greetingText" class="form-control" value="<%= profile.getGreetingText() %>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Hero Bio Paragraph</label>
                    <textarea name="bio" rows="3" class="form-control"><%= profile.getBio() %></textarea>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Availability Status Pill</label>
                        <input type="text" name="statusText" class="form-control" value="<%= profile.getStatusText() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Location</label>
                        <input type="text" name="location" class="form-control" value="<%= profile.getLocation() %>">
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Hero Highlight 1 (Gold Medal Text)</label>
                        <input type="text" name="highlightBadge1" class="form-control" value="<%= profile.getHighlightBadge1() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Hero Highlight 2 (Degree Text)</label>
                        <input type="text" name="highlightBadge2" class="form-control" value="<%= profile.getHighlightBadge2() %>">
                    </div>
                </div>

                <div class="form-grid" style="grid-template-columns:repeat(4,1fr);">
                    <div class="form-group">
                        <label class="form-label">Photo Top Badge Title</label>
                        <input type="text" name="topCardBadgeTitle" class="form-control" value="<%= profile.getTopCardBadgeTitle() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Photo Top Badge Sub</label>
                        <input type="text" name="topCardBadgeSub" class="form-control" value="<%= profile.getTopCardBadgeSub() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Photo Bottom Badge Title</label>
                        <input type="text" name="bottomCardBadgeTitle" class="form-control" value="<%= profile.getBottomCardBadgeTitle() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Photo Bottom Badge Sub</label>
                        <input type="text" name="bottomCardBadgeSub" class="form-control" value="<%= profile.getBottomCardBadgeSub() %>">
                    </div>
                </div>

                <h3 style="font-size:1rem;font-weight:800;color:#00e5ff;margin:0.8rem 0 1rem;">3. Contact &amp; Social Links</h3>
                <div class="form-grid" style="grid-template-columns:repeat(3,1fr);">
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control" value="<%= profile.getEmail() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" class="form-control" value="<%= profile.getPhone() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">GitHub Profile URL</label>
                        <input type="text" name="githubUrl" class="form-control" value="<%= profile.getGithubUrl() %>">
                    </div>
                </div>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">LinkedIn Profile URL</label>
                        <input type="text" name="linkedinUrl" class="form-control" value="<%= profile.getLinkedinUrl() %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">LeetCode Profile URL</label>
                        <input type="text" name="leetcodeUrl" class="form-control" value="<%= profile.getLeetcodeUrl() %>">
                    </div>
                </div>

                <button type="submit" class="btn-explore">
                    <i class="fa-solid fa-floppy-disk"></i> Save All Profile, Photo &amp; Resume Settings
                </button>
            </form>
        </div>

        <!-- ================= TAB 3: PROJECTS ================= -->
        <div id="tab-projects" class="tab-panel <%= "projects".equals(activeTab) ? "active" : "" %>">
            <h2 style="font-size:1.5rem;font-weight:800;margin-bottom:1.2rem;">Manage Projects Showcase</h2>

            <form action="<%= request.getContextPath() %>/admin" method="post" enctype="multipart/form-data" class="edu-card" style="margin-bottom:2rem;" id="projectForm">
                <input type="hidden" name="action" value="saveProject">
                <input type="hidden" name="id" id="proj_id" value="0">

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
                    <h3 id="proj_form_heading" style="font-size:1.05rem;font-weight:800;color:#00e5ff;">+ Add New Flagship Project</h3>
                    <button type="button" class="btn-sm-edit" onclick="resetProjectForm()">Reset to New</button>
                </div>

                <div class="form-grid" style="grid-template-columns:1.5fr 1fr 1fr 90px;">
                    <div class="form-group">
                        <label class="form-label">Project Title *</label>
                        <input type="text" name="title" id="proj_title" class="form-control" required placeholder="e.g. Enterprise Warehouse Management System">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Category *</label>
                        <select name="category" id="proj_category" class="form-control">
                            <option value="Java Full Stack">Java Full Stack</option>
                            <option value="MERN Stack">MERN Stack</option>
                            <option value="AI & Microservices">AI &amp; Microservices</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Build Method Badge *</label>
                        <select name="buildMethod" id="proj_method" class="form-control">
                            <option value="Solo Handcrafted">Solo Handcrafted</option>
                            <option value="AI & Prompt Engineered">AI &amp; Prompt Engineered</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Order</label>
                        <input type="number" name="displayOrder" id="proj_order" class="form-control" value="1">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Short Card Summary *</label>
                    <textarea name="description" id="proj_desc" rows="2" class="form-control" required></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Deep-Dive System Architecture Details</label>
                    <textarea name="architectureDetails" id="proj_arch" rows="2" class="form-control"></textarea>
                </div>

                <div class="form-grid" style="grid-template-columns:1.5fr 1fr 1fr;">
                    <div class="form-group">
                        <label class="form-label">Tech Stack (Comma-separated tags) *</label>
                        <input type="text" name="techStack" id="proj_tech" class="form-control" placeholder="Java 17, Spring Boot 3, PostgreSQL, Hibernate / JPA" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">GitHub Repository URL</label>
                        <input type="text" name="githubUrl" id="proj_github" class="form-control" placeholder="https://github.com/...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Upload Architecture / Screenshot (Optional)</label>
                        <input type="file" name="proofFile" class="form-control">
                        <input type="hidden" name="proofUrl" id="proj_proof">
                    </div>
                </div>

                <div style="display:flex;align-items:center;gap:1.2rem;margin-top:0.5rem;">
                    <label style="display:inline-flex;align-items:center;gap:0.45rem;font-size:0.84rem;cursor:pointer;">
                        <input type="checkbox" name="featured" id="proj_featured" checked> Show FEATURED Badge
                    </label>
                    <button type="submit" class="btn-explore">
                        <i class="fa-solid fa-floppy-disk"></i> Save Project
                    </button>
                </div>
            </form>

            <div class="edu-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Order</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Method</th>
                            <th>Tech Stack</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Project pr : projects) { %>
                        <tr>
                            <td><%= pr.getDisplayOrder() %></td>
                            <td style="font-weight:700;color:#fff;"><%= pr.getTitle() %></td>
                            <td><span class="edu-duration-pill"><%= pr.getCategory() %></span></td>
                            <td><%= pr.getBuildMethod() %></td>
                            <td style="color:#94a3b8;max-width:260px;"><%= pr.getTechStack() %></td>
                            <td style="white-space:nowrap;">
                                <button type="button" class="btn-sm-edit"
                                        data-id="<%= pr.getId() %>"
                                        data-title="<%= pr.getTitle().replace("\"", "&quot;") %>"
                                        data-cat="<%= pr.getCategory() %>"
                                        data-method="<%= pr.getBuildMethod() %>"
                                        data-desc="<%= pr.getDescription().replace("\"", "&quot;") %>"
                                        data-arch="<%= (pr.getArchitectureDetails() != null ? pr.getArchitectureDetails() : "").replace("\"", "&quot;") %>"
                                        data-tech="<%= pr.getTechStack().replace("\"", "&quot;") %>"
                                        data-github="<%= pr.getGithubUrl() != null ? pr.getGithubUrl() : "" %>"
                                        data-proof="<%= pr.getProofUrl() != null ? pr.getProofUrl() : "" %>"
                                        data-order="<%= pr.getDisplayOrder() %>"
                                        data-feat="<%= pr.isFeatured() %>"
                                        onclick="editProject(this)">Edit</button>
                                <a href="<%= request.getContextPath() %>/admin?action=deleteProject&id=<%= pr.getId() %>"
                                   class="btn-sm-del" onclick="return confirm('Delete this project?')">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= TAB 4: EDUCATION & PROOFS ================= -->
        <div id="tab-education" class="tab-panel <%= "education".equals(activeTab) ? "active" : "" %>">
            <h2 style="font-size:1.5rem;font-weight:800;margin-bottom:1.2rem;">Manage Education &amp; Verified Marksheet Proofs</h2>

            <form action="<%= request.getContextPath() %>/admin" method="post" enctype="multipart/form-data" class="edu-card" style="margin-bottom:2rem;">
                <input type="hidden" name="action" value="saveEducation">
                <input type="hidden" name="id" id="edu_id" value="0">

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
                    <h3 id="edu_form_heading" style="font-size:1.05rem;font-weight:800;color:#10b981;">+ Add / Update Academic Qualification</h3>
                    <button type="button" class="btn-sm-edit" onclick="resetEduForm()">Reset to New</button>
                </div>

                <div class="form-grid" style="grid-template-columns:1.5fr 1fr 90px;">
                    <div class="form-group">
                        <label class="form-label">Degree / Qualification Title *</label>
                        <input type="text" name="degree" id="edu_degree" class="form-control" required placeholder="e.g. Master of Computer Applications (MCA)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Duration Pill *</label>
                        <input type="text" name="duration" id="edu_duration" class="form-control" required placeholder="e.g. 2024 – 2026">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Order</label>
                        <input type="number" name="displayOrder" id="edu_order" class="form-control" value="1">
                    </div>
                </div>

                <div class="form-grid" style="grid-template-columns:1fr 1fr 1fr;">
                    <div class="form-group">
                        <label class="form-label">College / Institution *</label>
                        <input type="text" name="institution" id="edu_inst" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">University / Board *</label>
                        <input type="text" name="university" id="edu_univ" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Status / CGPA / Percentage *</label>
                        <input type="text" name="statusText" id="edu_status" class="form-control" required placeholder="Completed (First Class — CGPA: 7.84)">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Coursework / Specialization Description</label>
                    <textarea name="description" id="edu_desc" rows="2" class="form-control"></textarea>
                </div>

                <h4 style="font-size:0.84rem;color:#10b981;margin:0.8rem 0 0.6rem;">Attach Verified Proof Documents (Marksheets / Degree Certificates PDF or Image)</h4>
                <div class="form-grid" style="grid-template-columns:repeat(3,1fr);">
                    <div class="form-group">
                        <label class="form-label">Proof 1 Label</label>
                        <input type="text" name="proof1Title" id="edu_p1t" class="form-control" placeholder="e.g. Official Final Marksheet">
                        <input type="file" name="proof1File" class="form-control" style="margin-top:0.4rem;">
                        <input type="hidden" name="proof1Url" id="edu_p1u">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Proof 2 Label</label>
                        <input type="text" name="proof2Title" id="edu_p2t" class="form-control" placeholder="e.g. CET Score Card / Passing Cert">
                        <input type="file" name="proof2File" class="form-control" style="margin-top:0.4rem;">
                        <input type="hidden" name="proof2Url" id="edu_p2u">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Proof 3 Label (Optional)</label>
                        <input type="text" name="proof3Title" id="edu_p3t" class="form-control" placeholder="e.g. ABC ID / Migration Cert">
                        <input type="file" name="proof3File" class="form-control" style="margin-top:0.4rem;">
                        <input type="hidden" name="proof3Url" id="edu_p3u">
                    </div>
                </div>

                <button type="submit" class="btn-explore">
                    <i class="fa-solid fa-floppy-disk"></i> Save Education &amp; Proofs
                </button>
            </form>

            <div class="edu-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Degree</th>
                            <th>Institution</th>
                            <th>Duration &amp; CGPA</th>
                            <th>Attached Proofs</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Education ed : educations) { %>
                        <tr>
                            <td style="font-weight:700;color:#fff;"><%= ed.getDegree() %></td>
                            <td><%= ed.getInstitution() %></td>
                            <td><%= ed.getDuration() %><br><small style="color:#10b981;"><%= ed.getStatusText() %></small></td>
                            <td style="font-size:0.75rem;color:#cbd5e1;">
                                <%= ed.getProof1Title() %>
                                <%= (ed.getProof2Title() != null && !ed.getProof2Title().isEmpty()) ? (" | " + ed.getProof2Title()) : "" %>
                            </td>
                            <td style="white-space:nowrap;">
                                <button type="button" class="btn-sm-edit"
                                        data-id="<%= ed.getId() %>"
                                        data-degree="<%= ed.getDegree().replace("\"", "&quot;") %>"
                                        data-inst="<%= ed.getInstitution().replace("\"", "&quot;") %>"
                                        data-univ="<%= ed.getUniversity().replace("\"", "&quot;") %>"
                                        data-dur="<%= ed.getDuration().replace("\"", "&quot;") %>"
                                        data-status="<%= ed.getStatusText().replace("\"", "&quot;") %>"
                                        data-desc="<%= ed.getDescription().replace("\"", "&quot;") %>"
                                        data-p1t="<%= ed.getProof1Title() != null ? ed.getProof1Title().replace("\"", "&quot;") : "" %>"
                                        data-p1u="<%= ed.getProof1Url() != null ? ed.getProof1Url() : "" %>"
                                        data-p2t="<%= ed.getProof2Title() != null ? ed.getProof2Title().replace("\"", "&quot;") : "" %>"
                                        data-p2u="<%= ed.getProof2Url() != null ? ed.getProof2Url() : "" %>"
                                        data-p3t="<%= ed.getProof3Title() != null ? ed.getProof3Title().replace("\"", "&quot;") : "" %>"
                                        data-p3u="<%= ed.getProof3Url() != null ? ed.getProof3Url() : "" %>"
                                        data-order="<%= ed.getDisplayOrder() %>"
                                        onclick="editEducation(this)">Edit</button>
                                <a href="<%= request.getContextPath() %>/admin?action=deleteEducation&id=<%= ed.getId() %>"
                                   class="btn-sm-del" onclick="return confirm('Delete this education entry?')">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= TAB 5: CERTIFICATES ================= -->
        <div id="tab-certificates" class="tab-panel <%= "certificates".equals(activeTab) ? "active" : "" %>">
            <h2 style="font-size:1.5rem;font-weight:800;margin-bottom:1.2rem;">Manage Verified Certifications &amp; Honors</h2>

            <form action="<%= request.getContextPath() %>/admin" method="post" enctype="multipart/form-data" class="edu-card" style="margin-bottom:2rem;">
                <input type="hidden" name="action" value="saveCertificate">
                <input type="hidden" name="id" id="cert_id" value="0">

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
                    <h3 id="cert_form_heading" style="font-size:1.05rem;font-weight:800;color:#fbbf24;">+ Add / Edit Certification</h3>
                    <button type="button" class="btn-sm-edit" onclick="resetCertForm()">Reset to New</button>
                </div>

                <div class="form-grid" style="grid-template-columns:1.5fr 1fr 1fr;">
                    <div class="form-group">
                        <label class="form-label">Certificate Title *</label>
                        <input type="text" name="title" id="cert_title" class="form-control" required placeholder="e.g. Programming In Java (Elite + Gold Medal)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Issuing Organization *</label>
                        <input type="text" name="issuer" id="cert_issuer" class="form-control" required placeholder="e.g. IIT Kharagpur & NPTEL">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Category *</label>
                        <select name="category" id="cert_cat" class="form-control">
                            <option value="Java & DSA (IIT NPTEL)">Java &amp; DSA (IIT NPTEL)</option>
                            <option value="Web & Google Certs">Web &amp; Google Certs</option>
                        </select>
                    </div>
                </div>

                <div class="form-grid" style="grid-template-columns:1fr 1fr 1fr 90px;">
                    <div class="form-group">
                        <label class="form-label">Issue Date *</label>
                        <input type="text" name="issueDate" id="cert_date" class="form-control" required placeholder="e.g. Jul - Oct 2025">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Score / Recognition Badge *</label>
                        <input type="text" name="scoreBadge" id="cert_score" class="form-control" required placeholder="e.g. 91% (Elite + Gold)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Credential ID *</label>
                        <input type="text" name="credentialId" id="cert_cred" class="form-control" required placeholder="e.g. NPTEL25CS110S4669...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Order</label>
                        <input type="number" name="displayOrder" id="cert_order" class="form-control" value="1">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea name="description" id="cert_desc" rows="2" class="form-control"></textarea>
                </div>

                <div class="form-grid" style="grid-template-columns:1.2fr 1fr 1fr;">
                    <div class="form-group">
                        <label class="form-label">Skill Tags (Comma-separated)</label>
                        <input type="text" name="skillTags" id="cert_skills" class="form-control" placeholder="Java OOP, Multithreading, Generics">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Top Gold Ribbon Text (If Elite+Gold)</label>
                        <input type="text" name="topRibbonText" id="cert_ribbon" class="form-control" value="ELITE + GOLD MEDALIST">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Upload Certificate PDF / Image</label>
                        <input type="file" name="proofFile" class="form-control">
                        <input type="hidden" name="proofUrl" id="cert_proof">
                    </div>
                </div>

                <div style="display:flex;align-items:center;gap:1.2rem;margin-top:0.5rem;">
                    <label style="display:inline-flex;align-items:center;gap:0.45rem;font-size:0.84rem;color:#fbbf24;font-weight:700;cursor:pointer;">
                        <input type="checkbox" name="eliteGold" id="cert_elite"> Highlight with Golden Border &amp; Top Ribbon
                    </label>
                    <button type="submit" class="btn-explore">
                        <i class="fa-solid fa-floppy-disk"></i> Save Certificate
                    </button>
                </div>
            </form>

            <div class="edu-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Issuer</th>
                            <th>Score</th>
                            <th>Category</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Certificate c : certificates) { %>
                        <tr>
                            <td style="font-weight:700;color:#fff;">
                                <%= c.getTitle() %>
                                <% if (c.isEliteGold()) { %><span class="cert-score-pill" style="margin-left:6px;">GOLD</span><% } %>
                            </td>
                            <td style="color:#00e5ff;"><%= c.getIssuer() %></td>
                            <td><%= c.getScoreBadge() %></td>
                            <td><%= c.getCategory() %></td>
                            <td style="white-space:nowrap;">
                                <button type="button" class="btn-sm-edit"
                                        data-id="<%= c.getId() %>"
                                        data-title="<%= c.getTitle().replace("\"", "&quot;") %>"
                                        data-issuer="<%= c.getIssuer().replace("\"", "&quot;") %>"
                                        data-date="<%= c.getIssueDate().replace("\"", "&quot;") %>"
                                        data-score="<%= c.getScoreBadge().replace("\"", "&quot;") %>"
                                        data-cat="<%= c.getCategory() %>"
                                        data-elite="<%= c.isEliteGold() %>"
                                        data-ribbon="<%= c.getTopRibbonText() != null ? c.getTopRibbonText() : "" %>"
                                        data-desc="<%= c.getDescription().replace("\"", "&quot;") %>"
                                        data-skills="<%= c.getSkillTags().replace("\"", "&quot;") %>"
                                        data-cred="<%= c.getCredentialId().replace("\"", "&quot;") %>"
                                        data-proof="<%= c.getProofUrl() != null ? c.getProofUrl() : "" %>"
                                        data-order="<%= c.getDisplayOrder() %>"
                                        onclick="editCertificate(this)">Edit</button>
                                <a href="<%= request.getContextPath() %>/admin?action=deleteCertificate&id=<%= c.getId() %>"
                                   class="btn-sm-del" onclick="return confirm('Delete this certificate?')">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= TAB 6: WORK EXPERIENCE ================= -->
        <div id="tab-experience" class="tab-panel <%= "experience".equals(activeTab) ? "active" : "" %>">
            <h2 style="font-size:1.5rem;font-weight:800;margin-bottom:1.2rem;">Manage Work Experience &amp; Internship Proofs</h2>

            <form action="<%= request.getContextPath() %>/admin" method="post" enctype="multipart/form-data" class="edu-card" style="margin-bottom:2rem;">
                <input type="hidden" name="action" value="saveExperience">
                <input type="hidden" name="id" id="exp_id" value="0">

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
                    <h3 id="exp_form_heading" style="font-size:1.05rem;font-weight:800;color:#00e5ff;">+ Add / Edit Work Experience</h3>
                    <button type="button" class="btn-sm-edit" onclick="resetExpForm()">Reset to New</button>
                </div>

                <div class="form-grid" style="grid-template-columns:1.3fr 1.2fr 1fr 80px;">
                    <div class="form-group">
                        <label class="form-label">Role Title *</label>
                        <input type="text" name="roleTitle" id="exp_role" class="form-control" required placeholder="e.g. MERN Stack Developer Intern">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Company Name *</label>
                        <input type="text" name="company" id="exp_company" class="form-control" required placeholder="e.g. AutoFlow Technologies Pvt. Ltd.">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Type Badge *</label>
                        <input type="text" name="expType" id="exp_type" class="form-control" value="Internship" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Order</label>
                        <input type="number" name="displayOrder" id="exp_order" class="form-control" value="1">
                    </div>
                </div>

                <div class="form-grid" style="grid-template-columns:1fr 1fr 1fr;">
                    <div class="form-group">
                        <label class="form-label">Track Subtitle</label>
                        <input type="text" name="trackName" id="exp_track" class="form-control" placeholder="e.g. Full Stack Track">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Duration *</label>
                        <input type="text" name="duration" id="exp_dur" class="form-control" required placeholder="e.g. Feb 2026 – May 2026">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Location *</label>
                        <input type="text" name="location" id="exp_loc" class="form-control" required placeholder="e.g. Pune, Maharashtra">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Responsibilities &amp; Achievements Description *</label>
                    <textarea name="description" id="exp_desc" rows="2" class="form-control" required></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Technologies Used (Comma-separated) *</label>
                    <input type="text" name="techStack" id="exp_tech" class="form-control" required placeholder="MERN Stack, React.js, Node.js, Express.js, MongoDB">
                </div>

                <h4 style="font-size:0.84rem;color:#10b981;margin:0.8rem 0 0.6rem;">Attach Verified Internship / Experience Proofs (Completion Cert, Offer Letter, Training Cert)</h4>
                <div class="form-grid" style="grid-template-columns:repeat(3,1fr);">
                    <div class="form-group">
                        <label class="form-label">Proof 1 Title</label>
                        <input type="text" name="proof1Title" id="exp_p1t" class="form-control" placeholder="Internship Completion Certificate">
                        <input type="file" name="proof1File" class="form-control" style="margin-top:0.4rem;">
                        <input type="hidden" name="proof1Url" id="exp_p1u">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Proof 2 Title</label>
                        <input type="text" name="proof2Title" id="exp_p2t" class="form-control" placeholder="Official Offer Letter">
                        <input type="file" name="proof2File" class="form-control" style="margin-top:0.4rem;">
                        <input type="hidden" name="proof2Url" id="exp_p2u">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Proof 3 Title</label>
                        <input type="text" name="proof3Title" id="exp_p3t" class="form-control" placeholder="Training Certificate">
                        <input type="file" name="proof3File" class="form-control" style="margin-top:0.4rem;">
                        <input type="hidden" name="proof3Url" id="exp_p3u">
                    </div>
                </div>

                <button type="submit" class="btn-explore">
                    <i class="fa-solid fa-floppy-disk"></i> Save Experience &amp; Proofs
                </button>
            </form>

            <div class="edu-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Role</th>
                            <th>Company</th>
                            <th>Duration</th>
                            <th>Proofs</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Experience ex : experiences) { %>
                        <tr>
                            <td style="font-weight:700;color:#fff;"><%= ex.getRoleTitle() %></td>
                            <td><%= ex.getCompany() %></td>
                            <td><%= ex.getDuration() %></td>
                            <td style="font-size:0.75rem;color:#cbd5e1;">
                                <%= ex.getProof1Title() %>
                                <%= (ex.getProof2Title() != null && !ex.getProof2Title().isEmpty()) ? (" | " + ex.getProof2Title()) : "" %>
                            </td>
                            <td style="white-space:nowrap;">
                                <button type="button" class="btn-sm-edit"
                                        data-id="<%= ex.getId() %>"
                                        data-role="<%= ex.getRoleTitle().replace("\"", "&quot;") %>"
                                        data-company="<%= ex.getCompany().replace("\"", "&quot;") %>"
                                        data-type="<%= ex.getExpType() %>"
                                        data-track="<%= ex.getTrackName() %>"
                                        data-dur="<%= ex.getDuration() %>"
                                        data-loc="<%= ex.getLocation() %>"
                                        data-desc="<%= ex.getDescription().replace("\"", "&quot;") %>"
                                        data-tech="<%= ex.getTechStack().replace("\"", "&quot;") %>"
                                        data-p1t="<%= ex.getProof1Title() != null ? ex.getProof1Title() : "" %>"
                                        data-p1u="<%= ex.getProof1Url() != null ? ex.getProof1Url() : "" %>"
                                        data-p2t="<%= ex.getProof2Title() != null ? ex.getProof2Title() : "" %>"
                                        data-p2u="<%= ex.getProof2Url() != null ? ex.getProof2Url() : "" %>"
                                        data-p3t="<%= ex.getProof3Title() != null ? ex.getProof3Title() : "" %>"
                                        data-p3u="<%= ex.getProof3Url() != null ? ex.getProof3Url() : "" %>"
                                        data-order="<%= ex.getDisplayOrder() %>"
                                        onclick="editExperience(this)">Edit</button>
                                <a href="<%= request.getContextPath() %>/admin?action=deleteExperience&id=<%= ex.getId() %>"
                                   class="btn-sm-del" onclick="return confirm('Delete this experience entry?')">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= TAB 7: SKILLS ================= -->
        <div id="tab-skills" class="tab-panel <%= "skills".equals(activeTab) ? "active" : "" %>">
            <h2 style="font-size:1.5rem;font-weight:800;margin-bottom:1.2rem;">Manage Technical Skills Matrix</h2>

            <form action="<%= request.getContextPath() %>/admin" method="post" class="edu-card" style="margin-bottom:2rem;">
                <input type="hidden" name="action" value="saveSkill">
                <input type="hidden" name="id" id="sk_id" value="0">

                <div class="form-grid" style="grid-template-columns:1.2fr 1.2fr 110px 140px 90px auto;align-items:end;">
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Category *</label>
                        <select name="category" id="sk_cat" class="form-control">
                            <option value="Java Enterprise & Backend">Java Enterprise &amp; Backend</option>
                            <option value="MERN Stack & Modern Web">MERN Stack &amp; Modern Web</option>
                            <option value="Databases & Cloud / DevOps">Databases &amp; Cloud / DevOps</option>
                            <option value="AI & Engineering Foundations">AI &amp; Engineering Foundations</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Skill Name *</label>
                        <input type="text" name="skillName" id="sk_name" class="form-control" required placeholder="e.g. Spring Boot 3">
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Level (%) *</label>
                        <input type="number" name="proficiency" id="sk_prof" class="form-control" value="90" min="10" max="100">
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Badge Label</label>
                        <input type="text" name="badgeText" id="sk_badge" class="form-control" placeholder="e.g. Production">
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Order</label>
                        <input type="number" name="displayOrder" id="sk_order" class="form-control" value="1">
                    </div>
                    <button type="submit" class="btn-explore" style="padding:0.68rem 1.1rem;">Save</button>
                </div>
            </form>

            <div class="edu-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Skill</th>
                            <th>Proficiency</th>
                            <th>Badge</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Skill sk : skills) { %>
                        <tr>
                            <td><%= sk.getCategory() %></td>
                            <td style="font-weight:700;color:#fff;"><%= sk.getSkillName() %></td>
                            <td><%= sk.getProficiency() %>%</td>
                            <td><span class="skill-badge"><%= sk.getBadgeText() %></span></td>
                            <td>
                                <button type="button" class="btn-sm-edit"
                                        onclick="document.getElementById('sk_id').value='<%= sk.getId() %>';document.getElementById('sk_cat').value='<%= sk.getCategory() %>';document.getElementById('sk_name').value='<%= sk.getSkillName().replace("'", "\\'") %>';document.getElementById('sk_prof').value='<%= sk.getProficiency() %>';document.getElementById('sk_badge').value='<%= sk.getBadgeText() %>';document.getElementById('sk_order').value='<%= sk.getDisplayOrder() %>';">Edit</button>
                                <a href="<%= request.getContextPath() %>/admin?action=deleteSkill&id=<%= sk.getId() %>" class="btn-sm-del">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= TAB 8: RECRUITER MESSAGES ================= -->
        <div id="tab-messages" class="tab-panel <%= "messages".equals(activeTab) ? "active" : "" %>">
            <h2 style="font-size:1.5rem;font-weight:800;margin-bottom:1.2rem;">Recruiter Inquiries &amp; Interview Invitations</h2>

            <div class="edu-card">
                <% if (messages.isEmpty()) { %>
                <p style="color:#94a3b8;text-align:center;padding:2rem 0;">No recruiter messages received yet. Test the form on the portfolio or Recruiter Module!</p>
                <% } else { %>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Recruiter &amp; Company</th>
                            <th>Contact</th>
                            <th>Role Offered</th>
                            <th>Message</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (RecruiterMessage m : messages) { %>
                        <tr style="<%= !m.isRead() ? "background:rgba(0,229,255,0.05);" : "" %>">
                            <td style="font-size:0.75rem;color:#94a3b8;"><%= m.getCreatedAt() %></td>
                            <td>
                                <strong style="color:#fff;"><%= m.getRecruiterName() %></strong><br>
                                <span style="color:#00e5ff;font-size:0.78rem;"><%= m.getCompanyName() %></span>
                            </td>
                            <td style="font-size:0.78rem;">
                                <%= m.getRecruiterEmail() %><br>
                                <span style="color:#94a3b8;"><%= m.getRecruiterPhone() != null ? m.getRecruiterPhone() : "" %></span>
                            </td>
                            <td style="font-weight:700;color:#34d399;"><%= m.getRoleOffered() %></td>
                            <td style="max-width:280px;color:#cbd5e1;"><%= m.getMessage() %></td>
                            <td style="white-space:nowrap;">
                                <% if (!m.isRead()) { %>
                                <a href="<%= request.getContextPath() %>/admin?action=markRead&id=<%= m.getId() %>" class="btn-sm-edit">Mark Read</a>
                                <% } %>
                                <a href="<%= request.getContextPath() %>/admin?action=deleteMessage&id=<%= m.getId() %>" class="btn-sm-del" onclick="return confirm('Delete message?')">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>
        </div>

    </main>
</div>

<script>
    function switchTab(tabName, btn) {
        var panels = document.querySelectorAll('.tab-panel');
        for (var i = 0; i < panels.length; i++) panels[i].classList.remove('active');
        var btns = document.querySelectorAll('.admin-tab-btn');
        for (var j = 0; j < btns.length; j++) btns[j].classList.remove('active');
        document.getElementById('tab-' + tabName).classList.add('active');
        if (btn) btn.classList.add('active');
    }

    function switchTabByName(tabName) {
        var btns = document.querySelectorAll('.admin-tab-btn');
        for (var i = 0; i < btns.length; i++) {
            var b = btns[i];
            if (b.getAttribute('onclick') && b.getAttribute('onclick').indexOf("'" + tabName + "'") !== -1) {
                switchTab(tabName, b);
            }
        }
    }

    function editProject(btn) {
        document.getElementById('proj_form_heading').textContent = '✏️ Editing Project #' + btn.dataset.id;
        document.getElementById('proj_id').value = btn.dataset.id;
        document.getElementById('proj_title').value = btn.dataset.title;
        document.getElementById('proj_category').value = btn.dataset.cat;
        document.getElementById('proj_method').value = btn.dataset.method;
        document.getElementById('proj_desc').value = btn.dataset.desc;
        document.getElementById('proj_arch').value = btn.dataset.arch;
        document.getElementById('proj_tech').value = btn.dataset.tech;
        document.getElementById('proj_github').value = btn.dataset.github;
        document.getElementById('proj_proof').value = btn.dataset.proof;
        document.getElementById('proj_order').value = btn.dataset.order;
        document.getElementById('proj_featured').checked = (btn.dataset.feat === 'true');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function resetProjectForm() {
        document.getElementById('proj_form_heading').textContent = '+ Add New Flagship Project';
        document.getElementById('proj_id').value = '0';
        document.getElementById('proj_title').value = '';
        document.getElementById('proj_desc').value = '';
        document.getElementById('proj_arch').value = '';
        document.getElementById('proj_tech').value = '';
        document.getElementById('proj_github').value = '';
        document.getElementById('proj_proof').value = '';
    }

    function editEducation(btn) {
        document.getElementById('edu_form_heading').textContent = '✏️ Editing Education #' + btn.dataset.id;
        document.getElementById('edu_id').value = btn.dataset.id;
        document.getElementById('edu_degree').value = btn.dataset.degree;
        document.getElementById('edu_inst').value = btn.dataset.inst;
        document.getElementById('edu_univ').value = btn.dataset.univ;
        document.getElementById('edu_duration').value = btn.dataset.dur;
        document.getElementById('edu_status').value = btn.dataset.status;
        document.getElementById('edu_desc').value = btn.dataset.desc;
        document.getElementById('edu_p1t').value = btn.dataset.p1t;
        document.getElementById('edu_p1u').value = btn.dataset.p1u;
        document.getElementById('edu_p2t').value = btn.dataset.p2t;
        document.getElementById('edu_p2u').value = btn.dataset.p2u;
        document.getElementById('edu_p3t').value = btn.dataset.p3t;
        document.getElementById('edu_p3u').value = btn.dataset.p3u;
        document.getElementById('edu_order').value = btn.dataset.order;
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function resetEduForm() {
        document.getElementById('edu_form_heading').textContent = '+ Add Academic Qualification';
        document.getElementById('edu_id').value = '0';
        document.getElementById('edu_degree').value = '';
        document.getElementById('edu_inst').value = '';
        document.getElementById('edu_univ').value = '';
        document.getElementById('edu_duration').value = '';
        document.getElementById('edu_status').value = '';
        document.getElementById('edu_desc').value = '';
        document.getElementById('edu_p1t').value = '';
        document.getElementById('edu_p2t').value = '';
        document.getElementById('edu_p3t').value = '';
    }

    function editCertificate(btn) {
        document.getElementById('cert_form_heading').textContent = '✏️ Editing Certificate #' + btn.dataset.id;
        document.getElementById('cert_id').value = btn.dataset.id;
        document.getElementById('cert_title').value = btn.dataset.title;
        document.getElementById('cert_issuer').value = btn.dataset.issuer;
        document.getElementById('cert_date').value = btn.dataset.date;
        document.getElementById('cert_score').value = btn.dataset.score;
        document.getElementById('cert_cat').value = btn.dataset.cat;
        document.getElementById('cert_elite').checked = (btn.dataset.elite === 'true');
        document.getElementById('cert_ribbon').value = btn.dataset.ribbon;
        document.getElementById('cert_desc').value = btn.dataset.desc;
        document.getElementById('cert_skills').value = btn.dataset.skills;
        document.getElementById('cert_cred').value = btn.dataset.cred;
        document.getElementById('cert_proof').value = btn.dataset.proof;
        document.getElementById('cert_order').value = btn.dataset.order;
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function resetCertForm() {
        document.getElementById('cert_form_heading').textContent = '+ Add Certification';
        document.getElementById('cert_id').value = '0';
        document.getElementById('cert_title').value = '';
        document.getElementById('cert_issuer').value = '';
        document.getElementById('cert_date').value = '';
        document.getElementById('cert_score').value = '';
        document.getElementById('cert_desc').value = '';
        document.getElementById('cert_skills').value = '';
        document.getElementById('cert_cred').value = '';
    }

    function editExperience(btn) {
        document.getElementById('exp_form_heading').textContent = '✏️ Editing Experience #' + btn.dataset.id;
        document.getElementById('exp_id').value = btn.dataset.id;
        document.getElementById('exp_role').value = btn.dataset.role;
        document.getElementById('exp_company').value = btn.dataset.company;
        document.getElementById('exp_type').value = btn.dataset.type;
        document.getElementById('exp_track').value = btn.dataset.track;
        document.getElementById('exp_dur').value = btn.dataset.dur;
        document.getElementById('exp_loc').value = btn.dataset.loc;
        document.getElementById('exp_desc').value = btn.dataset.desc;
        document.getElementById('exp_tech').value = btn.dataset.tech;
        document.getElementById('exp_p1t').value = btn.dataset.p1t;
        document.getElementById('exp_p1u').value = btn.dataset.p1u;
        document.getElementById('exp_p2t').value = btn.dataset.p2t;
        document.getElementById('exp_p2u').value = btn.dataset.p2u;
        document.getElementById('exp_p3t').value = btn.dataset.p3t;
        document.getElementById('exp_p3u').value = btn.dataset.p3u;
        document.getElementById('exp_order').value = btn.dataset.order;
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function resetExpForm() {
        document.getElementById('exp_form_heading').textContent = '+ Add Work Experience';
        document.getElementById('exp_id').value = '0';
        document.getElementById('exp_role').value = '';
        document.getElementById('exp_company').value = '';
        document.getElementById('exp_dur').value = '';
        document.getElementById('exp_desc').value = '';
        document.getElementById('exp_tech').value = '';
    }
</script>
</body>
</html>
