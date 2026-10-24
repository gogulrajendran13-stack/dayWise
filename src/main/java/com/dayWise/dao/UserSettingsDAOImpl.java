
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.dayWise.model.UserSettings;
import com.dayWise.util.DBConnection;

public class UserSettingsDAOImpl implements UserSettingsDAO {

    // Create initial settings for a user
    @Override
    public boolean createSettings(UserSettings settings) {

        String sql = "INSERT INTO user_settings "
                + "(user_id, theme, daily_focus_minutes, "
                + "notifications_enabled, reminder_enabled, language) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, settings.getUserId());
            statement.setString(2, settings.getTheme());
            statement.setInt(3, settings.getDailyFocusMinutes());
            statement.setBoolean(4, settings.isNotificationsEnabled());
            statement.setBoolean(5, settings.isReminderEnabled());
            statement.setString(6, settings.getLanguage());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error creating user settings.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve settings for a particular user
    @Override
    public UserSettings getSettingsByUserId(long userId) {

        String sql = "SELECT * FROM user_settings WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapUserSettings(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving user settings.");
            e.printStackTrace();
        }

        return null;
    }

    // Update all settings for a user
    @Override
    public boolean updateSettings(UserSettings settings) {

        String sql = "UPDATE user_settings SET "
                + "theme = ?, daily_focus_minutes = ?, "
                + "notifications_enabled = ?, reminder_enabled = ?, "
                + "language = ? "
                + "WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, settings.getTheme());
            statement.setInt(2, settings.getDailyFocusMinutes());
            statement.setBoolean(3, settings.isNotificationsEnabled());
            statement.setBoolean(4, settings.isReminderEnabled());
            statement.setString(5, settings.getLanguage());
            statement.setLong(6, settings.getUserId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user settings.");
            e.printStackTrace();
            return false;
        }
    }

    // Update the dashboard theme
    @Override
    public boolean updateTheme(long userId, String theme) {

        if (!"LIGHT".equals(theme) && !"DARK".equals(theme)) {
            return false;
        }

        String sql = "UPDATE user_settings SET theme = ? "
                + "WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, theme);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating theme.");
            e.printStackTrace();
            return false;
        }
    }

    // Update the daily focus target
    @Override
    public boolean updateDailyFocusMinutes(long userId, int minutes) {

        if (minutes < 0) {
            return false;
        }

        String sql = "UPDATE user_settings "
                + "SET daily_focus_minutes = ? WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, minutes);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating daily focus target.");
            e.printStackTrace();
            return false;
        }
    }

    // Enable or disable notifications
    @Override
    public boolean updateNotificationsEnabled(
            long userId, boolean enabled) {

        String sql = "UPDATE user_settings "
                + "SET notifications_enabled = ? WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setBoolean(1, enabled);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating notification preference.");
            e.printStackTrace();
            return false;
        }
    }

    // Enable or disable reminders
    @Override
    public boolean updateReminderEnabled(
            long userId, boolean enabled) {

        String sql = "UPDATE user_settings "
                + "SET reminder_enabled = ? WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setBoolean(1, enabled);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating reminder preference.");
            e.printStackTrace();
            return false;
        }
    }

    // Update the preferred language
    @Override
    public boolean updateLanguage(long userId, String language) {

        if (language == null || language.trim().isEmpty()
                || language.length() > 10) {
            return false;
        }

        String sql = "UPDATE user_settings "
                + "SET language = ? WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, language.trim());
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating language preference.");
            e.printStackTrace();
            return false;
        }
    }

    // Convert a database row into a UserSettings object
    private UserSettings mapUserSettings(ResultSet resultSet)
            throws SQLException {

        UserSettings settings = new UserSettings();

        settings.setSettingId(resultSet.getLong("setting_id"));
        settings.setUserId(resultSet.getLong("user_id"));
        settings.setTheme(resultSet.getString("theme"));
        settings.setDailyFocusMinutes(
                resultSet.getInt("daily_focus_minutes"));
        settings.setNotificationsEnabled(
                resultSet.getBoolean("notifications_enabled"));
        settings.setReminderEnabled(
                resultSet.getBoolean("reminder_enabled"));
        settings.setLanguage(resultSet.getString("language"));
        settings.setCreatedAt(resultSet.getTimestamp("created_at"));
        settings.setUpdatedAt(resultSet.getTimestamp("updated_at"));

        return settings;
    }
}
