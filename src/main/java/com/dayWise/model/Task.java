
package com.dayWise.model;

import java.sql.Timestamp;

/**
 * Represents a task in the dayWise application.
 * Maps to the tasks table in daywise_db.
 */
public class Task {

    private long taskId;
    private long userId;
    private Long projectId;
    private Long categoryId;
    private Long parentTaskId;
    private String title;
    private String description;
    private String priority;
    private String status;
    private Timestamp dueAt;
    private int positionOrder;
    private Integer estimatedMinutes;
    private Timestamp completedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Task() {
    }

    public Task(long userId, Long projectId, Long categoryId,
                Long parentTaskId, String title,
                String description, String priority,
                String status, Timestamp dueAt,
                int positionOrder, Integer estimatedMinutes) {
        this.userId = userId;
        this.projectId = projectId;
        this.categoryId = categoryId;
        this.parentTaskId = parentTaskId;
        this.title = title;
        this.description = description;
        this.priority = priority;
        this.status = status;
        this.dueAt = dueAt;
        this.positionOrder = positionOrder;
        this.estimatedMinutes = estimatedMinutes;
    }

    public long getTaskId() {
        return taskId;
    }

    public void setTaskId(long taskId) {
        this.taskId = taskId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public Long getParentTaskId() {
        return parentTaskId;
    }

    public void setParentTaskId(Long parentTaskId) {
        this.parentTaskId = parentTaskId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getDueAt() {
        return dueAt;
    }

    public void setDueAt(Timestamp dueAt) {
        this.dueAt = dueAt;
    }

    public int getPositionOrder() {
        return positionOrder;
    }

    public void setPositionOrder(int positionOrder) {
        this.positionOrder = positionOrder;
    }

    public Integer getEstimatedMinutes() {
        return estimatedMinutes;
    }

    public void setEstimatedMinutes(Integer estimatedMinutes) {
        this.estimatedMinutes = estimatedMinutes;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
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
