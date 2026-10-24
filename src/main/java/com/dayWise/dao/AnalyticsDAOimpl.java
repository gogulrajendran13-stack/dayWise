
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.dayWise.util.DBConnection;

public class AnalyticsDAOimpl implements AnalyticsDAO {

    @Override
    public Map<String, Object> getAnalyticsData(long userId) {

        Map<String, Object> data = new LinkedHashMap<>();

        int total = 0;
        int completed = 0;
        int todo = 0;
        int inProgress = 0;
        int cancelled = 0;

        String summarySql =
                "SELECT COUNT(*) AS total_tasks, " +
                "SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_tasks, " +
                "SUM(CASE WHEN status = 'TODO' THEN 1 ELSE 0 END) AS todo_tasks, " +
                "SUM(CASE WHEN status = 'IN_PROGRESS' THEN 1 ELSE 0 END) AS progress_tasks, " +
                "SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_tasks " +
                "FROM tasks WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(summarySql)) {

            statement.setLong(1, userId);

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total_tasks");
                    completed = rs.getInt("completed_tasks");
                    todo = rs.getInt("todo_tasks");
                    inProgress = rs.getInt("progress_tasks");
                    cancelled = rs.getInt("cancelled_tasks");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to load analytics summary.", e);
        }

        int pending = todo + inProgress;
        double completionRate = total == 0
                ? 0.0
                : Math.round((completed * 10000.0) / total) / 100.0;

        data.put("totalTasks", total);
        data.put("completedTasks", completed);
        data.put("pendingTasks", pending);
        data.put("completionRate", completionRate);

        List<String> monthlyLabels = new ArrayList<>();
        List<Integer> monthlyCompleted = new ArrayList<>();
        List<Integer> monthlyRemaining = new ArrayList<>();

        DateTimeFormatter monthLabelFormat =
                DateTimeFormatter.ofPattern("MMM");

        String monthlySql =
                "SELECT " +
                "SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count, " +
                "SUM(CASE WHEN status IN ('TODO', 'IN_PROGRESS') THEN 1 ELSE 0 END) AS remaining_count " +
                "FROM tasks " +
                "WHERE user_id = ? AND created_at >= ? AND created_at < ?";

        LocalDate firstMonth =
                YearMonth.now().minusMonths(5).atDay(1);

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(monthlySql)) {

            for (int i = 0; i < 6; i++) {
                LocalDate monthStart = firstMonth.plusMonths(i);
                LocalDate nextMonth = monthStart.plusMonths(1);

                statement.setLong(1, userId);
                statement.setTimestamp(2,
                        Timestamp.valueOf(monthStart.atStartOfDay()));
                statement.setTimestamp(3,
                        Timestamp.valueOf(nextMonth.atStartOfDay()));

                try (ResultSet rs = statement.executeQuery()) {
                    int monthCompleted = 0;
                    int monthRemaining = 0;

                    if (rs.next()) {
                        monthCompleted = rs.getInt("completed_count");
                        monthRemaining = rs.getInt("remaining_count");
                    }

                    monthlyLabels.add(
                            monthStart.format(monthLabelFormat));
                    monthlyCompleted.add(monthCompleted);
                    monthlyRemaining.add(monthRemaining);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to load monthly analytics.", e);
        }

        data.put("monthlyLabels", monthlyLabels);
        data.put("monthlyCompleted", monthlyCompleted);
        data.put("monthlyRemaining", monthlyRemaining);

        List<String> weeklyLabels = new ArrayList<>();
        List<Integer> weeklyCompleted = new ArrayList<>();

        DateTimeFormatter weekLabelFormat =
                DateTimeFormatter.ofPattern("dd MMM");

        String weeklySql =
                "SELECT COUNT(*) AS completed_count " +
                "FROM tasks " +
                "WHERE user_id = ? AND status = 'COMPLETED' " +
                "AND completed_at >= ? AND completed_at < ?";

        LocalDate thisWeek = LocalDate.now()
                .with(java.time.DayOfWeek.MONDAY);

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(weeklySql)) {

            for (int i = 5; i >= 0; i--) {
                LocalDate weekStart = thisWeek.minusWeeks(i);
                LocalDate nextWeek = weekStart.plusWeeks(1);

                statement.setLong(1, userId);
                statement.setTimestamp(2,
                        Timestamp.valueOf(weekStart.atStartOfDay()));
                statement.setTimestamp(3,
                        Timestamp.valueOf(nextWeek.atStartOfDay()));

                try (ResultSet rs = statement.executeQuery()) {
                    int count = 0;

                    if (rs.next()) {
                        count = rs.getInt("completed_count");
                    }

                    weeklyLabels.add(
                            weekStart.format(weekLabelFormat));
                    weeklyCompleted.add(count);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to load weekly analytics.", e);
        }

        data.put("weeklyLabels", weeklyLabels);
        data.put("weeklyCompleted", weeklyCompleted);

        List<String> statusLabels = new ArrayList<>();
        List<Integer> statusCounts = new ArrayList<>();

        statusLabels.add("To Do");
        statusCounts.add(todo);

        statusLabels.add("In Progress");
        statusCounts.add(inProgress);

        statusLabels.add("Completed");
        statusCounts.add(completed);

        statusLabels.add("Cancelled");
        statusCounts.add(cancelled);

        data.put("statusLabels", statusLabels);
        data.put("statusCounts", statusCounts);

        data.put("progressCompleted", completed);
        data.put("progressRemaining", Math.max(0, total - completed));

        return data;
    }
}
