
package com.dayWise.service;

import com.dayWise.model.UserSettings;

/**
 * Defines business operations for user settings.
 */
public interface UserSettingsService {

    boolean createSettings(UserSettings settings);

    UserSettings getSettingsByUserId(long userId);

    boolean updateSettings(UserSettings settings);

    boolean updateTheme(long userId, String theme);

    boolean updateDailyFocusMinutes(long userId, int minutes);

    boolean updateNotificationsEnabled(long userId, boolean enabled);

    boolean updateReminderEnabled(long userId, boolean enabled);

    boolean updateLanguage(long userId, String language);
}
