
package com.dayWise.model;

import java.sql.Timestamp;

public class FocusSession {

    // Unique ID of the focus session
    private long sessionId;

    // User who owns the session
    private long userId;

    // Related task ID; null if the session is not linked to a task
    private Long taskId;

    // Type of session, such as FOCUS or BREAK
    private String sessionType;

    // Session start date and time
    private Timestamp startTime;

    // Session end date and time; null while the session is running
    private Timestamp endTime;

    // Total session duration in minutes
    private int durationMinutes;

    // Session status, such as IN_PROGRESS or COMPLETED
    private String status;

    // Optional notes about the session
    private String notes;

    // Date and time when the record was created
    private Timestamp createdAt;

    // Default constructor
    public FocusSession() {
    }

    // Constructor for starting a new focus session
    public FocusSession(long userId, Long taskId,
                        String sessionType, Timestamp startTime) {
        this.userId = userId;
        this.taskId = taskId;
        this.sessionType = sessionType;
        this.startTime = startTime;
        this.durationMinutes = 0;
        this.status = "IN_PROGRESS";
    }

    public long getSessionId() {
        return sessionId;
    }

    public void setSessionId(long sessionId) {
        this.sessionId = sessionId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public String getSessionType() {
        return sessionType;
    }

    public void setSessionType(String sessionType) {
        this.sessionType = sessionType;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
