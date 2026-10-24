
package com.dayWise.dao;

import java.util.List;

import com.dayWise.model.Notification;

public interface NotificationDAO {

    // Create a notification for a user
    boolean addNotification(Notification notification);

    // Retrieve all notifications belonging to a user
    List<Notification> getNotificationsByUserId(long userId);

    // Retrieve unread notifications belonging to a user
    List<Notification> getUnreadNotifications(long userId);

    // Retrieve one notification by ID and owner
    Notification getNotificationById(
            long notificationId, long userId);

    // Mark one notification as read
    boolean markAsRead(long notificationId, long userId);

    // Mark all notifications as read for a user
    boolean markAllAsRead(long userId);

    // Delete one notification belonging to a user
    boolean deleteNotification(long notificationId, long userId);

    // Delete all notifications belonging to a user
    boolean deleteAllNotifications(long userId);
}
