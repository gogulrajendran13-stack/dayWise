
package com.dayWise.service;

import java.math.BigDecimal;
import java.util.List;

import com.dayWise.model.Goal;

/**
 * Defines business operations for managing user goals.
 */
public interface GoalService {

    boolean addGoal(Goal goal);

    List<Goal> getGoalsByUserId(long userId);

    List<Goal> getGoalsByStatus(long userId, String status);

    Goal getGoalById(long goalId, long userId);

    boolean updateGoal(Goal goal);

    boolean updateGoalProgress(long goalId, long userId,
            BigDecimal currentValue);

    boolean updateGoalStatus(long goalId, long userId,
            String status);

    boolean deleteGoal(long goalId, long userId);
}
