<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.dayWise.model.UserSettings" %>
<%@ page import="com.dayWise.model.User" %>
<%@ page import="java.util.Locale" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String contextPath = request.getContextPath();

    UserSettings settings =
        (UserSettings) request.getAttribute("settings");

    String currentTheme = settings != null
            && settings.getTheme() != null
            ? settings.getTheme().toUpperCase(Locale.ROOT)
            : "LIGHT";

    int focusMinutes = settings != null
            ? settings.getDailyFocusMinutes() : 120;

    boolean notificationsEnabled = settings == null
            || settings.isNotificationsEnabled();

    boolean remindersEnabled = settings == null
            || settings.isReminderEnabled();

    String currentLanguage = settings != null
            && settings.getLanguage() != null
            ? settings.getLanguage() : "en";

    String displayName = "User";
    Object userObject = session.getAttribute("user");

    if (userObject instanceof User) {
        User currentUser = (User) userObject;

        if (currentUser.getFullName() != null
                && !currentUser.getFullName().trim().isEmpty()) {
            displayName = currentUser.getFullName().trim();
        }
    }

    String initial = displayName.substring(0, 1)
            .toUpperCase(Locale.ROOT);

    String status = request.getParameter("status");
%>

<!DOCTYPE html>
<html lang="<%= "ta".equals(currentLanguage) ? "ta" : "en" %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Settings | dayWise</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/settings.css">

</head>

<body class="<%= "DARK".equals(currentTheme) ? "dark-theme" : "light-theme" %>">

<div class="app-layout">

    <!-- Sidebar: retain the existing navigation design -->
    <aside class="sidebar" id="sidebar">

        <a class="brand" href="<%= contextPath %>/dashboard">
            <span class="brand-icon">✓</span>
            <span class="brand-name">dayWise</span>
        </a>

        <nav class="sidebar-nav" aria-label="Main navigation">

            <p class="nav-label">WORKSPACE</p>

            <a href="<%= contextPath %>/dashboard" class="nav-link">
                <span class="nav-icon">▦</span>
                <span>Dashboard</span>
            </a>

            <a href="<%= contextPath %>/tasks" class="nav-link">
                <span class="nav-icon">☑</span>
                <span>My Tasks</span>
            </a>

            <a href="<%= contextPath %>/projects" class="nav-link">
                <span class="nav-icon">▤</span>
                <span>Projects</span>
            </a>

            <a href="<%= contextPath %>/categories" class="nav-link">
                <span class="nav-icon">◈</span>
                <span>Categories</span>
            </a>

            <a href="<%= contextPath %>/recurring-tasks" class="nav-link">
                <span class="nav-icon">↻</span>
                <span>Recurring Tasks</span>
            </a>

            <p class="nav-label">PRODUCTIVITY</p>

            <a href="<%= contextPath %>/reminders" class="nav-link">
                <span class="nav-icon">♧</span>
                <span>Reminders</span>
            </a>

            <a href="<%= contextPath %>/notifications" class="nav-link">
                <span class="nav-icon">♢</span>
                <span>Notifications</span>
            </a>

            <a href="<%= contextPath %>/goals" class="nav-link">
                <span class="nav-icon">◎</span>
                <span>Goals</span>
            </a>

            <a href="<%= contextPath %>/focus-sessions" class="nav-link">
                <span class="nav-icon">◷</span>
                <span>Focus Sessions</span>
            </a>

            <p class="nav-label">ACCOUNT</p>

            <a href="<%= contextPath %>/profile" class="nav-link">
                <span class="nav-icon">♙</span>
                <span>Profile</span>
            </a>

            <a href="<%= contextPath %>/settings"
               class="nav-link active"
               aria-current="page">
                <span class="nav-icon">⚙</span>
                <span>Settings</span>
            </a>

        </nav>

        <div class="sidebar-bottom">
            <a href="<%= contextPath %>/logout"
               class="nav-link logout-link">
                <span class="nav-icon">⇥</span>
                <span>Logout</span>
            </a>
        </div>

    </aside>

    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <div class="page-column">

        <!-- Top navbar -->
        <header class="topbar">

            <div class="topbar-left">
                <button type="button"
                        class="menu-toggle"
                        id="menuToggle"
                        aria-label="Toggle navigation"
                        aria-controls="sidebar"
                        aria-expanded="false">
                    ☰
                </button>

                <div class="breadcrumb">
                    <span>Workspace</span>
                    <span class="breadcrumb-divider">/</span>
                    <strong>Settings</strong>
                </div>
            </div>

            <a class="profile-chip"
               href="<%= contextPath %>/profile">

                <span class="profile-avatar"><%= initial %></span>

                <span class="profile-details">
                    <span class="profile-name"><%= displayName %></span>
                    <span class="profile-label">Personal workspace</span>
                </span>

            </a>

        </header>

        <main class="main-content">
            <div class="page-content">

                <section class="page-heading">
                    <div>
                        <h1>Settings</h1>
                        <p class="page-description">
                            Customize your workspace and productivity preferences.
                        </p>
                    </div>
                </section>

                <!-- Save feedback -->
                <% if ("success".equals(status)) { %>
                    <div class="feedback-message success-message"
                         id="settingsFeedback"
                         role="status">
                        Your settings were saved successfully.
                    </div>
                <% } else if ("error".equals(status)) { %>
                    <div class="feedback-message error-message"
                         id="settingsFeedback"
                         role="alert">
                        We couldn't update your settings. Please check your values and try again.
                    </div>
                <% } %>

                <!-- ONE FORM FOR ALL FIVE SETTINGS -->
                <form action="<%= contextPath %>/settings"
                      method="post"
                      id="settingsForm">

                    <input type="hidden" name="action" value="save">

                   
                    <!-- 3. Notifications -->
                    <section class="settings-section">

                        <div class="section-heading">
                            <div class="section-icon">♧</div>
                            <div>
                                <h2>Notifications</h2>
                                <p>Control which workspace updates you receive.</p>
                            </div>
                        </div>

                        <div class="setting-row">
                            <div class="setting-description">
                                <h3>Enable notifications</h3>
                                <p>Receive updates about tasks and workspace activity.</p>
                            </div>

                            <label class="toggle-control">
                                <input type="checkbox"
                                       name="notificationsEnabled"
                                       value="true"
                                       <%= notificationsEnabled ? "checked" : "" %>>

                                <span class="toggle-slider"></span>

                                <span class="toggle-label">
                                    <%= notificationsEnabled ? "Enabled" : "Disabled" %>
                                </span>
                            </label>
                        </div>

                    </section>

                    <!-- 4. Reminders -->
                    <section class="settings-section">

                        <div class="section-heading">
                            <div class="section-icon">◷</div>
                            <div>
                                <h2>Reminders</h2>
                                <p>Manage your task reminder preferences.</p>
                            </div>
                        </div>

                        <div class="setting-row">
                            <div class="setting-description">
                                <h3>Enable reminders</h3>
                                <p>Allow reminders for tasks that need your attention.</p>
                            </div>

                            <label class="toggle-control">
                                <input type="checkbox"
                                       name="reminderEnabled"
                                       value="true"
                                       <%= remindersEnabled ? "checked" : "" %>>

                                <span class="toggle-slider"></span>

                                <span class="toggle-label">
                                    <%= remindersEnabled ? "Enabled" : "Disabled" %>
                                </span>
                            </label>
                        </div>

                    </section>

                    <!-- 5. Language -->
                    

                    <!-- One save button for all settings -->
                    <div class="settings-save-bar">
                        <button type="submit" class="primary-button">
                            Save Settings
                        </button>
                    </div>

                </form>

            </div>
        </main>

    </div>
</div>

<!-- Full-width footer remains outside app-layout -->
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
            <a href="<%= contextPath %>/recurring-tasks">Recurring Tasks</a>
            <a href="<%= contextPath %>/reminders">Reminders</a>
            <a href="<%= contextPath %>/notifications">Notifications</a>
            <a href="<%= contextPath %>/goals">Goals</a>
            <a href="<%= contextPath %>/focus-sessions">Focus Sessions</a>
        </div>

        <div class="footer-column">
            <h3>ACCOUNT</h3>
            <a href="<%= contextPath %>/profile">Profile</a>
            <a href="<%= contextPath %>/settings">Settings</a>
        </div>

    </div>

    <div class="footer-bottom">
        <p>&copy; <%= java.time.Year.now() %> dayWise. All rights reserved.</p>
        <p>Small steps. Meaningful progress.</p>
    </div>

</footer>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebarOverlay");
    const menuToggle = document.getElementById("menuToggle");
    const feedback = document.getElementById("settingsFeedback");
    const settingsForm = document.getElementById("settingsForm");
    const themeSelect = document.getElementById("theme");

    function openSidebar() {
        if (!sidebar || !overlay || !menuToggle) return;

        sidebar.classList.add("sidebar-open");
        overlay.classList.add("overlay-open");
        menuToggle.setAttribute("aria-expanded", "true");
        document.body.classList.add("sidebar-visible");
    }

    function closeSidebar() {
        if (!sidebar || !overlay || !menuToggle) return;

        sidebar.classList.remove("sidebar-open");
        overlay.classList.remove("overlay-open");
        menuToggle.setAttribute("aria-expanded", "false");
        document.body.classList.remove("sidebar-visible");
    }

    if (menuToggle) {
        menuToggle.addEventListener("click", function () {
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

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") closeSidebar();
    });

    window.addEventListener("resize", function () {
        if (window.innerWidth > 900) closeSidebar();
    });

    document.querySelectorAll(".toggle-control input").forEach(function (input) {
        input.addEventListener("change", function () {
            const label = input.closest(".toggle-control")
                               .querySelector(".toggle-label");

            if (label) {
                label.textContent = input.checked ? "Enabled" : "Disabled";
            }
        });
    });

    /*
     * Preview the selected theme immediately on this page.
     * The selected theme is also saved to the database when Save Settings
     * is submitted. Other pages need to read the saved theme too.
     */
    if (themeSelect) {
        themeSelect.addEventListener("change", function () {
            document.body.classList.toggle(
                "dark-theme",
                themeSelect.value === "DARK"
            );

            document.body.classList.toggle(
                "light-theme",
                themeSelect.value !== "DARK"
            );
        });
    }

    /*
     * Remove status from the address bar after showing the feedback.
     * This prevents the same message from reappearing on refresh.
     */
    if (feedback) {
        window.history.replaceState(
            {},
            document.title,
            window.location.pathname
        );

        window.setTimeout(function () {
            feedback.style.transition = "opacity 0.3s ease";
            feedback.style.opacity = "0";

            window.setTimeout(function () {
                feedback.remove();
            }, 350);
        }, 3000);
    }

    if (settingsForm) {
        settingsForm.addEventListener("submit", function () {
            const button = settingsForm.querySelector(
                ".settings-save-bar button"
            );

            if (button) {
                button.disabled = true;
                button.textContent = "Saving...";
            }
        });
    }
});
</script>

</body>
</html>