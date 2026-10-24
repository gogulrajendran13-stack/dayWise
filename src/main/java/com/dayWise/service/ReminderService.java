
package com.dayWise.service;

import java.util.List;

import com.dayWise.model.Reminder;

/**
 * Defines business operations for managing task reminders.
 */
public interface ReminderService {

    boolean addReminder(Reminder reminder);

    List<Reminder> getRemindersByUserId(long userId);

    List<Reminder> getDueReminders();

    Reminder getReminderById(long reminderId, long userId);

    boolean updateReminder(Reminder reminder);

    boolean updateReminderStatus(long reminderId, long userId,
            String status);

    boolean deleteReminder(long reminderId, long userId);
}
