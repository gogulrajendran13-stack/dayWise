
package com.dayWise.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import com.dayWise.model.Project;
import com.dayWise.service.ProjectService;
import com.dayWise.service.ProjectServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/projects")
public class ProjectController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProjectService projectService;

    @Override
    public void init() throws ServletException {
        projectService = new ProjectServiceImpl();
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

        List<Project> projects =
                projectService.getProjectsByUserId(userId);

        request.setAttribute("projects", projects);

        request.getRequestDispatcher("/projects.jsp")
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

        if (action == null) {
            redirect(request, response, "invalidAction");
            return;
        }

        try {
            boolean success;

            switch (action) {
                case "add":
                    success = addProject(request, userId);
                    break;

                case "update":
                    success = updateProject(request, userId);
                    break;

                case "status":
                    success = updateStatus(request, userId);
                    break;

                case "delete":
                    success = deleteProject(request, userId);
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
                    "Project operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean addProject(
            HttpServletRequest request, long userId) {

        String name = request.getParameter("projectName");

        if (isBlank(name)) {
            return false;
        }

        Project project = new Project();

        project.setUserId(userId);
        project.setProjectName(name.trim());
        project.setDescription(request.getParameter("description"));

        String color = request.getParameter("projectColor");
        project.setProjectColor(
                isBlank(color) ? "#8B5CF6" : color.trim());

        project.setStatus("ACTIVE");
        project.setStartDate(
                parseDate(request.getParameter("startDate")));
        project.setDueDate(
                parseDate(request.getParameter("dueDate")));

        return projectService.addProject(project);
    }

    private boolean updateProject(
            HttpServletRequest request, long userId) {

        Long projectId = parsePositiveLong(
                request.getParameter("projectId"));

        if (projectId == null) {
            return false;
        }

        Project project = projectService.getProjectById(
                projectId, userId);

        if (project == null) {
            return false;
        }

        String name = request.getParameter("projectName");

        if (isBlank(name)) {
            return false;
        }

        project.setProjectName(name.trim());
        project.setDescription(request.getParameter("description"));

        String color = request.getParameter("projectColor");

        if (!isBlank(color)) {
            project.setProjectColor(color.trim());
        }

        project.setStartDate(
                parseDate(request.getParameter("startDate")));
        project.setDueDate(
                parseDate(request.getParameter("dueDate")));

        return projectService.updateProject(project);
    }

    private boolean updateStatus(
            HttpServletRequest request, long userId) {

        Long projectId = parsePositiveLong(
                request.getParameter("projectId"));

        String status = request.getParameter("status");

        if (projectId == null || !isValidStatus(status)) {
            return false;
        }

        return projectService.updateProjectStatus(
                projectId, userId, status);
    }

    private boolean deleteProject(
            HttpServletRequest request, long userId) {

        Long projectId = parsePositiveLong(
                request.getParameter("projectId"));

        if (projectId == null) {
            return false;
        }

        return projectService.deleteProject(projectId, userId);
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

    private Date parseDate(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Date.valueOf(value.trim());

        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException(
                    "Invalid project date.");
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void redirect(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/projects?message=" + message);
    }
}
