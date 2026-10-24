
package com.dayWise.service;

import java.util.Collections;
import java.util.List;

import com.dayWise.dao.RecurringTaskDAO;
import com.dayWise.dao.RecurringTaskDAOImpl;
import com.dayWise.model.RecurringTask;

/**
 * Implements business rules for recurring-task schedules.
 */
public class RecurringTaskServiceImpl
        implements RecurringTaskService {

    private final RecurringTaskDAO recurringTaskDAO;

    public RecurringTaskServiceImpl() {
        this(new RecurringTaskDAOImpl());
    }

    public RecurringTaskServiceImpl(
            RecurringTaskDAO recurringTaskDAO) {

        if (recurringTaskDAO == null) {
            throw new IllegalArgumentException(
                    "RecurringTaskDAO cannot be null.");
        }

        this.recurringTaskDAO = recurringTaskDAO;
    }

    @Override
    public boolean addRecurringTask(RecurringTask recurringTask) {

        if (recurringTask == null
                || recurringTask.getUserId() <= 0
                || recurringTask.getTitle() == null
                || recurringTask.getStartDate() == null) {
            return false;
        }

        String title = recurringTask.getTitle().trim();

        if (title.isEmpty() || title.length() > 200) {
            return false;
        }

        recurringTask.setTitle(title);

        if (recurringTask.getDescription() != null
                && recurringTask.getDescription().length() > 65535) {
            return false;
        }

        String frequency = recurringTask.getFrequency();

        if (frequency == null) {
            return false;
        }

        frequency = frequency.trim().toUpperCase();

        if (!isValidFrequency(frequency)) {
            return false;
        }

        recurringTask.setFrequency(frequency);

        if (recurringTask.getRepeatInterval() < 1
                || recurringTask.getRepeatInterval() > 365) {
            return false;
        }

        if (recurringTask.getEndDate() != null
                && recurringTask.getEndDate().before(
                        recurringTask.getStartDate())) {
            return false;
        }

        if ("WEEKLY".equals(frequency)) {
            if (!isValidDaysOfWeek(
                    recurringTask.getDaysOfWeek())) {
                return false;
            }
        }

        if ("MONTHLY".equals(frequency)) {
            Integer day = recurringTask.getDayOfMonth();

            if (day == null || day < 1 || day > 31) {
                return false;
            }
        }

        // New schedules are active by default.
        recurringTask.setActive(true);

        return recurringTaskDAO.addRecurringTask(recurringTask);
    }

    @Override
    public List<RecurringTask> getRecurringTasksByUserId(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<RecurringTask> recurringTasks =
                recurringTaskDAO.getRecurringTasksByUserId(userId);

        return recurringTasks != null
                ? recurringTasks : Collections.emptyList();
    }

    @Override
    public RecurringTask getRecurringTaskById(
            long recurringId, long userId) {

        if (recurringId <= 0 || userId <= 0) {
            return null;
        }

        return recurringTaskDAO.getRecurringTaskById(
                recurringId, userId);
    }

    @Override
    public boolean updateRecurringTask(
            RecurringTask recurringTask) {

        if (recurringTask == null
                || recurringTask.getRecurringId() <= 0
                || recurringTask.getUserId() <= 0
                || recurringTask.getTitle() == null
                || recurringTask.getStartDate() == null) {
            return false;
        }

        RecurringTask existingTask =
                recurringTaskDAO.getRecurringTaskById(
                        recurringTask.getRecurringId(),
                        recurringTask.getUserId());

        if (existingTask == null) {
            return false;
        }

        String title = recurringTask.getTitle().trim();

        if (title.isEmpty() || title.length() > 200) {
            return false;
        }

        recurringTask.setTitle(title);

        String frequency = recurringTask.getFrequency();

        if (frequency == null) {
            return false;
        }

        frequency = frequency.trim().toUpperCase();

        if (!isValidFrequency(frequency)) {
            return false;
        }

        recurringTask.setFrequency(frequency);

        if (recurringTask.getRepeatInterval() < 1
                || recurringTask.getRepeatInterval() > 365) {
            return false;
        }

        if (recurringTask.getEndDate() != null
                && recurringTask.getEndDate().before(
                        recurringTask.getStartDate())) {
            return false;
        }

        if ("WEEKLY".equals(frequency)
                && !isValidDaysOfWeek(
                        recurringTask.getDaysOfWeek())) {
            return false;
        }

        if ("MONTHLY".equals(frequency)) {
            Integer day = recurringTask.getDayOfMonth();

            if (day == null || day < 1 || day > 31) {
                return false;
            }
        }

        return recurringTaskDAO.updateRecurringTask(recurringTask);
    }

    @Override
    public boolean updateRecurringTaskStatus(
            long recurringId, long userId, boolean active) {

        if (recurringId <= 0 || userId <= 0) {
            return false;
        }

        RecurringTask existingTask =
                recurringTaskDAO.getRecurringTaskById(
                        recurringId, userId);

        if (existingTask == null) {
            return false;
        }

        return recurringTaskDAO.updateRecurringTaskStatus(
                recurringId, userId, active);
    }

    @Override
    public boolean deleteRecurringTask(long recurringId, long userId) {

        if (recurringId <= 0 || userId <= 0) {
            return false;
        }

        RecurringTask existingTask =
                recurringTaskDAO.getRecurringTaskById(
                        recurringId, userId);

        if (existingTask == null) {
            return false;
        }

        return recurringTaskDAO.deleteRecurringTask(
                recurringId, userId);
    }

    @Override
    public List<RecurringTask> getDueRecurringTasks() {

        List<RecurringTask> recurringTasks =
                recurringTaskDAO.getDueRecurringTasks();

        return recurringTasks != null
                ? recurringTasks : Collections.emptyList();
    }

    private boolean isValidFrequency(String frequency) {

        return "DAILY".equals(frequency)
                || "WEEKLY".equals(frequency)
                || "MONTHLY".equals(frequency)
                || "YEARLY".equals(frequency)
                || "CUSTOM".equals(frequency);
    }

    /**
     * Accepts comma-separated weekday abbreviations, for example:
     * MON,WED,FRI
     */
    private boolean isValidDaysOfWeek(String daysOfWeek) {

        if (daysOfWeek == null || daysOfWeek.trim().isEmpty()) {
            return false;
        }

        String[] days = daysOfWeek.toUpperCase().split(",");

        for (String day : days) {
            String value = day.trim();

            if (!value.equals("MON")
                    && !value.equals("TUE")
                    && !value.equals("WED")
                    && !value.equals("THU")
                    && !value.equals("FRI")
                    && !value.equals("SAT")
                    && !value.equals("SUN")) {
                return false;
            }
        }

        return days.length > 0;
    }
}
