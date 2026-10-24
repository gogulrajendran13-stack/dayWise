
package com.dayWise.service;

import java.util.List;

import com.dayWise.model.Notification;

/**
 * Defines business operations for user notifications.
 */
public interface NotificationService {

    boolean addNotification(Notification notification);

    List<Notification> getNotificationsByUserId(long userId);

    List<Notification> getUnreadNotifications(long userId);

    Notification getNotificationById(long notificationId, long userId);

    boolean markAsRead(long notificationId, long userId);

    boolean markAllAsRead(long userId);

    boolean deleteNotification(long notificationId, long userId);

    boolean deleteAllNotifications(long userId);
}
