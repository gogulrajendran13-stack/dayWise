
package com.dayWise.controller;

import java.io.IOException;
import java.util.List;

import com.dayWise.model.Notification;
import com.dayWise.service.NotificationService;
import com.dayWise.service.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/notifications")
public class NotificationController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        notificationService = new NotificationServiceImpl();
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

        List<Notification> notifications =
                notificationService.getNotificationsByUserId(userId);

        request.setAttribute("notifications", notifications);

        request.getRequestDispatcher("/notifications.jsp")
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

                case "markRead":
                    success = markRead(request, userId);
                    break;

                case "markAllRead":
                    success = notificationService
                            .markAllAsRead(userId);
                    break;

                case "delete":
                    success = deleteNotification(request, userId);
                    break;

                case "deleteAll":
                    success = notificationService
                            .deleteAllNotifications(userId);
                    break;

                default:
                    redirect(request, response, "invalidAction");
                    return;
            }

            redirect(request, response,
                    success ? "success" : "failed");

        } catch (RuntimeException exception) {
            getServletContext().log(
                    "Notification operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean markRead(
            HttpServletRequest request, long userId) {

        Long notificationId = parsePositiveLong(
                request.getParameter("notificationId"));

        if (notificationId == null) {
            return false;
        }

        return notificationService.markAsRead(
                notificationId, userId);
    }

    private boolean deleteNotification(
            HttpServletRequest request, long userId) {

        Long notificationId = parsePositiveLong(
                request.getParameter("notificationId"));

        if (notificationId == null) {
            return false;
        }

        return notificationService.deleteNotification(
                notificationId, userId);
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
                        + "/notifications?message=" + message);
    }
}
