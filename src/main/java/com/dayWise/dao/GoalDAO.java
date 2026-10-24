
package com.dayWise.dao;

import java.util.List;

import com.dayWise.model.Goal;

public interface GoalDAO {

    // Create a new goal for a user
    boolean addGoal(Goal goal);

    // Retrieve all goals belonging to a user
    List<Goal> getGoalsByUserId(long userId);

    // Retrieve goals belonging to a user with a specific status
    List<Goal> getGoalsByStatus(long userId, String status);

    // Retrieve one goal by its ID and owner
    Goal getGoalById(long goalId, long userId);

    // Update goal details and progress
    boolean updateGoal(Goal goal);

    // Update the current progress of a goal
    boolean updateGoalProgress(long goalId, long userId,
                               java.math.BigDecimal currentValue);

    // Update the status of a goal
    boolean updateGoalStatus(long goalId, long userId, String status);

    // Delete a goal belonging to a specific user
    boolean deleteGoal(long goalId, long userId);
}
