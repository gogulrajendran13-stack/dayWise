
package com.dayWise.controller;

import java.io.IOException;

import com.dayWise.model.UserSettings;
import com.dayWise.service.UserSettingsService;
import com.dayWise.service.UserSettingsServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/settings")
public class UserSettingsController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserSettingsService userSettingsService;

    @Override
    public void init() throws ServletException {
        userSettingsService = new UserSettingsServiceImpl();
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

        UserSettings settings =
                userSettingsService.getSettingsByUserId(userId);

        if (settings == null) {
            UserSettings newSettings = new UserSettings(userId);

            if (userSettingsService.createSettings(newSettings)) {
                settings = userSettingsService
                        .getSettingsByUserId(userId);
            }
        }

        if (settings == null) {
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load user settings.");
            return;
        }

        request.setAttribute("settings", settings);

        request.getRequestDispatcher("/settings.jsp")
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
                case "save":
                    success = saveSettings(request, userId);
                    break;

                case "theme":
                    success = updateTheme(request, userId);
                    break;

                case "focusTime":
                    success = updateFocusTime(request, userId);
                    break;

                case "notifications":
                    success = updateNotifications(request, userId);
                    break;

                case "reminders":
                    success = updateReminders(request, userId);
                    break;

                case "language":
                    success = updateLanguage(request, userId);
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
                    "Settings operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean saveSettings(
            HttpServletRequest request, long userId) {

        String theme = request.getParameter("theme");
        String focusValue = request.getParameter("dailyFocusMinutes");
        String language = request.getParameter("language");

        if (!isValidTheme(theme)
                || isBlank(focusValue)
                || isBlank(language)) {
            return false;
        }

        int focusMinutes = parseFocusMinutes(focusValue);

        if (focusMinutes < 0 || focusMinutes > 1440) {
            return false;
        }

        boolean notificationsEnabled =
                "true".equals(request.getParameter("notificationsEnabled"));

        boolean remindersEnabled =
                "true".equals(request.getParameter("reminderEnabled"));

        UserSettings settings =
                userSettingsService.getSettingsByUserId(userId);

        if (settings == null) {
            settings = new UserSettings(userId);
            if (!userSettingsService.createSettings(settings)) {
                return false;
            }
        }

        settings.setTheme(theme.trim().toUpperCase());
        settings.setDailyFocusMinutes(focusMinutes);
        settings.setNotificationsEnabled(notificationsEnabled);
        settings.setReminderEnabled(remindersEnabled);
        settings.setLanguage(language.trim());

        return userSettingsService.updateSettings(settings);
    }

    private boolean updateTheme(
            HttpServletRequest request, long userId) {

        String theme = request.getParameter("theme");

        if (!isValidTheme(theme)) {
            return false;
        }

        return userSettingsService.updateTheme(
                userId, theme.trim().toUpperCase());
    }

    private boolean updateFocusTime(
            HttpServletRequest request, long userId) {

        String value = request.getParameter("dailyFocusMinutes");

        if (isBlank(value)) {
            return false;
        }

        int minutes = parseFocusMinutes(value);

        if (minutes < 0 || minutes > 1440) {
            return false;
        }

        return userSettingsService.updateDailyFocusMinutes(
                userId, minutes);
    }


private boolean updateNotifications(
        HttpServletRequest request, long userId) {

    boolean enabled =
            "true".equals(request.getParameter("notificationsEnabled"));

    return userSettingsService.updateNotificationsEnabled(
            userId, enabled);
}

private boolean updateReminders(
        HttpServletRequest request, long userId) {

    boolean enabled =
            "true".equals(request.getParameter("reminderEnabled"));

    return userSettingsService.updateReminderEnabled(
            userId, enabled);
}


    private boolean updateLanguage(
            HttpServletRequest request, long userId) {

        String language = request.getParameter("language");

        if (isBlank(language) || language.trim().length() > 10) {
            return false;
        }

        return userSettingsService.updateLanguage(
                userId, language.trim());
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

    private int parseFocusMinutes(String value) {

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException(
                    "Invalid focus duration.");
        }
    }

    private boolean isValidTheme(String theme) {
        return "LIGHT".equalsIgnoreCase(theme)
                || "DARK".equalsIgnoreCase(theme);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

private void redirect(HttpServletRequest request,
        HttpServletResponse response, String message)
        throws IOException {

    String status;

    switch (message) {
        case "success":
            status = "success";
            break;
        case "failed":
        case "invalidInput":
        case "invalidAction":
            status = "error";
            break;
        default:
            status = "error";
    }

    response.sendRedirect(
            request.getContextPath()
                    + "/settings?status=" + status);
}

}
