
package com.dayWise.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import com.dayWise.model.Goal;
import com.dayWise.service.GoalService;
import com.dayWise.service.GoalServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/goals")
public class GoalController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private GoalService goalService;

    @Override
    public void init() throws ServletException {
        goalService = new GoalServiceImpl();
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

        List<Goal> goals = goalService.getGoalsByUserId(userId);

        request.setAttribute("goals", goals);

        request.getRequestDispatcher("/goals.jsp")
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
                    success = addGoal(request, userId);
                    break;

                case "update":
                    success = updateGoal(request, userId);
                    break;

                case "progress":
                    success = updateProgress(request, userId);
                    break;

                case "status":
                    success = updateStatus(request, userId);
                    break;

                case "delete":
                    success = deleteGoal(request, userId);
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
                    "Goal operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean addGoal(
            HttpServletRequest request, long userId) {

        String title = request.getParameter("goalTitle");

        if (isBlank(title)) {
            return false;
        }

        BigDecimal targetValue =
                parseOptionalDecimal(request.getParameter("targetValue"));

        BigDecimal currentValue =
                parseOptionalDecimal(request.getParameter("currentValue"));

        if (targetValue != null && targetValue.signum() < 0) {
            return false;
        }

        if (currentValue == null) {
            currentValue = BigDecimal.ZERO;
        }

        if (currentValue.signum() < 0
                || (targetValue != null
                && currentValue.compareTo(targetValue) > 0)) {
            return false;
        }

        Goal goal = new Goal();

        goal.setUserId(userId);
        goal.setGoalTitle(title.trim());
        goal.setDescription(request.getParameter("description"));
        goal.setTargetValue(targetValue);
        goal.setCurrentValue(currentValue);
        goal.setUnit(request.getParameter("unit"));
        goal.setStartDate(parseDate(request.getParameter("startDate")));
        goal.setTargetDate(parseDate(request.getParameter("targetDate")));
        goal.setStatus("ACTIVE");

        return goalService.addGoal(goal);
    }

    private boolean updateGoal(
            HttpServletRequest request, long userId) {

        Long goalId = parsePositiveLong(
                request.getParameter("goalId"));

        if (goalId == null) {
            return false;
        }

        Goal goal = goalService.getGoalById(goalId, userId);

        if (goal == null) {
            return false;
        }

        String title = request.getParameter("goalTitle");

        if (isBlank(title)) {
            return false;
        }

        BigDecimal targetValue =
                parseOptionalDecimal(request.getParameter("targetValue"));

        if (targetValue != null && targetValue.signum() < 0) {
            return false;
        }

        if (targetValue != null
                && goal.getCurrentValue() != null
                && goal.getCurrentValue().compareTo(targetValue) > 0) {
            return false;
        }

        goal.setGoalTitle(title.trim());
        goal.setDescription(request.getParameter("description"));
        goal.setTargetValue(targetValue);
        goal.setUnit(request.getParameter("unit"));
        goal.setStartDate(parseDate(request.getParameter("startDate")));
        goal.setTargetDate(parseDate(request.getParameter("targetDate")));

        return goalService.updateGoal(goal);
    }

    private boolean updateProgress(
            HttpServletRequest request, long userId) {

        Long goalId = parsePositiveLong(
                request.getParameter("goalId"));

        BigDecimal currentValue =
                parseOptionalDecimal(request.getParameter("currentValue"));

        if (goalId == null || currentValue == null
                || currentValue.signum() < 0) {
            return false;
        }

        Goal goal = goalService.getGoalById(goalId, userId);

        if (goal == null) {
            return false;
        }

        if (goal.getTargetValue() != null
                && currentValue.compareTo(goal.getTargetValue()) > 0) {
            return false;
        }

        return goalService.updateGoalProgress(
                goalId, userId, currentValue);
    }

    private boolean updateStatus(
            HttpServletRequest request, long userId) {

        Long goalId = parsePositiveLong(
                request.getParameter("goalId"));

        String status = request.getParameter("status");

        if (goalId == null || !isValidStatus(status)) {
            return false;
        }

        return goalService.updateGoalStatus(
                goalId, userId, status);
    }

    private boolean deleteGoal(
            HttpServletRequest request, long userId) {

        Long goalId = parsePositiveLong(
                request.getParameter("goalId"));

        if (goalId == null) {
            return false;
        }

        return goalService.deleteGoal(goalId, userId);
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
        return "ACTIVE".equals(status)
                || "COMPLETED".equals(status)
                || "ARCHIVED".equals(status);
    }

    private BigDecimal parseOptionalDecimal(String value) {

        if (isBlank(value)) {
            return null;
        }

        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException(
                    "Enter a valid numeric value.");
        }
    }

    private Date parseDate(String value) {

        if (isBlank(value)) {
            return null;
        }

        try {
            return Date.valueOf(value.trim());
        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException(
                    "Enter a valid date.");
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void redirect(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/goals?message=" + message);
    }
}
