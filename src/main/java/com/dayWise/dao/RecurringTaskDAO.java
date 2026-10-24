
package com.dayWise.dao;

import java.util.List;

import com.dayWise.model.RecurringTask;

public interface RecurringTaskDAO {

    // Create a recurring task rule for a user
    boolean addRecurringTask(RecurringTask recurringTask);

    // Retrieve all recurring task rules belonging to a user
    List<RecurringTask> getRecurringTasksByUserId(long userId);

    // Retrieve one recurring task rule by ID and owner
    RecurringTask getRecurringTaskById(
            long recurringId, long userId);

    // Update a recurring task rule
    boolean updateRecurringTask(RecurringTask recurringTask);

    // Enable or disable a recurring task rule
    boolean updateRecurringTaskStatus(
            long recurringId, long userId, boolean active);

    // Delete a recurring task rule belonging to a user
    boolean deleteRecurringTask(long recurringId, long userId);

    // Retrieve active recurring rules that are due to run
    List<RecurringTask> getDueRecurringTasks();
}
