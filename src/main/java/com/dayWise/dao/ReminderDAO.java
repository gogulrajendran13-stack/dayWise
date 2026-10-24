
package com.dayWise.dao;

import java.util.List;

import com.dayWise.model.Reminder;

public interface ReminderDAO {

    // Create a reminder for a task
    boolean addReminder(Reminder reminder);

    // Retrieve all reminders belonging to a user
    List<Reminder> getRemindersByUserId(long userId);

    // Retrieve pending reminders that are due
    List<Reminder> getDueReminders();

    // Retrieve one reminder by ID and owner
    Reminder getReminderById(long reminderId, long userId);

    // Update reminder details
    boolean updateReminder(Reminder reminder);

    // Change reminder status
    boolean updateReminderStatus(
            long reminderId, long userId, String status);

    // Delete a reminder belonging to a user
    boolean deleteReminder(long reminderId, long userId);
}
