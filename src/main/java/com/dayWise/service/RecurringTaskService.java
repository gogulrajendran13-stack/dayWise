
package com.dayWise.service;

import java.util.List;

import com.dayWise.model.RecurringTask;

/**
 * Defines business operations for recurring tasks.
 */
public interface RecurringTaskService {

    boolean addRecurringTask(RecurringTask recurringTask);

    List<RecurringTask> getRecurringTasksByUserId(long userId);

    RecurringTask getRecurringTaskById(long recurringId, long userId);

    boolean updateRecurringTask(RecurringTask recurringTask);

    boolean updateRecurringTaskStatus(long recurringId, long userId,
            boolean active);

    boolean deleteRecurringTask(long recurringId, long userId);

    List<RecurringTask> getDueRecurringTasks();
}
