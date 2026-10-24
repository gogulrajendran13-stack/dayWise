
package com.dayWise.service;

import java.util.Collections;
import java.util.List;

import com.dayWise.dao.ProjectDAO;
import com.dayWise.dao.ProjectDAOImpl;
import com.dayWise.model.Project;

/**
 * Implements business rules for project management.
 */
public class ProjectServiceImpl implements ProjectService {

    private final ProjectDAO projectDAO;

    public ProjectServiceImpl() {
        this(new ProjectDAOImpl());
    }

    public ProjectServiceImpl(ProjectDAO projectDAO) {
        if (projectDAO == null) {
            throw new IllegalArgumentException(
                    "ProjectDAO cannot be null.");
        }

        this.projectDAO = projectDAO;
    }

    @Override
    public boolean addProject(Project project) {

        if (project == null || project.getUserId() <= 0) {
            return false;
        }

        String projectName = project.getProjectName();

        if (projectName == null) {
            return false;
        }

        projectName = projectName.trim();

        if (projectName.isEmpty() || projectName.length() > 150) {
            return false;
        }

        if (project.getDescription() != null
                && project.getDescription().length() > 65535) {
            return false;
        }

        if (project.getStartDate() != null
                && project.getDueDate() != null
                && project.getDueDate()
                        .before(project.getStartDate())) {
            return false;
        }

        project.setProjectName(projectName);

        if (project.getProjectColor() == null
                || !project.getProjectColor().matches(
                        "^#[0-9A-Fa-f]{6}$")) {
            project.setProjectColor("#8B5CF6");
        }

        if (project.getStatus() == null
                || project.getStatus().trim().isEmpty()) {
            project.setStatus("ACTIVE");
        } else {
            project.setStatus(
                    project.getStatus().trim().toUpperCase());
        }

        if (!isValidStatus(project.getStatus())) {
            return false;
        }

        return projectDAO.addProject(project);
    }

    @Override
    public List<Project> getProjectsByUserId(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<Project> projects =
                projectDAO.getProjectsByUserId(userId);

        return projects != null
                ? projects : Collections.emptyList();
    }

    @Override
    public Project getProjectById(long projectId, long userId) {

        if (projectId <= 0 || userId <= 0) {
            return null;
        }

        return projectDAO.getProjectById(projectId, userId);
    }

    @Override
    public boolean updateProject(Project project) {

        if (project == null || project.getProjectId() <= 0
                || project.getUserId() <= 0
                || project.getProjectName() == null) {
            return false;
        }

        String projectName = project.getProjectName().trim();

        if (projectName.isEmpty() || projectName.length() > 150) {
            return false;
        }

        if (project.getStartDate() != null
                && project.getDueDate() != null
                && project.getDueDate()
                        .before(project.getStartDate())) {
            return false;
        }

        Project existingProject = projectDAO.getProjectById(
                project.getProjectId(), project.getUserId());

        if (existingProject == null) {
            return false;
        }

        project.setProjectName(projectName);

        if (project.getProjectColor() == null
                || !project.getProjectColor().matches(
                        "^#[0-9A-Fa-f]{6}$")) {
            project.setProjectColor("#8B5CF6");
        }

        if (project.getStatus() == null
                || !isValidStatus(
                        project.getStatus().trim().toUpperCase())) {
            return false;
        }

        project.setStatus(
                project.getStatus().trim().toUpperCase());

        return projectDAO.updateProject(project);
    }

    @Override
    public boolean updateProjectStatus(long projectId, long userId,
            String status) {

        if (projectId <= 0 || userId <= 0 || status == null) {
            return false;
        }

        status = status.trim().toUpperCase();

        if (!isValidStatus(status)) {
            return false;
        }

        Project existingProject =
                projectDAO.getProjectById(projectId, userId);

        if (existingProject == null) {
            return false;
        }

        return projectDAO.updateProjectStatus(
                projectId, userId, status);
    }

    @Override
    public boolean deleteProject(long projectId, long userId) {

        if (projectId <= 0 || userId <= 0) {
            return false;
        }

        Project existingProject =
                projectDAO.getProjectById(projectId, userId);

        if (existingProject == null) {
            return false;
        }

        return projectDAO.deleteProject(projectId, userId);
    }

    private boolean isValidStatus(String status) {

        return "ACTIVE".equals(status)
                || "COMPLETED".equals(status)
                || "ARCHIVED".equals(status);
    }
}
