package com.portfolio.model;

public class Certificate {
    private int id;
    private String title;
    private String issuer;
    private String issueDate;
    private String scoreBadge;
    private String category;
    private boolean eliteGold;
    private String topRibbonText;
    private String description;
    private String skillTags;
    private String credentialId;
    private String proofUrl;
    private int displayOrder;

    public Certificate() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getIssuer() { return issuer; }
    public void setIssuer(String issuer) { this.issuer = issuer; }

    public String getIssueDate() { return issueDate; }
    public void setIssueDate(String issueDate) { this.issueDate = issueDate; }

    public String getScoreBadge() { return scoreBadge; }
    public void setScoreBadge(String scoreBadge) { this.scoreBadge = scoreBadge; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public boolean isEliteGold() { return eliteGold; }
    public void setEliteGold(boolean eliteGold) { this.eliteGold = eliteGold; }

    public String getTopRibbonText() { return topRibbonText; }
    public void setTopRibbonText(String topRibbonText) { this.topRibbonText = topRibbonText; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSkillTags() { return skillTags; }
    public void setSkillTags(String skillTags) { this.skillTags = skillTags; }

    public String getCredentialId() { return credentialId; }
    public void setCredentialId(String credentialId) { this.credentialId = credentialId; }

    public String getProofUrl() { return proofUrl; }
    public void setProofUrl(String proofUrl) { this.proofUrl = proofUrl; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }

    public String[] getSkillArray() {
        if (skillTags == null || skillTags.trim().isEmpty()) {
            return new String[0];
        }
        return skillTags.split("\\s*,\\s*");
    }
}
