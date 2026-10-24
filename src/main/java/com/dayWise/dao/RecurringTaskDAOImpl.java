
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.dayWise.model.RecurringTask;
import com.dayWise.util.DBConnection;

public class RecurringTaskDAOImpl implements RecurringTaskDAO {

    // Create a recurring task rule
    @Override
    public boolean addRecurringTask(RecurringTask recurringTask) {

        String sql = "INSERT INTO recurring_tasks "
                + "(user_id, title, description, frequency, "
                + "repeat_interval, days_of_week, day_of_month, "
                + "start_date, end_date, next_run_at, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, recurringTask.getUserId());
            statement.setString(2, recurringTask.getTitle());
            statement.setString(3, recurringTask.getDescription());
            statement.setString(4, recurringTask.getFrequency());
            statement.setInt(5, recurringTask.getRepeatInterval());
            statement.setString(6, recurringTask.getDaysOfWeek());

            if (recurringTask.getDayOfMonth() != null) {
                statement.setInt(7, recurringTask.getDayOfMonth());
            } else {
                statement.setNull(7, Types.TINYINT);
            }

            statement.setDate(8, recurringTask.getStartDate());

            if (recurringTask.getEndDate() != null) {
                statement.setDate(9, recurringTask.getEndDate());
            } else {
                statement.setNull(9, Types.DATE);
            }

            if (recurringTask.getNextRunAt() != null) {
                statement.setTimestamp(10, recurringTask.getNextRunAt());
            } else {
                statement.setNull(10, Types.TIMESTAMP);
            }

            statement.setBoolean(11, recurringTask.isActive());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error creating recurring task.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve recurring task rules belonging to a user
    @Override
    public List<RecurringTask> getRecurringTasksByUserId(long userId) {

        List<RecurringTask> recurringTasks = new ArrayList<>();

        String sql = "SELECT * FROM recurring_tasks "
                + "WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    recurringTasks.add(mapRecurringTask(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving recurring tasks.");
            e.printStackTrace();
        }

        return recurringTasks;
    }

    // Retrieve one recurring rule only if it belongs to the user
    @Override
    public RecurringTask getRecurringTaskById(
            long recurringId, long userId) {

        String sql = "SELECT * FROM recurring_tasks "
                + "WHERE recurring_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, recurringId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapRecurringTask(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving recurring task.");
            e.printStackTrace();
        }

        return null;
    }

    // Update a recurring task rule while checking ownership
    @Override
    public boolean updateRecurringTask(RecurringTask recurringTask) {

        String sql = "UPDATE recurring_tasks SET "
                + "title = ?, description = ?, frequency = ?, "
                + "repeat_interval = ?, days_of_week = ?, "
                + "day_of_month = ?, start_date = ?, end_date = ?, "
                + "next_run_at = ?, is_active = ? "
                + "WHERE recurring_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, recurringTask.getTitle());
            statement.setString(2, recurringTask.getDescription());
            statement.setString(3, recurringTask.getFrequency());
            statement.setInt(4, recurringTask.getRepeatInterval());
            statement.setString(5, recurringTask.getDaysOfWeek());

            if (recurringTask.getDayOfMonth() != null) {
                statement.setInt(6, recurringTask.getDayOfMonth());
            } else {
                statement.setNull(6, Types.TINYINT);
            }

            statement.setDate(7, recurringTask.getStartDate());

            if (recurringTask.getEndDate() != null) {
                statement.setDate(8, recurringTask.getEndDate());
            } else {
                statement.setNull(8, Types.DATE);
            }

            if (recurringTask.getNextRunAt() != null) {
                statement.setTimestamp(9, recurringTask.getNextRunAt());
            } else {
                statement.setNull(9, Types.TIMESTAMP);
            }

            statement.setBoolean(10, recurringTask.isActive());
            statement.setLong(11, recurringTask.getRecurringId());
            statement.setLong(12, recurringTask.getUserId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating recurring task.");
            e.printStackTrace();
            return false;
        }
    }

    // Activate or pause a recurring task rule
    @Override
    public boolean updateRecurringTaskStatus(
            long recurringId, long userId, boolean active) {

        String sql = "UPDATE recurring_tasks SET is_active = ? "
                + "WHERE recurring_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setBoolean(1, active);
            statement.setLong(2, recurringId);
            statement.setLong(3, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error changing recurring task status.");
            e.printStackTrace();
            return false;
        }
    }

    // Delete a recurring rule only if it belongs to the user
    @Override
    public boolean deleteRecurringTask(long recurringId, long userId) {

        String sql = "DELETE FROM recurring_tasks "
                + "WHERE recurring_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, recurringId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting recurring task.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve active recurring rules whose next run time has arrived
    @Override
    public List<RecurringTask> getDueRecurringTasks() {

        List<RecurringTask> recurringTasks = new ArrayList<>();

        String sql = "SELECT * FROM recurring_tasks "
                + "WHERE is_active = TRUE "
                + "AND next_run_at IS NOT NULL "
                + "AND next_run_at <= CURRENT_TIMESTAMP "
                + "AND start_date <= CURRENT_DATE "
                + "AND (end_date IS NULL OR end_date >= CURRENT_DATE) "
                + "ORDER BY next_run_at ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                recurringTasks.add(mapRecurringTask(resultSet));
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving due recurring tasks.");
            e.printStackTrace();
        }

        return recurringTasks;
    }

    // Convert a database row into a RecurringTask object
    private RecurringTask mapRecurringTask(ResultSet resultSet)
            throws SQLException {

        RecurringTask recurringTask = new RecurringTask();

        recurringTask.setRecurringId(
                resultSet.getLong("recurring_id"));
        recurringTask.setUserId(resultSet.getLong("user_id"));
        recurringTask.setTitle(resultSet.getString("title"));
        recurringTask.setDescription(resultSet.getString("description"));
        recurringTask.setFrequency(resultSet.getString("frequency"));
        recurringTask.setRepeatInterval(
                resultSet.getInt("repeat_interval"));
        recurringTask.setDaysOfWeek(
                resultSet.getString("days_of_week"));

        int dayOfMonth = resultSet.getInt("day_of_month");
        recurringTask.setDayOfMonth(
                resultSet.wasNull() ? null : dayOfMonth);

        Date startDate = resultSet.getDate("start_date");
        recurringTask.setStartDate(startDate);

        Date endDate = resultSet.getDate("end_date");
        recurringTask.setEndDate(endDate);

        Timestamp nextRunAt = resultSet.getTimestamp("next_run_at");
        recurringTask.setNextRunAt(nextRunAt);

        recurringTask.setActive(resultSet.getBoolean("is_active"));
        recurringTask.setCreatedAt(resultSet.getTimestamp("created_at"));

        return recurringTask;
    }
}
