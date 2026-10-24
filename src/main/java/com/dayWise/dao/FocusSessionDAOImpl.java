
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.dayWise.model.FocusSession;
import com.dayWise.util.DBConnection;

public class FocusSessionDAOImpl implements FocusSessionDAO {

    // Start a new focus session
    @Override
    public boolean startSession(FocusSession session) {

        String sql = "INSERT INTO focus_sessions "
                + "(user_id, task_id, session_type, start_time, "
                + "end_time, duration_minutes, status, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, session.getUserId());

            if (session.getTaskId() != null) {
                statement.setLong(2, session.getTaskId());
            } else {
                statement.setNull(2, Types.BIGINT);
            }

            statement.setString(3, session.getSessionType());
            statement.setTimestamp(4, session.getStartTime());
            setNullableTimestamp(statement, 5, session.getEndTime());
            statement.setInt(6, session.getDurationMinutes());
            statement.setString(7, session.getStatus());
            statement.setString(8, session.getNotes());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error starting focus session.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve all focus sessions belonging to a user
    @Override
    public List<FocusSession> getSessionsByUserId(long userId) {

        List<FocusSession> sessions = new ArrayList<>();

        String sql = "SELECT * FROM focus_sessions "
                + "WHERE user_id = ? ORDER BY start_time DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    sessions.add(mapFocusSession(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving focus sessions.");
            e.printStackTrace();
        }

        return sessions;
    }

    // Retrieve sessions linked to a task and owned by the user
    @Override
    public List<FocusSession> getSessionsByTaskId(
            long taskId, long userId) {

        List<FocusSession> sessions = new ArrayList<>();

        String sql = "SELECT * FROM focus_sessions "
                + "WHERE task_id = ? AND user_id = ? "
                + "ORDER BY start_time DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, taskId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    sessions.add(mapFocusSession(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving task focus sessions.");
            e.printStackTrace();
        }

        return sessions;
    }

    // Retrieve one session only if it belongs to the specified user
    @Override
    public FocusSession getSessionById(long sessionId, long userId) {

        String sql = "SELECT * FROM focus_sessions "
                + "WHERE session_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, sessionId);
            statement.setLong(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapFocusSession(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving focus session.");
            e.printStackTrace();
        }

        return null;
    }

    // End a session and save its duration
    @Override
    public boolean endSession(
            long sessionId,
            long userId,
            int durationMinutes,
            String status) {

        if (durationMinutes < 0
                || (!"COMPLETED".equals(status)
                && !"CANCELLED".equals(status))) {
            return false;
        }

        String sql = "UPDATE focus_sessions SET "
                + "end_time = CURRENT_TIMESTAMP, "
                + "duration_minutes = ?, status = ? "
                + "WHERE session_id = ? AND user_id = ? "
                + "AND status = 'IN_PROGRESS'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, durationMinutes);
            statement.setString(2, status);
            statement.setLong(3, sessionId);
            statement.setLong(4, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error ending focus session.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve sessions that are currently in progress
    @Override
    public List<FocusSession> getActiveSessions(long userId) {

        List<FocusSession> sessions = new ArrayList<>();

        String sql = "SELECT * FROM focus_sessions "
                + "WHERE user_id = ? AND status = 'IN_PROGRESS' "
                + "ORDER BY start_time DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    sessions.add(mapFocusSession(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving active sessions.");
            e.printStackTrace();
        }

        return sessions;
    }

    // Delete a session only if it belongs to the specified user
    @Override
    public boolean deleteSession(long sessionId, long userId) {

        String sql = "DELETE FROM focus_sessions "
                + "WHERE session_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, sessionId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting focus session.");
            e.printStackTrace();
            return false;
        }
    }

    // Calculate total minutes spent in completed focus sessions
    @Override
    public int getTotalFocusMinutes(long userId) {

        String sql = "SELECT COALESCE(SUM(duration_minutes), 0) "
                + "AS total_minutes FROM focus_sessions "
                + "WHERE user_id = ? "
                + "AND session_type = 'FOCUS' "
                + "AND status = 'COMPLETED'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("total_minutes");
                }
            }

        } catch (SQLException e) {
            System.err.println("Error calculating focus minutes.");
            e.printStackTrace();
        }

        return 0;
    }

    // Convert a database row into a FocusSession object
    private FocusSession mapFocusSession(ResultSet resultSet)
            throws SQLException {

        FocusSession session = new FocusSession();

        session.setSessionId(resultSet.getLong("session_id"));
        session.setUserId(resultSet.getLong("user_id"));

        long taskId = resultSet.getLong("task_id");
        session.setTaskId(resultSet.wasNull() ? null : taskId);

        session.setSessionType(resultSet.getString("session_type"));
        session.setStartTime(resultSet.getTimestamp("start_time"));
        session.setEndTime(resultSet.getTimestamp("end_time"));
        session.setDurationMinutes(
                resultSet.getInt("duration_minutes"));
        session.setStatus(resultSet.getString("status"));
        session.setNotes(resultSet.getString("notes"));
        session.setCreatedAt(resultSet.getTimestamp("created_at"));

        return session;
    }

    // Set an optional timestamp while preserving SQL NULL
    private void setNullableTimestamp(
            PreparedStatement statement, int index, Timestamp value)
            throws SQLException {

        if (value != null) {
            statement.setTimestamp(index, value);
        } else {
            statement.setNull(index, Types.TIMESTAMP);
        }
    }
}
