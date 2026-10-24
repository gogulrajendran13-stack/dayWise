
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dayWise.model.FocusSession" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String contextPath = request.getContextPath();

    String fullName = (String) session.getAttribute("fullName");
    if (fullName == null || fullName.isBlank()) {
        fullName = "User";
    }

    String firstName = fullName.trim().split("\\s+")[0];

    String safeFirstName = firstName
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");

    List<FocusSession> focusSessions =
        (List<FocusSession>) request.getAttribute("focusSessions");

    if (focusSessions == null) {
        focusSessions = java.util.Collections.emptyList();
    }

    Object totalMinutesAttribute = request.getAttribute("totalFocusMinutes");
    int totalFocusMinutes = 0;

    if (totalMinutesAttribute instanceof Number) {
        totalFocusMinutes = Math.max(0,
            ((Number) totalMinutesAttribute).intValue());
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String safeError = "";

    if (errorMessage != null) {
        safeError = errorMessage
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }

    String success = request.getParameter("success");

    String formattedTotalHours = String.valueOf(totalFocusMinutes / 60);
    String formattedRemainingMinutes = String.valueOf(totalFocusMinutes % 60);

    DateTimeFormatter dateTimeFormatter =
        DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a", Locale.ENGLISH);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Focus Sessions | dayWise</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/focus-sessions.css">
</head>

<body>

<!-- ======================================================
     APPLICATION LAYOUT: sidebar + main content
     The shared footer is deliberately OUTSIDE this layout.
     ====================================================== -->
<div class="app-layout">

    <!-- ========== SHARED SIDEBAR ========== -->
    <aside class="sidebar" id="sidebar">

        <a class="brand" href="<%= contextPath %>/dashboard"
           aria-label="dayWise dashboard">
            <span class="brand-icon">✓</span>
            <span class="brand-name">dayWise</span>
        </a>

        <nav class="sidebar-nav" aria-label="Main navigation">

            <p class="nav-label">WORKSPACE</p>

            <a class="nav-link" href="<%= contextPath %>/dashboard">
                <span class="nav-icon">⌂</span>
                <span>Dashboard</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/tasks">
                <span class="nav-icon">▤</span>
                <span>My Tasks</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/projects">
                <span class="nav-icon">▦</span>
                <span>Projects</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/categories">
                <span class="nav-icon">◇</span>
                <span>Categories</span>
            </a>

            <p class="nav-label">PRODUCTIVITY</p>

            <a class="nav-link" href="<%= contextPath %>/recurring-tasks">
                <span class="nav-icon">↻</span>
                <span>Recurring Tasks</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/reminders">
                <span class="nav-icon">◷</span>
                <span>Reminders</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/notifications">
                <span class="nav-icon">♧</span>
                <span>Notifications</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/goals">
                <span class="nav-icon">◎</span>
                <span>Goals</span>
            </a>

            <a class="nav-link active"
               href="<%= contextPath %>/focus-sessions"
               aria-current="page">
                <span class="nav-icon">◷</span>
                <span>Focus Sessions</span>
            </a>

            <p class="nav-label">ACCOUNT</p>

            <a class="nav-link" href="<%= contextPath %>/profile">
                <span class="nav-icon">♙</span>
                <span>Profile</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/settings">
                <span class="nav-icon">⚙</span>
                <span>Settings</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <form class="logout-form"
                  action="<%= contextPath %>/logout"
                  method="post">
                <button class="logout-button" type="submit">
                    <span class="nav-icon">⇥</span>
                    <span>Logout</span>
                </button>
            </form>
        </div>

    </aside>
    <!-- ========== END SHARED SIDEBAR ========== -->


    <!-- Mobile overlay -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>


    <!-- ========== MAIN COLUMN ========== -->
    <div class="page-column">

        <main class="main-content">

            <!-- Top navigation -->
            <header class="topbar">

                <div class="topbar-left">
                    <button class="mobile-menu-button"
                            id="menuButton"
                            type="button"
                            aria-label="Open navigation"
                            aria-controls="sidebar"
                            aria-expanded="false">
                        ☰
                    </button>

                    <div class="breadcrumb">
                        Productivity <span>/</span>
                        <strong>Focus Sessions</strong>
                    </div>
                </div>

                <a class="profile-chip"
                   href="<%= contextPath %>/profile">
                    <span class="avatar">
                        <%= safeFirstName.substring(0, 1)
                                      .toUpperCase(Locale.ROOT) %>
                    </span>
                    <span class="profile-details">
                        <span class="profile-name"><%= safeFirstName %></span>
                        <span class="profile-label">Personal workspace</span>
                    </span>
                </a>

            </header>


            <div class="page-content">

                <!-- Page heading -->
                <section class="page-heading">
                    <div>
                        <p class="eyebrow">FOCUS · BREATHE · REPEAT</p>
                        <h1>Focus <span>Sessions</span></h1>
                        <p class="page-description">
                            Make dedicated time for your work and track your focus history.
                        </p>
                    </div>

                    <a class="primary-button" href="#startSessionForm">
                        <span>＋</span> Start a session
                    </a>
                </section>


                <!-- Feedback messages -->
                <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                    <div class="alert alert-error" role="alert">
                        <%= safeError %>
                    </div>
                <% } %>

                <% if ("started".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Your focus session has started.
                    </div>
                <% } else if ("completed".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Your focus session has been completed.
                    </div>
                <% } else if ("cancelled".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Your focus session has been cancelled.
                    </div>
                <% } else if ("deleted".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Focus session deleted successfully.
                    </div>
                <% } %>


                <!-- Focus summary cards -->
                <section class="focus-summary-grid">

                    <article class="summary-card">
                        <div class="summary-icon summary-purple">◷</div>
                        <p class="summary-label">Total focus time</p>
                        <h2>
                            <%= formattedTotalHours %><span>h</span>
                            <%= formattedRemainingMinutes %><span>m</span>
                        </h2>
                        <p class="summary-description">
                            Total minutes reported by your controller.
                        </p>
                    </article>

                    <article class="summary-card">
                        <div class="summary-icon summary-blue">◎</div>
                        <p class="summary-label">Sessions in this list</p>
                        <h2><%= focusSessions.size() %></h2>
                        <p class="summary-description">
                            Sessions returned for your account.
                        </p>
                    </article>

                    <article class="summary-card">
                        <div class="summary-icon summary-green">✦</div>
                        <p class="summary-label">Small steps</p>
                        <h2>One at a time</h2>
                        <p class="summary-description">
                            Consistency matters more than perfection.
                        </p>
                    </article>

                </section>


                <!-- Start session form -->
                <section class="focus-form-card" id="startSessionForm">

                    <div class="section-heading">
                        <div>
                            <h2>Start a focus session</h2>
                            <p>Choose a session type and add optional notes.</p>
                        </div>
                    </div>

                    <form action="<%= contextPath %>/focus-sessions"
                          method="post"
                          class="focus-form">

                        <input type="hidden" name="action" value="start">

                        <div class="form-field">
                            <label for="sessionType">Session type <span>*</span></label>
                            <select id="sessionType" name="sessionType" required>
                                <option value="FOCUS">Focus</option>
                                <option value="BREAK">Break</option>
                            </select>
                        </div>

                        <div class="form-field">
                            <label for="taskId">Related task ID (optional)</label>
                            <input type="number"
                                   id="taskId"
                                   name="taskId"
                                   min="1"
                                   step="1"
                                   placeholder="Enter a task ID">
                        </div>

                        <div class="form-field full-width">
                            <label for="sessionNotes">Notes (optional)</label>
                            <textarea id="sessionNotes"
                                      name="notes"
                                      rows="3"
                                      maxlength="2000"
                                      placeholder="What would you like to focus on?"></textarea>
                        </div>

                        <div class="form-actions full-width">
                            <button class="primary-button" type="submit">
                                Start session
                            </button>
                        </div>

                    </form>
                </section>


                <!-- Session history -->
                <section class="sessions-section">

                    <div class="section-heading history-heading">
                        <div>
                            <h2>Session history</h2>
                            <p>Review your previous and active sessions.</p>
                        </div>

                        <span class="session-count">
                            <%= focusSessions.size() %> session(s)
                        </span>
                    </div>

                    <% if (focusSessions.isEmpty()) { %>

                        <div class="empty-state">
                            <div class="empty-icon">◷</div>
                            <h3>Your focus journey starts here</h3>
                            <p>
                                Start your first session to begin building a
                                record of your focused work.
                            </p>
                            <a class="secondary-button" href="#startSessionForm">
                                Start your first session
                            </a>
                        </div>

                    <% } else { %>

                        <div class="session-list">

                            <% for (FocusSession focusSession : focusSessions) {

                                String sessionType = focusSession.getSessionType() == null
                                    ? "FOCUS" : focusSession.getSessionType();

                                String safeSessionType = sessionType
                                    .replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;");

                                String sessionStatus = focusSession.getStatus() == null
                                    ? "UNKNOWN" : focusSession.getStatus();

                                String safeSessionStatus = sessionStatus
                                    .replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;");

                                String notes = focusSession.getNotes() == null
                                    ? "" : focusSession.getNotes();

                                String safeNotes = notes
                                    .replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;");

                                String startTimeText =
                                    focusSession.getStartTime() == null
                                    ? "Not recorded"
                                    : focusSession.getStartTime()
                                        .toLocalDateTime()
                                        .format(dateTimeFormatter);

                                String endTimeText =
                                    focusSession.getEndTime() == null
                                    ? "In progress"
                                    : focusSession.getEndTime()
                                        .toLocalDateTime()
                                        .format(dateTimeFormatter);

                                int duration =
                                    Math.max(0, focusSession.getDurationMinutes());
                            %>

                                <article class="session-card">

                                    <div class="session-type-icon">
                                        <%= "BREAK".equalsIgnoreCase(sessionType)
                                            ? "☕" : "◷" %>
                                    </div>

                                    <div class="session-main">

                                        <div class="session-title-row">
                                            <h3>
                                                <%= safeSessionType %> session
                                                <span class="session-id">
                                                    #<%= focusSession.getSessionId() %>
                                                </span>
                                            </h3>

                                            <span class="status-badge
                                                <%= "IN_PROGRESS".equalsIgnoreCase(sessionStatus)
                                                    ? "status-progress"
                                                    : "status-complete" %>">
                                                <%= safeSessionStatus %>
                                            </span>
                                        </div>

                                        <p class="session-time">
                                            Started: <%= startTimeText %>
                                        </p>

                                        <p class="session-time">
                                            Ended: <%= endTimeText %>
                                        </p>

                                        <% if (!safeNotes.isBlank()) { %>
                                            <p class="session-notes"><%= safeNotes %></p>
                                        <% } %>

                                        <div class="session-duration">
                                            Duration:
                                            <strong><%= duration %> minute(s)</strong>
                                        </div>

                                    </div>

                                    <div class="session-actions">

                                        <% if ("IN_PROGRESS".equalsIgnoreCase(sessionStatus)) { %>

                                            <form action="<%= contextPath %>/focus-sessions"
                                                  method="post">
                                                <input type="hidden"
                                                       name="action"
                                                       value="complete">
                                                <input type="hidden"
                                                       name="sessionId"
                                                       value="<%= focusSession.getSessionId() %>">

                                                <button class="primary-button"
                                                        type="submit">
                                                    Complete
                                                </button>
                                            </form>

                                            <form action="<%= contextPath %>/focus-sessions"
                                                  method="post"
                                                  onsubmit="return confirm('Cancel this focus session?');">
                                                <input type="hidden"
                                                       name="action"
                                                       value="cancel">
                                                <input type="hidden"
                                                       name="sessionId"
                                                       value="<%= focusSession.getSessionId() %>">

                                                <button class="secondary-button"
                                                        type="submit">
                                                    Cancel
                                                </button>
                                            </form>

                                        <% } else { %>

                                            <form action="<%= contextPath %>/focus-sessions"
                                                  method="post"
                                                  onsubmit="return confirm('Delete this session record?');">
                                                <input type="hidden"
                                                       name="action"
                                                       value="delete">
                                                <input type="hidden"
                                                       name="sessionId"
                                                       value="<%= focusSession.getSessionId() %>">

                                                <button class="icon-button delete-button"
                                                        type="submit"
                                                        aria-label="Delete session"
                                                        title="Delete session">
                                                    ×
                                                </button>
                                            </form>

                                        <% } %>

                                    </div>
                                </article>

                            <% } %>

                        </div>

                    <% } %>

                </section>

            </div>
            <!-- End page-content -->

        </main>
        <!-- End main-content -->

    </div>
    <!-- End page-column -->

</div>
<!-- End app-layout -->


<!-- ======================================================
     SHARED FULL-WIDTH FOOTER
     Outside app-layout so it spans below BOTH sidebar
     and main content.
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


<!-- Mobile sidebar interaction -->
<script>
(function () {
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebarOverlay");
    const menuButton = document.getElementById("menuButton");

    function closeMenu() {
        sidebar.classList.remove("sidebar-open");
        overlay.classList.remove("overlay-open");
        menuButton.setAttribute("aria-expanded", "false");
        menuButton.setAttribute("aria-label", "Open navigation");
    }

    menuButton.addEventListener("click", function () {
        const isOpen = sidebar.classList.toggle("sidebar-open");

        overlay.classList.toggle("overlay-open", isOpen);
        menuButton.setAttribute("aria-expanded", String(isOpen));
        menuButton.setAttribute(
            "aria-label",
            isOpen ? "Close navigation" : "Open navigation"
        );
    });

    overlay.addEventListener("click", closeMenu);

    document.querySelectorAll(".sidebar .nav-link").forEach(function (link) {
        link.addEventListener("click", closeMenu);
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeMenu();
        }
    });

    window.addEventListener("resize", function () {
        if (window.innerWidth > 900) {
            closeMenu();
        }
    });
})();
</script>

</body>
</html>
