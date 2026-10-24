
package com.dayWise.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

import com.dayWise.model.FocusSession;
import com.dayWise.service.FocusSessionService;
import com.dayWise.service.FocusSessionServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/focus-sessions")
public class FocusSessionController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private FocusSessionService focusSessionService;

    @Override
    public void init() throws ServletException {
        focusSessionService = new FocusSessionServiceImpl();
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

        List<FocusSession> sessions =
                focusSessionService.getSessionsByUserId(userId);

        int totalFocusMinutes =
                focusSessionService.getTotalFocusMinutes(userId);

        request.setAttribute("sessions", sessions);
        request.setAttribute("totalFocusMinutes", totalFocusMinutes);

        request.getRequestDispatcher("/focus-sessions.jsp")
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
                case "start":
                    success = startSession(request, userId);
                    break;

                case "complete":
                    success = finishSession(
                            request, userId, "COMPLETED");
                    break;

                case "cancel":
                    success = finishSession(
                            request, userId, "CANCELLED");
                    break;

                case "delete":
                    success = deleteSession(request, userId);
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
                    "Focus session operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean startSession(
            HttpServletRequest request, long userId) {

        Long taskId = parseOptionalPositiveLong(
                request.getParameter("taskId"));

        String sessionType = request.getParameter("sessionType");

        if (sessionType == null || sessionType.trim().isEmpty()) {
            sessionType = "FOCUS";
        }

        sessionType = sessionType.trim().toUpperCase();

        if (!sessionType.equals("FOCUS")
                && !sessionType.equals("SHORT_BREAK")
                && !sessionType.equals("LONG_BREAK")) {
            return false;
        }

        // Avoid multiple simultaneous active sessions.
        List<FocusSession> activeSessions =
                focusSessionService.getActiveSessions(userId);

        if (activeSessions != null && !activeSessions.isEmpty()) {
            return false;
        }

        FocusSession session = new FocusSession(
                userId,
                taskId,
                sessionType,
                Timestamp.valueOf(LocalDateTime.now()));

        return focusSessionService.startSession(session);
    }

    private boolean finishSession(
            HttpServletRequest request, long userId,
            String finalStatus) {

        Long sessionId = parseOptionalPositiveLong(
                request.getParameter("sessionId"));

        if (sessionId == null) {
            return false;
        }

        FocusSession session =
                focusSessionService.getSessionById(sessionId, userId);

        if (session == null
                || session.getStartTime() == null
                || !"IN_PROGRESS".equals(session.getStatus())) {
            return false;
        }

        LocalDateTime start =
                session.getStartTime().toLocalDateTime();

        LocalDateTime now = LocalDateTime.now();

        long elapsedMinutes = Duration.between(start, now).toMinutes();

        if (elapsedMinutes < 0) {
            return false;
        }

        int durationMinutes = (int) Math.min(
                elapsedMinutes, Integer.MAX_VALUE);

        return focusSessionService.endSession(
                sessionId, userId, durationMinutes, finalStatus);
    }

    private boolean deleteSession(
            HttpServletRequest request, long userId) {

        Long sessionId = parseOptionalPositiveLong(
                request.getParameter("sessionId"));

        if (sessionId == null) {
            return false;
        }

        return focusSessionService.deleteSession(
                sessionId, userId);
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

    private Long parseOptionalPositiveLong(String value) {

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
                        + "/focus-sessions?message=" + message);
    }
}
