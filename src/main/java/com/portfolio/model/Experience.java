package com.portfolio.model;

public class Experience {
    private int id;
    private String roleTitle;
    private String company;
    private String expType;
    private String trackName;
    private String duration;
    private String location;
    private String description;
    private String techStack;
    private String proof1Title;
    private String proof1Url;
    private String proof2Title;
    private String proof2Url;
    private String proof3Title;
    private String proof3Url;
    private int displayOrder;

    public Experience() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRoleTitle() { return roleTitle; }
    public void setRoleTitle(String roleTitle) { this.roleTitle = roleTitle; }

    public String getCompany() { return company; }
    public void setCompany(String company) { this.company = company; }

    public String getExpType() { return expType; }
    public void setExpType(String expType) { this.expType = expType; }

    public String getTrackName() { return trackName; }
    public void setTrackName(String trackName) { this.trackName = trackName; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getTechStack() { return techStack; }
    public void setTechStack(String techStack) { this.techStack = techStack; }

    public String getProof1Title() { return proof1Title; }
    public void setProof1Title(String proof1Title) { this.proof1Title = proof1Title; }

    public String getProof1Url() { return proof1Url; }
    public void setProof1Url(String proof1Url) { this.proof1Url = proof1Url; }

    public String getProof2Title() { return proof2Title; }
    public void setProof2Title(String proof2Title) { this.proof2Title = proof2Title; }

    public String getProof2Url() { return proof2Url; }
    public void setProof2Url(String proof2Url) { this.proof2Url = proof2Url; }

    public String getProof3Title() { return proof3Title; }
    public void setProof3Title(String proof3Title) { this.proof3Title = proof3Title; }

    public String getProof3Url() { return proof3Url; }
    public void setProof3Url(String proof3Url) { this.proof3Url = proof3Url; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }

    public String[] getTechArray() {
        if (techStack == null || techStack.trim().isEmpty()) {
            return new String[0];
        }
        return techStack.split("\\s*,\\s*");
    }
}
