
package com.dayWise.dao;

import java.util.List;

import com.dayWise.model.Project;

public interface ProjectDAO {

    // Create a new project for a user
    boolean addProject(Project project);

    // Retrieve all projects belonging to a user
    List<Project> getProjectsByUserId(long userId);

    // Retrieve one project by its ID and owner
    Project getProjectById(long projectId, long userId);

    // Update project details
    boolean updateProject(Project project);

    // Delete a project belonging to a specific user
    boolean deleteProject(long projectId, long userId);

    // Update the status of a project
    boolean updateProjectStatus(
            long projectId, long userId, String status);
}
