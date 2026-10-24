
package com.dayWise.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Represents a project in the dayWise application.
 * Maps to the projects table in daywise_db.
 */
public class Project {

    private long projectId;
    private long userId;
    private String projectName;
    private String description;
    private String projectColor;
    private String status;
    private Date startDate;
    private Date dueDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Project() {
    }

    public Project(long userId, String projectName,
                   String description, String projectColor,
                   String status, Date startDate, Date dueDate) {
        this.userId = userId;
        this.projectName = projectName;
        this.description = description;
        this.projectColor = projectColor;
        this.status = status;
        this.startDate = startDate;
        this.dueDate = dueDate;
    }

    public long getProjectId() {
        return projectId;
    }

    public void setProjectId(long projectId) {
        this.projectId = projectId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getProjectColor() {
        return projectColor;
    }

    public void setProjectColor(String projectColor) {
        this.projectColor = projectColor;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
