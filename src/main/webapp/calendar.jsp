
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.time.LocalDate,java.time.format.DateTimeFormatter,java.util.List,com.dayWise.model.Task" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String taskDate(Task task) {
        if (task == null || task.getDueAt() == null) {
            return "";
        }

        return task.getDueAt().toLocalDateTime()
                   .toLocalDate().toString();
    }

    private String taskStatusClass(Task task) {
        String status = task.getStatus();

        if (status == null) return "todo";

        switch (status.toUpperCase()) {
            case "COMPLETED":
                return "completed";
            case "IN_PROGRESS":
                return "in-progress";
            case "CANCELLED":
                return "cancelled";
            default:
                return "todo";
        }
    }
%>

<%
    Object sessionUserId = session.getAttribute("userId");

    if (!(sessionUserId instanceof Number)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Task> tasks =
        (List<Task>) request.getAttribute("tasks");

    LocalDate weekStart =
        (LocalDate) request.getAttribute("weekStart");

    LocalDate weekEnd =
        (LocalDate) request.getAttribute("weekEnd");

    LocalDate today =
        (LocalDate) request.getAttribute("today");

    if (tasks == null) {
        tasks = java.util.Collections.emptyList();
    }

    if (weekStart == null) {
        weekStart = LocalDate.now()
            .with(java.time.DayOfWeek.MONDAY);
    }

    if (weekEnd == null) {
        weekEnd = weekStart.plusDays(6);
    }

    if (today == null) {
        today = LocalDate.now();
    }

    DateTimeFormatter headingFormat =
        DateTimeFormatter.ofPattern("MMM d, yyyy");

    DateTimeFormatter shortDateFormat =
        DateTimeFormatter.ofPattern("MMM d");

    String previousWeek =
        weekStart.minusWeeks(1).toString();

    String nextWeek =
        weekStart.plusWeeks(1).toString();

    Object fullNameObject = session.getAttribute("fullName");

    String fullName = fullNameObject == null
        ? "User"
        : fullNameObject.toString();

    String initial = fullName.trim().isEmpty()
        ? "U"
        : fullName.trim().substring(0, 1).toUpperCase();
%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Calendar | dayWise</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/calendar.css">
</head>

<body>

<div class="app-layout">

    <!-- ================ SIDEBAR ================ -->
    <aside class="sidebar" id="sidebar">

        <a class="brand" href="<%= request.getContextPath() %>/dashboard">
            <span class="brand-icon">&#10003;</span>
            <span class="brand-name">dayWise</span>
        </a>

        <nav class="sidebar-nav">

            <div class="nav-label">WORKSPACE</div>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/dashboard">
                <span class="nav-icon">&#9638;</span>
                <span>Dashboard</span>
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/tasks">
                <span class="nav-icon">&#9745;</span>
                <span>My Tasks</span>
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/projects">
                <span class="nav-icon">&#9776;</span>
                <span>Projects</span>
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/categories">
                <span class="nav-icon">&#9671;</span>
                <span>Categories</span>
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/recurring-tasks">
                <span class="nav-icon">&#8635;</span>
                <span>Recurring Tasks</span>
            </a>

            <div class="nav-label">PRODUCTIVITY</div>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/reminders">
                <span class="nav-icon">&#9826;</span>
                <span>Reminders</span>
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/notifications">
                <span class="nav-icon">&#9672;</span>
                <span>Notifications</span>
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/goals">
                <span class="nav-icon">&#9673;</span>
                <span>Goals</span>
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/focus-sessions">
                <span class="nav-icon">&#9719;</span>
                <span>Focus Sessions</span>
            </a>

            <a class="nav-link active"
               href="<%= request.getContextPath() %>/calendar">
                <span class="nav-icon">&#128197;</span>
                <span>Calendar</span>
            </a>

            <div class="nav-label">ACCOUNT</div>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/profile">
                <span class="nav-icon">&#9813;</span>
                <span>Profile</span>
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/settings">
                <span class="nav-icon">&#9881;</span>
                <span>Settings</span>
            </a>

        </nav>

        <div class="sidebar-bottom">
            <a class="nav-link logout-link"
               href="<%= request.getContextPath() %>/logout">
                <span class="nav-icon">&#10132;</span>
                <span>Logout</span>
            </a>
        </div>

    </aside>

    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- ================ MAIN COLUMN ================ -->
    <div class="page-column">

        <!-- Top bar -->
        <header class="topbar">

            <div class="topbar-left">

                <button class="menu-toggle"
                        id="menuToggle"
                        type="button"
                        aria-label="Open navigation">
                    &#9776;
                </button>

                <div class="breadcrumb">
                    <span>Workspace</span>
                    <span class="breadcrumb-divider">/</span>
                    <strong>Calendar</strong>
                </div>

            </div>

            <div class="profile-chip">
                <div class="profile-avatar">
                    <%= escapeHtml(initial) %>
                </div>

                <div class="profile-details">
                    <span class="profile-name">
                        <%= escapeHtml(fullName) %>
                    </span>
                    <span class="profile-label">Personal workspace</span>
                </div>
            </div>

        </header>

        <!-- Calendar content -->
        <main class="main-content">

            <div class="calendar-content">

                <section class="calendar-heading">

                    <div>
                        <span class="eyebrow">PLAN YOUR WEEK</span>
                        <h1>Calendar</h1>
                        <p>
                            Keep your tasks and deadlines organized
                            throughout the week.
                        </p>
                    </div>

                    <a class="today-button"
                       href="<%= request.getContextPath() %>/calendar">
                        Today
                    </a>

                </section>

                <!-- Date navigation -->
                <section class="calendar-toolbar">

                    <div class="date-navigation">

                        <a class="arrow-button"
                           aria-label="Previous week"
                           href="<%= request.getContextPath() %>/calendar?week=<%= previousWeek %>">
                            &#8592;
                        </a>

                        <a class="arrow-button"
                           aria-label="Next week"
                           href="<%= request.getContextPath() %>/calendar?week=<%= nextWeek %>">
                            &#8594;
                        </a>

                        <div class="date-range">
                            <span class="calendar-symbol">&#128197;</span>

                            <span>
                                <%= weekStart.format(headingFormat) %>
                                &ndash;
                                <%= weekEnd.format(headingFormat) %>
                            </span>
                        </div>

                    </div>

                    <div class="week-label">
                        WEEKLY VIEW
                    </div>

                </section>

                <!-- Weekly calendar grid -->
                <section class="calendar-panel">

                    <div class="calendar-grid">

                        <!-- Header row -->
                        <div class="grid-header task-header">
                            <span>Task</span>
                            <small>Task name and status</small>
                        </div>

                        <%
                            String[] dayNames = {
                                "Mon", "Tue", "Wed", "Thu",
                                "Fri", "Sat", "Sun"
                            };

                            for (int day = 0; day < 7; day++) {
                                LocalDate date = weekStart.plusDays(day);
                                boolean isToday = date.equals(today);
                        %>

                            <div class="grid-header day-header
                                <%= isToday ? "today-column" : "" %>">

                                <span><%= dayNames[day] %></span>

                                <strong>
                                    <%= date.getDayOfMonth() %>
                                </strong>

                            </div>

                        <%
                            }
                        %>

                        <!-- Task rows -->
                        <%
                            int visibleTasks = 0;

                            for (Task task : tasks) {
                                String dueDate = taskDate(task);

                                if (dueDate.isEmpty()) {
                                    continue;
                                }

                                LocalDate taskDueDate;

                                try {
                                    taskDueDate = LocalDate.parse(dueDate);
                                } catch (Exception exception) {
                                    continue;
                                }

                                if (taskDueDate.isBefore(weekStart)
                                        || taskDueDate.isAfter(weekEnd)) {
                                    continue;
                                }

                                visibleTasks++;

                                String statusClass = taskStatusClass(task);
                                String title = task.getTitle() == null
                                    ? "Untitled task"
                                    : task.getTitle();

                                String status = task.getStatus() == null
                                    ? "TODO"
                                    : task.getStatus().replace("_", " ");

                                String priority = task.getPriority() == null
                                    ? "NORMAL"
                                    : task.getPriority();

                                int taskDay =
                                    taskDueDate.getDayOfWeek().getValue() - 1;
                        %>

                            <div class="task-name-cell">

                                <span class="task-color-dot <%= statusClass %>"></span>

                                <div class="task-name-details">
                                    <strong><%= escapeHtml(title) %></strong>
                                    <span><%= escapeHtml(status) %></span>
                                </div>

                            </div>

                            <%
                                for (int day = 0; day < 7; day++) {
                                    LocalDate date = weekStart.plusDays(day);
                            %>

                                <div class="day-cell
                                    <%= date.equals(today) ? "today-column" : "" %>">

                                    <%
                                        if (day == taskDay) {
                                    %>

                                        <div class="task-card <%= statusClass %>">

                                            <strong>
                                                <%= escapeHtml(title) %>
                                            </strong>

                                            <span class="task-card-priority">
                                                <%= escapeHtml(priority) %>
                                            </span>

                                            <span class="task-card-status">
                                                <%= escapeHtml(status) %>
                                            </span>

                                        </div>

                                    <%
                                        }
                                    %>

                                </div>

                            <%
                                }
                            }

                            if (visibleTasks == 0) {
                            %>

                                <div class="empty-task-message">
                                    No tasks with due dates in this week.
                                    <br>
                                    Add a due date to a task to see it here.
                                </div>

                            <%
                            }
                        %>

                    </div>

                </section>

                <!-- Calendar legend -->
                <section class="calendar-legend">

                    <span class="legend-title">TASK STATUS</span>

                    <span class="legend-item">
                        <i class="legend-dot todo"></i>
                        To do
                    </span>

                    <span class="legend-item">
                        <i class="legend-dot in-progress"></i>
                        In progress
                    </span>

                    <span class="legend-item">
                        <i class="legend-dot completed"></i>
                        Completed
                    </span>

                    <span class="legend-item">
                        <i class="legend-dot cancelled"></i>
                        Cancelled
                    </span>

                </section>

            </div>

        </main>

    </div>

</div>

<!-- ======================================================
     SHARED FULL-WIDTH FOOTER
     Outside app-layout: spans below sidebar and main area.
     ====================================================== -->
<footer class="site-footer">

    <div class="footer-main">

        <div class="footer-about">

            <a class="footer-brand" href="<%= contextPath %>/dashboard">
                <span class="footer-brand-icon">✓</span>
                <span>dayWise</span>
            </a>

            <h2>Make room for what matters.</h2>

            <p>
                Organize tasks, plan projects, build routines,
                and make focused progress throughout your day.
            </p>

            <p class="footer-tagline">Make every day count.</p>

        </div>

        <div class="footer-column">
            <h3>Workspace</h3>
            <a href="<%= contextPath %>/dashboard">Dashboard</a>
            <a href="<%= contextPath %>/tasks">My Tasks</a>
            <a href="<%= contextPath %>/projects">Projects</a>
            <a href="<%= contextPath %>/categories">Categories</a>
        </div>

        <div class="footer-column">
            <h3>Productivity</h3>
            <a href="<%= contextPath %>/goals">Goals</a>
            <a href="<%= contextPath %>/focus-sessions">Focus Sessions</a>
            <a href="<%= contextPath %>/recurring-tasks">Recurring Tasks</a>
            <a href="<%= contextPath %>/reminders">Reminders</a>
        </div>

        <div class="footer-column">
            <h3>Account</h3>
            <a href="<%= contextPath %>/profile">My Profile</a>
            <a href="<%= contextPath %>/settings">Settings</a>
            <a href="<%= contextPath %>/notifications">Notifications</a>
            <a href="<%= contextPath %>/logout">Logout</a>
        </div>

    </div>

    <div class="footer-bottom">
        <p>
            &copy; <%= java.time.Year.now().getValue() %> dayWise.
            All rights reserved.
        </p>

        <p>Plan mindfully. Focus deeply. Make progress.</p>
    </div>

</footer>


<script>
    const menuToggle = document.getElementById("menuToggle");
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebarOverlay");

    function closeSidebar() {
        sidebar.classList.remove("sidebar-open");
        overlay.classList.remove("overlay-open");
        document.body.classList.remove("sidebar-visible");
    }

    if (menuToggle && sidebar && overlay) {
        menuToggle.addEventListener("click", function () {
            sidebar.classList.toggle("sidebar-open");
            overlay.classList.toggle("overlay-open");
            document.body.classList.toggle("sidebar-visible");
        });

        overlay.addEventListener("click", closeSidebar);
    }
</script>

</body>
</html>
