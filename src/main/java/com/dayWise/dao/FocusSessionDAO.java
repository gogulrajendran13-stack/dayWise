
package com.dayWise.dao;

import java.util.List;

import com.dayWise.model.FocusSession;

public interface FocusSessionDAO {

    // Start a new focus session
    boolean startSession(FocusSession session);

    // Retrieve all focus sessions belonging to a user
    List<FocusSession> getSessionsByUserId(long userId);

    // Retrieve focus sessions associated with a specific task
    List<FocusSession> getSessionsByTaskId(long taskId, long userId);

    // Retrieve one session by its ID and owner
    FocusSession getSessionById(long sessionId, long userId);

    // End a session and save its duration
    boolean endSession(
            long sessionId,
            long userId,
            int durationMinutes,
            String status);

    // Retrieve sessions that are currently in progress
    List<FocusSession> getActiveSessions(long userId);

    // Delete a focus session belonging to a specific user
    boolean deleteSession(long sessionId, long userId);

    // Calculate the total completed focus minutes for a user
    int getTotalFocusMinutes(long userId);
}
