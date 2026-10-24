
package com.dayWise.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

import com.dayWise.model.RecurringTask;
import com.dayWise.service.RecurringTaskService;
import com.dayWise.service.RecurringTaskServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/recurring-tasks")
public class RecurringTaskController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RecurringTaskService recurringTaskService;

    @Override
    public void init() throws ServletException {
        recurringTaskService = new RecurringTaskServiceImpl();
    }

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

        List<RecurringTask> recurringTasks =
                recurringTaskService.getRecurringTasksByUserId(userId);

        request.setAttribute("recurringTasks", recurringTasks);

        request.getRequestDispatcher("/recurring-tasks.jsp")
                .forward(request, response);
    }

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
            redirect(request, response, "invalidAction");
            return;
        }

        try {
            boolean success;

            switch (action) {
                case "add":
                    success = addRecurringTask(request, userId);
                    break;

                case "update":
                    success = updateRecurringTask(request, userId);
                    break;

                case "pause":
                    success = changeActiveStatus(request, userId, false);
                    break;

                case "resume":
                    success = changeActiveStatus(request, userId, true);
                    break;

                case "delete":
                    success = deleteRecurringTask(request, userId);
                    break;

                default:
                    redirect(request, response, "invalidAction");
                    return;
            }

            redirect(request, response,
                    success ? "success" : "failed");

        } catch (IllegalArgumentException exception) {
            redirect(request, response, "invalidInput");

        } catch (RuntimeException exception) {
            getServletContext().log(
                    "Recurring task operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean addRecurringTask(
            HttpServletRequest request, long userId) {

        String title = request.getParameter("title");
        String frequency = request.getParameter("frequency");

        if (isBlank(title) || !isValidFrequency(frequency)) {
            return false;
        }

        int interval = parsePositiveInt(
                request.getParameter("repeatInterval"), 1);

        LocalDate startDate = parseDate(
                request.getParameter("startDate"));

        if (startDate == null) {
            startDate = LocalDate.now();
        }

        LocalDate endDate = parseDate(
                request.getParameter("endDate"));

        if (endDate != null && endDate.isBefore(startDate)) {
            return false;
        }

        RecurringTask task = new RecurringTask();

        task.setUserId(userId);
        task.setTitle(title.trim());
        task.setDescription(request.getParameter("description"));
        task.setFrequency(frequency.trim().toUpperCase());
        task.setRepeatInterval(interval);
        task.setDaysOfWeek(request.getParameter("daysOfWeek"));
        task.setDayOfMonth(parseNullableInt(
                request.getParameter("dayOfMonth")));
        task.setStartDate(Date.valueOf(startDate));
        task.setEndDate(
                endDate == null ? null : Date.valueOf(endDate));
        task.setActive(true);

        // Set the initial run time so the schedule can be processed.
        LocalDate firstRun = startDate;
        task.setNextRunAt(Timestamp.valueOf(
                firstRun.atStartOfDay()));

        return recurringTaskService.addRecurringTask(task);
    }

    private boolean updateRecurringTask(
            HttpServletRequest request, long userId) {

        Long recurringId = parsePositiveLong(
                request.getParameter("recurringId"));

        if (recurringId == null) {
            return false;
        }

        RecurringTask task =
                recurringTaskService.getRecurringTaskById(
                        recurringId, userId);

        if (task == null) {
            return false;
        }

        String title = request.getParameter("title");
        String frequency = request.getParameter("frequency");

        if (isBlank(title) || !isValidFrequency(frequency)) {
            return false;
        }

        int interval = parsePositiveInt(
                request.getParameter("repeatInterval"), 1);

        LocalDate startDate = parseDate(
                request.getParameter("startDate"));

        if (startDate == null) {
            startDate = task.getStartDate().toLocalDate();
        }

        LocalDate endDate = parseDate(
                request.getParameter("endDate"));

        if (endDate != null && endDate.isBefore(startDate)) {
            return false;
        }

        task.setTitle(title.trim());
        task.setDescription(request.getParameter("description"));
        task.setFrequency(frequency.trim().toUpperCase());
        task.setRepeatInterval(interval);
        task.setDaysOfWeek(request.getParameter("daysOfWeek"));
        task.setDayOfMonth(parseNullableInt(
                request.getParameter("dayOfMonth")));
        task.setStartDate(Date.valueOf(startDate));
        task.setEndDate(
                endDate == null ? null : Date.valueOf(endDate));

        return recurringTaskService.updateRecurringTask(task);
    }

    private boolean changeActiveStatus(
            HttpServletRequest request, long userId,
            boolean active) {

        Long recurringId = parsePositiveLong(
                request.getParameter("recurringId"));

        if (recurringId == null) {
            return false;
        }

        return recurringTaskService.updateRecurringTaskStatus(
                recurringId, userId, active);
    }

    private boolean deleteRecurringTask(
            HttpServletRequest request, long userId) {

        Long recurringId = parsePositiveLong(
                request.getParameter("recurringId"));

        if (recurringId == null) {
            return false;
        }

        return recurringTaskService.deleteRecurringTask(
                recurringId, userId);
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

    private boolean isValidFrequency(String frequency) {

        if (frequency == null) {
            return false;
        }

        String value = frequency.trim().toUpperCase();

        return value.equals("DAILY")
                || value.equals("WEEKLY")
                || value.equals("MONTHLY")
                || value.equals("YEARLY")
                || value.equals("CUSTOM");
    }

    private LocalDate parseDate(String value) {

        if (isBlank(value)) {
            return null;
        }

        try {
            return LocalDate.parse(value.trim());
        } catch (RuntimeException exception) {
            throw new IllegalArgumentException("Invalid date.");
        }
    }

    private Long parsePositiveLong(String value) {

        if (isBlank(value)) {
            return null;
        }

        try {
            long number = Long.parseLong(value.trim());
            return number > 0 ? number : null;
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private int parsePositiveInt(String value, int defaultValue) {

        Integer number = parseNullableInt(value);

        if (number == null) {
            return defaultValue;
        }

        if (number < 1) {
            throw new IllegalArgumentException(
                    "Interval must be at least 1.");
        }

        return number;
    }

    private Integer parseNullableInt(String value) {

        if (isBlank(value)) {
            return null;
        }

        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("Invalid number.");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void redirect(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/recurring-tasks?message=" + message);
    }
}
