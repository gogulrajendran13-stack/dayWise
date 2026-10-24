
package com.dayWise.dao;

import com.dayWise.model.UserSettings;

public interface UserSettingsDAO {

    // Create default settings for a user
    boolean createSettings(UserSettings settings);

    // Retrieve settings belonging to a user
    UserSettings getSettingsByUserId(long userId);

    // Update all user settings
    boolean updateSettings(UserSettings settings);

    // Update the dashboard theme
    boolean updateTheme(long userId, String theme);

    // Update the daily focus target in minutes
    boolean updateDailyFocusMinutes(long userId, int minutes);

    // Enable or disable notifications
    boolean updateNotificationsEnabled(
            long userId, boolean enabled);

    // Enable or disable reminders
    boolean updateReminderEnabled(
            long userId, boolean enabled);

    // Update the preferred language
    boolean updateLanguage(long userId, String language);
}
