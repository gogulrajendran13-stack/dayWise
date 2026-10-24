
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dayWise.model.Project;
import com.dayWise.util.DBConnection;

public class ProjectDAOImpl implements ProjectDAO {

    // Create a new project
    @Override
    public boolean addProject(Project project) {

        String sql = "INSERT INTO projects "
                + "(user_id, project_name, description, project_color, "
                + "status, start_date, due_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, project.getUserId());
            statement.setString(2, project.getProjectName());
            statement.setString(3, project.getDescription());
            statement.setString(4, project.getProjectColor());
            statement.setString(5, project.getStatus());

            // SQL DATE columns can be NULL
            if (project.getStartDate() != null) {
                statement.setDate(6, project.getStartDate());
            } else {
                statement.setNull(6, java.sql.Types.DATE);
            }

            if (project.getDueDate() != null) {
                statement.setDate(7, project.getDueDate());
            } else {
                statement.setNull(7, java.sql.Types.DATE);
            }

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error creating project.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve all projects belonging to a user
    @Override
    public List<Project> getProjectsByUserId(long userId) {

        List<Project> projects = new ArrayList<>();

        String sql = "SELECT * FROM projects "
                + "WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    projects.add(mapProject(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving projects.");
            e.printStackTrace();
        }

        return projects;
    }

    // Retrieve a project only when it belongs to the specified user
    @Override
    public Project getProjectById(long projectId, long userId) {

        String sql = "SELECT * FROM projects "
                + "WHERE project_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, projectId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapProject(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving project by ID.");
            e.printStackTrace();
        }

        return null;
    }

    // Update project details while checking ownership
    @Override
    public boolean updateProject(Project project) {

        String sql = "UPDATE projects SET "
                + "project_name = ?, description = ?, "
                + "project_color = ?, status = ?, "
                + "start_date = ?, due_date = ? "
                + "WHERE project_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, project.getProjectName());
            statement.setString(2, project.getDescription());
            statement.setString(3, project.getProjectColor());
            statement.setString(4, project.getStatus());

            if (project.getStartDate() != null) {
                statement.setDate(5, project.getStartDate());
            } else {
                statement.setNull(5, java.sql.Types.DATE);
            }

            if (project.getDueDate() != null) {
                statement.setDate(6, project.getDueDate());
            } else {
                statement.setNull(6, java.sql.Types.DATE);
            }

            statement.setLong(7, project.getProjectId());
            statement.setLong(8, project.getUserId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating project.");
            e.printStackTrace();
            return false;
        }
    }

    // Delete a project only if it belongs to the specified user
    @Override
    public boolean deleteProject(long projectId, long userId) {

        String sql = "DELETE FROM projects "
                + "WHERE project_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, projectId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting project.");
            e.printStackTrace();
            return false;
        }
    }

    // Update the status of a project
    @Override
    public boolean updateProjectStatus(
            long projectId, long userId, String status) {

        // Accept only the statuses supported by the database
        if (!"ACTIVE".equals(status)
                && !"COMPLETED".equals(status)
                && !"ARCHIVED".equals(status)) {
            return false;
        }

        String sql = "UPDATE projects SET status = ? "
                + "WHERE project_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setLong(2, projectId);
            statement.setLong(3, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating project status.");
            e.printStackTrace();
            return false;
        }
    }

    // Convert a database row into a Project object
    private Project mapProject(ResultSet resultSet)
            throws SQLException {

        Project project = new Project();

        project.setProjectId(resultSet.getLong("project_id"));
        project.setUserId(resultSet.getLong("user_id"));
        project.setProjectName(resultSet.getString("project_name"));
        project.setDescription(resultSet.getString("description"));
        project.setProjectColor(resultSet.getString("project_color"));
        project.setStatus(resultSet.getString("status"));

        Date startDate = resultSet.getDate("start_date");
        project.setStartDate(startDate);

        Date dueDate = resultSet.getDate("due_date");
        project.setDueDate(dueDate);

        project.setCreatedAt(resultSet.getTimestamp("created_at"));
        project.setUpdatedAt(resultSet.getTimestamp("updated_at"));

        return project;
    }
}
