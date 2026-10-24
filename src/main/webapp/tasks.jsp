
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.dayWise.model.Task"%>
<%@ page import="com.dayWise.model.Project"%>
<%@ page import="com.dayWise.model.Category"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.util.Locale"%>

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

    String firstInitial = firstName.substring(0, 1)
        .toUpperCase(Locale.ROOT);

    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    List<Project> projects = (List<Project>) request.getAttribute("projects");
    List<Category> categories = (List<Category>) request.getAttribute("categories");

    if (tasks == null) {
        tasks = java.util.Collections.emptyList();
    }
    if (projects == null) {
        projects = java.util.Collections.emptyList();
    }
    if (categories == null) {
        categories = java.util.Collections.emptyList();
    }

    String currentSearch = request.getParameter("search");
    if (currentSearch == null) {
        currentSearch = "";
    }

    String safeSearch = currentSearch
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");

    String currentStatus = request.getParameter("status");
    if (currentStatus == null || currentStatus.isBlank()) {
        currentStatus = "all";
    }

    String currentError = (String) request.getAttribute("errorMessage");
    String safeError = "";

    if (currentError != null) {
        safeError = currentError
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }

    String successMessage = request.getParameter("success");

    int completedCount = 0;
    int pendingCount = 0;
    int inProgressCount = 0;

    for (Task task : tasks) {
        String status = task.getStatus() == null
            ? "pending"
            : task.getStatus().toLowerCase(Locale.ROOT);

        if ("completed".equals(status)) {
            completedCount++;
        } else if ("in_progress".equals(status)) {
            inProgressCount++;
        } else {
            pendingCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tasks | dayWise</title>

    <!-- Tasks stylesheet. Keep it separate from the JSP. -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/tasks.css">
</head>

<body>

<div class="app-layout">

    <!-- =====================================================
         SIDEBAR
         Keep this shared navigation consistent across pages.
         ===================================================== -->
    <aside class="sidebar" id="sidebar">

        <a class="brand" href="<%= contextPath %>/dashboard"
           aria-label="dayWise dashboard">
            <span class="brand-icon">✓</span>
            <span class="brand-name">day<span>Wise</span></span>
        </a>

        <nav class="sidebar-nav" aria-label="Main navigation">

            <p class="nav-label">Workspace</p>

            <ul class="nav-list">
                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/dashboard">
                        <span class="nav-icon">⌂</span>
                        <span>Dashboard</span>
                    </a>
                </li>

                <li>
                    <a class="nav-link active"
                       href="<%= contextPath %>/tasks"
                       aria-current="page">
                        <span class="nav-icon">▤</span>
                        <span>My Tasks</span>
                    </a>
                </li>

                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/projects">
                        <span class="nav-icon">▦</span>
                        <span>Projects</span>
                    </a>
                </li>

                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/categories">
                        <span class="nav-icon">◇</span>
                        <span>Categories</span>
                    </a>
                </li>
            </ul>

            <p class="nav-label">Productivity</p>

            <ul class="nav-list">
                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/recurring-tasks">
                        <span class="nav-icon">↻</span>
                        <span>Recurring Tasks</span>
                    </a>
                </li>

                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/reminders">
                        <span class="nav-icon">◷</span>
                        <span>Reminders</span>
                    </a>
                </li>

                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/notifications">
                        <span class="nav-icon">♧</span>
                        <span>Notifications</span>
                    </a>
                </li>

                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/goals">
                        <span class="nav-icon">◎</span>
                        <span>Goals</span>
                    </a>
                </li>

                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/focus-sessions">
                        <span class="nav-icon">◷</span>
                        <span>Focus Sessions</span>
                    </a>
                </li>
            </ul>

            <p class="nav-label">Account</p>

            <ul class="nav-list">
                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/profile">
                        <span class="nav-icon">♙</span>
                        <span>Profile</span>
                    </a>
                </li>

                <li>
                    <a class="nav-link"
                       href="<%= contextPath %>/settings">
                        <span class="nav-icon">⚙</span>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>

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

    <!-- Mobile sidebar overlay -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- =====================================================
         RIGHT-HAND PAGE COLUMN
         The footer is a sibling of main, not inside main.
         ===================================================== -->
    <div class="page-column">

        <!-- =================================================
             MAIN CONTENT
             Only task-specific content belongs here.
             ================================================= -->
        <main class="main-content">

            <!-- Top bar -->
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
                        Workspace <span class="breadcrumb-separator">/</span>
                        <strong>My Tasks</strong>
                    </div>
                </div>

                <a class="profile-chip"
                   href="<%= contextPath %>/profile">
                    <span class="avatar"><%= firstInitial %></span>
                    <span class="profile-details">
                        <span class="profile-name"><%= safeFirstName %></span>
                        <span class="profile-label">Your personal space</span>
                    </span>
                </a>

            </header>

            <div class="page-content">

                <!-- Page heading -->
                <section class="page-heading">
                    <div>
                        <p class="eyebrow">PLAN · PRIORITIZE · PROGRESS</p>
                        <h1>My <span>Tasks</span></h1>
                        <p class="page-description">
                            Keep track of your responsibilities and focus on
                            what matters most.
                        </p>
                    </div>

                    <button class="primary-button"
                            type="button"
                            id="openTaskForm">
                        <span>＋</span> Add task
                    </button>
                </section>

                <!-- Error message -->
                <% if (currentError != null && !currentError.isBlank()) { %>
                    <div class="alert alert-error" role="alert">
                        <strong>Something went wrong.</strong>
                        <span><%= safeError %></span>
                    </div>
                <% } %>

                <!-- Success messages -->
                <% if ("added".equals(successMessage)) { %>
                    <div class="alert alert-success" role="status">
                        ✓ Task created successfully.
                    </div>
                <% } else if ("updated".equals(successMessage)) { %>
                    <div class="alert alert-success" role="status">
                        ✓ Task updated successfully.
                    </div>
                <% } else if ("deleted".equals(successMessage)) { %>
                    <div class="alert alert-success" role="status">
                        ✓ Task deleted successfully.
                    </div>
                <% } %>

                <!-- Task overview cards -->
                <section class="task-summary-grid"
                         aria-label="Task overview">

                    <article class="summary-card summary-total">
                        <div class="summary-icon">▤</div>
                        <div>
                            <p>Total tasks</p>
                            <h2><%= tasks.size() %></h2>
                        </div>
                    </article>

                    <article class="summary-card summary-pending">
                        <div class="summary-icon">◷</div>
                        <div>
                            <p>Pending</p>
                            <h2><%= pendingCount %></h2>
                        </div>
                    </article>

                    <article class="summary-card summary-progress">
                        <div class="summary-icon">↗</div>
                        <div>
                            <p>In progress</p>
                            <h2><%= inProgressCount %></h2>
                        </div>
                    </article>

                    <article class="summary-card summary-completed">
                        <div class="summary-icon">✓</div>
                        <div>
                            <p>Completed</p>
                            <h2><%= completedCount %></h2>
                        </div>
                    </article>

                </section>

                <!-- Search and status filters -->
                <section class="filter-panel">
                    <form action="<%= contextPath %>/tasks"
                          method="get"
                          class="filter-form">

                        <label class="search-wrapper">
                            <span aria-hidden="true">⌕</span>
                            <input type="search"
                                   name="search"
                                   value="<%= safeSearch %>"
                                   placeholder="Search your tasks..."
                                   aria-label="Search tasks">
                        </label>

                        <label class="status-filter">
                            <span class="visually-hidden">Filter by status</span>
                            <select name="status"
                                    aria-label="Filter tasks by status">
                                <option value="all"
                                    <%= "all".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    All tasks
                                </option>
                                <option value="pending"
                                    <%= "pending".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    Pending
                                </option>
                                <option value="in_progress"
                                    <%= "in_progress".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    In progress
                                </option>
                                <option value="completed"
                                    <%= "completed".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    Completed
                                </option>
                            </select>
                        </label>

                        <button class="secondary-button" type="submit">
                            Apply filters
                        </button>

                        <a class="reset-link"
                           href="<%= contextPath %>/tasks">
                            Reset
                        </a>

                    </form>
                </section>

                <!-- Create task form -->
                <section class="task-form-card"
                         id="taskFormCard"
                         hidden>

                    <div class="form-card-heading">
                        <div>
                            <p class="eyebrow">NEW TASK</p>
                            <h2>Create a task</h2>
                            <p>Add the details of your next task.</p>
                        </div>

                        <button type="button"
                                class="close-button"
                                id="closeTaskForm"
                                aria-label="Close task form">
                            ×
                        </button>
                    </div>

                    <form action="<%= contextPath %>/tasks"
                          method="post"
                          class="task-form">

                        <input type="hidden" name="action" value="add">

                        <div class="form-field full-width">
                            <label for="taskTitle">Task title *</label>
                            <input type="text"
                                   id="taskTitle"
                                   name="title"
                                   maxlength="200"
                                   placeholder="What do you need to do?"
                                   required>
                        </div>

                        <div class="form-field full-width">
                            <label for="taskDescription">Description</label>
                            <textarea id="taskDescription"
                                      name="description"
                                      rows="3"
                                      maxlength="2000"
                                      placeholder="Add a few details (optional)"></textarea>
                        </div>

                        <div class="form-field">
                            <label for="taskPriority">Priority</label>
                            <select id="taskPriority" name="priority">
                                <option value="low">Low</option>
                                <option value="medium" selected>Medium</option>
                                <option value="high">High</option>
                                <option value="urgent">Urgent</option>
                            </select>
                        </div>

                        <div class="form-field">
                            <label for="taskDueDate">Due date</label>
                            <input type="datetime-local"
                                   id="taskDueDate"
                                   name="dueDate">
                        </div>

                        <div class="form-field">
                            <label for="taskProject">Project</label>
                            <select id="taskProject" name="projectId">
                                <option value="">No project</option>
                                <% for (Project project : projects) { 
                                    String projectName =
                                        project.getProjectName() == null
                                        ? ""
                                        : project.getProjectName();

                                    String safeProjectName = projectName
                                        .replace("&", "&amp;")
                                        .replace("<", "&lt;")
                                        .replace(">", "&gt;")
                                        .replace("\"", "&quot;")
                                        .replace("'", "&#39;");
                                %>
                                    <option value="<%= project.getProjectId() %>">
                                        <%= safeProjectName %>
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-field">
                            <label for="taskCategory">Category</label>
                            <select id="taskCategory" name="categoryId">
                                <option value="">No category</option>
                                <% for (Category category : categories) {
                                    String categoryName =
                                        category.getCategoryName() == null
                                        ? ""
                                        : category.getCategoryName();

                                    String safeCategoryName = categoryName
                                        .replace("&", "&amp;")
                                        .replace("<", "&lt;")
                                        .replace(">", "&gt;")
                                        .replace("\"", "&quot;")
                                        .replace("'", "&#39;");
                                %>
                                    <option value="<%= category.getCategoryId() %>">
                                        <%= safeCategoryName %>
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-actions full-width">
                            <button type="button"
                                    class="secondary-button"
                                    id="cancelTaskForm">
                                Cancel
                            </button>

                            <button type="submit" class="primary-button">
                                Save task
                            </button>
                        </div>

                    </form>
                </section>

                <!-- Task list -->
                <section class="tasks-section">

                    <div class="section-heading">
                        <div>
                            <p class="eyebrow">YOUR WORKSPACE</p>
                            <h2>Your task list</h2>
                            <p>Tasks matching your selected filters.</p>
                        </div>

                        <span class="task-count">
                            <%= tasks.size() %>
                            <%= tasks.size() == 1 ? "task" : "tasks" %>
                        </span>
                    </div>

                    <% if (tasks.isEmpty()) { %>

                        <div class="empty-state">
                            <div class="empty-icon">✦</div>
                            <h3>No tasks to show</h3>
                            <p>
                                Try another filter, or create a task to get
                                started.
                            </p>
                            <button type="button"
                                    class="primary-button"
                                    id="emptyAddTask">
                                ＋ Create your first task
                            </button>
                        </div>

                    <% } else { %>

                        <div class="task-list">

                            <% for (Task task : tasks) {

                                String taskStatus = task.getStatus() == null
                                    ? "pending"
                                    : task.getStatus().toLowerCase(Locale.ROOT);

                                String priority = task.getPriority() == null
                                    ? "medium"
                                    : task.getPriority().toLowerCase(Locale.ROOT);

                                String title = task.getTitle() == null
                                    ? ""
                                    : task.getTitle();

                                String safeTitle = title
                                    .replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;");

                                String description =
                                    task.getDescription() == null
                                    ? ""
                                    : task.getDescription();

                                String safeDescription = description
                                    .replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;");

                                String safeStatus = taskStatus
                                    .replaceAll("[^a-z_]", "");

                                String safePriority = priority
                                    .replaceAll("[^a-z_]", "");

                                String dueDateText = "";

                                if (task.getDueAt() != null) {
                                    dueDateText = task.getDueAt()
                                        .toLocalDateTime()
                                        .format(DateTimeFormatter.ofPattern(
                                            "dd MMM yyyy, hh:mm a",
                                            Locale.ENGLISH
                                        ));
                                }

                                String safeDueDate = dueDateText
                                    .replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;");
                            %>

                                <article class="task-item">

                                    <div class="task-status-marker">
                                        <% if ("completed".equals(taskStatus)) { %>
                                            <span class="completed-mark">✓</span>
                                        <% } else { %>
                                            <span class="pending-mark"></span>
                                        <% } %>
                                    </div>

                                    <div class="task-main">

                                        <h3 class="<%= "completed".equals(taskStatus)
                                            ? "task-completed" : "" %>">
                                            <%= safeTitle %>
                                        </h3>

                                        <% if (!safeDescription.isBlank()) { %>
                                            <p class="task-description">
                                                <%= safeDescription %>
                                            </p>
                                        <% } %>

                                        <div class="task-metadata">

                                            <span class="status-badge status-<%= safeStatus %>">
                                                <%= safeStatus.replace('_', ' ') %>
                                            </span>

                                            <span class="priority-badge priority-<%= safePriority %>">
                                                <%= safePriority %> priority
                                            </span>

                                            <% if (!safeDueDate.isBlank()) { %>
                                                <span class="due-date">
                                                    ◷ <%= safeDueDate %>
                                                </span>
                                            <% } %>

                                        </div>
                                    </div>

                                    <div class="task-actions">

                                        <% if (!"completed".equals(taskStatus)) { %>
                                            <form action="<%= contextPath %>/tasks"
                                                  method="post">
                                                <input type="hidden"
                                                       name="action"
                                                       value="status">
                                                <input type="hidden"
                                                       name="taskId"
                                                       value="<%= task.getTaskId() %>">
                                                <input type="hidden"
                                                       name="status"
                                                       value="completed">

                                                <button class="icon-button complete-button"
                                                        type="submit"
                                                        title="Mark completed"
                                                        aria-label="Mark completed">
                                                    ✓
                                                </button>
                                            </form>
                                        <% } %>

                                        <form action="<%= contextPath %>/tasks"
                                              method="post"
                                              onsubmit="return confirm('Delete this task?');">
                                            <input type="hidden"
                                                   name="action"
                                                   value="delete">
                                            <input type="hidden"
                                                   name="taskId"
                                                   value="<%= task.getTaskId() %>">

                                            <button class="icon-button delete-button"
                                                    type="submit"
                                                    title="Delete task"
                                                    aria-label="Delete task">
                                                ×
                                            </button>
                                        </form>

                                    </div>

                                </article>

                            <% } %>

                        </div>

                    <% } %>

                </section>

            </div>
        </main>

        <!-- =================================================
             SHARED FOOTER
             IMPORTANT: This is outside </main>.
             It spans the right-hand page column, not the
             task content container.
             ================================================= -->

    </div>
    <!-- End page-column -->

</div>
        <footer class="site-footer">

            <div class="footer-main">

                <div class="footer-about">
                    <a class="footer-brand"
                       href="<%= contextPath %>/dashboard">
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
                    &copy; <%= java.time.Year.now().getValue() %>
                    dayWise. All rights reserved.
                </p>
                <p>Plan mindfully. Focus deeply. Make progress.</p>
            </div>

        </footer>
<!-- End app-layout -->

<script>
(function () {
    "use strict";

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

    const taskFormCard = document.getElementById("taskFormCard");
    const taskTitle = document.getElementById("taskTitle");

    function openTaskForm() {
        taskFormCard.hidden = false;
        taskFormCard.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });
        taskTitle.focus();
    }

    function closeTaskForm() {
        taskFormCard.hidden = true;
    }

    document.getElementById("openTaskForm")
        .addEventListener("click", openTaskForm);

    const emptyAddTask = document.getElementById("emptyAddTask");
    if (emptyAddTask) {
        emptyAddTask.addEventListener("click", openTaskForm);
    }

    document.getElementById("closeTaskForm")
        .addEventListener("click", closeTaskForm);

    document.getElementById("cancelTaskForm")
        .addEventListener("click", closeTaskForm);

    const query = new URLSearchParams(window.location.search);
    if (query.get("action") === "add") {
        openTaskForm();
    }
})();
</script>

</body>
</html>
