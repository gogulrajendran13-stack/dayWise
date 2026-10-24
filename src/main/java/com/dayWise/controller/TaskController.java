
package com.dayWise.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import com.dayWise.model.Task;
import com.dayWise.service.TaskService;
import com.dayWise.service.TaskServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/tasks")
public class TaskController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TaskService taskService;

    @Override
    public void init() throws ServletException {
        taskService = new TaskServiceImpl();
    }

    // Display tasks and support searching or status filtering.
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long userId = getUserId(request);

        if (userId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<Task> tasks;

        if (keyword != null && !keyword.trim().isEmpty()) {
            tasks = taskService.searchTasks(userId, keyword.trim());
        } else if (isValidStatus(status)) {
            tasks = taskService.getTasksByStatus(userId, status);
        } else {
            tasks = taskService.getTasksByUserId(userId);
        }

        request.setAttribute("tasks", tasks);

        request.getRequestDispatcher("/tasks.jsp")
                .forward(request, response);
    }

    // Handle all task modifications through one controller.
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Long userId = getUserId(request);

        if (userId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            redirectWithMessage(request, response, "invalidAction");
            return;
        }

        try {
            boolean success;

            switch (action) {

                case "add":
                    success = addTask(request, userId);
                    break;

                case "update":
                    success = updateTask(request, userId);
                    break;

                case "status":
                    success = updateStatus(request, userId);
                    break;

                case "position":
                    success = updatePosition(request, userId);
                    break;

                case "delete":
                    success = deleteTask(request, userId);
                    break;

                default:
                    redirectWithMessage(
                            request, response, "invalidAction");
                    return;
            }

            redirectWithMessage(
                    request, response,
                    success ? "success" : "failed");

        } catch (IllegalArgumentException exception) {
            redirectWithMessage(request, response, "invalidInput");

        } catch (RuntimeException exception) {
            getServletContext().log(
                    "Task operation failed.", exception);

            redirectWithMessage(request, response, "failed");
        }
    }

    private boolean addTask(HttpServletRequest request, long userId) {

        String title = request.getParameter("title");

        if (isBlank(title)) {
            return false;
        }

        Task task = new Task();

        task.setUserId(userId);
        task.setTitle(title.trim());
        task.setDescription(request.getParameter("description"));
        task.setPriority(normalizePriority(
                request.getParameter("priority")));
        task.setStatus("TODO");
        task.setPositionOrder(parseInteger(
                request.getParameter("positionOrder"), 0));
        task.setEstimatedMinutes(parseNullableInteger(
                request.getParameter("estimatedMinutes")));
        task.setProjectId(parseNullableLong(
                request.getParameter("projectId")));
        task.setCategoryId(parseNullableLong(
                request.getParameter("categoryId")));
        task.setParentTaskId(parseNullableLong(
                request.getParameter("parentTaskId")));
        task.setDueAt(parseTimestamp(
                request.getParameter("dueAt")));

        return taskService.addTask(task);
    }

    private boolean updateTask(HttpServletRequest request, long userId) {

        Long taskId = parsePositiveLong(
                request.getParameter("taskId"));

        if (taskId == null) {
            return false;
        }

        Task task = taskService.getTaskById(taskId, userId);

        if (task == null) {
            return false;
        }

        String title = request.getParameter("title");

        if (isBlank(title)) {
            return false;
        }

        task.setTitle(title.trim());
        task.setDescription(request.getParameter("description"));
        task.setPriority(normalizePriority(
                request.getParameter("priority")));
        task.setDueAt(parseTimestamp(
                request.getParameter("dueAt")));
        task.setEstimatedMinutes(parseNullableInteger(
                request.getParameter("estimatedMinutes")));

        return taskService.updateTask(task);
    }

    private boolean updateStatus(
            HttpServletRequest request, long userId) {

        Long taskId = parsePositiveLong(
                request.getParameter("taskId"));
        String status = request.getParameter("status");

        if (taskId == null || !isValidStatus(status)) {
            return false;
        }

        return taskService.updateTaskStatus(
                taskId, userId, status);
    }

    private boolean updatePosition(
            HttpServletRequest request, long userId) {

        Long taskId = parsePositiveLong(
                request.getParameter("taskId"));
        Integer position = parseNullableInteger(
                request.getParameter("positionOrder"));

        if (taskId == null || position == null || position < 0) {
            return false;
        }

        return taskService.updateTaskPosition(
                taskId, userId, position);
    }

    private boolean deleteTask(
            HttpServletRequest request, long userId) {

        Long taskId = parsePositiveLong(
                request.getParameter("taskId"));

        if (taskId == null) {
            return false;
        }

        return taskService.deleteTask(taskId, userId);
    }

    private Long getUserId(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object value = session.getAttribute("userId");

        if (!(value instanceof Number)) {
            return null;
        }

        long userId = ((Number) value).longValue();

        return userId > 0 ? userId : null;
    }

    private boolean isValidStatus(String status) {

        if (status == null) {
            return false;
        }

        return status.equals("TODO")
                || status.equals("IN_PROGRESS")
                || status.equals("COMPLETED")
                || status.equals("CANCELLED");
    }

    private String normalizePriority(String priority) {

        if (priority == null || priority.trim().isEmpty()) {
            return "MEDIUM";
        }

        String value = priority.trim().toUpperCase();

        if (value.equals("LOW")
                || value.equals("MEDIUM")
                || value.equals("HIGH")
                || value.equals("URGENT")) {
            return value;
        }

        return "MEDIUM";
    }

    private Timestamp parseTimestamp(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            String normalized = value.trim().replace('T', ' ');

            if (normalized.length() == 16) {
                normalized += ":00";
            }

            return Timestamp.valueOf(normalized);

        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException(
                    "Invalid task due date and time.");
        }
    }

    private Long parseNullableLong(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            long number = Long.parseLong(value.trim());

            if (number <= 0) {
                throw new IllegalArgumentException(
                        "ID must be positive.");
            }

            return number;

        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("Invalid ID.");
        }
    }

    private Long parsePositiveLong(String value) {
        return parseNullableLong(value);
    }

    private Integer parseNullableInteger(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.valueOf(value.trim());

        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("Invalid number.");
        }
    }

    private int parseInteger(String value, int defaultValue) {

        Integer parsed = parseNullableInteger(value);

        return parsed == null ? defaultValue : parsed;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void redirectWithMessage(
            HttpServletRequest request,
            HttpServletResponse response,
            String message) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/tasks?message=" + message);
    }
}
