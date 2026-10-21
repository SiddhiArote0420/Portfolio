package com.portfolio.model;

import java.sql.Timestamp;

public class RecruiterMessage {
    private int id;
    private String recruiterName;
    private String companyName;
    private String recruiterEmail;
    private String recruiterPhone;
    private String roleOffered;
    private String message;
    private boolean isRead;
    private Timestamp createdAt;

    public RecruiterMessage() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRecruiterName() { return recruiterName; }
    public void setRecruiterName(String recruiterName) { this.recruiterName = recruiterName; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getRecruiterEmail() { return recruiterEmail; }
    public void setRecruiterEmail(String recruiterEmail) { this.recruiterEmail = recruiterEmail; }

    public String getRecruiterPhone() { return recruiterPhone; }
    public void setRecruiterPhone(String recruiterPhone) { this.recruiterPhone = recruiterPhone; }

    public String getRoleOffered() { return roleOffered; }
    public void setRoleOffered(String roleOffered) { this.roleOffered = roleOffered; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
