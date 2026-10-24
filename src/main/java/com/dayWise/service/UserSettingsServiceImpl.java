
package com.dayWise.service;

import com.dayWise.dao.UserSettingsDAO;
import com.dayWise.dao.UserSettingsDAOImpl;
import com.dayWise.model.UserSettings;

/**
 * Implements business rules for user settings.
 */
public class UserSettingsServiceImpl
        implements UserSettingsService {

    private static final int MIN_FOCUS_MINUTES = 0;
    private static final int MAX_FOCUS_MINUTES = 1440;

    private final UserSettingsDAO userSettingsDAO;

    public UserSettingsServiceImpl() {
        this(new UserSettingsDAOImpl());
    }

    public UserSettingsServiceImpl(
            UserSettingsDAO userSettingsDAO) {

        if (userSettingsDAO == null) {
            throw new IllegalArgumentException(
                    "UserSettingsDAO cannot be null.");
        }

        this.userSettingsDAO = userSettingsDAO;
    }

    @Override
    public boolean createSettings(UserSettings settings) {

        if (settings == null || settings.getUserId() <= 0) {
            return false;
        }

        if (!isValidTheme(settings.getTheme())
                || !isValidFocusMinutes(
                        settings.getDailyFocusMinutes())
                || !isValidLanguage(settings.getLanguage())) {
            return false;
        }

        settings.setTheme(
                settings.getTheme().trim().toUpperCase());

        settings.setLanguage(
                settings.getLanguage().trim().toLowerCase());

        return userSettingsDAO.createSettings(settings);
    }

    @Override
    public UserSettings getSettingsByUserId(long userId) {

        if (userId <= 0) {
            return null;
        }

        return userSettingsDAO.getSettingsByUserId(userId);
    }

    @Override
    public boolean updateSettings(UserSettings settings) {

        if (settings == null || settings.getUserId() <= 0) {
            return false;
        }

        if (!isValidTheme(settings.getTheme())
                || !isValidFocusMinutes(
                        settings.getDailyFocusMinutes())
                || !isValidLanguage(settings.getLanguage())) {
            return false;
        }

        UserSettings existingSettings =
                userSettingsDAO.getSettingsByUserId(
                        settings.getUserId());

        if (existingSettings == null) {
            return false;
        }

        settings.setTheme(
                settings.getTheme().trim().toUpperCase());

        settings.setLanguage(
                settings.getLanguage().trim().toLowerCase());

        return userSettingsDAO.updateSettings(settings);
    }

    @Override
    public boolean updateTheme(long userId, String theme) {

        if (userId <= 0 || !isValidTheme(theme)) {
            return false;
        }

        if (userSettingsDAO.getSettingsByUserId(userId) == null) {
            return false;
        }

        return userSettingsDAO.updateTheme(
                userId, theme.trim().toUpperCase());
    }

    @Override
    public boolean updateDailyFocusMinutes(
            long userId, int minutes) {

        if (userId <= 0 || !isValidFocusMinutes(minutes)) {
            return false;
        }

        if (userSettingsDAO.getSettingsByUserId(userId) == null) {
            return false;
        }

        return userSettingsDAO.updateDailyFocusMinutes(
                userId, minutes);
    }

    @Override
    public boolean updateNotificationsEnabled(
            long userId, boolean enabled) {

        if (userId <= 0) {
            return false;
        }

        if (userSettingsDAO.getSettingsByUserId(userId) == null) {
            return false;
        }

        return userSettingsDAO.updateNotificationsEnabled(
                userId, enabled);
    }

    @Override
    public boolean updateReminderEnabled(
            long userId, boolean enabled) {

        if (userId <= 0) {
            return false;
        }

        if (userSettingsDAO.getSettingsByUserId(userId) == null) {
            return false;
        }

        return userSettingsDAO.updateReminderEnabled(
                userId, enabled);
    }

    @Override
    public boolean updateLanguage(long userId, String language) {

        if (userId <= 0 || !isValidLanguage(language)) {
            return false;
        }

        if (userSettingsDAO.getSettingsByUserId(userId) == null) {
            return false;
        }

        return userSettingsDAO.updateLanguage(
                userId, language.trim().toLowerCase());
    }

    private boolean isValidTheme(String theme) {

        if (theme == null) {
            return false;
        }

        theme = theme.trim().toUpperCase();

        return "LIGHT".equals(theme) || "DARK".equals(theme);
    }

    private boolean isValidFocusMinutes(int minutes) {

        return minutes >= MIN_FOCUS_MINUTES
                && minutes <= MAX_FOCUS_MINUTES;
    }

    private boolean isValidLanguage(String language) {

        if (language == null) {
            return false;
        }

        language = language.trim();

        return !language.isEmpty()
                && language.length() <= 10
                && language.matches("^[A-Za-z0-9_-]+$");
    }
}
