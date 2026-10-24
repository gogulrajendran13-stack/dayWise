<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.dayWise.model.Goal" %>

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

    List<Goal> goals = (List<Goal>) request.getAttribute("goals");
    if (goals == null) {
        goals = java.util.Collections.emptyList();
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

    <title>My Goals | dayWise</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/goals.css">
</head>
<body>

<!-- ==================== APPLICATION LAYOUT ==================== -->
<div class="app-layout">

    <!-- ==================== SIDEBAR ==================== -->
    <aside class="sidebar" id="sidebar">

        <a class="brand" href="<%= contextPath %>/dashboard">
            <span class="brand-icon">✓</span>
            <span class="brand-name">dayWise</span>
        </a>

        <nav class="sidebar-nav" aria-label="Main navigation">

            <p class="nav-label">WORKSPACE</p>

            <a class="nav-link" href="<%= contextPath %>/dashboard">
                <span class="nav-icon">▦</span>
                <span>Dashboard</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/tasks">
                <span class="nav-icon">☑</span>
                <span>My Tasks</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/projects">
                <span class="nav-icon">▤</span>
                <span>Projects</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/categories">
                <span class="nav-icon">◈</span>
                <span>Categories</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/recurring-tasks">
                <span class="nav-icon">↻</span>
                <span>Recurring Tasks</span>
            </a>

            <p class="nav-label">PRODUCTIVITY</p>

            <a class="nav-link active"
               href="<%= contextPath %>/goals"
               aria-current="page">
                <span class="nav-icon">◎</span>
                <span>My Goals</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/focus-sessions">
                <span class="nav-icon">◷</span>
                <span>Focus Sessions</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/reminders">
                <span class="nav-icon">♧</span>
                <span>Reminders</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/notifications">
                <span class="nav-icon">♢</span>
                <span>Notifications</span>
            </a>

            <p class="nav-label">ACCOUNT</p>

            <a class="nav-link" href="<%= contextPath %>/profile">
                <span class="nav-icon">♙</span>
                <span>My Profile</span>
            </a>

            <a class="nav-link" href="<%= contextPath %>/settings">
                <span class="nav-icon">⚙</span>
                <span>Settings</span>
            </a>

        </nav>

        <!-- Sidebar motivational card -->
        <!-- Sidebar bottom: Logout only, no promotional card -->
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
    <!-- ==================== END SIDEBAR ==================== -->

    <!-- Mobile sidebar overlay -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- ==================== PAGE COLUMN ==================== -->
    <div class="page-column">

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
                    Personal Growth
                    <span>/</span>
                    <strong>My Goals</strong>
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
        <!-- End top navigation -->

        <!-- ==================== MAIN CONTENT ==================== -->
        <main class="main-content">

            <div class="page-content">

                <!-- Page heading -->
                <section class="page-heading">

                    <div>
                        <p class="eyebrow">DREAM · PLAN · ACHIEVE</p>

                        <h1>My <span>Goals</span></h1>

                        <p class="page-description">
                            Define what matters to you and track your progress
                            one step at a time.
                        </p>
                    </div>

                    <button class="primary-button"
                            id="openGoalForm"
                            type="button">
                        ＋ New goal
                    </button>

                </section>

                <!-- Error message -->
                <% if (errorMessage != null && !errorMessage.isBlank()) { %>

                    <div class="alert alert-error" role="alert">
                        <%= safeError %>
                    </div>

                <% } %>

                <!-- Success messages -->
                <% if ("added".equals(success)) { %>

                    <div class="alert alert-success" role="status">
                        Goal created successfully.
                    </div>

                <% } else if ("updated".equals(success)) { %>

                    <div class="alert alert-success" role="status">
                        Goal updated successfully.
                    </div>

                <% } else if ("deleted".equals(success)) { %>

                    <div class="alert alert-success" role="status">
                        Goal deleted successfully.
                    </div>

                <% } %>

                <!-- ==================== CREATE GOAL FORM ==================== -->
                <section class="goal-form-card" id="goalFormCard" hidden>

                    <div class="form-card-heading">

                        <div>
                            <h2>Create a goal</h2>
                            <p>Give yourself a target to work toward.</p>
                        </div>

                        <button class="close-button"
                                id="closeGoalForm"
                                type="button"
                                aria-label="Close form">
                            ×
                        </button>

                    </div>

                    <form action="<%= contextPath %>/goals"
                          method="post"
                          class="goal-form">

                        <input type="hidden" name="action" value="add">

                        <div class="form-field full-width">
                            <label for="goalTitle">
                                Goal title <span>*</span>
                            </label>

                            <input type="text"
                                   id="goalTitle"
                                   name="title"
                                   maxlength="200"
                                   placeholder="e.g. Complete my Java course"
                                   required>
                        </div>

                        <div class="form-field full-width">
                            <label for="goalDescription">Description</label>

                            <textarea id="goalDescription"
                                      name="description"
                                      rows="3"
                                      maxlength="2000"
                                      placeholder="Describe what you want to achieve"></textarea>
                        </div>

                        <div class="form-field">
                            <label for="targetDate">Target date</label>

                            <input type="date"
                                   id="targetDate"
                                   name="targetDate">
                        </div>

                        <div class="form-field">
                            <label for="targetValue">Target value</label>

                            <input type="number"
                                   id="targetValue"
                                   name="targetValue"
                                   min="1"
                                   step="1"
                                   placeholder="e.g. 30">
                        </div>

                        <div class="form-field">
                            <label for="unit">Unit</label>

                            <input type="text"
                                   id="unit"
                                   name="unit"
                                   maxlength="50"
                                   placeholder="e.g. days, chapters, hours">
                        </div>

                        <div class="form-actions full-width">

                            <button class="secondary-button"
                                    id="cancelGoalForm"
                                    type="button">
                                Cancel
                            </button>

                            <button class="primary-button" type="submit">
                                Save goal
                            </button>

                        </div>

                    </form>

                </section>
                <!-- ==================== END CREATE GOAL FORM ==================== -->

                <!-- ==================== GOALS LIST ==================== -->
                <section class="goals-section">

                    <div class="section-heading">

                        <div>
                            <h2>Your goals</h2>
                            <p>
                                Keep your ambitions visible and your progress moving.
                            </p>
                        </div>

                        <span class="goal-count">
                            <%= goals.size() %>
                            <%= goals.size() == 1 ? "goal" : "goals" %>
                        </span>

                    </div>

                    <% if (goals.isEmpty()) { %>

                        <!-- Empty state -->
                        <div class="empty-state">

                            <div class="empty-icon">◎</div>

                            <h3>Your next milestone starts here</h3>

                            <p>
                                Add a goal to start turning your plans
                                into measurable progress.
                            </p>

                            <button class="primary-button"
                                    id="emptyCreateGoal"
                                    type="button">
                                ＋ Create your first goal
                            </button>

                        </div>

                    <% } else { %>

                        <!-- Existing goals -->
                        <div class="goal-grid">

                            <% for (Goal goal : goals) {

                                String title = goal.getGoalTitle() == null
                                        ? "" : goal.getGoalTitle();

                                String safeTitle = escapeHtml(title);

                                String description = goal.getDescription() == null
                                        ? "" : goal.getDescription();

                                String safeDescription = escapeHtml(description);

                                String rawStatus = goal.getStatus() == null
                                        ? "Active" : goal.getStatus();

                                String safeStatus = escapeHtml(rawStatus);

                                String statusClass = rawStatus
                                        .toLowerCase(Locale.ROOT)
                                        .replaceAll("[^a-z0-9_-]", "");

                                java.math.BigDecimal targetDecimal = goal.getTargetValue();
                                java.math.BigDecimal currentDecimal = goal.getCurrentValue();

                                double targetValue = targetDecimal == null
                                        ? 0.0
                                        : targetDecimal.doubleValue();

                                double currentValue = currentDecimal == null
                                        ? 0.0
                                        : currentDecimal.doubleValue();
                                int progressPercent = 0;

                                if (targetValue > 0) {
                                    progressPercent = (int) Math.round(
                                            (currentValue / targetValue) * 100
                                    );
                                }

                                progressPercent = Math.max(
                                        0,
                                        Math.min(100, progressPercent)
                                );
                            %>

                                <article class="goal-card">

                                    <div class="goal-card-top">

                                        <div class="goal-symbol">◎</div>

                                        <span class="status-badge status-<%= statusClass %>">
                                            <%= safeStatus %>
                                        </span>

                                    </div>

                                    <h3><%= safeTitle %></h3>

                                    <p class="goal-description">
                                        <%= safeDescription.isBlank()
                                                ? "Keep working toward your next milestone."
                                                : safeDescription %>
                                    </p>

                                    <!-- Progress display -->
                                    <div class="progress-section">

                                        <div class="progress-heading">
                                            <span>Progress</span>
                                            <strong><%= progressPercent %>%</strong>
                                        </div>

                                        <div class="progress-track"
                                             role="progressbar"
                                             aria-label="Goal progress"
                                             aria-valuemin="0"
                                             aria-valuemax="100"
                                             aria-valuenow="<%= progressPercent %>">

                                            <div class="progress-fill"
                                                 style="width: <%= progressPercent %>%;">
                                            </div>

                                        </div>

                                    </div>

                                    <!-- Update progress -->
                                    <form action="<%= contextPath %>/goals"
                                          method="post"
                                          class="progress-form">

                                        <input type="hidden"
                                               name="action"
                                               value="progress">

                                        <input type="hidden"
                                               name="goalId"
                                               value="<%= goal.getGoalId() %>">

                                        <label for="progress-<%= goal.getGoalId() %>">
                                            Update progress (%)
                                        </label>

                                        <div class="progress-input-row">

                                            <input type="number"
                                                   id="progress-<%= goal.getGoalId() %>"
                                                   name="progressPercent"
                                                   min="0"
                                                   max="100"
                                                   step="1"
                                                   value="<%= progressPercent %>"
                                                   required>

                                            <button class="secondary-button"
                                                    type="submit">
                                                Update
                                            </button>

                                        </div>

                                    </form>

                                    <!-- Goal card footer -->
                                    <div class="goal-card-footer">

                                        <span class="goal-id">
                                            Goal #<%= goal.getGoalId() %>
                                        </span>

                                        <form action="<%= contextPath %>/goals"
                                              method="post"
                                              onsubmit="return confirm('Are you sure you want to delete this goal?');">

                                            <input type="hidden"
                                                   name="action"
                                                   value="delete">

                                            <input type="hidden"
                                                   name="goalId"
                                                   value="<%= goal.getGoalId() %>">

                                            <button class="delete-button"
                                                    type="submit">
                                                Delete
                                            </button>

                                        </form>

                                    </div>

                                </article>

                            <% } %>

                        </div>

                    <% } %>

                </section>
                <!-- ==================== END GOALS LIST ==================== -->

            </div>
        </main>
        <!-- ==================== END MAIN CONTENT ==================== -->

    </div>
    <!-- ==================== END PAGE COLUMN ==================== -->

</div>
<!-- ==================== END APPLICATION LAYOUT ==================== -->


<!-- ==================== FULL-WIDTH FOOTER ==================== -->
<footer class="site-footer">

    <div class="footer-main">

        <div class="footer-about">

            <a class="footer-brand" href="<%= contextPath %>/dashboard">
                <span class="footer-brand-icon">✓</span>
                <span>dayWise</span>
            </a>

            <h2>Make every day count.</h2>

            <p>
                Organize your tasks, build better habits, and turn your
                goals into meaningful progress.
            </p>

            <p class="footer-tagline">
                PLAN WITH PURPOSE. PROGRESS WITH CONFIDENCE.
            </p>

        </div>

        <div class="footer-column">
            <h3>WORKSPACE</h3>
            <a href="<%= contextPath %>/dashboard">Dashboard</a>
            <a href="<%= contextPath %>/tasks">My Tasks</a>
            <a href="<%= contextPath %>/projects">Projects</a>
            <a href="<%= contextPath %>/categories">Categories</a>
        </div>

        <div class="footer-column">
            <h3>PRODUCTIVITY</h3>
            <a href="<%= contextPath %>/goals">My Goals</a>
            <a href="<%= contextPath %>/recurring-tasks">Recurring Tasks</a>
            <a href="<%= contextPath %>/focus-sessions">Focus Sessions</a>
            <a href="<%= contextPath %>/reminders">Reminders</a>
        </div>

        <div class="footer-column">
            <h3>YOUR ACCOUNT</h3>
            <a href="<%= contextPath %>/notifications">Notifications</a>
            <a href="<%= contextPath %>/profile">My Profile</a>
            <a href="<%= contextPath %>/settings">Settings</a>
        </div>

    </div>

    <div class="footer-bottom">

        <p>
            &copy; <%= java.time.Year.now() %> dayWise. All rights reserved.
        </p>

        <p>Small steps. Meaningful progress.</p>

    </div>

</footer>
<!-- ==================== END FULL-WIDTH FOOTER ==================== -->


<!-- ==================== JAVASCRIPT ==================== -->
<script>
document.addEventListener("DOMContentLoaded", function () {

    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebarOverlay");
    const menuButton = document.getElementById("menuButton");

    const goalFormCard = document.getElementById("goalFormCard");
    const openGoalForm = document.getElementById("openGoalForm");
    const closeGoalForm = document.getElementById("closeGoalForm");
    const cancelGoalForm = document.getElementById("cancelGoalForm");
    const emptyCreateGoal = document.getElementById("emptyCreateGoal");

    function openSidebar() {
        if (!sidebar || !overlay || !menuButton) return;

        sidebar.classList.add("sidebar-open");
        overlay.classList.add("overlay-open");
        menuButton.setAttribute("aria-expanded", "true");
        document.body.classList.add("sidebar-visible");
    }

    function closeSidebar() {
        if (!sidebar || !overlay || !menuButton) return;

        sidebar.classList.remove("sidebar-open");
        overlay.classList.remove("overlay-open");
        menuButton.setAttribute("aria-expanded", "false");
        document.body.classList.remove("sidebar-visible");
    }

    if (menuButton) {
        menuButton.addEventListener("click", function () {
            if (sidebar && sidebar.classList.contains("sidebar-open")) {
                closeSidebar();
            } else {
                openSidebar();
            }
        });
    }

    if (overlay) {
        overlay.addEventListener("click", closeSidebar);
    }

    if (sidebar) {
        sidebar.querySelectorAll("a").forEach(function (link) {
            link.addEventListener("click", closeSidebar);
        });
    }

    function closeGoalFormPanel() {
        if (goalFormCard) {
            goalFormCard.hidden = true;
        }
    }

    function openGoalFormPanel() {
        if (!goalFormCard) return;

        goalFormCard.hidden = false;

        goalFormCard.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });

        const titleInput = document.getElementById("goalTitle");

        if (titleInput) {
            window.setTimeout(function () {
                titleInput.focus();
            }, 200);
        }
    }

    if (openGoalForm) {
        openGoalForm.addEventListener("click", openGoalFormPanel);
    }

    if (emptyCreateGoal) {
        emptyCreateGoal.addEventListener("click", openGoalFormPanel);
    }

    if (closeGoalForm) {
        closeGoalForm.addEventListener("click", closeGoalFormPanel);
    }

    if (cancelGoalForm) {
        cancelGoalForm.addEventListener("click", closeGoalFormPanel);
    }

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeSidebar();
            closeGoalFormPanel();
        }
    });

    window.addEventListener("resize", function () {
        if (window.innerWidth > 900) {
            closeSidebar();
        }
    });

    const hasError = document.querySelector(".alert-error") !== null;
    const urlParams = new URLSearchParams(window.location.search);

    if (hasError || urlParams.get("action") === "add") {
        openGoalFormPanel();
    }

});
</script>
<!-- ==================== END JAVASCRIPT ==================== -->

</body>
</html>