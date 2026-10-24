
package com.dayWise.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

import com.dayWise.model.Reminder;
import com.dayWise.service.ReminderService;
import com.dayWise.service.ReminderServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reminders")
public class ReminderController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ReminderService reminderService;

    @Override
    public void init() throws ServletException {
        reminderService = new ReminderServiceImpl();
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

        List<Reminder> reminders =
                reminderService.getRemindersByUserId(userId);

        request.setAttribute("reminders", reminders);

        request.getRequestDispatcher("/reminders.jsp")
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
                    success = addReminder(request, userId);
                    break;

                case "update":
                    success = updateReminder(request, userId);
                    break;

                case "status":
                    success = updateStatus(request, userId);
                    break;

                case "delete":
                    success = deleteReminder(request, userId);
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
                    "Reminder operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean addReminder(
            HttpServletRequest request, long userId) {

        Long taskId = parsePositiveLong(
                request.getParameter("taskId"));

        Timestamp reminderAt = parseReminderTime(
                request.getParameter("reminderAt"));

        if (taskId == null || reminderAt == null
                || !reminderAt.toLocalDateTime()
                        .isAfter(LocalDateTime.now())) {
            return false;
        }

        String message = request.getParameter("reminderMessage");

        Reminder reminder = new Reminder(
                userId,
                taskId,
                reminderAt,
                message == null ? "" : message.trim());

        return reminderService.addReminder(reminder);
    }

    private boolean updateReminder(
            HttpServletRequest request, long userId) {

        Long reminderId = parsePositiveLong(
                request.getParameter("reminderId"));

        if (reminderId == null) {
            return false;
        }

        Reminder reminder = reminderService.getReminderById(
                reminderId, userId);

        if (reminder == null) {
            return false;
        }

        Timestamp reminderAt = parseReminderTime(
                request.getParameter("reminderAt"));

        if (reminderAt == null
                || !reminderAt.toLocalDateTime()
                        .isAfter(LocalDateTime.now())) {
            return false;
        }

        Long taskId = parsePositiveLong(
                request.getParameter("taskId"));

        if (taskId == null) {
            return false;
        }

        reminder.setTaskId(taskId);
        reminder.setReminderAt(reminderAt);
        reminder.setReminderMessage(
                request.getParameter("reminderMessage"));

        return reminderService.updateReminder(reminder);
    }

    private boolean updateStatus(
            HttpServletRequest request, long userId) {

        Long reminderId = parsePositiveLong(
                request.getParameter("reminderId"));

        String status = request.getParameter("status");

        if (reminderId == null
                || !("PENDING".equals(status)
                || "SENT".equals(status)
                || "CANCELLED".equals(status))) {
            return false;
        }

        return reminderService.updateReminderStatus(
                reminderId, userId, status);
    }

    private boolean deleteReminder(
            HttpServletRequest request, long userId) {

        Long reminderId = parsePositiveLong(
                request.getParameter("reminderId"));

        if (reminderId == null) {
            return false;
        }

        return reminderService.deleteReminder(
                reminderId, userId);
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

    private Timestamp parseReminderTime(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Timestamp.valueOf(
                    value.trim().replace('T', ' ') + 
                    (value.trim().length() == 16 ? ":00" : ""));

        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException(
                    "Invalid reminder date and time.");
        }
    }

    private Long parsePositiveLong(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            long number = Long.parseLong(value.trim());
            return number > 0 ? number : null;

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private void redirect(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/reminders?message=" + message);
    }
}
