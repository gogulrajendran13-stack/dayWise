
package com.dayWise.controller;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import com.dayWise.dao.TaskDAO;
import com.dayWise.dao.TaskDAOImpl;
import com.dayWise.model.Task;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/calendar")
public class CalendarController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TaskDAO taskDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("userId") instanceof Number)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        long userId = ((Number) session.getAttribute("userId")).longValue();

        if (userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LocalDate selectedDate = LocalDate.now();

        String dateParameter = request.getParameter("week");

        if (dateParameter != null && !dateParameter.trim().isEmpty()) {
            try {
                selectedDate = LocalDate.parse(dateParameter.trim());
            } catch (DateTimeParseException exception) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid calendar date."
                );
                return;
            }
        }

        LocalDate weekStart =
                selectedDate.with(DayOfWeek.MONDAY);

        LocalDate weekEnd = weekStart.plusDays(6);

        try {
            List<Task> tasks = taskDAO.getTasksByUserId(userId);

            request.setAttribute("tasks", tasks);
            request.setAttribute("weekStart", weekStart);
            request.setAttribute("weekEnd", weekEnd);
            request.setAttribute("today", LocalDate.now());

            request.getRequestDispatcher("/calendar.jsp")
                   .forward(request, response);

        } catch (RuntimeException exception) {
            getServletContext().log(
                "Unable to load the calendar.",
                exception
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load the calendar. Please try again."
            );
        }
    }
}
