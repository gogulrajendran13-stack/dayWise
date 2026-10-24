
package com.dayWise.service;

import java.util.List;

import com.dayWise.model.Task;

/**
 * Defines business operations for managing user tasks.
 */
public interface TaskService {

    boolean addTask(Task task);

    List<Task> getTasksByUserId(long userId);

    List<Task> getTasksByStatus(long userId, String status);

    Task getTaskById(long taskId, long userId);

    boolean updateTask(Task task);

    boolean updateTaskStatus(long taskId, long userId,
            String status);

    boolean updateTaskPosition(long taskId, long userId,
            int positionOrder);

    boolean deleteTask(long taskId, long userId);

    List<Task> searchTasks(long userId, String keyword);
}
