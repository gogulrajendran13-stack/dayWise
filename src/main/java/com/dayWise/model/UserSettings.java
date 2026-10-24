
package com.dayWise.model;

import java.sql.Timestamp;

public class UserSettings {

    // Unique settings record ID
    private long settingId;

    // User who owns these settings
    private long userId;

    // Dashboard theme: LIGHT or DARK
    private String theme;

    // Daily focus target in minutes
    private int dailyFocusMinutes;

    // Whether notifications are enabled
    private boolean notificationsEnabled;

    // Whether reminders are enabled
    private boolean reminderEnabled;

    // Preferred language, such as en
    private String language;

    // Date and time when settings were created
    private Timestamp createdAt;

    // Date and time when settings were last updated
    private Timestamp updatedAt;

    // Default constructor
    public UserSettings() {
    }

    // Constructor with default settings
    public UserSettings(long userId) {
        this.userId = userId;
        this.theme = "LIGHT";
        this.dailyFocusMinutes = 120;
        this.notificationsEnabled = true;
        this.reminderEnabled = true;
        this.language = "en";
    }

    public long getSettingId() {
        return settingId;
    }

    public void setSettingId(long settingId) {
        this.settingId = settingId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public int getDailyFocusMinutes() {
        return dailyFocusMinutes;
    }

    public void setDailyFocusMinutes(int dailyFocusMinutes) {
        this.dailyFocusMinutes = dailyFocusMinutes;
    }

    public boolean isNotificationsEnabled() {
        return notificationsEnabled;
    }

    public void setNotificationsEnabled(boolean notificationsEnabled) {
        this.notificationsEnabled = notificationsEnabled;
    }

    public boolean isReminderEnabled() {
        return reminderEnabled;
    }

    public void setReminderEnabled(boolean reminderEnabled) {
        this.reminderEnabled = reminderEnabled;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
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
