
package com.dayWise.service;

import java.sql.Timestamp;
import java.util.Collections;
import java.util.List;

import com.dayWise.dao.ReminderDAO;
import com.dayWise.dao.ReminderDAOImpl;
import com.dayWise.model.Reminder;

/**
 * Implements business rules for task reminders.
 */
public class ReminderServiceImpl implements ReminderService {

    private final ReminderDAO reminderDAO;

    public ReminderServiceImpl() {
        this(new ReminderDAOImpl());
    }

    public ReminderServiceImpl(ReminderDAO reminderDAO) {
        if (reminderDAO == null) {
            throw new IllegalArgumentException(
                    "ReminderDAO cannot be null.");
        }

        this.reminderDAO = reminderDAO;
    }

    @Override
    public boolean addReminder(Reminder reminder) {

        if (reminder == null
                || reminder.getUserId() <= 0
                || reminder.getTaskId() <= 0
                || reminder.getReminderAt() == null) {
            return false;
        }

        Timestamp reminderAt = reminder.getReminderAt();

        if (reminderAt.before(new Timestamp(System.currentTimeMillis()))) {
            return false;
        }

        String message = reminder.getReminderMessage();

        if (message != null) {
            message = message.trim();

            if (message.length() > 255) {
                return false;
            }

            reminder.setReminderMessage(
                    message.isEmpty() ? null : message);
        }

        // A newly created reminder must await delivery.
        reminder.setStatus("PENDING");
        reminder.setSentAt(null);

        return reminderDAO.addReminder(reminder);
    }

    @Override
    public List<Reminder> getRemindersByUserId(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<Reminder> reminders =
                reminderDAO.getRemindersByUserId(userId);

        return reminders != null
                ? reminders : Collections.emptyList();
    }

    @Override
    public List<Reminder> getDueReminders() {

        List<Reminder> reminders =
                reminderDAO.getDueReminders();

        return reminders != null
                ? reminders : Collections.emptyList();
    }

    @Override
    public Reminder getReminderById(long reminderId, long userId) {

        if (reminderId <= 0 || userId <= 0) {
            return null;
        }

        return reminderDAO.getReminderById(reminderId, userId);
    }

    @Override
    public boolean updateReminder(Reminder reminder) {

        if (reminder == null
                || reminder.getReminderId() <= 0
                || reminder.getUserId() <= 0
                || reminder.getTaskId() <= 0
                || reminder.getReminderAt() == null) {
            return false;
        }

        Reminder existingReminder =
                reminderDAO.getReminderById(
                        reminder.getReminderId(),
                        reminder.getUserId());

        if (existingReminder == null) {
            return false;
        }

        if (reminder.getReminderAt().before(
                new Timestamp(System.currentTimeMillis()))) {
            return false;
        }

        String message = reminder.getReminderMessage();

        if (message != null) {
            message = message.trim();

            if (message.length() > 255) {
                return false;
            }

            reminder.setReminderMessage(
                    message.isEmpty() ? null : message);
        }

        // Editing a reminder schedules it for delivery again.
        reminder.setStatus("PENDING");
        reminder.setSentAt(null);

        return reminderDAO.updateReminder(reminder);
    }

    @Override
    public boolean updateReminderStatus(long reminderId, long userId,
            String status) {

        if (reminderId <= 0 || userId <= 0 || status == null) {
            return false;
        }

        status = status.trim().toUpperCase();

        if (!isValidStatus(status)) {
            return false;
        }

        Reminder existingReminder =
                reminderDAO.getReminderById(reminderId, userId);

        if (existingReminder == null) {
            return false;
        }

        return reminderDAO.updateReminderStatus(
                reminderId, userId, status);
    }

    @Override
    public boolean deleteReminder(long reminderId, long userId) {

        if (reminderId <= 0 || userId <= 0) {
            return false;
        }

        Reminder existingReminder =
                reminderDAO.getReminderById(reminderId, userId);

        if (existingReminder == null) {
            return false;
        }

        return reminderDAO.deleteReminder(reminderId, userId);
    }

    private boolean isValidStatus(String status) {

        return "PENDING".equals(status)
                || "SENT".equals(status)
                || "CANCELLED".equals(status);
    }
}
