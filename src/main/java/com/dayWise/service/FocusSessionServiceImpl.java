
package com.dayWise.service;

import java.sql.Timestamp;
import java.util.Collections;
import java.util.List;

import com.dayWise.dao.FocusSessionDAO;
import com.dayWise.dao.FocusSessionDAOImpl;
import com.dayWise.model.FocusSession;

/**
 * Implements business rules for focus-session management.
 */
public class FocusSessionServiceImpl implements FocusSessionService {

    private final FocusSessionDAO focusSessionDAO;

    public FocusSessionServiceImpl() {
        this(new FocusSessionDAOImpl());
    }

    public FocusSessionServiceImpl(FocusSessionDAO focusSessionDAO) {
        if (focusSessionDAO == null) {
            throw new IllegalArgumentException(
                    "FocusSessionDAO cannot be null.");
        }

        this.focusSessionDAO = focusSessionDAO;
    }

    @Override
    public boolean startSession(FocusSession session) {

        if (session == null || session.getUserId() <= 0
                || session.getStartTime() == null) {
            return false;
        }

        if (session.getStartTime().after(
                new Timestamp(System.currentTimeMillis()))) {
            return false;
        }

        String sessionType = session.getSessionType();

        if (sessionType == null || sessionType.trim().isEmpty()) {
            sessionType = "FOCUS";
        } else {
            sessionType = sessionType.trim().toUpperCase();
        }

        if (!isValidSessionType(sessionType)) {
            return false;
        }

        session.setSessionType(sessionType);
        session.setDurationMinutes(0);
        session.setStatus("IN_PROGRESS");
        session.setEndTime(null);

        if (session.getNotes() != null
                && session.getNotes().length() > 500) {
            return false;
        }

        return focusSessionDAO.startSession(session);
    }

    @Override
    public List<FocusSession> getSessionsByUserId(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<FocusSession> sessions =
                focusSessionDAO.getSessionsByUserId(userId);

        return sessions != null
                ? sessions : Collections.emptyList();
    }

    @Override
    public List<FocusSession> getSessionsByTaskId(
            long taskId, long userId) {

        if (taskId <= 0 || userId <= 0) {
            return Collections.emptyList();
        }

        List<FocusSession> sessions =
                focusSessionDAO.getSessionsByTaskId(taskId, userId);

        return sessions != null
                ? sessions : Collections.emptyList();
    }

    @Override
    public FocusSession getSessionById(long sessionId, long userId) {

        if (sessionId <= 0 || userId <= 0) {
            return null;
        }

        return focusSessionDAO.getSessionById(sessionId, userId);
    }

    @Override
    public boolean endSession(long sessionId, long userId,
            int durationMinutes, String status) {

        if (sessionId <= 0 || userId <= 0
                || durationMinutes < 0
                || durationMinutes > 1440
                || status == null) {
            return false;
        }

        status = status.trim().toUpperCase();

        if (!"COMPLETED".equals(status)
                && !"CANCELLED".equals(status)) {
            return false;
        }

        FocusSession session =
                focusSessionDAO.getSessionById(sessionId, userId);

        if (session == null
                || !"IN_PROGRESS".equals(session.getStatus())) {
            return false;
        }

        Timestamp startTime = session.getStartTime();

        if (startTime == null) {
            return false;
        }

        long elapsedMillis =
                System.currentTimeMillis() - startTime.getTime();

        long elapsedMinutes = elapsedMillis / 60_000L;

        // Prevent a client from claiming more time than has elapsed.
        if (durationMinutes > elapsedMinutes + 1) {
            return false;
        }

        return focusSessionDAO.endSession(
                sessionId, userId, durationMinutes, status);
    }

    @Override
    public List<FocusSession> getActiveSessions(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<FocusSession> sessions =
                focusSessionDAO.getActiveSessions(userId);

        return sessions != null
                ? sessions : Collections.emptyList();
    }

    @Override
    public boolean deleteSession(long sessionId, long userId) {

        if (sessionId <= 0 || userId <= 0) {
            return false;
        }

        FocusSession session =
                focusSessionDAO.getSessionById(sessionId, userId);

        if (session == null) {
            return false;
        }

        return focusSessionDAO.deleteSession(sessionId, userId);
    }

    @Override
    public int getTotalFocusMinutes(long userId) {

        if (userId <= 0) {
            return 0;
        }

        return Math.max(
                0, focusSessionDAO.getTotalFocusMinutes(userId));
    }

    private boolean isValidSessionType(String sessionType) {

        return "FOCUS".equals(sessionType)
                || "SHORT_BREAK".equals(sessionType)
                || "LONG_BREAK".equals(sessionType);
    }
}
