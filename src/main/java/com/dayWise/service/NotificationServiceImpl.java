
package com.dayWise.service;

import java.util.Collections;
import java.util.List;

import com.dayWise.dao.NotificationDAO;
import com.dayWise.dao.NotificationDAOImpl;
import com.dayWise.model.Notification;

/**
 * Implements business rules for managing notifications.
 */
public class NotificationServiceImpl implements NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationServiceImpl() {
        this(new NotificationDAOImpl());
    }

    public NotificationServiceImpl(NotificationDAO notificationDAO) {
        if (notificationDAO == null) {
            throw new IllegalArgumentException(
                    "NotificationDAO cannot be null.");
        }

        this.notificationDAO = notificationDAO;
    }

    @Override
    public boolean addNotification(Notification notification) {

        if (notification == null
                || notification.getUserId() <= 0
                || notification.getTitle() == null
                || notification.getMessage() == null
                || notification.getNotificationType() == null) {
            return false;
        }

        String title = notification.getTitle().trim();
        String message = notification.getMessage().trim();
        String type = notification.getNotificationType()
                .trim().toUpperCase();

        if (title.isEmpty() || title.length() > 150
                || message.isEmpty() || message.length() > 500
                || !isValidType(type)) {
            return false;
        }

        notification.setTitle(title);
        notification.setMessage(message);
        notification.setNotificationType(type);
        notification.setRead(false);

        return notificationDAO.addNotification(notification);
    }

    @Override
    public List<Notification> getNotificationsByUserId(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<Notification> notifications =
                notificationDAO.getNotificationsByUserId(userId);

        return notifications != null
                ? notifications : Collections.emptyList();
    }

    @Override
    public List<Notification> getUnreadNotifications(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<Notification> notifications =
                notificationDAO.getUnreadNotifications(userId);

        return notifications != null
                ? notifications : Collections.emptyList();
    }

    @Override
    public Notification getNotificationById(
            long notificationId, long userId) {

        if (notificationId <= 0 || userId <= 0) {
            return null;
        }

        return notificationDAO.getNotificationById(
                notificationId, userId);
    }

    @Override
    public boolean markAsRead(long notificationId, long userId) {

        if (notificationId <= 0 || userId <= 0) {
            return false;
        }

        Notification notification =
                notificationDAO.getNotificationById(
                        notificationId, userId);

        if (notification == null) {
            return false;
        }

        if (notification.isRead()) {
            return true;
        }

        return notificationDAO.markAsRead(notificationId, userId);
    }

    @Override
    public boolean markAllAsRead(long userId) {

        if (userId <= 0) {
            return false;
        }

        return notificationDAO.markAllAsRead(userId);
    }

    @Override
    public boolean deleteNotification(
            long notificationId, long userId) {

        if (notificationId <= 0 || userId <= 0) {
            return false;
        }

        Notification notification =
                notificationDAO.getNotificationById(
                        notificationId, userId);

        if (notification == null) {
            return false;
        }

        return notificationDAO.deleteNotification(
                notificationId, userId);
    }

    @Override
    public boolean deleteAllNotifications(long userId) {

        if (userId <= 0) {
            return false;
        }

        return notificationDAO.deleteAllNotifications(userId);
    }

    /**
     * Accepts notification types used by the application.
     */
    private boolean isValidType(String type) {

        return "TASK".equals(type)
                || "REMINDER".equals(type)
                || "PROJECT".equals(type)
                || "GOAL".equals(type)
                || "SYSTEM".equals(type)
                || "FOCUS".equals(type)
                || "GENERAL".equals(type);
    }
}
