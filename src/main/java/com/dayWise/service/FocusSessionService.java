
package com.dayWise.service;

import java.util.List;

import com.dayWise.model.FocusSession;

/**
 * Defines business operations for focus sessions.
 */
public interface FocusSessionService {

    boolean startSession(FocusSession session);

    List<FocusSession> getSessionsByUserId(long userId);

    List<FocusSession> getSessionsByTaskId(long taskId, long userId);

    FocusSession getSessionById(long sessionId, long userId);

    boolean endSession(long sessionId, long userId,
            int durationMinutes, String status);

    List<FocusSession> getActiveSessions(long userId);

    boolean deleteSession(long sessionId, long userId);

    int getTotalFocusMinutes(long userId);
}
