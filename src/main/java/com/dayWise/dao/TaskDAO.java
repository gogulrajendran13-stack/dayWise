
package com.dayWise.dao;

import java.util.List;

import com.dayWise.model.Task;

public interface TaskDAO {

    // Create a new task
    boolean addTask(Task task);

    // Retrieve all tasks belonging to a user
    List<Task> getTasksByUserId(long userId);

    // Retrieve tasks belonging to a user with a specific status
    List<Task> getTasksByStatus(long userId, String status);

    // Retrieve one task by its ID and owner
    Task getTaskById(long taskId, long userId);

    // Update task details
    boolean updateTask(Task task);

    // Update the status of a task
    boolean updateTaskStatus(
            long taskId, long userId, String status);

    // Update the task's display order
    boolean updateTaskPosition(
            long taskId, long userId, int positionOrder);

    // Delete a task belonging to a specific user
    boolean deleteTask(long taskId, long userId);

    // Search tasks by title or description
    List<Task> searchTasks(long userId, String keyword);
}
