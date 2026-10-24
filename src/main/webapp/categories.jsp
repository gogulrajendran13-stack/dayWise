
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.dayWise.model.Category" %>

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

    List<Category> categories =
        (List<Category>) request.getAttribute("categories");

    if (categories == null) {
        categories = java.util.Collections.emptyList();
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

    <title>Categories | dayWise</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/categories.css">
</head>

<body>

<!-- ======================================================
     APPLICATION LAYOUT
     Sidebar and main content share one row.
     The footer is outside this layout and spans the page.
     ====================================================== -->
<div class="app-layout">

    <!-- ========== SHARED SIDEBAR ========== -->
    <aside class="sidebar" id="sidebar">

        <a class="brand"
           href="<%= contextPath %>/dashboard"
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

            <a class="nav-link active"
               href="<%= contextPath %>/categories"
               aria-current="page">
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
                        <strong>Categories</strong>
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
                        <p class="eyebrow">SORT · GROUP · SIMPLIFY</p>
                        <h1>Task <span>Categories</span></h1>

                        <p class="page-description">
                            Create categories to organize tasks around the things that matter.
                        </p>
                    </div>

                    <button class="primary-button"
                            id="openCategoryForm"
                            type="button">
                        ＋ New category
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
                        Category created successfully.
                    </div>
                <% } else if ("updated".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Category updated successfully.
                    </div>
                <% } else if ("deleted".equals(success)) { %>
                    <div class="alert alert-success" role="status">
                        Category deleted successfully.
                    </div>
                <% } %>


                <!-- Create category form -->
                <section class="category-form-card"
                         id="categoryFormCard"
                         hidden>

                    <div class="form-card-heading">

                        <div>
                            <h2>Create a category</h2>
                            <p>Choose a name and a color for easy identification.</p>
                        </div>

                        <button class="close-button"
                                id="closeCategoryForm"
                                type="button"
                                aria-label="Close form">
                            ×
                        </button>

                    </div>

                    <form action="<%= contextPath %>/categories"
                          method="post"
                          class="category-form">

                        <input type="hidden" name="action" value="add">

                        <div class="form-field">
                            <label for="categoryName">
                                Category name <span>*</span>
                            </label>

                            <input type="text"
                                   id="categoryName"
                                   name="categoryName"
                                   maxlength="100"
                                   placeholder="e.g. Work, Personal, Learning"
                                   required>
                        </div>

                        <div class="form-field">
                            <label for="categoryColor">Category color</label>

                            <input type="color"
                                   id="categoryColor"
                                   name="categoryColor"
                                   value="#7655e8">
                        </div>

                        <div class="form-actions full-width">

                            <button class="secondary-button"
                                    id="cancelCategoryForm"
                                    type="button">
                                Cancel
                            </button>

                            <button class="primary-button" type="submit">
                                Save category
                            </button>

                        </div>

                    </form>

                </section>


                <!-- Category list -->
                <section class="categories-section">

                    <div class="section-heading">

                        <div>
                            <h2>Your categories</h2>
                            <p>Categories available in your workspace.</p>
                        </div>

                        <span class="category-count">
                            <%= categories.size() %>
                            <%= categories.size() == 1 ? "category" : "categories" %>
                        </span>

                    </div>


                    <% if (categories.isEmpty()) { %>

                        <div class="empty-state">

                            <div class="empty-icon">◇</div>

                            <h3>Start with a little organization</h3>

                            <p>
                                Create your first category to make related tasks
                                easier to organize.
                            </p>

                            <button class="primary-button"
                                    id="emptyCreateCategory"
                                    type="button">
                                ＋ Create your first category
                            </button>

                        </div>

                    <% } else { %>

                        <div class="category-grid">

                            <% for (Category category : categories) {

                                String categoryName =
                                    category.getCategoryName() == null
                                    ? "" : category.getCategoryName();

                                String safeCategoryName =
                                    escapeHtml(categoryName);

                                String categoryColor =
                                    category.getCategoryColor();

                                if (categoryColor == null ||
                                    !categoryColor.matches("^#[0-9a-fA-F]{6}$")) {
                                    categoryColor = "#7655e8";
                                }
                            %>

                                <article class="category-card">

                                    <div class="category-card-header">

                                        <span class="category-color"
                                              style="background-color: <%= categoryColor %>;">
                                        </span>

                                        <span class="category-label">
                                            TASK CATEGORY
                                        </span>

                                    </div>

                                    <h3><%= safeCategoryName %></h3>

                                    <p class="category-description">
                                        Organize your tasks under
                                        <strong><%= safeCategoryName %></strong>.
                                    </p>

                                    <div class="category-card-footer">

                                        <span class="category-id">
                                            Category #<%= category.getCategoryId() %>
                                        </span>

                                        <form action="<%= contextPath %>/categories"
                                              method="post"
                                              onsubmit="return confirm('Delete this category?');">

                                            <input type="hidden"
                                                   name="action"
                                                   value="delete">

                                            <input type="hidden"
                                                   name="categoryId"
                                                   value="<%= category.getCategoryId() %>">

                                            <button class="icon-button delete-button"
                                                    type="submit"
                                                    aria-label="Delete category"
                                                    title="Delete category">
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
            <!-- End page-content -->

        </main>
        <!-- End main-content -->

    </div>
    <!-- End page-column -->

</div>
<!-- End app-layout -->


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



<!-- Mobile navigation and category form controls -->
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

    /* Category form controls */
    const formCard = document.getElementById("categoryFormCard");
    const categoryName = document.getElementById("categoryName");

    const openButton = document.getElementById("openCategoryForm");
    const emptyCreateButton = document.getElementById("emptyCreateCategory");
    const closeButton = document.getElementById("closeCategoryForm");
    const cancelButton = document.getElementById("cancelCategoryForm");

    function openForm() {
        formCard.hidden = false;

        formCard.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });

        categoryName.focus();
    }

    function closeForm() {
        formCard.hidden = true;
    }

    openButton.addEventListener("click", openForm);

    if (emptyCreateButton) {
        emptyCreateButton.addEventListener("click", openForm);
    }

    closeButton.addEventListener("click", closeForm);
    cancelButton.addEventListener("click", closeForm);

    /* Keep the form visible when the controller returns an error. */
    <% if (errorMessage != null && !errorMessage.isBlank()) { %>
        formCard.hidden = false;
    <% } %>

    /* Allow the form to be opened through ?action=add. */
    if (new URLSearchParams(window.location.search).get("action") === "add") {
        openForm();
    }
})();
</script>

</body>
</html>
