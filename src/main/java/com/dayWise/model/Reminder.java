
package com.dayWise.model;

import java.sql.Timestamp;

public class Reminder {

    // Unique ID of the reminder
    private long reminderId;

    // User who owns this reminder
    private long userId;

    // Task associated with this reminder
    private long taskId;

    // Date and time when the reminder should trigger
    private Timestamp reminderAt;

    // Optional message displayed with the reminder
    private String reminderMessage;

    // Reminder status: PENDING, SENT, or CANCELLED
    private String status;

    // Date and time when the reminder was sent
    private Timestamp sentAt;

    // Date and time when the reminder was created
    private Timestamp createdAt;

    // Default constructor
    public Reminder() {
    }

    // Constructor for creating a new reminder
    public Reminder(long userId, long taskId,
                    Timestamp reminderAt, String reminderMessage) {
        this.userId = userId;
        this.taskId = taskId;
        this.reminderAt = reminderAt;
        this.reminderMessage = reminderMessage;
        this.status = "PENDING";
    }

    public long getReminderId() {
        return reminderId;
    }

    public void setReminderId(long reminderId) {
        this.reminderId = reminderId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getTaskId() {
        return taskId;
    }

    public void setTaskId(long taskId) {
        this.taskId = taskId;
    }

    public Timestamp getReminderAt() {
        return reminderAt;
    }

    public void setReminderAt(Timestamp reminderAt) {
        this.reminderAt = reminderAt;
    }

    public String getReminderMessage() {
        return reminderMessage;
    }

    public void setReminderMessage(String reminderMessage) {
        this.reminderMessage = reminderMessage;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
