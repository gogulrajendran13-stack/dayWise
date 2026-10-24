
package com.dayWise.controller;

import java.io.IOException;

import com.dayWise.model.User;
import com.dayWise.service.UserService;
import com.dayWise.service.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
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

        User user = userService.getUserProfile(userId);

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "User profile not found.");
            return;
        }

        request.setAttribute("user", user);

        request.getRequestDispatcher("/profile.jsp")
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
                case "updateProfile":
                    success = updateProfile(request, userId);
                    break;

                case "changePassword":
                    success = changePassword(request, userId);
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
                    "Profile operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean updateProfile(
            HttpServletRequest request, long userId) {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        if (isBlank(fullName) || isBlank(email)) {
            return false;
        }

        fullName = fullName.trim();
        email = email.trim();

        if (fullName.length() > 100
                || !email.matches(
                "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
                || email.length() > 150) {
            return false;
        }

        User user = userService.getUserProfile(userId);

        if (user == null) {
            return false;
        }

        user.setFullName(fullName);
        user.setEmail(email);

        boolean updated = userService.updateUserProfile(user);

        if (updated) {
            HttpSession session = request.getSession(false);

            if (session != null) {
                session.setAttribute("fullName", fullName);
                session.setAttribute("email", email);
            }
        }

        return updated;
    }

    private boolean changePassword(
            HttpServletRequest request, long userId) {

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (isBlank(currentPassword)
                || isBlank(newPassword)
                || isBlank(confirmPassword)) {
            return false;
        }

        if (!newPassword.equals(confirmPassword)) {
            return false;
        }

        if (newPassword.length() < 8) {
            return false;
        }

        if (newPassword.equals(currentPassword)) {
            return false;
        }

        return userService.changePassword(
                userId, currentPassword, newPassword);
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void redirect(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/profile?message=" + message);
    }
}
