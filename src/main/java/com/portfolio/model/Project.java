package com.portfolio.model;

public class Project {
    private int id;
    private String title;
    private String category;
    private String buildMethod;
    private boolean featured;
    private String description;
    private String architectureDetails;
    private String techStack;
    private String githubUrl;
    private String liveUrl;
    private String proofUrl;
    private int displayOrder;

    public Project() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getBuildMethod() { return buildMethod; }
    public void setBuildMethod(String buildMethod) { this.buildMethod = buildMethod; }

    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getArchitectureDetails() { return architectureDetails; }
    public void setArchitectureDetails(String architectureDetails) { this.architectureDetails = architectureDetails; }

    public String getTechStack() { return techStack; }
    public void setTechStack(String techStack) { this.techStack = techStack; }

    public String getGithubUrl() { return normalizeExternalUrl(githubUrl); }
    public void setGithubUrl(String githubUrl) { this.githubUrl = normalizeExternalUrl(githubUrl); }

    public String getLiveUrl() { return normalizeExternalUrl(liveUrl); }
    public void setLiveUrl(String liveUrl) { this.liveUrl = normalizeExternalUrl(liveUrl); }

    public String getProofUrl() { return proofUrl; }
    public void setProofUrl(String proofUrl) { this.proofUrl = proofUrl; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }

    public String[] getTechArray() {
        if (techStack == null || techStack.trim().isEmpty()) {
            return new String[0];
        }
        return techStack.split("\\s*,\\s*");
    }

    private static String normalizeExternalUrl(String url) {
        if (url == null) return "";
        String t = url.trim();
        if (t.isEmpty() || t.startsWith("http://") || t.startsWith("https://") || t.startsWith("#") || t.startsWith("/")) {
            return t;
        }
        return "https://" + t;
    }
}
