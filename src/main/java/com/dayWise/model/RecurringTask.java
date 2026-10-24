
package com.dayWise.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Represents a recurring task rule in dayWise.
 * Maps to the recurring_tasks table in daywise_db.
 */
public class RecurringTask {

    private long recurringId;
    private long userId;
    private String title;
    private String description;
    private String frequency;
    private int repeatInterval;
    private String daysOfWeek;
    private Integer dayOfMonth;
    private Date startDate;
    private Date endDate;
    private Timestamp nextRunAt;
    private boolean active;
    private Timestamp createdAt;

    public RecurringTask() {
    }

    public long getRecurringId() {
        return recurringId;
    }

    public void setRecurringId(long recurringId) {
        this.recurringId = recurringId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public int getRepeatInterval() {
        return repeatInterval;
    }

    public void setRepeatInterval(int repeatInterval) {
        this.repeatInterval = repeatInterval;
    }

    public String getDaysOfWeek() {
        return daysOfWeek;
    }

    public void setDaysOfWeek(String daysOfWeek) {
        this.daysOfWeek = daysOfWeek;
    }

    public Integer getDayOfMonth() {
        return dayOfMonth;
    }

    public void setDayOfMonth(Integer dayOfMonth) {
        this.dayOfMonth = dayOfMonth;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Timestamp getNextRunAt() {
        return nextRunAt;
    }

    public void setNextRunAt(Timestamp nextRunAt) {
        this.nextRunAt = nextRunAt;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
