
package com.dayWise.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.dayWise.model.Goal;
import com.dayWise.util.DBConnection;

public class GoalDAOImpl implements GoalDAO {

    // Create a new goal for a user
    @Override
    public boolean addGoal(Goal goal) {

        String sql = "INSERT INTO goals "
                + "(user_id, goal_title, description, target_value, "
                + "current_value, unit, start_date, target_date, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, goal.getUserId());
            statement.setString(2, goal.getGoalTitle());
            statement.setString(3, goal.getDescription());

            setNullableDecimal(statement, 4, goal.getTargetValue());

            BigDecimal currentValue = goal.getCurrentValue();
            statement.setBigDecimal(
                    5, currentValue == null ? BigDecimal.ZERO : currentValue);

            statement.setString(6, goal.getUnit());
            setNullableDate(statement, 7, goal.getStartDate());
            setNullableDate(statement, 8, goal.getTargetDate());

            String status = goal.getStatus() == null
                    ? "ACTIVE" : goal.getStatus();

            if (!isValidStatus(status)) {
                return false;
            }

            statement.setString(9, status);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error creating goal.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve all goals belonging to a user
    @Override
    public List<Goal> getGoalsByUserId(long userId) {

        List<Goal> goals = new ArrayList<>();

        String sql = "SELECT * FROM goals "
                + "WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    goals.add(mapGoal(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving goals.");
            e.printStackTrace();
        }

        return goals;
    }

    // Retrieve goals with a particular status
    @Override
    public List<Goal> getGoalsByStatus(long userId, String status) {

        List<Goal> goals = new ArrayList<>();

        if (!isValidStatus(status)) {
            return goals;
        }

        String sql = "SELECT * FROM goals "
                + "WHERE user_id = ? AND status = ? "
                + "ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);
            statement.setString(2, status);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    goals.add(mapGoal(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving goals by status.");
            e.printStackTrace();
        }

        return goals;
    }

    // Retrieve one goal only when it belongs to the specified user
    @Override
    public Goal getGoalById(long goalId, long userId) {

        String sql = "SELECT * FROM goals "
                + "WHERE goal_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, goalId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapGoal(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving goal by ID.");
            e.printStackTrace();
        }

        return null;
    }

    // Update goal details while checking ownership
    @Override
    public boolean updateGoal(Goal goal) {

        String sql = "UPDATE goals SET "
                + "goal_title = ?, description = ?, target_value = ?, "
                + "current_value = ?, unit = ?, start_date = ?, "
                + "target_date = ?, status = ? "
                + "WHERE goal_id = ? AND user_id = ?";

        String status = goal.getStatus() == null
                ? "ACTIVE" : goal.getStatus();

        if (!isValidStatus(status)) {
            return false;
        }

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, goal.getGoalTitle());
            statement.setString(2, goal.getDescription());

            setNullableDecimal(statement, 3, goal.getTargetValue());

            BigDecimal currentValue = goal.getCurrentValue();
            statement.setBigDecimal(
                    4, currentValue == null ? BigDecimal.ZERO : currentValue);

            statement.setString(5, goal.getUnit());
            setNullableDate(statement, 6, goal.getStartDate());
            setNullableDate(statement, 7, goal.getTargetDate());
            statement.setString(8, status);
            statement.setLong(9, goal.getGoalId());
            statement.setLong(10, goal.getUserId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating goal.");
            e.printStackTrace();
            return false;
        }
    }

    // Update the current progress of a goal
    @Override
    public boolean updateGoalProgress(
            long goalId, long userId, BigDecimal currentValue) {

        if (currentValue == null
                || currentValue.compareTo(BigDecimal.ZERO) < 0) {
            return false;
        }

        String sql = "UPDATE goals SET current_value = ? "
                + "WHERE goal_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setBigDecimal(1, currentValue);
            statement.setLong(2, goalId);
            statement.setLong(3, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating goal progress.");
            e.printStackTrace();
            return false;
        }
    }

    // Update a goal's status
    @Override
    public boolean updateGoalStatus(
            long goalId, long userId, String status) {

        if (!isValidStatus(status)) {
            return false;
        }

        String sql = "UPDATE goals SET status = ? "
                + "WHERE goal_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setLong(2, goalId);
            statement.setLong(3, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating goal status.");
            e.printStackTrace();
            return false;
        }
    }

    // Delete a goal only when it belongs to the specified user
    @Override
    public boolean deleteGoal(long goalId, long userId) {

        String sql = "DELETE FROM goals "
                + "WHERE goal_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, goalId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting goal.");
            e.printStackTrace();
            return false;
        }
    }

    // Convert a database row into a Goal object
    private Goal mapGoal(ResultSet resultSet) throws SQLException {

        Goal goal = new Goal();

        goal.setGoalId(resultSet.getLong("goal_id"));
        goal.setUserId(resultSet.getLong("user_id"));
        goal.setGoalTitle(resultSet.getString("goal_title"));
        goal.setDescription(resultSet.getString("description"));
        goal.setTargetValue(resultSet.getBigDecimal("target_value"));
        goal.setCurrentValue(resultSet.getBigDecimal("current_value"));
        goal.setUnit(resultSet.getString("unit"));

        Date startDate = resultSet.getDate("start_date");
        goal.setStartDate(startDate);

        Date targetDate = resultSet.getDate("target_date");
        goal.setTargetDate(targetDate);

        goal.setStatus(resultSet.getString("status"));
        goal.setCreatedAt(resultSet.getTimestamp("created_at"));
        goal.setUpdatedAt(resultSet.getTimestamp("updated_at"));

        return goal;
    }

    // Set a nullable decimal value
    private void setNullableDecimal(
            PreparedStatement statement, int index, BigDecimal value)
            throws SQLException {

        if (value != null) {
            statement.setBigDecimal(index, value);
        } else {
            statement.setNull(index, Types.DECIMAL);
        }
    }

    // Set an optional SQL DATE value
    private void setNullableDate(
            PreparedStatement statement, int index, Date value)
            throws SQLException {

        if (value != null) {
            statement.setDate(index, value);
        } else {
            statement.setNull(index, Types.DATE);
        }
    }

    // Validate statuses supported by the goals table
    private boolean isValidStatus(String status) {

        return "ACTIVE".equals(status)
                || "COMPLETED".equals(status)
                || "ARCHIVED".equals(status);
    }
}
