
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.dayWise.model.Reminder" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

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
    String safeFirstName = escapeHtml(firstName);

    List<Reminder> reminders =
        (List<Reminder>) request.getAttribute("reminders");

    if (reminders == null) {
        reminders = java.util.Collections.emptyList();
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String safeError = escapeHtml(errorMessage);
    String success = request.getParameter("success");

    java.time.format.DateTimeFormatter dateTimeFormatter =
        java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reminders | dayWise</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/reminders.css">
</head>

<body>

<!-- =====================================================
     APP LAYOUT: SIDEBAR + MAIN COLUMN
     Footer is deliberately outside this container.
     ===================================================== -->
<div class="app-layout">

    <!-- Shared sidebar -->
    <aside class="sidebar" id="sidebar">

        <a class="brand" href="<%= contextPath %>/dashboard">
            <span class="brand-icon">✓</span>
            <span class="brand-name">dayWise</span>
        </a>

        <nav class="sidebar-nav" aria-label="Main navigation">

            <p class="nav-label">WORKSPACE</p>

            <a class="nav-link" href="<%= contextPath %>/dashboard">
                <span class="nav-icon">⌂</span><span>Dashboard</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/tasks">
                <span class="nav-icon">▤</span><span>My Tasks</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/projects">
                <span class="nav-icon">▦</span><span>Projects</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/categories">
                <span class="nav-icon">◇</span><span>Categories</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/recurring-tasks">
                <span class="nav-icon">↻</span><span>Recurring Tasks</span>
            </a>

            <p class="nav-label">PRODUCTIVITY</p>

            <a class="nav-link active"
               href="<%= contextPath %>/reminders"
               aria-current="page">
                <span class="nav-icon">◷</span><span>Reminders</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/notifications">
                <span class="nav-icon">♧</span><span>Notifications</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/goals">
                <span class="nav-icon">◎</span><span>Goals</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/focus-sessions">
                <span class="nav-icon">◷</span><span>Focus Sessions</span>
            </a>

            <p class="nav-label">ACCOUNT</p>

            <a class="nav-link" href="<%= contextPath %>/profile">
                <span class="nav-icon">♙</span><span>Profile</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/settings">
                <span class="nav-icon">⚙</span><span>Settings</span>
            </a>

        </nav>

        <div class="sidebar-bottom">
            <form class="logout-form"
                  action="<%= contextPath %>/logout"
                  method="post">
                <button class="logout-button" type="submit">
                    <span class="nav-icon">⇥</span><span>Logout</span>
                </button>
            </form>
        </div>

    </aside>
    <!-- End shared sidebar -->

    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- Main column -->
    <div class="page-column">

        <main class="main-content">

            <!-- Top bar -->
            <header class="topbar">

                <div class="topbar-left">
                    <button class="mobile-menu-button"
                            id="menuButton"
                            type="button"
                            aria-label="Open navigation"
                            aria-controls="sidebar"
                            aria-expanded="false">☰</button>

                    <div class="breadcrumb">
                        Workspace <span>/</span>
                        <strong>Reminders</strong>
                    </div>
                </div>

                <a class="profile-chip" href="<%= contextPath %>/profile">
                    <span class="avatar">
                        <%= firstName.substring(0, 1).toUpperCase(Locale.ROOT) %>
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
                        <p class="eyebrow">PLAN · REMEMBER · COMPLETE</p>
                        <h1>My <span>Reminders</span></h1>
                        <p class="page-description">
                            Schedule reminders for important tasks so they don't slip through the cracks.
                        </p>
                    </div>

                    <button class="primary-button"
                            id="openReminderForm"
                            type="button">＋ New reminder</button>
                </section>

                <!-- Feedback messages -->
                <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                    <div class="alert alert-error" role="alert">
                        <%= safeError %>
                    </div>
                <% } %>

                <% if ("added".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Reminder created successfully.
                    </div>
                <% } else if ("updated".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Reminder updated successfully.
                    </div>
                <% } else if ("deleted".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Reminder deleted successfully.
                    </div>
                <% } %>

                <!-- Create reminder form -->
                <section class="reminder-form-card"
                         id="reminderFormCard"
                         hidden>

                    <div class="form-card-heading">
                        <div>
                            <h2>Create a reminder</h2>
                            <p>Choose the task and the time you want to remember it.</p>
                        </div>

                        <button class="close-button"
                                id="closeReminderForm"
                                type="button"
                                aria-label="Close form">×</button>
                    </div>

                    <form action="<%= contextPath %>/reminders"
                          method="post"
                          class="reminder-form">

                        <input type="hidden" name="action" value="add">

                        <div class="form-field">
                            <label for="taskId">Task ID <span>*</span></label>
                            <input type="number"
                                   id="taskId"
                                   name="taskId"
                                   min="1"
                                   step="1"
                                   placeholder="Enter your task ID"
                                   required>
                            <small>Use the ID of a task belonging to your account.</small>
                        </div>

                        <div class="form-field">
                            <label for="reminderAt">Reminder date and time <span>*</span></label>
                            <input type="datetime-local"
                                   id="reminderAt"
                                   name="reminderAt"
                                   required>
                        </div>

                        <div class="form-field full-width">
                            <label for="reminderMessage">Message (optional)</label>
                            <textarea id="reminderMessage"
                                      name="reminderMessage"
                                      rows="3"
                                      maxlength="1000"
                                      placeholder="e.g. Review your project before the meeting"></textarea>
                        </div>

                        <div class="form-actions full-width">
                            <button class="secondary-button"
                                    id="cancelReminderForm"
                                    type="button">Cancel</button>

                            <button class="primary-button" type="submit">
                                Save reminder
                            </button>
                        </div>

                    </form>
                </section>

                <!-- Reminder list -->
                <section class="reminders-section">

                    <div class="section-heading">
                        <div>
                            <h2>Your reminders</h2>
                            <p>Review scheduled reminders and their current status.</p>
                        </div>

                        <span class="reminder-count">
                            <%= reminders.size() %>
                            <%= reminders.size() == 1 ? "reminder" : "reminders" %>
                        </span>
                    </div>

                    <% if (reminders.isEmpty()) { %>

                        <div class="empty-state">
                            <div class="empty-icon">◷</div>
                            <h3>Nothing to remind you about yet</h3>
                            <p>
                                Create a reminder for a task and give yourself
                                one less thing to remember.
                            </p>

                            <button class="primary-button"
                                    id="emptyCreateReminder"
                                    type="button">＋ Create your first reminder</button>
                        </div>

                    <% } else { %>

                        <div class="reminder-list">

                            <% for (Reminder reminder : reminders) {

                                String message = reminder.getReminderMessage() == null
                                    || reminder.getReminderMessage().isBlank()
                                    ? "Task reminder"
                                    : reminder.getReminderMessage();

                                String safeMessage = escapeHtml(message);

                                String status = reminder.getStatus() == null
                                    ? "PENDING"
                                    : reminder.getStatus().toUpperCase(Locale.ROOT);

                                String safeStatus = escapeHtml(status);

                                String reminderAtText = reminder.getReminderAt() == null
                                    ? "Not scheduled"
                                    : reminder.getReminderAt()
                                               .toLocalDateTime()
                                               .format(dateTimeFormatter);

                                String safeReminderAt = escapeHtml(reminderAtText);

                                String sentAtText = reminder.getSentAt() == null
                                    ? "Not sent"
                                    : reminder.getSentAt()
                                               .toLocalDateTime()
                                               .format(dateTimeFormatter);

                                String safeSentAt = escapeHtml(sentAtText);
                            %>

                                <article class="reminder-card">

                                    <div class="reminder-icon">◷</div>

                                    <div class="reminder-main">

                                        <div class="reminder-title-row">
                                            <h3><%= safeMessage %></h3>

                                            <span class="status-badge status-<%= status.toLowerCase(Locale.ROOT) %>">
                                                <%= safeStatus %>
                                            </span>
                                        </div>

                                        <p class="reminder-time">
                                            <strong>Scheduled:</strong>
                                            <%= safeReminderAt %>
                                        </p>

                                        <p class="reminder-task">
                                            Task ID: <%= reminder.getTaskId() %>
                                        </p>

                                        <% if (reminder.getSentAt() != null) { %>
                                            <p class="reminder-time">
                                                <strong>Sent:</strong> <%= safeSentAt %>
                                            </p>
                                        <% } %>

                                    </div>

                                    <div class="reminder-actions">

                                        <% if ("PENDING".equalsIgnoreCase(status)) { %>
                                            <form action="<%= contextPath %>/reminders"
                                                  method="post">
                                                <input type="hidden" name="action" value="status">
                                                <input type="hidden"
                                                       name="reminderId"
                                                       value="<%= reminder.getReminderId() %>">
                                                <input type="hidden"
                                                       name="status"
                                                       value="CANCELLED">

                                                <button class="secondary-button"
                                                        type="submit">Cancel</button>
                                            </form>
                                        <% } %>

                                        <form action="<%= contextPath %>/reminders"
                                              method="post"
                                              onsubmit="return confirm('Delete this reminder?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden"
                                                   name="reminderId"
                                                   value="<%= reminder.getReminderId() %>">

                                            <button class="icon-button delete-button"
                                                    type="submit"
                                                    aria-label="Delete reminder"
                                                    title="Delete reminder">×</button>
                                        </form>

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


<!-- =====================================================
     SHARED FULL-WIDTH FOOTER
     Outside app-layout: spans sidebar and main area.
     ===================================================== -->
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
        <p>&copy; <%= java.time.Year.now().getValue() %> dayWise. All rights reserved.</p>
        <p>Plan mindfully. Focus deeply. Make progress.</p>
    </div>

</footer>


<!-- Mobile navigation and reminder form controls -->
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
        if (event.key === "Escape") closeMenu();
    });

    window.addEventListener("resize", function () {
        if (window.innerWidth > 900) closeMenu();
    });

    const formCard = document.getElementById("reminderFormCard");
    const taskId = document.getElementById("taskId");
    const reminderAt = document.getElementById("reminderAt");
    const reminderForm = formCard.querySelector("form");

    const openButton = document.getElementById("openReminderForm");
    const emptyButton = document.getElementById("emptyCreateReminder");
    const closeButton = document.getElementById("closeReminderForm");
    const cancelButton = document.getElementById("cancelReminderForm");

    function setDefaultDateTime() {
        if (!reminderAt.value) {
            const now = new Date();
            now.setMinutes(now.getMinutes() + 5);

            const localDateTime = new Date(
                now.getTime() - now.getTimezoneOffset() * 60000
            ).toISOString().slice(0, 16);

            reminderAt.value = localDateTime;
        }
    }

    function openForm() {
        formCard.hidden = false;
        setDefaultDateTime();

        formCard.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });

        taskId.focus();
    }

    function closeForm() {
        formCard.hidden = true;
    }

    reminderForm.addEventListener("submit", function (event) {
        if (reminderAt.value) {
            const chosenTime = new Date(reminderAt.value);
            const currentTime = new Date();

            if (chosenTime <= currentTime) {
                event.preventDefault();
                reminderAt.setCustomValidity(
                    "Choose a reminder time in the future."
                );
                reminderAt.reportValidity();
                return;
            }
        }

        reminderAt.setCustomValidity("");
    });

    reminderAt.addEventListener("input", function () {
        reminderAt.setCustomValidity("");
    });

    openButton.addEventListener("click", openForm);

    if (emptyButton) {
        emptyButton.addEventListener("click", openForm);
    }

    closeButton.addEventListener("click", closeForm);
    cancelButton.addEventListener("click", closeForm);

    <% if (errorMessage != null && !errorMessage.isBlank()) { %>
        formCard.hidden = false;
    <% } %>
})();
</script>

</body>
</html>
