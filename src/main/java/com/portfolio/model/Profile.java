package com.portfolio.model;

public class Profile {
    private int id;
    private String logoInitials;
    private String shortName;
    private String navSubtitle;
    private String fullName;
    private String greetingText;
    private String roleTitle;
    private String bio;
    private String statusText;
    private String location;
    private String highlightBadge1;
    private String highlightBadge2;
    private String topCardBadgeTitle;
    private String topCardBadgeSub;
    private String bottomCardBadgeTitle;
    private String bottomCardBadgeSub;
    private String profilePicUrl;
    private String resumeUrl;
    private String goldProofUrl;
    private String githubUrl;
    private String linkedinUrl;
    private String leetcodeUrl;
    private String email;
    private String phone;

    public Profile() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getLogoInitials() { return logoInitials; }
    public void setLogoInitials(String logoInitials) { this.logoInitials = logoInitials; }

    public String getShortName() { return shortName; }
    public void setShortName(String shortName) { this.shortName = shortName; }

    public String getNavSubtitle() { return navSubtitle; }
    public void setNavSubtitle(String navSubtitle) { this.navSubtitle = navSubtitle; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getGreetingText() { return greetingText; }
    public void setGreetingText(String greetingText) { this.greetingText = greetingText; }

    public String getRoleTitle() { return roleTitle; }
    public void setRoleTitle(String roleTitle) { this.roleTitle = roleTitle; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getStatusText() { return statusText; }
    public void setStatusText(String statusText) { this.statusText = statusText; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getHighlightBadge1() { return highlightBadge1; }
    public void setHighlightBadge1(String highlightBadge1) { this.highlightBadge1 = highlightBadge1; }

    public String getHighlightBadge2() { return highlightBadge2; }
    public void setHighlightBadge2(String highlightBadge2) { this.highlightBadge2 = highlightBadge2; }

    public String getTopCardBadgeTitle() { return topCardBadgeTitle; }
    public void setTopCardBadgeTitle(String topCardBadgeTitle) { this.topCardBadgeTitle = topCardBadgeTitle; }

    public String getTopCardBadgeSub() { return topCardBadgeSub; }
    public void setTopCardBadgeSub(String topCardBadgeSub) { this.topCardBadgeSub = topCardBadgeSub; }

    public String getBottomCardBadgeTitle() { return bottomCardBadgeTitle; }
    public void setBottomCardBadgeTitle(String bottomCardBadgeTitle) { this.bottomCardBadgeTitle = bottomCardBadgeTitle; }

    public String getBottomCardBadgeSub() { return bottomCardBadgeSub; }
    public void setBottomCardBadgeSub(String bottomCardBadgeSub) { this.bottomCardBadgeSub = bottomCardBadgeSub; }

    public String getProfilePicUrl() { return profilePicUrl; }
    public void setProfilePicUrl(String profilePicUrl) { this.profilePicUrl = profilePicUrl; }

    public String getResumeUrl() { return resumeUrl; }
    public void setResumeUrl(String resumeUrl) { this.resumeUrl = resumeUrl; }

    public String getGoldProofUrl() { return goldProofUrl; }
    public void setGoldProofUrl(String goldProofUrl) { this.goldProofUrl = goldProofUrl; }

    public String getGithubUrl() { return normalizeExternalUrl(githubUrl); }
    public void setGithubUrl(String githubUrl) { this.githubUrl = normalizeExternalUrl(githubUrl); }

    public String getLinkedinUrl() { return normalizeExternalUrl(linkedinUrl); }
    public void setLinkedinUrl(String linkedinUrl) { this.linkedinUrl = normalizeExternalUrl(linkedinUrl); }

    public String getLeetcodeUrl() { return normalizeExternalUrl(leetcodeUrl); }
    public void setLeetcodeUrl(String leetcodeUrl) { this.leetcodeUrl = normalizeExternalUrl(leetcodeUrl); }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    private static String normalizeExternalUrl(String url) {
        if (url == null) return "";
        String t = url.trim();
        if (t.isEmpty() || t.startsWith("http://") || t.startsWith("https://") || t.startsWith("#") || t.startsWith("/")) {
            return t;
        }
        return "https://" + t;
    }
}
