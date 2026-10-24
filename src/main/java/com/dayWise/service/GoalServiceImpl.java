
package com.dayWise.service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import com.dayWise.dao.GoalDAO;
import com.dayWise.dao.GoalDAOImpl;
import com.dayWise.model.Goal;

/**
 * Implements business rules for goal management.
 */
public class GoalServiceImpl implements GoalService {

    private final GoalDAO goalDAO;

    public GoalServiceImpl() {
        this(new GoalDAOImpl());
    }

    public GoalServiceImpl(GoalDAO goalDAO) {
        if (goalDAO == null) {
            throw new IllegalArgumentException(
                    "GoalDAO cannot be null.");
        }

        this.goalDAO = goalDAO;
    }

    @Override
    public boolean addGoal(Goal goal) {

        if (goal == null || goal.getUserId() <= 0
                || goal.getGoalTitle() == null) {
            return false;
        }

        String title = goal.getGoalTitle().trim();

        if (title.isEmpty() || title.length() > 200) {
            return false;
        }

        if (goal.getDescription() != null
                && goal.getDescription().length() > 65535) {
            return false;
        }

        BigDecimal target = goal.getTargetValue();
        BigDecimal current = goal.getCurrentValue();

        if (target != null && target.signum() < 0) {
            return false;
        }

        if (current == null) {
            current = BigDecimal.ZERO;
        }

        if (current.signum() < 0) {
            return false;
        }

        if (current.precision() > 10
                || current.scale() > 2) {
            return false;
        }

        if (target != null
                && (target.precision() > 10 || target.scale() > 2)) {
            return false;
        }

        if (goal.getUnit() != null
                && goal.getUnit().trim().length() > 30) {
            return false;
        }

        if (goal.getStartDate() != null
                && goal.getTargetDate() != null
                && goal.getTargetDate().before(goal.getStartDate())) {
            return false;
        }

        goal.setGoalTitle(title);
        goal.setCurrentValue(current);

        if (goal.getStatus() == null
                || goal.getStatus().trim().isEmpty()) {
            goal.setStatus("ACTIVE");
        } else {
            goal.setStatus(goal.getStatus().trim().toUpperCase());
        }

        if (!isValidStatus(goal.getStatus())) {
            return false;
        }

        return goalDAO.addGoal(goal);
    }

    @Override
    public List<Goal> getGoalsByUserId(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<Goal> goals = goalDAO.getGoalsByUserId(userId);

        return goals != null ? goals : Collections.emptyList();
    }

    @Override
    public List<Goal> getGoalsByStatus(long userId, String status) {

        if (userId <= 0 || status == null) {
            return Collections.emptyList();
        }

        status = status.trim().toUpperCase();

        if (!isValidStatus(status)) {
            return Collections.emptyList();
        }

        List<Goal> goals = goalDAO.getGoalsByStatus(userId, status);

        return goals != null ? goals : Collections.emptyList();
    }

    @Override
    public Goal getGoalById(long goalId, long userId) {

        if (goalId <= 0 || userId <= 0) {
            return null;
        }

        return goalDAO.getGoalById(goalId, userId);
    }

    @Override
    public boolean updateGoal(Goal goal) {

        if (goal == null || goal.getGoalId() <= 0
                || goal.getUserId() <= 0
                || goal.getGoalTitle() == null) {
            return false;
        }

        Goal existingGoal = goalDAO.getGoalById(
                goal.getGoalId(), goal.getUserId());

        if (existingGoal == null) {
            return false;
        }

        String title = goal.getGoalTitle().trim();

        if (title.isEmpty() || title.length() > 200) {
            return false;
        }

        if (goal.getTargetValue() != null
                && (goal.getTargetValue().signum() < 0
                || goal.getTargetValue().precision() > 10
                || goal.getTargetValue().scale() > 2)) {
            return false;
        }

        if (goal.getCurrentValue() == null
                || goal.getCurrentValue().signum() < 0
                || goal.getCurrentValue().precision() > 10
                || goal.getCurrentValue().scale() > 2) {
            return false;
        }

        if (goal.getUnit() != null
                && goal.getUnit().trim().length() > 30) {
            return false;
        }

        if (goal.getStartDate() != null
                && goal.getTargetDate() != null
                && goal.getTargetDate().before(goal.getStartDate())) {
            return false;
        }

        if (goal.getStatus() == null
                || !isValidStatus(
                        goal.getStatus().trim().toUpperCase())) {
            return false;
        }

        goal.setGoalTitle(title);
        goal.setStatus(goal.getStatus().trim().toUpperCase());

        return goalDAO.updateGoal(goal);
    }

    @Override
    public boolean updateGoalProgress(long goalId, long userId,
            BigDecimal currentValue) {

        if (goalId <= 0 || userId <= 0 || currentValue == null
                || currentValue.signum() < 0
                || currentValue.precision() > 10
                || currentValue.scale() > 2) {
            return false;
        }

        Goal goal = goalDAO.getGoalById(goalId, userId);

        if (goal == null) {
            return false;
        }

        return goalDAO.updateGoalProgress(
                goalId, userId, currentValue);
    }

    @Override
    public boolean updateGoalStatus(long goalId, long userId,
            String status) {

        if (goalId <= 0 || userId <= 0 || status == null) {
            return false;
        }

        status = status.trim().toUpperCase();

        if (!isValidStatus(status)) {
            return false;
        }

        Goal goal = goalDAO.getGoalById(goalId, userId);

        if (goal == null) {
            return false;
        }

        return goalDAO.updateGoalStatus(goalId, userId, status);
    }

    @Override
    public boolean deleteGoal(long goalId, long userId) {

        if (goalId <= 0 || userId <= 0) {
            return false;
        }

        Goal goal = goalDAO.getGoalById(goalId, userId);

        if (goal == null) {
            return false;
        }

        return goalDAO.deleteGoal(goalId, userId);
    }

    private boolean isValidStatus(String status) {

        return "ACTIVE".equals(status)
                || "COMPLETED".equals(status)
                || "ARCHIVED".equals(status);
    }
}
