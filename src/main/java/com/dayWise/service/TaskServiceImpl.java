
package com.dayWise.service;

import java.util.Collections;
import java.util.List;

import com.dayWise.dao.TaskDAO;
import com.dayWise.dao.TaskDAOImpl;
import com.dayWise.model.Task;

/**
 * Implements business rules for managing user tasks.
 */
public class TaskServiceImpl implements TaskService {

    private final TaskDAO taskDAO;

    public TaskServiceImpl() {
        this(new TaskDAOImpl());
    }

    public TaskServiceImpl(TaskDAO taskDAO) {
        if (taskDAO == null) {
            throw new IllegalArgumentException(
                    "TaskDAO cannot be null.");
        }

        this.taskDAO = taskDAO;
    }

    @Override
    public boolean addTask(Task task) {

        if (task == null || task.getUserId() <= 0) {
            return false;
        }

        if (task.getTitle() == null) {
            return false;
        }

        String title = task.getTitle().trim();

        if (title.isEmpty() || title.length() > 200) {
            return false;
        }

        if (task.getDescription() != null
                && task.getDescription().length() > 65535) {
            return false;
        }

        if (task.getEstimatedMinutes() != null
                && task.getEstimatedMinutes() < 0) {
            return false;
        }

        if (task.getPositionOrder() < 0) {
            return false;
        }

        task.setTitle(title);

        if (task.getPriority() == null
                || task.getPriority().trim().isEmpty()) {
            task.setPriority("MEDIUM");
        } else {
            task.setPriority(
                    task.getPriority().trim().toUpperCase());
        }

        if (!isValidPriority(task.getPriority())) {
            return false;
        }

        if (task.getStatus() == null
                || task.getStatus().trim().isEmpty()) {
            task.setStatus("TODO");
        } else {
            task.setStatus(
                    task.getStatus().trim().toUpperCase());
        }

        if (!isValidStatus(task.getStatus())) {
            return false;
        }

        // New tasks should not arrive already marked as completed.
        if (!"COMPLETED".equals(task.getStatus())) {
            task.setCompletedAt(null);
        }

        return taskDAO.addTask(task);
    }

    @Override
    public List<Task> getTasksByUserId(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<Task> tasks = taskDAO.getTasksByUserId(userId);

        return tasks != null ? tasks : Collections.emptyList();
    }

    @Override
    public List<Task> getTasksByStatus(long userId, String status) {

        if (userId <= 0 || status == null) {
            return Collections.emptyList();
        }

        status = status.trim().toUpperCase();

        if (!isValidStatus(status)) {
            return Collections.emptyList();
        }

        List<Task> tasks =
                taskDAO.getTasksByStatus(userId, status);

        return tasks != null ? tasks : Collections.emptyList();
    }

    @Override
    public Task getTaskById(long taskId, long userId) {

        if (taskId <= 0 || userId <= 0) {
            return null;
        }

        return taskDAO.getTaskById(taskId, userId);
    }

    @Override
    public boolean updateTask(Task task) {

        if (task == null || task.getTaskId() <= 0
                || task.getUserId() <= 0
                || task.getTitle() == null) {
            return false;
        }

        String title = task.getTitle().trim();

        if (title.isEmpty() || title.length() > 200) {
            return false;
        }

        if (task.getEstimatedMinutes() != null
                && task.getEstimatedMinutes() < 0) {
            return false;
        }

        if (task.getPositionOrder() < 0) {
            return false;
        }

        Task existingTask = taskDAO.getTaskById(
                task.getTaskId(), task.getUserId());

        if (existingTask == null) {
            return false;
        }

        task.setTitle(title);

        if (task.getPriority() == null
                || !isValidPriority(
                        task.getPriority().trim().toUpperCase())) {
            return false;
        }

        task.setPriority(
                task.getPriority().trim().toUpperCase());

        if (task.getStatus() == null
                || !isValidStatus(
                        task.getStatus().trim().toUpperCase())) {
            return false;
        }

        task.setStatus(task.getStatus().trim().toUpperCase());

        return taskDAO.updateTask(task);
    }

    @Override
    public boolean updateTaskStatus(long taskId, long userId,
            String status) {

        if (taskId <= 0 || userId <= 0 || status == null) {
            return false;
        }

        status = status.trim().toUpperCase();

        if (!isValidStatus(status)) {
            return false;
        }

        Task existingTask = taskDAO.getTaskById(taskId, userId);

        if (existingTask == null) {
            return false;
        }

        return taskDAO.updateTaskStatus(taskId, userId, status);
    }

    @Override
    public boolean updateTaskPosition(long taskId, long userId,
            int positionOrder) {

        if (taskId <= 0 || userId <= 0 || positionOrder < 0) {
            return false;
        }

        Task existingTask = taskDAO.getTaskById(taskId, userId);

        if (existingTask == null) {
            return false;
        }

        return taskDAO.updateTaskPosition(
                taskId, userId, positionOrder);
    }

    @Override
    public boolean deleteTask(long taskId, long userId) {

        if (taskId <= 0 || userId <= 0) {
            return false;
        }

        Task existingTask = taskDAO.getTaskById(taskId, userId);

        if (existingTask == null) {
            return false;
        }

        return taskDAO.deleteTask(taskId, userId);
    }

    @Override
    public List<Task> searchTasks(long userId, String keyword) {

        if (userId <= 0 || keyword == null
                || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        List<Task> tasks =
                taskDAO.searchTasks(userId, keyword.trim());

        return tasks != null ? tasks : Collections.emptyList();
    }

    private boolean isValidPriority(String priority) {

        return "LOW".equals(priority)
                || "MEDIUM".equals(priority)
                || "HIGH".equals(priority)
                || "URGENT".equals(priority);
    }

    private boolean isValidStatus(String status) {

        return "TODO".equals(status)
                || "IN_PROGRESS".equals(status)
                || "COMPLETED".equals(status)
                || "CANCELLED".equals(status);
    }
}
