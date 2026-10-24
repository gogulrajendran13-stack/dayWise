
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dayWise.model.Notification;
import com.dayWise.util.DBConnection;

public class NotificationDAOImpl implements NotificationDAO {

    // Create a notification for a user
    @Override
    public boolean addNotification(Notification notification) {

        String sql = "INSERT INTO notifications "
                + "(user_id, task_id, notification_type, "
                + "title, message, is_read) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, notification.getUserId());

            // task_id is optional in the notifications table
            if (notification.getTaskId() != null) {
                statement.setLong(2, notification.getTaskId());
            } else {
                statement.setNull(2, java.sql.Types.BIGINT);
            }

            statement.setString(3, notification.getNotificationType());
            statement.setString(4, notification.getTitle());
            statement.setString(5, notification.getMessage());
            statement.setBoolean(6, notification.isRead());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error creating notification.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve all notifications belonging to a user
    @Override
    public List<Notification> getNotificationsByUserId(long userId) {

        List<Notification> notifications = new ArrayList<>();

        String sql = "SELECT * FROM notifications "
                + "WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    notifications.add(mapNotification(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving notifications.");
            e.printStackTrace();
        }

        return notifications;
    }

    // Retrieve unread notifications belonging to a user
    @Override
    public List<Notification> getUnreadNotifications(long userId) {

        List<Notification> notifications = new ArrayList<>();

        String sql = "SELECT * FROM notifications "
                + "WHERE user_id = ? AND is_read = FALSE "
                + "ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    notifications.add(mapNotification(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving unread notifications.");
            e.printStackTrace();
        }

        return notifications;
    }

    // Retrieve one notification only if it belongs to the user
    @Override
    public Notification getNotificationById(
            long notificationId, long userId) {

        String sql = "SELECT * FROM notifications "
                + "WHERE notification_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, notificationId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapNotification(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving notification.");
            e.printStackTrace();
        }

        return null;
    }

    // Mark one notification as read
    @Override
    public boolean markAsRead(long notificationId, long userId) {

        String sql = "UPDATE notifications SET is_read = TRUE "
                + "WHERE notification_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, notificationId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error marking notification as read.");
            e.printStackTrace();
            return false;
        }
    }

    // Mark all notifications as read for a user
    @Override
    public boolean markAllAsRead(long userId) {

        String sql = "UPDATE notifications SET is_read = TRUE "
                + "WHERE user_id = ? AND is_read = FALSE";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            // No unread notifications is also a valid outcome.
            // executeUpdate() returns zero when no rows change.
            statement.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error marking all notifications as read.");
            e.printStackTrace();
            return false;
        }
    }

    // Delete one notification only if it belongs to the user
    @Override
    public boolean deleteNotification(
            long notificationId, long userId) {

        String sql = "DELETE FROM notifications "
                + "WHERE notification_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, notificationId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting notification.");
            e.printStackTrace();
            return false;
        }
    }

    // Delete all notifications belonging to a user
    @Override
    public boolean deleteAllNotifications(long userId) {

        String sql = "DELETE FROM notifications WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            // Succeed even if the user has no notifications to delete.
            statement.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error deleting all notifications.");
            e.printStackTrace();
            return false;
        }
    }

    // Convert a database row into a Notification object
    private Notification mapNotification(ResultSet resultSet)
            throws SQLException {

        Notification notification = new Notification();

        notification.setNotificationId(
                resultSet.getLong("notification_id"));
        notification.setUserId(resultSet.getLong("user_id"));

        long taskId = resultSet.getLong("task_id");
        notification.setTaskId(
                resultSet.wasNull() ? null : taskId);

        notification.setNotificationType(
                resultSet.getString("notification_type"));
        notification.setTitle(resultSet.getString("title"));
        notification.setMessage(resultSet.getString("message"));
        notification.setRead(resultSet.getBoolean("is_read"));
        notification.setCreatedAt(
                resultSet.getTimestamp("created_at"));

        return notification;
    }
}
