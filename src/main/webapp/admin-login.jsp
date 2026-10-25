<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin CMS Login — Portfolio Control Center</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/portfolio.css">
</head>
<body style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:1.5rem;">

<div class="edu-card" style="width:100%;max-width:430px;padding:2.2rem;">
    <div style="text-align:center;margin-bottom:1.6rem;">
        <div class="brand-logo" style="width:52px;height:52px;margin:0 auto 0.85rem;font-size:1.2rem;">SA</div>
        <h1 style="font-size:1.45rem;font-weight:900;color:#fff;">Siddhi Arote — Admin CMS</h1>
        <p style="font-size:0.82rem;color:#94a3b8;margin-top:0.25rem;">
            Sign in to update your photo, resume, projects, skills, experience, education &amp; verified proofs.
        </p>
    </div>

    <% if ("1".equals(request.getParameter("error"))) { %>
    <div style="background:rgba(244,63,94,0.15);border:1px solid #f43f5e;color:#fda4af;padding:0.7rem 1rem;border-radius:10px;font-size:0.8rem;margin-bottom:1.1rem;text-align:center;">
        <i class="fa-solid fa-triangle-exclamation"></i> Invalid administrator username or password.
    </div>
    <% } else if ("locked".equals(request.getParameter("error"))) { %>
    <div style="background:rgba(244,63,94,0.15);border:1px solid #f43f5e;color:#fda4af;padding:0.7rem 1rem;border-radius:10px;font-size:0.8rem;margin-bottom:1.1rem;text-align:center;">
        <i class="fa-solid fa-shield-halved"></i> Too many failed login attempts. Access temporarily locked for 15 minutes.
    </div>
    <% } %>

    <% if ("1".equals(request.getParameter("logout"))) { %>
    <div style="background:rgba(16,185,129,0.15);border:1px solid #10b981;color:#6ee7b7;padding:0.7rem 1rem;border-radius:10px;font-size:0.8rem;margin-bottom:1.1rem;text-align:center;">
        <i class="fa-solid fa-circle-check"></i> Logged out safely.
    </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/admin" method="post" autocomplete="off">
        <input type="hidden" name="action" value="login">
        <div class="form-group">
            <label class="form-label">Admin Username</label>
            <input type="text" name="username" class="form-control" placeholder="Enter administrator username" autocomplete="username" required>
        </div>
        <div class="form-group" style="margin-bottom:1.4rem;">
            <label class="form-label">Admin Password</label>
            <input type="password" name="password" class="form-control" placeholder="Enter administrator password" autocomplete="current-password" required>
        </div>
        <button type="submit" class="btn-explore" style="width:100%;justify-content:center;">
            <i class="fa-solid fa-lock-open"></i> Sign In to Portfolio Admin
        </button>
    </form>

    <div style="margin-top:1.4rem;padding-top:1rem;border-top:1px solid rgba(255,255,255,0.06);display:flex;justify-content:space-between;font-size:0.78rem;color:#64748b;">
        <span><i class="fa-solid fa-shield-halved"></i> Authorized Administrator Only</span>
        <a href="<%= request.getContextPath() %>/index.jsp" style="color:#00e5ff;font-weight:600;">← Back to Portfolio</a>
    </div>
</div>

</body>
</html>
