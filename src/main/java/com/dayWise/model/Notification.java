
package com.dayWise.model;

import java.sql.Timestamp;

public class Notification {

    // Unique notification ID
    private long notificationId;

    // User who receives the notification
    private long userId;

    // Related task ID; can be null if no task is associated
    private Long taskId;

    // Type of notification, such as TASK_REMINDER
    private String notificationType;

    // Notification heading
    private String title;

    // Notification message
    private String message;

    // Whether the user has read the notification
    private boolean read;

    // Date and time when the notification was created
    private Timestamp createdAt;

    // Default constructor
    public Notification() {
    }

    // Constructor for creating a notification
    public Notification(long userId, Long taskId,
                        String notificationType,
                        String title, String message) {
        this.userId = userId;
        this.taskId = taskId;
        this.notificationType = notificationType;
        this.title = title;
        this.message = message;
        this.read = false;
    }

    public long getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(long notificationId) {
        this.notificationId = notificationId;
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

    public String getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
