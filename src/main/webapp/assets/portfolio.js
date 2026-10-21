/**
 * portfolio.js
 * Dynamically loads & filters Portfolio data (Profile, Projects, Education, Certificates, Experience, Skills)
 * using JavaScript + JSON (Fetch API).
 * Written in 100% ES5-compatible syntax so Eclipse JSDT Validator reports zero errors/warnings.
 */

var portfolioJsonData = {
    profile: null,
    projects: [],
    skills: [],
    educations: [],
    certificates: [],
    experiences: []
};

var activeProjectCategory = 'ALL';
var activeProjectMethod = 'ALL';
var activeSkillCategory = 'ALL';
var activeCertCategory = 'ALL';

document.addEventListener('DOMContentLoaded', function () {
    loadPortfolioJsonData();
});

function normalizeExternalUrl(url, fallback) {
    if (!url || !String(url).replace(/^\s+|\s+$/g, '')) {
        return fallback || '#';
    }
    var trimmed = String(url).replace(/^\s+|\s+$/g, '');
    if (
        trimmed.indexOf('http://') === 0 ||
        trimmed.indexOf('https://') === 0 ||
        trimmed.indexOf('mailto:') === 0 ||
        trimmed.indexOf('tel:') === 0 ||
        trimmed.indexOf('#') === 0 ||
        trimmed.indexOf('/') === 0
    ) {
        return trimmed;
    }
    return 'https://' + trimmed;
}

function resolveAssetUrl(relPath) {
    if (!relPath) return '';
    var p = String(relPath).replace(/^\s+|\s+$/g, '');
    if (!p) return '';
    if (p.indexOf('http://') === 0 || p.indexOf('https://') === 0 || p.indexOf('data:') === 0) {
        return p;
    }
    var base = window.PORTFOLIO_CTX || '';
    if (base && p.indexOf('/') !== 0) {
        return base + '/' + p;
    }
    return p;
}

function applyPortfolioDataObject(data) {
    if (!data) return;
    if (data.profile) {
        portfolioJsonData.profile = data.profile;
        if (window.IS_STATIC_PORTFOLIO) {
            renderProfileFromJson(portfolioJsonData.profile, data);
        }
    }
    if (Array.isArray(data.projects)) {
        portfolioJsonData.projects = data.projects;
        renderProjectsFromJson(portfolioJsonData.projects);
    }
    if (Array.isArray(data.skills)) {
        portfolioJsonData.skills = data.skills;
        renderSkillsFromJson(portfolioJsonData.skills);
    }
    if (Array.isArray(data.educations)) {
        portfolioJsonData.educations = data.educations;
        if (window.IS_STATIC_PORTFOLIO) {
            renderEducationFromJson(portfolioJsonData.educations);
        }
    }
    if (Array.isArray(data.certificates)) {
        portfolioJsonData.certificates = data.certificates;
        if (window.IS_STATIC_PORTFOLIO) {
            renderCertificatesFromJson(portfolioJsonData.certificates);
        }
    }
    if (Array.isArray(data.experiences)) {
        portfolioJsonData.experiences = data.experiences;
        if (window.IS_STATIC_PORTFOLIO) {
            renderExperienceFromJson(portfolioJsonData.experiences);
        }
    }
}

function loadPortfolioJsonData() {
    var base = window.PORTFOLIO_CTX || '';
    var bust = '?t=' + new Date().getTime();
    var apiUrl = (base ? base + '/api/portfolio-data' : 'data/portfolio-data.json') + bust;
    var fallbackJsonUrl = (base ? base + '/data/portfolio-data.json' : 'data/portfolio-data.json') + bust;

    fetch(apiUrl, { cache: 'no-store' })
        .then(function (response) {
            if (!response.ok) {
                return fetch(fallbackJsonUrl, { cache: 'no-store' });
            }
            return response;
        })
        .catch(function () {
            return fetch(fallbackJsonUrl, { cache: 'no-store' });
        })
        .then(function (response) {
            if (!response || !response.ok) {
                throw new Error('JSON not available');
            }
            return response.json();
        })
        .then(function (data) {
            // Check if user saved newer draft in browser localStorage on static live site
            if (window.IS_STATIC_PORTFOLIO) {
                try {
                    var localRaw = localStorage.getItem('PORTFOLIO_LIVE_OVERRIDE');
                    if (localRaw) {
                        var localData = JSON.parse(localRaw);
                        if (localData && localData._updatedAt) {
                            data = localData;
                        }
                    }
                } catch (e) {}
            }
            applyPortfolioDataObject(data);
        })
        .catch(function (err) {
            console.log('Using server-rendered portfolio cards.', err);
        });
}

/**
 * Returns adaptive Bootstrap column classes based on total visible cards
 */
function getAdaptiveThreeColClass(count) {
    if (count === 1) return 'col-lg-8 col-md-10 mx-auto';
    if (count === 2) return 'col-lg-6 col-md-6';
    return 'col-lg-4 col-md-6';
}

function getAdaptiveTwoColClass(count) {
    if (count === 1) return 'col-lg-8 col-md-10 mx-auto';
    return 'col-lg-6 col-md-6';
}

/**
 * Dynamically updates Profile Hero, Resume & Contact details on Static Live Site
 */
function renderProfileFromJson(pf, fullData) {
    if (!pf) return;
    document.title = (pf.fullName || 'Siddhi Arote') + ' \u2014 ' + (pf.roleTitle || 'Full-Stack Developer');

    var setText = function (id, val) {
        var el = document.getElementById(id);
        if (el && val !== undefined && val !== null) el.textContent = val;
    };
    setText('navLogoInitials', pf.logoInitials || 'SA');
    setText('navShortName', pf.shortName || pf.fullName);
    setText('navSubtitle', pf.navSubtitle || 'Full-Stack Developer');
    setText('heroStatusText', pf.statusText);
    setText('heroLocation', pf.location);
    setText('heroGreeting', pf.greetingText);
    setText('heroFullName', pf.fullName);
    setText('heroBio', pf.bio);
    setText('photoCaptionName', pf.shortName || pf.fullName);
    setText('topBadgeTitle', pf.topCardBadgeTitle);
    setText('topBadgeSub', pf.topCardBadgeSub);
    setText('bottomBadgeTitle', pf.bottomCardBadgeTitle);
    setText('bottomBadgeSub', pf.bottomCardBadgeSub);
    setText('resumeHeadingName', (pf.fullName || 'Siddhi Arote') + ' \u2014 Official Resume');
    setText('resumeSubRole', pf.roleTitle);
    setText('contactEmailText', pf.email);
    setText('contactPhoneText', pf.phone);
    setText('contactLocationText', pf.location);
    setText('footerFullName', pf.fullName);
    setText('footerNavSub', pf.navSubtitle);

    var picEl = document.getElementById('heroProfileImg');
    if (picEl && pf.profilePicUrl) {
        picEl.src = resolveAssetUrl(pf.profilePicUrl);
    }

    var resIframe = document.getElementById('resumePreviewIframe');
    var resViewBtn = document.getElementById('resumeFullscreenBtn');
    var resDlBtn = document.getElementById('resumeDownloadBtn');
    if (pf.resumeUrl) {
        var rUrl = resolveAssetUrl(pf.resumeUrl);
        if (resIframe) resIframe.src = rUrl;
        if (resViewBtn) resViewBtn.href = rUrl;
        if (resDlBtn) resDlBtn.href = rUrl;
    }

    var ghLinks = document.querySelectorAll('.dyn-github-link');
    for (var i = 0; i < ghLinks.length; i++) {
        ghLinks[i].href = normalizeExternalUrl(pf.githubUrl, 'https://github.com/SiddhiArote0420');
    }
    var liLinks = document.querySelectorAll('.dyn-linkedin-link');
    for (var j = 0; j < liLinks.length; j++) {
        liLinks[j].href = normalizeExternalUrl(pf.linkedinUrl, 'https://linkedin.com/');
    }
    var lcLinks = document.querySelectorAll('.dyn-leetcode-link');
    for (var k = 0; k < lcLinks.length; k++) {
        lcLinks[k].href = normalizeExternalUrl(pf.leetcodeUrl, 'https://leetcode.com/');
    }
    var emLinks = document.querySelectorAll('.dyn-email-link');
    for (var m = 0; m < emLinks.length; m++) {
        emLinks[m].href = 'mailto:' + (pf.email || 'siddhiarote5@gmail.com');
    }
}

/**
 * Renders Projects dynamically from JSON into Bootstrap 5 Dark Cards (#projectsGrid)
 */
function renderProjectsFromJson(projectsList) {
    var grid = document.getElementById('projectsGrid');
    if (!grid) return;

    var adminHref = window.IS_STATIC_PORTFOLIO ? 'admin.html?tab=projects' : ((window.PORTFOLIO_CTX || '') + '/admin?tab=projects');
    if (!projectsList || projectsList.length === 0) {
        grid.innerHTML =
            '<div class="col-lg-8 col-md-10 mx-auto">' +
                '<div class="card project-card text-center p-5 border-secondary">' +
                    '<div class="mb-3" style="font-size:2.2rem;color:#00e5ff;"><i class="fa-solid fa-folder-plus"></i></div>' +
                    '<h4 class="text-white fw-bold mb-2">No Projects Added Yet</h4>' +
                    '<p class="text-secondary mb-3">Open the Admin CMS Portal to add your own flagship projects, tech stacks, GitHub links, and architecture details.</p>' +
                    '<div><a href="' + adminHref + '" class="btn-explore">+ Add Projects in Admin Panel</a></div>' +
                '</div>' +
            '</div>';
        return;
    }

    var searchInput = document.getElementById('projectSearchInput');
    var query = searchInput ? searchInput.value.toLowerCase().replace(/^\s+|\s+$/g, '') : '';

    var filtered = [];
    for (var i = 0; i < projectsList.length; i++) {
        var pr = projectsList[i];
        var cat = (pr.category || '').toLowerCase();
        var method = (pr.buildMethod || '').toLowerCase();
        var techStr = Array.isArray(pr.techStack) ? pr.techStack.join(' ') : (pr.techStack || '');
        var fullText = ((pr.title || '') + ' ' + (pr.description || '') + ' ' + techStr).toLowerCase();

        var matchCat = (activeProjectCategory === 'ALL') || (cat === activeProjectCategory.toLowerCase());
        var matchMethod = (activeProjectMethod === 'ALL') || (method.indexOf(activeProjectMethod.toLowerCase()) !== -1);
        var matchSearch = (!query) || (fullText.indexOf(query) !== -1);

        if (matchCat && matchMethod && matchSearch) {
            filtered.push(pr);
        }
    }

    if (filtered.length === 0) {
        grid.innerHTML =
            '<div class="col-lg-8 col-md-10 mx-auto">' +
                '<div class="card project-card text-center p-5 border-secondary">' +
                    '<h5 class="text-white mb-2">No matching projects found</h5>' +
                    '<p class="text-secondary mb-0">Try clearing the search box or switching project category tabs.</p>' +
                '</div>' +
            '</div>';
        return;
    }

    var colClass = getAdaptiveThreeColClass(filtered.length);
    var htmlParts = [];

    for (var j = 0; j < filtered.length; j++) {
        var item = filtered[j];
        var isAi = (item.buildMethod || '').toLowerCase().indexOf('ai') !== -1;
        var methodBadgeClass = isAi ? 'ai' : 'solo';
        var methodLabel = isAi ? '&#129302; AI &amp; Prompt Engineered' : '&lt;/&gt; &#128736;&#65039; Solo Handcrafted';
        var techs = Array.isArray(item.techStack)
            ? item.techStack
            : (item.techStack ? String(item.techStack).split(/\s*,\s*/) : []);

        var visibleTechs = '';
        var maxTech = Math.min(techs.length, 5);
        for (var k = 0; k < maxTech; k++) {
            visibleTechs += '<span class="tech-tag">' + escapeHtml(techs[k]) + '</span>';
        }
        var extraTechs = techs.length > 5
            ? '<span class="tech-tag more">+' + (techs.length - 5) + ' more</span>'
            : '';
        var featuredBadge = item.featured ? '<span class="badge-featured">FEATURED</span>' : '';
        var rawLink = (item.liveUrl && String(item.liveUrl).replace(/^\s+|\s+$/g, ''))
            ? item.liveUrl
            : (item.githubUrl || '#projects');
        var linkUrl = normalizeExternalUrl(rawLink, '#projects');
        var ghUrl = item.githubUrl && String(item.githubUrl).replace(/^\s+|\s+$/g, '')
            ? normalizeExternalUrl(item.githubUrl, '#')
            : '#';

        htmlParts.push(
            '<div class="' + colClass + ' d-flex align-items-stretch">' +
                '<div class="card project-card w-100 border-secondary">' +
                    '<div>' +
                        '<div class="project-top-badges">' +
                            '<span class="badge-method ' + methodBadgeClass + '">' + methodLabel + '</span>' +
                            featuredBadge +
                        '</div>' +
                        '<div class="project-title-row">' +
                            '<h3 class="project-title">' + escapeHtml(item.title) + '</h3>' +
                            '<a href="' + escapeAttr(linkUrl) + '" target="_blank" style="color:#64748b;font-size:0.85rem;" title="Open Project Link">' +
                                '<i class="fa-solid fa-arrow-up-right-from-square"></i>' +
                            '</a>' +
                        '</div>' +
                        '<p class="project-desc">' + escapeHtml(item.description) + '</p>' +
                        '<div class="tech-tags">' +
                            visibleTechs +
                            extraTechs +
                        '</div>' +
                    '</div>' +
                    '<div class="project-footer">' +
                        '<button type="button" class="deep-dive-link"' +
                            ' data-title="' + escapeAttr(item.title) + '"' +
                            ' data-cat="' + escapeAttr((item.category || '') + ' \u2022 ' + (item.buildMethod || '')) + '"' +
                            ' data-desc="' + escapeAttr(item.description) + '"' +
                            ' data-arch="' + escapeAttr(item.architectureDetails || '') + '"' +
                            ' data-tech="' + escapeAttr(techs.join(', ')) + '"' +
                            ' data-github="' + escapeAttr(ghUrl) + '"' +
                            ' data-proof="' + escapeAttr(item.proofUrl || '') + '"' +
                            ' onclick="openProjectDeepDive(this)">' +
                            'Click for Deep Dive &amp; Architecture \u2192' +
                        '</button>' +
                        '<a href="' + escapeAttr(ghUrl) + '" target="_blank" class="repo-icon-btn" title="View Source on GitHub">' +
                            '<i class="fa-brands fa-github"></i>' +
                        '</a>' +
                    '</div>' +
                '</div>' +
            '</div>'
        );
    }

    grid.innerHTML = htmlParts.join('');
}

/**
 * Renders Education cards dynamically from JSON (#educationGrid)
 */
function renderEducationFromJson(eduList) {
    var grid = document.getElementById('educationGrid');
    if (!grid) return;

    var adminHref = window.IS_STATIC_PORTFOLIO ? 'admin.html?tab=education' : ((window.PORTFOLIO_CTX || '') + '/admin?tab=education');
    if (!eduList || eduList.length === 0) {
        grid.innerHTML =
            '<div class="col-lg-8 col-md-10 mx-auto">' +
                '<div class="card edu-card text-center p-5 border-secondary">' +
                    '<div class="mb-3" style="font-size:2.2rem;color:#10b981;"><i class="fa-solid fa-graduation-cap"></i></div>' +
                    '<h4 class="text-white fw-bold mb-2">Add Your Academic Background &amp; Marksheet Proofs</h4>' +
                    '<div><a href="' + adminHref + '" class="btn-explore">+ Add Education in Admin Panel</a></div>' +
                '</div>' +
            '</div>';
        return;
    }

    var colClass = getAdaptiveTwoColClass(eduList.length);
    var htmlParts = [];

    for (var i = 0; i < eduList.length; i++) {
        var ed = eduList[i];
        var p1Label = (ed.proof1Title && String(ed.proof1Title).replace(/^\s+|\s+$/g, '')) ? ed.proof1Title : (ed.proof1Url ? 'Official Marksheet / Proof' : '');
        var p2Label = (ed.proof2Title && String(ed.proof2Title).replace(/^\s+|\s+$/g, '')) ? ed.proof2Title : (ed.proof2Url ? 'Academic Certificate / Proof 2' : '');
        var p3Label = (ed.proof3Title && String(ed.proof3Title).replace(/^\s+|\s+$/g, '')) ? ed.proof3Title : (ed.proof3Url ? 'Verified Record / Proof 3' : '');

        var pillsHtml = '';
        var subText = (ed.degree || '') + ' \u2014 ' + (ed.statusText || '');
        if (p1Label) {
            pillsHtml +=
                '<button type="button" class="proof-pill-btn"' +
                    ' data-ptitle="' + escapeAttr(p1Label) + '"' +
                    ' data-purl="' + escapeAttr(ed.proof1Url || '') + '"' +
                    ' data-psub="' + escapeAttr(subText) + '"' +
                    ' onclick="openProofModal(this.getAttribute(\'data-ptitle\'), this.getAttribute(\'data-purl\'), this.getAttribute(\'data-psub\'))">' +
                    '<i class="fa-regular fa-file-lines doc-ic"></i><span>' + escapeHtml(p1Label) + '</span><i class="fa-regular fa-eye eye-ic"></i>' +
                '</button>';
        }
        if (p2Label) {
            pillsHtml +=
                '<button type="button" class="proof-pill-btn"' +
                    ' data-ptitle="' + escapeAttr(p2Label) + '"' +
                    ' data-purl="' + escapeAttr(ed.proof2Url || '') + '"' +
                    ' data-psub="' + escapeAttr(subText) + '"' +
                    ' onclick="openProofModal(this.getAttribute(\'data-ptitle\'), this.getAttribute(\'data-purl\'), this.getAttribute(\'data-psub\'))">' +
                    '<i class="fa-regular fa-file-lines doc-ic"></i><span>' + escapeHtml(p2Label) + '</span><i class="fa-regular fa-eye eye-ic"></i>' +
                '</button>';
        }
        if (p3Label) {
            pillsHtml +=
                '<button type="button" class="proof-pill-btn"' +
                    ' data-ptitle="' + escapeAttr(p3Label) + '"' +
                    ' data-purl="' + escapeAttr(ed.proof3Url || '') + '"' +
                    ' data-psub="' + escapeAttr(subText) + '"' +
                    ' onclick="openProofModal(this.getAttribute(\'data-ptitle\'), this.getAttribute(\'data-purl\'), this.getAttribute(\'data-psub\'))">' +
                    '<i class="fa-regular fa-file-lines doc-ic"></i><span>' + escapeHtml(p3Label) + '</span><i class="fa-regular fa-eye eye-ic"></i>' +
                '</button>';
        }

        htmlParts.push(
            '<div class="' + colClass + ' d-flex align-items-stretch">' +
                '<div class="card edu-card w-100 border-secondary">' +
                    '<div>' +
                        '<div class="edu-top-row">' +
                            '<div class="edu-icon-box"><i class="fa-solid fa-graduation-cap"></i></div>' +
                            '<div class="edu-meta-right">' +
                                '<span class="edu-duration-pill">' + escapeHtml(ed.duration) + '</span>' +
                                '<span class="edu-status-text">' + escapeHtml(ed.statusText) + '</span>' +
                            '</div>' +
                        '</div>' +
                        '<h3 class="edu-degree">' + escapeHtml(ed.degree) + '</h3>' +
                        '<div class="edu-inst">' + escapeHtml(ed.institution) + '</div>' +
                        '<div class="edu-univ">' + escapeHtml(ed.university) + '</div>' +
                        '<p class="edu-desc">' + escapeHtml(ed.description) + '</p>' +
                    '</div>' +
                    '<div class="proof-section">' +
                        '<div class="proof-heading"><i class="fa-regular fa-circle-check"></i> INSPECT VERIFIED PROOFS &amp; MARKSHEETS:</div>' +
                        '<div class="proof-pills">' + pillsHtml + '</div>' +
                    '</div>' +
                '</div>' +
            '</div>'
        );
    }

    grid.innerHTML = htmlParts.join('');
}

/**
 * Renders Certificates dynamically from JSON (#certsGrid)
 */
function renderCertificatesFromJson(certList) {
    var grid = document.getElementById('certsGrid');
    if (!grid) return;

    var adminHref = window.IS_STATIC_PORTFOLIO ? 'admin.html?tab=certificates' : ((window.PORTFOLIO_CTX || '') + '/admin?tab=certificates');
    if (!certList || certList.length === 0) {
        grid.innerHTML =
            '<div class="col-lg-8 col-md-10 mx-auto">' +
                '<div class="card cert-card text-center p-5 border-secondary">' +
                    '<div class="mb-3" style="font-size:2.2rem;color:#fbbf24;"><i class="fa-solid fa-award"></i></div>' +
                    '<h4 class="text-white fw-bold mb-2">Add Your Certifications &amp; Honors</h4>' +
                    '<div><a href="' + adminHref + '" class="btn-explore">+ Add Certificates in Admin Panel</a></div>' +
                '</div>' +
            '</div>';
        return;
    }

    var filtered = [];
    for (var i = 0; i < certList.length; i++) {
        var c = certList[i];
        var cat = c.category || '';
        if (activeCertCategory === 'ALL' || cat.toLowerCase() === activeCertCategory.toLowerCase()) {
            filtered.push(c);
        }
    }

    var colClass = getAdaptiveThreeColClass(filtered.length);
    var htmlParts = [];

    for (var j = 0; j < filtered.length; j++) {
        var cert = filtered[j];
        var tags = cert.skillTags ? String(cert.skillTags).split(/\s*,\s*/) : [];
        var tagsHtml = '';
        for (var k = 0; k < tags.length; k++) {
            if (tags[k]) tagsHtml += '<span class="tech-tag">' + escapeHtml(tags[k]) + '</span>';
        }
        var ribbonHtml = cert.eliteGold
            ? '<div class="elite-top-ribbon">\u2728 ' + escapeHtml(cert.topRibbonText || 'ELITE + GOLD MEDALIST') + '</div>'
            : '';
        var cardClass = cert.eliteGold ? 'elite-gold' : 'border-secondary';
        var subInfo = 'Issued by ' + (cert.issuer || '') + ' \u2022 Score: ' + (cert.scoreBadge || '') + ' \u2022 Credential ID: ' + (cert.credentialId || '');

        htmlParts.push(
            '<div class="' + colClass + ' d-flex align-items-stretch cert-col-item" data-category="' + escapeAttr(cert.category || '') + '">' +
                '<div class="card cert-card w-100 ' + cardClass + '">' +
                    ribbonHtml +
                    '<div>' +
                        '<div class="cert-top-row">' +
                            '<div class="cert-icon-box"><i class="fa-solid fa-medal"></i></div>' +
                            '<span class="cert-date">' + escapeHtml(cert.issueDate) + '</span>' +
                        '</div>' +
                        '<h3 class="cert-title">' + escapeHtml(cert.title) + '</h3>' +
                        '<div class="cert-issuer">' + escapeHtml(cert.issuer) + '</div>' +
                        '<div class="cert-score-pill">Score / Recognition: ' + escapeHtml(cert.scoreBadge) + '</div>' +
                        '<p class="cert-desc">' + escapeHtml(cert.description) + '</p>' +
                        '<div class="tech-tags">' + tagsHtml + '</div>' +
                    '</div>' +
                    '<div class="cert-footer">' +
                        '<span class="cert-id" title="ID: ' + escapeAttr(cert.credentialId) + '">ID: ' + escapeHtml(cert.credentialId) + '</span>' +
                        '<button type="button" class="btn-view-cert"' +
                            ' data-ptitle="' + escapeAttr(cert.title) + '"' +
                            ' data-purl="' + escapeAttr(cert.proofUrl || '') + '"' +
                            ' data-psub="' + escapeAttr(subInfo) + '"' +
                            ' onclick="openProofModal(this.getAttribute(\'data-ptitle\'), this.getAttribute(\'data-purl\'), this.getAttribute(\'data-psub\'))">' +
                            '<i class="fa-regular fa-eye"></i> View Proof' +
                        '</button>' +
                    '</div>' +
                '</div>' +
            '</div>'
        );
    }

    grid.innerHTML = htmlParts.join('');
}

/**
 * Renders Experience cards dynamically from JSON (#experienceList)
 */
function renderExperienceFromJson(expList) {
    var listEl = document.getElementById('experienceList');
    if (!listEl) return;

    var adminHref = window.IS_STATIC_PORTFOLIO ? 'admin.html?tab=experience' : ((window.PORTFOLIO_CTX || '') + '/admin?tab=experience');
    if (!expList || expList.length === 0) {
        listEl.innerHTML =
            '<div class="card exp-card text-center p-5 border-secondary">' +
                '<div class="mb-3" style="font-size:2.2rem;color:#38bdf8;"><i class="fa-solid fa-briefcase"></i></div>' +
                '<h4 class="text-white fw-bold mb-2">Add Your Work Experience &amp; Internships</h4>' +
                '<div><a href="' + adminHref + '" class="btn-explore">+ Add Experience in Admin Panel</a></div>' +
            '</div>';
        return;
    }

    var htmlParts = [];
    for (var i = 0; i < expList.length; i++) {
        var ex = expList[i];
        var techs = ex.techStack ? String(ex.techStack).split(/\s*,\s*/) : [];
        var techHtml = '';
        for (var k = 0; k < techs.length; k++) {
            if (techs[k]) techHtml += '<span class="tech-tag">' + escapeHtml(techs[k]) + '</span>';
        }

        var p1Label = (ex.proof1Title && String(ex.proof1Title).replace(/^\s+|\s+$/g, '')) ? ex.proof1Title : (ex.proof1Url ? 'Experience Certificate / Proof' : '');
        var p2Label = (ex.proof2Title && String(ex.proof2Title).replace(/^\s+|\s+$/g, '')) ? ex.proof2Title : (ex.proof2Url ? 'Offer Letter / Proof 2' : '');
        var p3Label = (ex.proof3Title && String(ex.proof3Title).replace(/^\s+|\s+$/g, '')) ? ex.proof3Title : (ex.proof3Url ? 'Training Certificate / Proof 3' : '');

        var pillsHtml = '';
        var subInfo = (ex.roleTitle || '') + ' (' + (ex.duration || '') + ')';
        if (p1Label) {
            pillsHtml +=
                '<button type="button" class="proof-pill-btn"' +
                    ' data-ptitle="' + escapeAttr(p1Label + ' \u2014 ' + (ex.company || '')) + '"' +
                    ' data-purl="' + escapeAttr(ex.proof1Url || '') + '"' +
                    ' data-psub="' + escapeAttr(subInfo) + '"' +
                    ' onclick="openProofModal(this.getAttribute(\'data-ptitle\'), this.getAttribute(\'data-purl\'), this.getAttribute(\'data-psub\'))">' +
                    '<i class="fa-regular fa-file-lines doc-ic"></i><span>' + escapeHtml(p1Label) + '</span><i class="fa-regular fa-eye eye-ic"></i>' +
                '</button>';
        }
        if (p2Label) {
            pillsHtml +=
                '<button type="button" class="proof-pill-btn"' +
                    ' data-ptitle="' + escapeAttr(p2Label + ' \u2014 ' + (ex.company || '')) + '"' +
                    ' data-purl="' + escapeAttr(ex.proof2Url || '') + '"' +
                    ' data-psub="' + escapeAttr(subInfo) + '"' +
                    ' onclick="openProofModal(this.getAttribute(\'data-ptitle\'), this.getAttribute(\'data-purl\'), this.getAttribute(\'data-psub\'))">' +
                    '<i class="fa-regular fa-file-lines doc-ic"></i><span>' + escapeHtml(p2Label) + '</span><i class="fa-regular fa-eye eye-ic"></i>' +
                '</button>';
        }
        if (p3Label) {
            pillsHtml +=
                '<button type="button" class="proof-pill-btn"' +
                    ' data-ptitle="' + escapeAttr(p3Label + ' \u2014 ' + (ex.company || '')) + '"' +
                    ' data-purl="' + escapeAttr(ex.proof3Url || '') + '"' +
                    ' data-psub="' + escapeAttr(subInfo) + '"' +
                    ' onclick="openProofModal(this.getAttribute(\'data-ptitle\'), this.getAttribute(\'data-purl\'), this.getAttribute(\'data-psub\'))">' +
                    '<i class="fa-regular fa-file-lines doc-ic"></i><span>' + escapeHtml(p3Label) + '</span><i class="fa-regular fa-eye eye-ic"></i>' +
                '</button>';
        }

        var proofBarHtml = pillsHtml
            ? '<div class="exp-proof-bar">' +
                  '<div class="proof-heading" style="margin-bottom:0;"><i class="fa-regular fa-circle-check"></i> ATTACHED PROOFS:</div>' +
                  '<div class="proof-pills">' + pillsHtml + '</div>' +
              '</div>'
            : '';

        htmlParts.push(
            '<div class="card exp-card border-secondary">' +
                '<div class="exp-top-row">' +
                    '<div>' +
                        '<div class="exp-badges">' +
                            '<span class="badge-intern">' + escapeHtml(ex.expType || 'Internship') + '</span>' +
                            '<span class="exp-track">\u2022 ' + escapeHtml(ex.trackName || '') + '</span>' +
                        '</div>' +
                        '<h3 class="exp-role">' + escapeHtml(ex.roleTitle) + '</h3>' +
                        '<div class="exp-company"><i class="fa-regular fa-building"></i> ' + escapeHtml(ex.company) + '</div>' +
                    '</div>' +
                    '<div class="exp-meta-right">' +
                        '<div><i class="fa-regular fa-calendar" style="color:#22d3ee;"></i> ' + escapeHtml(ex.duration) + '</div>' +
                        '<div class="loc"><i class="fa-solid fa-location-dot" style="color:#f43f5e;"></i> ' + escapeHtml(ex.location) + '</div>' +
                    '</div>' +
                '</div>' +
                '<p class="exp-desc">' + escapeHtml(ex.description) + '</p>' +
                '<div class="tech-tags">' + techHtml + '</div>' +
                proofBarHtml +
            '</div>'
        );
    }

    listEl.innerHTML = htmlParts.join('');
}

/**
 * Helper to match a skill against a filter tab ('ALL', 'Java', 'MERN', 'AI')
 */
function matchesSkillFilter(sk, catFilter) {
    if (!catFilter || catFilter === 'ALL') return true;
    var cat = (sk.category || '').toLowerCase();
    var name = (sk.skillName || '').toLowerCase();
    var target = catFilter.toLowerCase();

    if (target === 'mern') {
        if (
            name.indexOf('html') !== -1 ||
            name.indexOf('css') !== -1 ||
            name.indexOf('javascript') !== -1 ||
            name.indexOf('js') !== -1 ||
            name.indexOf('react') !== -1 ||
            name.indexOf('node') !== -1 ||
            name.indexOf('express') !== -1 ||
            name.indexOf('mongo') !== -1 ||
            name.indexOf('bootstrap') !== -1 ||
            name.indexOf('tailwind') !== -1 ||
            cat.indexOf('mern') !== -1 ||
            cat.indexOf('web') !== -1
        ) {
            return true;
        }
        return false;
    }

    if (target === 'ai') {
        if (
            name.indexOf('git') !== -1 ||
            name.indexOf('docker') !== -1 ||
            name.indexOf('aws') !== -1 ||
            name.indexOf('cloud') !== -1 ||
            name.indexOf('postman') !== -1 ||
            name.indexOf('ai') !== -1 ||
            name.indexOf('prompt') !== -1 ||
            name.indexOf('linux') !== -1 ||
            name.indexOf('devops') !== -1 ||
            cat.indexOf('ai') !== -1 ||
            cat.indexOf('devops') !== -1 ||
            cat.indexOf('cloud') !== -1
        ) {
            return true;
        }
        return false;
    }

    if (target === 'java') {
        if (
            name.indexOf('java') !== -1 ||
            name.indexOf('servlet') !== -1 ||
            name.indexOf('jsp') !== -1 ||
            name.indexOf('jdbc') !== -1 ||
            name.indexOf('spring') !== -1 ||
            name.indexOf('hibernate') !== -1 ||
            name.indexOf('sql') !== -1 ||
            name.indexOf('mysql') !== -1 ||
            name.indexOf('postgres') !== -1 ||
            cat.indexOf('java') !== -1
        ) {
            return true;
        }
        return false;
    }

    return cat.indexOf(target) !== -1 || name.indexOf(target) !== -1;
}

/**
 * Renders Skills dynamically from JSON into the 2-Column Individual Skill Cards
 */
function renderSkillsFromJson(skillsList) {
    var grid = document.getElementById('skillsGrid');
    if (!grid) return;

    var adminHref = window.IS_STATIC_PORTFOLIO ? 'admin.html?tab=skills' : ((window.PORTFOLIO_CTX || '') + '/admin?tab=skills');
    if (!skillsList || skillsList.length === 0) {
        grid.innerHTML =
            '<div class="col-lg-8 col-md-10 mx-auto">' +
                '<div class="card skill-cat-card text-center p-5 border-secondary">' +
                    '<div class="mb-3" style="font-size:2.2rem;color:#f59e0b;"><i class="fa-solid fa-microchip"></i></div>' +
                    '<h4 class="text-white fw-bold mb-2">No Technical Skills Added Yet</h4>' +
                    '<p class="text-secondary mb-3">Open the Admin CMS Portal to add your own technical skills, categories, badges, and proficiency bars.</p>' +
                    '<div><a href="' + adminHref + '" class="btn-explore">+ Add Skills in Admin Panel</a></div>' +
                '</div>' +
            '</div>';
        return;
    }

    var filtered = [];
    for (var i = 0; i < skillsList.length; i++) {
        if (matchesSkillFilter(skillsList[i], activeSkillCategory)) {
            filtered.push(skillsList[i]);
        }
    }

    if (filtered.length === 0) {
        filtered = skillsList;
    }

    var colClass = getAdaptiveTwoColClass(filtered.length);
    var htmlParts = [];

    for (var j = 0; j < filtered.length; j++) {
        var sk = filtered[j];
        var badge = (sk.badgeText && String(sk.badgeText).replace(/^\s+|\s+$/g, ''))
            ? sk.badgeText
            : ((sk.proficiency || 90) + '%');
        var prof = Number(sk.proficiency) || 90;

        htmlParts.push(
            '<div class="' + colClass + '">' +
                '<div class="card border-secondary h-100" style="background:#0d1323;border-radius:14px;padding:1.25rem 1.4rem;">' +
                    '<div class="d-flex justify-content-between align-items-center mb-3">' +
                        '<div class="d-flex align-items-center gap-2">' +
                            '<i class="fa-regular fa-circle-check" style="color:#f59e0b;font-size:0.95rem;"></i>' +
                            '<span style="font-weight:700;font-size:0.98rem;color:#ffffff;">' + escapeHtml(sk.skillName) + '</span>' +
                        '</div>' +
                        '<span style="background:rgba(245,158,11,0.14);border:1px solid rgba(245,158,11,0.35);color:#fbbf24;font-size:0.7rem;font-weight:700;padding:0.2rem 0.65rem;border-radius:6px;">' +
                            escapeHtml(badge) +
                        '</span>' +
                    '</div>' +
                    '<div style="width:100%;height:6px;background:#1e293b;border-radius:999px;overflow:hidden;">' +
                        '<div style="width:' + prof + '%;height:100%;background:linear-gradient(90deg, #ea580c, #fbbf24);border-radius:999px;"></div>' +
                    '</div>' +
                '</div>' +
            '</div>'
        );
    }

    grid.innerHTML = htmlParts.join('');
}

function filterSkillsByCat(cat, btn) {
    activeSkillCategory = cat;
    var buttons = document.querySelectorAll('#skillFilterButtons .skill-tab-btn');
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].style.background = 'transparent';
        buttons[i].style.color = '#94a3b8';
    }
    if (btn) {
        btn.style.background = 'linear-gradient(90deg, #ea580c, #f59e0b)';
        btn.style.color = '#ffffff';
    }
    if (portfolioJsonData.skills && portfolioJsonData.skills.length > 0) {
        renderSkillsFromJson(portfolioJsonData.skills);
    } else {
        var items = document.querySelectorAll('#skillsGrid .skill-col-item');
        var visibleCount = 0;
        for (var j = 0; j < items.length; j++) {
            var col = items[j];
            var c = col.getAttribute('data-category') || '';
            var nameEl = col.querySelector('span');
            var sName = nameEl ? nameEl.textContent : '';
            var show = matchesSkillFilter({ category: c, skillName: sName }, cat);
            col.style.display = show ? 'block' : 'none';
            if (show) visibleCount++;
        }
        for (var k = 0; k < items.length; k++) {
            if (items[k].style.display !== 'none') {
                items[k].className = getAdaptiveTwoColClass(visibleCount) + ' skill-col-item';
            }
        }
    }
}

function copyTextToClipboard(text, btn) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(function () {
            var oldHtml = btn.innerHTML;
            btn.innerHTML = '<i class="fa-solid fa-check" style="color:#10b981;"></i>';
            setTimeout(function () { btn.innerHTML = oldHtml; }, 1500);
        });
    }
}

function escapeHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
}

function escapeAttr(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
}
