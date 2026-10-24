
package com.dayWise.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.dayWise.dao.AnalyticsDAO;
import com.dayWise.dao.AnalyticsDAOimpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/analytics")
public class AnalyticsController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AnalyticsDAO analyticsDAO;

    @Override
    public void init() throws ServletException {
        analyticsDAO = new AnalyticsDAOimpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Number)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        long userId = ((Number) session.getAttribute("userId")).longValue();

        if (userId <= 0) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        try {
            Map<String, Object> analytics =
                    analyticsDAO.getAnalyticsData(userId);

            request.setAttribute("analytics", analytics);

            request.setAttribute(
                    "monthlyLabelsJson",
                    toJson((List<?>) analytics.get("monthlyLabels")));
            request.setAttribute(
                    "monthlyCompletedJson",
                    toJson((List<?>) analytics.get("monthlyCompleted")));
            request.setAttribute(
                    "monthlyRemainingJson",
                    toJson((List<?>) analytics.get("monthlyRemaining")));

            request.setAttribute(
                    "weeklyLabelsJson",
                    toJson((List<?>) analytics.get("weeklyLabels")));
            request.setAttribute(
                    "weeklyCompletedJson",
                    toJson((List<?>) analytics.get("weeklyCompleted")));

            request.setAttribute(
                    "statusLabelsJson",
                    toJson((List<?>) analytics.get("statusLabels")));
            request.setAttribute(
                    "statusCountsJson",
                    toJson((List<?>) analytics.get("statusCounts")));

            request.getRequestDispatcher("/analytics.jsp")
                    .forward(request, response);

        } catch (RuntimeException e) {
            getServletContext().log(
                    "Unable to load analytics for user " + userId, e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load analytics. Please try again.");
        }
    }

    private String toJson(List<?> values) {
        StringBuilder json = new StringBuilder("[");
        boolean first = true;

        for (Object value : values) {
            if (!first) {
                json.append(",");
            }
            first = false;

            if (value instanceof Number || value instanceof Boolean) {
                json.append(value);
            } else {
                json.append("\"")
                    .append(escapeJson(String.valueOf(value)))
                    .append("\"");
            }
        }

        json.append("]");
        return json.toString();
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}
