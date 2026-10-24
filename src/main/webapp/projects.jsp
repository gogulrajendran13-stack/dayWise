
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.dayWise.model.Project" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
            .replace("&", "&amp;")
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

    List<Project> projects =
        (List<Project>) request.getAttribute("projects");

    if (projects == null) {
        projects = java.util.Collections.emptyList();
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

    <title>Projects | dayWise</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/projects.css">
</head>

<body>

<!-- ======================================================
     APPLICATION LAYOUT
     Sidebar and main content share this row.
     The full-width footer is OUTSIDE this layout.
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

            <a class="nav-link active"
               href="<%= contextPath %>/projects"
               aria-current="page">
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

            <a class="nav-link" href="<%= contextPath %>/focus-sessions">
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


    <!-- Mobile navigation overlay -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>


    <!-- ========== MAIN COLUMN ========== -->
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
                            aria-expanded="false">
                        ☰
                    </button>

                    <div class="breadcrumb">
                        Workspace <span>/</span>
                        <strong>Projects</strong>
                    </div>

                </div>

                <a class="profile-chip"
                   href="<%= contextPath %>/profile">

                    <span class="avatar">
                        <%= firstName.substring(0, 1)
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
                        <p class="eyebrow">PLAN · ORGANIZE · ACHIEVE</p>
                        <h1>My <span>Projects</span></h1>

                        <p class="page-description">
                            Bring related tasks together and turn your plans into progress.
                        </p>
                    </div>

                    <button class="primary-button"
                            id="openProjectForm"
                            type="button">
                        <span>＋</span> New project
                    </button>

                </section>


                <!-- Error and success messages -->
                <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                    <div class="alert alert-error" role="alert">
                        <%= safeError %>
                    </div>
                <% } %>

                <% if ("added".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Project created successfully.
                    </div>
                <% } else if ("updated".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Project updated successfully.
                    </div>
                <% } else if ("deleted".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Project deleted successfully.
                    </div>
                <% } %>


                <!-- Create project form -->
                <section class="project-form-card"
                         id="projectFormCard"
                         hidden>

                    <div class="form-card-heading">

                        <div>
                            <h2>Create a project</h2>
                            <p>Give your project a name and a clear purpose.</p>
                        </div>

                        <button class="close-button"
                                id="closeProjectForm"
                                type="button"
                                aria-label="Close form">
                            ×
                        </button>

                    </div>

                    <form action="<%= contextPath %>/projects"
                          method="post"
                          class="project-form">

                        <input type="hidden" name="action" value="add">

                        <div class="form-field">
                            <label for="projectName">
                                Project name <span>*</span>
                            </label>

                            <input type="text"
                                   id="projectName"
                                   name="projectName"
                                   maxlength="150"
                                   placeholder="e.g. Personal development"
                                   required>
                        </div>

                        <div class="form-field">
                            <label for="projectColor">Project color</label>

                            <input type="color"
                                   id="projectColor"
                                   name="color"
                                   value="#7655e8">
                        </div>

                        <div class="form-field full-width">
                            <label for="projectDescription">Description</label>

                            <textarea id="projectDescription"
                                      name="description"
                                      rows="3"
                                      maxlength="2000"
                                      placeholder="What do you want to accomplish?"></textarea>
                        </div>

                        <div class="form-actions full-width">

                            <button class="secondary-button"
                                    id="cancelProjectForm"
                                    type="button">
                                Cancel
                            </button>

                            <button class="primary-button" type="submit">
                                Save project
                            </button>

                        </div>

                    </form>

                </section>


                <!-- Project list -->
                <section class="projects-section">

                    <div class="section-heading">

                        <div>
                            <h2>Your projects</h2>
                            <p>Projects available in your workspace.</p>
                        </div>

                        <span class="project-count">
                            <%= projects.size() %> project(s)
                        </span>

                    </div>


                    <% if (projects.isEmpty()) { %>

                        <div class="empty-state">

                            <div class="empty-icon">▦</div>

                            <h3>Your next big idea starts here</h3>

                            <p>
                                Create a project to group related tasks
                                and keep your work organized.
                            </p>

                            <button class="primary-button"
                                    id="emptyCreateProject"
                                    type="button">
                                ＋ Create your first project
                            </button>

                        </div>

                    <% } else { %>

                        <div class="project-grid">

                            <% for (Project project : projects) {

                                String projectName = project.getProjectName() == null
                                    ? "" : project.getProjectName();

                                String safeProjectName = escapeHtml(projectName);

                                String projectDescription =
                                    project.getDescription() == null
                                    ? "" : project.getDescription();

                                String safeDescription =
                                    escapeHtml(projectDescription);

                                String projectStatus =
                                    project.getStatus() == null
                                    ? "active"
                                    : project.getStatus()
                                        .toLowerCase(Locale.ROOT);

                                String safeStatus = escapeHtml(projectStatus);

                                /* Keep status class safe for CSS. */
                                String statusClass = projectStatus
                                    .replaceAll("[^a-z0-9_-]", "");

                                /* Match the approved lavender project theme. */
                                String projectColor = "#7655e8";
                            %>

                                <article class="project-card">

                                    <div class="project-card-top">

                                        <span class="project-color"
                                              style="background-color: <%= projectColor %>;">
                                        </span>

                                        <span class="project-status status-<%= statusClass %>">
                                            <%= safeStatus.replace("_", " ") %>
                                        </span>

                                    </div>

                                    <h3><%= safeProjectName %></h3>

                                    <p class="project-description">
                                        <%= safeDescription.isBlank()
                                            ? "No description added yet."
                                            : safeDescription %>
                                    </p>

                                    <div class="project-card-footer">

                                        <span class="project-label">
                                            Project #<%= project.getProjectId() %>
                                        </span>

                                        <div class="project-actions">

                                            <form action="<%= contextPath %>/projects"
                                                  method="post"
                                                  onsubmit="return confirm('Delete this project? Make sure its tasks are handled first.');">

                                                <input type="hidden"
                                                       name="action"
                                                       value="delete">

                                                <input type="hidden"
                                                       name="projectId"
                                                       value="<%= project.getProjectId() %>">

                                                <button class="icon-button delete-button"
                                                        type="submit"
                                                        aria-label="Delete project"
                                                        title="Delete project">
                                                    ×
                                                </button>

                                            </form>

                                        </div>

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
     Outside app-layout: spans below sidebar AND main area.
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


<!-- Mobile navigation and project form controls -->
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

    /* Project form controls */
    const formCard = document.getElementById("projectFormCard");
    const projectName = document.getElementById("projectName");
    const openButton = document.getElementById("openProjectForm");
    const emptyCreateButton = document.getElementById("emptyCreateProject");
    const closeButton = document.getElementById("closeProjectForm");
    const cancelButton = document.getElementById("cancelProjectForm");

    function openForm() {
        formCard.hidden = false;
        formCard.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });
        projectName.focus();
    }

    function closeForm() {
        formCard.hidden = true;
    }

    openButton.addEventListener("click", openForm);

    /* This button exists only when there are no projects. */
    if (emptyCreateButton) {
        emptyCreateButton.addEventListener("click", openForm);
    }

    closeButton.addEventListener("click", closeForm);
    cancelButton.addEventListener("click", closeForm);

    /* Keep the form open if the server returns a validation error. */
    <% if (errorMessage != null && !errorMessage.isBlank()) { %>
        formCard.hidden = false;
    <% } %>
})();
</script>

</body>
</html>
