
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.dayWise.model.Task;
import com.dayWise.util.DBConnection;

public class TaskDAOImpl implements TaskDAO {

    // Create a new task
    @Override
    public boolean addTask(Task task) {

        String sql = "INSERT INTO tasks "
                + "(user_id, project_id, category_id, parent_task_id, "
                + "title, description, priority, status, due_at, "
                + "position_order, estimated_minutes, completed_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, task.getUserId());
            setNullableLong(statement, 2, task.getProjectId());
            setNullableLong(statement, 3, task.getCategoryId());
            setNullableLong(statement, 4, task.getParentTaskId());

            statement.setString(5, task.getTitle());
            statement.setString(6, task.getDescription());
            statement.setString(7, task.getPriority());
            statement.setString(8, task.getStatus());
            setNullableTimestamp(statement, 9, task.getDueAt());

            statement.setInt(10, task.getPositionOrder());

            if (task.getEstimatedMinutes() != null) {
                statement.setInt(11, task.getEstimatedMinutes());
            } else {
                statement.setNull(11, Types.INTEGER);
            }

            setNullableTimestamp(statement, 12, task.getCompletedAt());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error creating task.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve all tasks belonging to a user
    @Override
    public List<Task> getTasksByUserId(long userId) {

        List<Task> tasks = new ArrayList<>();

        String sql = "SELECT * FROM tasks "
                + "WHERE user_id = ? "
                + "ORDER BY position_order ASC, created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    tasks.add(mapTask(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving tasks.");
            e.printStackTrace();
        }

        return tasks;
    }

    // Retrieve tasks belonging to a user with a specific status
    @Override
    public List<Task> getTasksByStatus(long userId, String status) {

        List<Task> tasks = new ArrayList<>();

        if (!isValidStatus(status)) {
            return tasks;
        }

        String sql = "SELECT * FROM tasks "
                + "WHERE user_id = ? AND status = ? "
                + "ORDER BY position_order ASC, created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);
            statement.setString(2, status);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    tasks.add(mapTask(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving tasks by status.");
            e.printStackTrace();
        }

        return tasks;
    }

    // Retrieve one task only when it belongs to the specified user
    @Override
    public Task getTaskById(long taskId, long userId) {

        String sql = "SELECT * FROM tasks "
                + "WHERE task_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, taskId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapTask(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving task by ID.");
            e.printStackTrace();
        }

        return null;
    }

    // Update task details while checking ownership
    @Override
    public boolean updateTask(Task task) {

        String sql = "UPDATE tasks SET "
                + "project_id = ?, category_id = ?, parent_task_id = ?, "
                + "title = ?, description = ?, priority = ?, status = ?, "
                + "due_at = ?, position_order = ?, estimated_minutes = ?, "
                + "completed_at = ? "
                + "WHERE task_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            setNullableLong(statement, 1, task.getProjectId());
            setNullableLong(statement, 2, task.getCategoryId());
            setNullableLong(statement, 3, task.getParentTaskId());

            statement.setString(4, task.getTitle());
            statement.setString(5, task.getDescription());
            statement.setString(6, task.getPriority());
            statement.setString(7, task.getStatus());
            setNullableTimestamp(statement, 8, task.getDueAt());

            statement.setInt(9, task.getPositionOrder());

            if (task.getEstimatedMinutes() != null) {
                statement.setInt(10, task.getEstimatedMinutes());
            } else {
                statement.setNull(10, Types.INTEGER);
            }

            setNullableTimestamp(statement, 11, task.getCompletedAt());

            statement.setLong(12, task.getTaskId());
            statement.setLong(13, task.getUserId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating task.");
            e.printStackTrace();
            return false;
        }
    }

    // Update a task's status
    @Override
    public boolean updateTaskStatus(
            long taskId, long userId, String status) {

        if (!isValidStatus(status)) {
            return false;
        }

        String sql = "UPDATE tasks SET status = ?, "
                + "completed_at = CASE WHEN ? = 'COMPLETED' "
                + "THEN CURRENT_TIMESTAMP ELSE NULL END "
                + "WHERE task_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setString(2, status);
            statement.setLong(3, taskId);
            statement.setLong(4, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating task status.");
            e.printStackTrace();
            return false;
        }
    }

    // Save a task's position after dashboard reordering
    @Override
    public boolean updateTaskPosition(
            long taskId, long userId, int positionOrder) {

        String sql = "UPDATE tasks SET position_order = ? "
                + "WHERE task_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, positionOrder);
            statement.setLong(2, taskId);
            statement.setLong(3, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating task position.");
            e.printStackTrace();
            return false;
        }
    }

    // Delete a task only when it belongs to the specified user
    @Override
    public boolean deleteTask(long taskId, long userId) {

        String sql = "DELETE FROM tasks "
                + "WHERE task_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, taskId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting task.");
            e.printStackTrace();
            return false;
        }
    }

    // Search task titles and descriptions for a specific user
    @Override
    public List<Task> searchTasks(long userId, String keyword) {

        List<Task> tasks = new ArrayList<>();

        String sql = "SELECT * FROM tasks "
                + "WHERE user_id = ? "
                + "AND (title LIKE ? OR description LIKE ?) "
                + "ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            String searchPattern = "%"
                    + (keyword == null ? "" : keyword.trim())
                    + "%";

            statement.setLong(1, userId);
            statement.setString(2, searchPattern);
            statement.setString(3, searchPattern);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    tasks.add(mapTask(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error searching tasks.");
            e.printStackTrace();
        }

        return tasks;
    }

    // Convert a database row into a Task object
    private Task mapTask(ResultSet resultSet) throws SQLException {

        Task task = new Task();

        task.setTaskId(resultSet.getLong("task_id"));
        task.setUserId(resultSet.getLong("user_id"));

        task.setProjectId(getNullableLong(resultSet, "project_id"));
        task.setCategoryId(getNullableLong(resultSet, "category_id"));
        task.setParentTaskId(getNullableLong(resultSet, "parent_task_id"));

        task.setTitle(resultSet.getString("title"));
        task.setDescription(resultSet.getString("description"));
        task.setPriority(resultSet.getString("priority"));
        task.setStatus(resultSet.getString("status"));
        task.setDueAt(resultSet.getTimestamp("due_at"));
        task.setPositionOrder(resultSet.getInt("position_order"));

        int estimatedMinutes = resultSet.getInt("estimated_minutes");
        task.setEstimatedMinutes(
                resultSet.wasNull() ? null : estimatedMinutes);

        task.setCompletedAt(resultSet.getTimestamp("completed_at"));
        task.setCreatedAt(resultSet.getTimestamp("created_at"));
        task.setUpdatedAt(resultSet.getTimestamp("updated_at"));

        return task;
    }

    // Set a nullable foreign-key value in a prepared statement
    private void setNullableLong(
            PreparedStatement statement, int index, Long value)
            throws SQLException {

        if (value != null) {
            statement.setLong(index, value);
        } else {
            statement.setNull(index, Types.BIGINT);
        }
    }

    // Read a nullable BIGINT column without converting NULL to zero
    private Long getNullableLong(
            ResultSet resultSet, String columnName)
            throws SQLException {

        long value = resultSet.getLong(columnName);

        return resultSet.wasNull() ? null : value;
    }

    // Set an optional timestamp in a prepared statement
    private void setNullableTimestamp(
            PreparedStatement statement, int index, Timestamp value)
            throws SQLException {

        if (value != null) {
            statement.setTimestamp(index, value);
        } else {
            statement.setNull(index, Types.TIMESTAMP);
        }
    }

    // Validate the statuses allowed by the tasks table
    private boolean isValidStatus(String status) {

        return "TODO".equals(status)
                || "IN_PROGRESS".equals(status)
                || "COMPLETED".equals(status)
                || "CANCELLED".equals(status);
    }
}
