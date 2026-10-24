
package com.dayWise.service;

import java.util.List;

import com.dayWise.model.Project;

/**
 * Defines business operations for managing user projects.
 */
public interface ProjectService {

    boolean addProject(Project project);

    List<Project> getProjectsByUserId(long userId);

    Project getProjectById(long projectId, long userId);

    boolean updateProject(Project project);

    boolean updateProjectStatus(long projectId, long userId,
            String status);

    boolean deleteProject(long projectId, long userId);
}
