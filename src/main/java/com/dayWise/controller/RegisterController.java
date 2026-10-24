
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

@WebServlet("/register")
public class RegisterController extends HttpServlet {

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

        request.getRequestDispatcher("/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        if (isBlank(fullName) || isBlank(email)
                || isBlank(password)
                || isBlank(confirmPassword)) {

            showError(request, response,
                    "Please fill in all required fields.");
            return;
        }

        fullName = fullName.trim();
        email = email.trim();

        if (!email.matches(
                "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {

            showError(request, response,
                    "Please enter a valid email address.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            showError(request, response,
                    "Passwords do not match.");
            return;
        }

        if (password.length() < 8) {
            showError(request, response,
                    "Password must contain at least 8 characters.");
            return;
        }

        try {
            boolean registered = userService.registerUser(
                    fullName, email, password);

            if (registered) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/login?registered=1");
            } else {
                showError(request, response,
                        "Registration failed. The email may already be registered.");
            }

        } catch (RuntimeException exception) {
            getServletContext().log(
                    "Registration failed.", exception);

            showError(request, response,
                    "Unable to complete registration. Please try again.");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void showError(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);

        request.getRequestDispatcher("/register.jsp")
                .forward(request, response);
    }
}
