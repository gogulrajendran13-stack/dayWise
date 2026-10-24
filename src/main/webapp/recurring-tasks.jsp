
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.dayWise.model.RecurringTask" %>

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

    List<RecurringTask> recurringTasks =
        (List<RecurringTask>) request.getAttribute("recurringTasks");

    if (recurringTasks == null) {
        recurringTasks = java.util.Collections.emptyList();
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String safeError = escapeHtml(errorMessage);
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recurring Tasks | dayWise</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/recurring-tasks.css">
</head>

<body>

<!-- ======================================================
     APP LAYOUT: SIDEBAR + MAIN COLUMN
     The footer is deliberately outside this container.
     ====================================================== -->
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

            <a class="nav-link active"
               href="<%= contextPath %>/recurring-tasks"
               aria-current="page">
                <span class="nav-icon">↻</span><span>Recurring Tasks</span>
            </a>

            <p class="nav-label">PRODUCTIVITY</p>

            <a class="nav-link" href="<%= contextPath %>/reminders">
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
                        <strong>Recurring Tasks</strong>
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
                        <p class="eyebrow">REPEAT · BUILD · GROW</p>
                        <h1>Recurring <span>Tasks</span></h1>
                        <p class="page-description">
                            Set up routines for the tasks you need to repeat regularly.
                        </p>
                    </div>

                    <button class="primary-button"
                            id="openRecurringForm"
                            type="button">
                        ＋ New routine
                    </button>
                </section>

                <!-- Feedback messages -->
                <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                    <div class="alert alert-error" role="alert">
                        <%= safeError %>
                    </div>
                <% } %>

                <% if ("added".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Recurring task created successfully.
                    </div>
                <% } else if ("updated".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Recurring task updated successfully.
                    </div>
                <% } else if ("deleted".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Recurring task deleted successfully.
                    </div>
                <% } %>

                <!-- Create recurring task form -->
                <section class="recurring-form-card"
                         id="recurringFormCard"
                         hidden>

                    <div class="form-card-heading">
                        <div>
                            <h2>Create a recurring task</h2>
                            <p>Define the routine you want to maintain.</p>
                        </div>

                        <button class="close-button"
                                id="closeRecurringForm"
                                type="button"
                                aria-label="Close form">×</button>
                    </div>

                    <form action="<%= contextPath %>/recurring-tasks"
                          method="post"
                          class="recurring-form">

                        <input type="hidden" name="action" value="add">

                        <div class="form-field full-width">
                            <label for="recurringTitle">Task title <span>*</span></label>
                            <input type="text"
                                   id="recurringTitle"
                                   name="title"
                                   maxlength="200"
                                   placeholder="e.g. Review daily priorities"
                                   required>
                        </div>

                        <div class="form-field">
                            <label for="frequency">Repeat frequency <span>*</span></label>
                            <select id="frequency" name="frequency" required>
                                <option value="daily">Every day</option>
                                <option value="weekly" selected>Every week</option>
                                <option value="monthly">Every month</option>
                                <option value="yearly">Every year</option>
                            </select>
                        </div>

                        <div class="form-field">
                            <label for="startDate">Start date <span>*</span></label>
                            <input type="date" id="startDate" name="startDate" required>
                        </div>

                        <div class="form-field">
                            <label for="endDate">End date (optional)</label>
                            <input type="date" id="endDate" name="endDate">
                        </div>

                        <div class="form-field">
                            <label for="recurringPriority">Priority</label>
                            <select id="recurringPriority" name="priority">
                                <option value="low">Low</option>
                                <option value="medium" selected>Medium</option>
                                <option value="high">High</option>
                                <option value="urgent">Urgent</option>
                            </select>
                        </div>

                        <div class="form-actions full-width">
                            <button class="secondary-button"
                                    id="cancelRecurringForm"
                                    type="button">Cancel</button>

                            <button class="primary-button" type="submit">
                                Save routine
                            </button>
                        </div>

                    </form>
                </section>

                <!-- Recurring task list -->
                <section class="recurring-section">

                    <div class="section-heading">
                        <div>
                            <h2>Your routines</h2>
                            <p>Manage the tasks you want to repeat.</p>
                        </div>

                        <span class="recurring-count">
                            <%= recurringTasks.size() %>
                            <%= recurringTasks.size() == 1 ? "routine" : "routines" %>
                        </span>
                    </div>

                    <% if (recurringTasks.isEmpty()) { %>

                        <div class="empty-state">
                            <div class="empty-icon">↻</div>
                            <h3>No recurring tasks yet</h3>
                            <p>
                                Create a routine to make regular responsibilities
                                easier to manage.
                            </p>

                            <button class="primary-button"
                                    id="emptyCreateRecurring"
                                    type="button">
                                ＋ Create your first routine
                            </button>
                        </div>

                    <% } else { %>

                        <div class="recurring-list">

                            <% for (RecurringTask recurringTask : recurringTasks) {

                                String title = recurringTask.getTitle() == null
                                    ? "" : recurringTask.getTitle();

                                String safeTitle = escapeHtml(title);

                                String frequency = recurringTask.getFrequency() == null
                                    ? "unspecified" : recurringTask.getFrequency();

                                String safeFrequency = escapeHtml(frequency);

                                String recurringStatus = recurringTask.isActive()
                                    ? "active" : "paused";

                                String startDateText =
                                    recurringTask.getStartDate() == null
                                    ? "Not specified"
                                    : recurringTask.getStartDate().toString();

                                String safeStartDate = escapeHtml(startDateText);
                            %>

                                <article class="recurring-item">

                                    <div class="recurring-icon">↻</div>

                                    <div class="recurring-main">
                                        <h3><%= safeTitle %></h3>

                                        <p class="recurring-frequency">
                                            Repeats
                                            <strong><%= safeFrequency %></strong>
                                        </p>

                                        <div class="recurring-metadata">
                                            <span class="status-badge status-<%= recurringStatus %>">
                                                <%= recurringStatus %>
                                            </span>

                                            <span class="start-date">
                                                Starts: <%= safeStartDate %>
                                            </span>
                                        </div>
                                    </div>

                                    <div class="recurring-actions">

                                        <% if ("active".equals(recurringStatus)) { %>
                                            <form action="<%= contextPath %>/recurring-tasks"
                                                  method="post">
                                                <input type="hidden" name="action" value="pause">
                                                <input type="hidden"
                                                       name="recurringTaskId"
                                                       value="<%= recurringTask.getRecurringId() %>">

                                                <button class="secondary-button"
                                                        type="submit">Pause</button>
                                            </form>
                                        <% } else { %>
                                            <form action="<%= contextPath %>/recurring-tasks"
                                                  method="post">
                                                <input type="hidden" name="action" value="resume">
                                                <input type="hidden"
                                                       name="recurringTaskId"
                                                       value="<%= recurringTask.getRecurringId() %>">

                                                <button class="secondary-button"
                                                        type="submit">Resume</button>
                                            </form>
                                        <% } %>

                                        <form action="<%= contextPath %>/recurring-tasks"
                                              method="post"
                                              onsubmit="return confirm('Delete this recurring task?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden"
                                                   name="recurringTaskId"
                                                   value="<%= recurringTask.getRecurringId() %>">

                                            <button class="icon-button delete-button"
                                                    type="submit"
                                                    aria-label="Delete recurring task"
                                                    title="Delete recurring task">×</button>
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


<!-- ======================================================
     SHARED FULL-WIDTH FOOTER
     Outside app-layout, below both sidebar and main column.
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
        <p>&copy; <%= java.time.Year.now().getValue() %> dayWise. All rights reserved.</p>
        <p>Plan mindfully. Focus deeply. Make progress.</p>
    </div>

</footer>


<!-- Mobile navigation and form controls -->
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

    const formCard = document.getElementById("recurringFormCard");
    const titleInput = document.getElementById("recurringTitle");
    const startDate = document.getElementById("startDate");
    const endDate = document.getElementById("endDate");

    const openButton = document.getElementById("openRecurringForm");
    const emptyButton = document.getElementById("emptyCreateRecurring");
    const closeButton = document.getElementById("closeRecurringForm");
    const cancelButton = document.getElementById("cancelRecurringForm");

    function setDefaultStartDate() {
        if (!startDate.value) {
            const today = new Date();
            const localDate = new Date(
                today.getTime() - today.getTimezoneOffset() * 60000
            ).toISOString().slice(0, 10);

            startDate.value = localDate;
        }
    }

    function openForm() {
        formCard.hidden = false;
        setDefaultStartDate();

        formCard.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });

        titleInput.focus();
    }

    function closeForm() {
        formCard.hidden = true;
    }

    /* Prevent selecting an end date before the start date. */
    startDate.addEventListener("change", function () {
        endDate.min = startDate.value;

        if (endDate.value && endDate.value < startDate.value) {
            endDate.value = "";
        }
    });

    endDate.addEventListener("change", function () {
        if (startDate.value && endDate.value &&
            endDate.value < startDate.value) {
            endDate.setCustomValidity(
                "The end date cannot be earlier than the start date."
            );
        } else {
            endDate.setCustomValidity("");
        }
    });

    startDate.addEventListener("change", function () {
        endDate.setCustomValidity("");
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

    if (new URLSearchParams(window.location.search).get("action") === "add") {
        openForm();
    }
})();
</script>

</body>
</html>
