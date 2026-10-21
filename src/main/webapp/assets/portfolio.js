/**
 * portfolio.js
 * Dynamically loads & filters Portfolio data using JavaScript + JSON (Fetch API).
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

document.addEventListener('DOMContentLoaded', function () {
    loadPortfolioJsonData();
});

function normalizeExternalUrl(url, fallback) {
    if (!url || ! String(url).replace(/^\s+|\s+$/g, '')) {
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

function loadPortfolioJsonData() {
    var base = window.PORTFOLIO_CTX || '';
    var apiUrl = (base ? base + '/api/portfolio-data' : 'data/portfolio-data.json');
    var fallbackJsonUrl = (base ? base + '/data/portfolio-data.json' : 'data/portfolio-data.json');

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
            if (!data) return;
            if (data.profile) {
                portfolioJsonData.profile = data.profile;
            }
            if (Array.isArray(data.projects)) {
                portfolioJsonData.projects = data.projects;
                renderProjectsFromJson(portfolioJsonData.projects);
            }
            if (Array.isArray(data.skills)) {
                portfolioJsonData.skills = data.skills;
                renderSkillsFromJson(portfolioJsonData.skills);
            }
            if (Array.isArray(data.educations) && data.educations.length > 0) {
                portfolioJsonData.educations = data.educations;
                if (window.IS_STATIC_PORTFOLIO) {
                    renderEducationFromJson(portfolioJsonData.educations);
                }
            }
            if (Array.isArray(data.certificates) && data.certificates.length > 0) {
                portfolioJsonData.certificates = data.certificates;
                if (window.IS_STATIC_PORTFOLIO) {
                    renderCertificatesFromJson(portfolioJsonData.certificates);
                }
            }
            if (Array.isArray(data.experiences) && data.experiences.length > 0) {
                portfolioJsonData.experiences = data.experiences;
                if (window.IS_STATIC_PORTFOLIO) {
                    renderExperienceFromJson(portfolioJsonData.experiences);
                }
            }
        })
        .catch(function (err) {
            console.log('Using server-rendered portfolio cards.', err);
        });
}

/**
 * Returns adaptive Bootstrap column classes based on total visible cards
 * - 1 card  -> col-lg-8 col-md-10 mx-auto (centered, wide)
 * - 2 cards -> col-lg-6 col-md-6 (fills full row 50% + 50% evenly)
 * - 3+ cards -> col-lg-4 col-md-6 (3-column grid, centered row)
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
 * Renders Projects dynamically from JSON into Bootstrap 5 Dark Cards (#projectsGrid)
 */
function renderProjectsFromJson(projectsList) {
    var grid = document.getElementById('projectsGrid');
    if (!grid) return;

    var ctx = window.PORTFOLIO_CTX || '';
    if (!projectsList || projectsList.length === 0) {
        grid.innerHTML =
            '<div class="col-lg-8 col-md-10 mx-auto">' +
                '<div class="card project-card text-center p-5 border-secondary">' +
                    '<div class="mb-3" style="font-size:2.2rem;color:#00e5ff;"><i class="fa-solid fa-folder-plus"></i></div>' +
                    '<h4 class="text-white fw-bold mb-2">No Projects Added Yet</h4>' +
                    '<p class="text-secondary mb-3">Open the Admin CMS Portal to add your own flagship projects, tech stacks, GitHub links, and architecture details.</p>' +
                    '<div><a href="' + ctx + '/admin?tab=projects" class="btn-explore">+ Add Projects in Admin Panel</a></div>' +
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

    var ctx = window.PORTFOLIO_CTX || '';
    if (!skillsList || skillsList.length === 0) {
        grid.innerHTML =
            '<div class="col-lg-8 col-md-10 mx-auto">' +
                '<div class="card skill-cat-card text-center p-5 border-secondary">' +
                    '<div class="mb-3" style="font-size:2.2rem;color:#f59e0b;"><i class="fa-solid fa-microchip"></i></div>' +
                    '<h4 class="text-white fw-bold mb-2">No Technical Skills Added Yet</h4>' +
                    '<p class="text-secondary mb-3">Open the Admin CMS Portal to add your own technical skills, categories, badges, and proficiency bars.</p>' +
                    '<div><a href="' + ctx + '/admin?tab=skills" class="btn-explore">+ Add Skills in Admin Panel</a></div>' +
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
