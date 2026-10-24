
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.dayWise.model.Reminder;
import com.dayWise.util.DBConnection;

public class ReminderDAOImpl implements ReminderDAO {

    // Create a reminder linked to a task
    @Override
    public boolean addReminder(Reminder reminder) {

        String sql = "INSERT INTO reminders "
                + "(user_id, task_id, reminder_at, "
                + "reminder_message, status, sent_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, reminder.getUserId());
            statement.setLong(2, reminder.getTaskId());
            statement.setTimestamp(3, reminder.getReminderAt());
            statement.setString(4, reminder.getReminderMessage());

            // New reminders should normally start as PENDING
            String status = reminder.getStatus() == null
                    ? "PENDING" : reminder.getStatus();

            if (!isValidStatus(status)) {
                return false;
            }

            statement.setString(5, status);
            setNullableTimestamp(statement, 6, reminder.getSentAt());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error creating reminder.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve all reminders belonging to a user
    @Override
    public List<Reminder> getRemindersByUserId(long userId) {

        List<Reminder> reminders = new ArrayList<>();

        String sql = "SELECT * FROM reminders "
                + "WHERE user_id = ? "
                + "ORDER BY reminder_at ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    reminders.add(mapReminder(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving reminders.");
            e.printStackTrace();
        }

        return reminders;
    }

    // Retrieve pending reminders whose scheduled time has arrived
    @Override
    public List<Reminder> getDueReminders() {

        List<Reminder> reminders = new ArrayList<>();

        String sql = "SELECT * FROM reminders "
                + "WHERE status = 'PENDING' "
                + "AND reminder_at <= CURRENT_TIMESTAMP "
                + "ORDER BY reminder_at ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                reminders.add(mapReminder(resultSet));
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving due reminders.");
            e.printStackTrace();
        }

        return reminders;
    }

    // Retrieve a reminder only when it belongs to the specified user
    @Override
    public Reminder getReminderById(long reminderId, long userId) {

        String sql = "SELECT * FROM reminders "
                + "WHERE reminder_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, reminderId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapReminder(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving reminder.");
            e.printStackTrace();
        }

        return null;
    }

    // Update reminder details while checking ownership
    @Override
    public boolean updateReminder(Reminder reminder) {

        String sql = "UPDATE reminders SET "
                + "task_id = ?, reminder_at = ?, "
                + "reminder_message = ?, status = ?, sent_at = ? "
                + "WHERE reminder_id = ? AND user_id = ?";

        String status = reminder.getStatus() == null
                ? "PENDING" : reminder.getStatus();

        if (!isValidStatus(status)) {
            return false;
        }

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, reminder.getTaskId());
            statement.setTimestamp(2, reminder.getReminderAt());
            statement.setString(3, reminder.getReminderMessage());
            statement.setString(4, status);
            setNullableTimestamp(statement, 5, reminder.getSentAt());
            statement.setLong(6, reminder.getReminderId());
            statement.setLong(7, reminder.getUserId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating reminder.");
            e.printStackTrace();
            return false;
        }
    }

    // Change a reminder's status
    @Override
    public boolean updateReminderStatus(
            long reminderId, long userId, String status) {

        if (!isValidStatus(status)) {
            return false;
        }

        String sql = "UPDATE reminders SET status = ?, "
                + "sent_at = CASE WHEN ? = 'SENT' "
                + "THEN CURRENT_TIMESTAMP ELSE NULL END "
                + "WHERE reminder_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setString(2, status);
            statement.setLong(3, reminderId);
            statement.setLong(4, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating reminder status.");
            e.printStackTrace();
            return false;
        }
    }

    // Delete a reminder only when it belongs to the specified user
    @Override
    public boolean deleteReminder(long reminderId, long userId) {

        String sql = "DELETE FROM reminders "
                + "WHERE reminder_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, reminderId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting reminder.");
            e.printStackTrace();
            return false;
        }
    }

    // Convert a database row into a Reminder object
    private Reminder mapReminder(ResultSet resultSet)
            throws SQLException {

        Reminder reminder = new Reminder();

        reminder.setReminderId(resultSet.getLong("reminder_id"));
        reminder.setUserId(resultSet.getLong("user_id"));
        reminder.setTaskId(resultSet.getLong("task_id"));
        reminder.setReminderAt(resultSet.getTimestamp("reminder_at"));
        reminder.setReminderMessage(
                resultSet.getString("reminder_message"));
        reminder.setStatus(resultSet.getString("status"));
        reminder.setSentAt(resultSet.getTimestamp("sent_at"));
        reminder.setCreatedAt(resultSet.getTimestamp("created_at"));

        return reminder;
    }

    // Set an optional timestamp, preserving SQL NULL values
    private void setNullableTimestamp(
            PreparedStatement statement, int index, Timestamp value)
            throws SQLException {

        if (value != null) {
            statement.setTimestamp(index, value);
        } else {
            statement.setNull(index, Types.TIMESTAMP);
        }
    }

    // Validate reminder statuses allowed by the database
    private boolean isValidStatus(String status) {

        return "PENDING".equals(status)
                || "SENT".equals(status)
                || "CANCELLED".equals(status);
    }
}
