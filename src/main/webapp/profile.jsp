<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.dayWise.model.User" %>
<%@ page import="java.util.Locale" %>

<%!
    // Escape values before displaying them in HTML.
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    // Verify login and read the existing user session.
    Object userObject = session.getAttribute("user");

    if (!(userObject instanceof User)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    User user = (User) userObject;
    String contextPath = request.getContextPath();

    String fullName = user.getFullName() == null
            ? "dayWise User" : user.getFullName().trim();

    if (fullName.isEmpty()) {
        fullName = "dayWise User";
    }

    String email = user.getEmail() == null
            ? "" : user.getEmail().trim();

    String userId = String.valueOf(user.getUserId());
    String initial = fullName.substring(0, 1).toUpperCase(Locale.ROOT);

    String accountStatus = user.getAccountStatus() == null
            ? "" : user.getAccountStatus().trim();

    boolean hasAccountStatus = !accountStatus.isEmpty();

    boolean accountActive =
            accountStatus.isEmpty()
            || "ACTIVE".equalsIgnoreCase(accountStatus)
            || "ENABLED".equalsIgnoreCase(accountStatus);

    // These details remain placeholders until profile editing is implemented.
    String phoneNumber = "Not added yet";
    String addressLine = "Not added yet";
    String cityRegion = "Not added yet";
    String country = "Not added yet";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | dayWise</title>

    <!-- Profile stylesheet -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/profile.css">
</head>

<body>

<!-- =========================================================
     APP CONTAINER: contains ONLY the sidebar and main content.
     The footer must remain outside this container.
     ========================================================= -->
<div class="app-container">

    <!-- ===================== SIDEBAR ===================== -->
    <aside class="sidebar" id="sidebar">

        <a class="brand"
           href="<%= contextPath %>/dashboard"
           aria-label="dayWise dashboard">
            <span class="brand-icon">✓</span>
            <span class="brand-name">dayWise</span>
        </a>

        <nav class="sidebar-navigation" aria-label="Main navigation">

            <p class="nav-label">Workspace</p>
            <ul class="nav-list">
                <li>
                    <a href="<%= contextPath %>/dashboard" class="nav-link">
                        <span class="nav-icon">⌂</span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/tasks" class="nav-link">
                        <span class="nav-icon">▤</span>
                        <span>My Tasks</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/projects" class="nav-link">
                        <span class="nav-icon">▦</span>
                        <span>Projects</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/categories" class="nav-link">
                        <span class="nav-icon">◈</span>
                        <span>Categories</span>
                    </a>
                </li>
            </ul>

            <p class="nav-label">Productivity</p>
            <ul class="nav-list">
                <li>
                    <a href="<%= contextPath %>/recurring-tasks" class="nav-link">
                        <span class="nav-icon">↻</span>
                        <span>Recurring Tasks</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/reminders" class="nav-link">
                        <span class="nav-icon">◷</span>
                        <span>Reminders</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/notifications" class="nav-link">
                        <span class="nav-icon">♧</span>
                        <span>Notifications</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/goals" class="nav-link">
                        <span class="nav-icon">◎</span>
                        <span>Goals</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/focus-sessions" class="nav-link">
                        <span class="nav-icon">◷</span>
                        <span>Focus Sessions</span>
                    </a>
                </li>
            </ul>

            <p class="nav-label">Account</p>
            <ul class="nav-list">
                <li>
                    <a href="<%= contextPath %>/profile"
                       class="nav-link active"
                       aria-current="page">
                        <span class="nav-icon">♙</span>
                        <span>Profile</span>
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/settings" class="nav-link">
                        <span class="nav-icon">⚙</span>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>
        </nav>

        <div class="sidebar-bottom">
            <a href="<%= contextPath %>/logout"
               class="nav-link logout-link">
                <span class="nav-icon">⇥</span>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- ===================== MAIN CONTENT ===================== -->
    <main class="main-content">

        <!-- Top navigation -->
        <header class="topbar">
            <div class="topbar-left">
                <button type="button"
                        class="menu-toggle"
                        id="menuToggle"
                        aria-label="Open navigation"
                        aria-controls="sidebar"
                        aria-expanded="false">
                    ☰
                </button>

                <div class="breadcrumb">
                    <span>Workspace</span>
                    <span class="breadcrumb-separator">/</span>
                    <strong>My Profile</strong>
                </div>
            </div>

            <div class="topbar-right">
                <span class="topbar-label">Your personal space</span>
                <a href="<%= contextPath %>/profile"
                   class="profile-avatar"
                   aria-label="My profile">
                    <%= escapeHtml(initial) %>
                </a>
            </div>
        </header>

        <!-- All profile sections are contained within profile-content. -->
        <div class="profile-content">

            <!-- Page heading -->
            <section class="page-heading">
                <div>
                    <h1>My Profile</h1>
                    <p class="page-description">
                        Your personal details, account information,
                        and productivity workspace in one place.
                    </p>
                </div>
            </section>

            <!-- Profile overview -->
            <section class="profile-overview" aria-labelledby="profileName">
                <div class="profile-avatar-large">
                    <%= escapeHtml(initial) %>
                </div>

                <div class="profile-overview-details">
                    <p class="eyebrow">PERSONAL WORKSPACE</p>

                    <h2 id="profileName">
                        <%= escapeHtml(fullName) %>
                    </h2>

                    <p>
                        <%= email.isEmpty()
                                ? "Email address not available"
                                : escapeHtml(email) %>
                    </p>

                    <div class="profile-chip-list">
                        <span class="profile-info-chip">
                            ✦ dayWise Member
                        </span>

                        <span class="profile-info-chip">
                            ◎ Account ID: <%= escapeHtml(userId) %>
                        </span>
                    </div>
                </div>

                <% if (hasAccountStatus) { %>
                    <span class="account-status <%= accountActive ? "" : "account-status-inactive" %>">
                        <%= escapeHtml(accountStatus) %>
                    </span>
                <% } %>
            </section>

            <!-- Personal information -->
            <section class="profile-section"
                     aria-labelledby="personalInfoHeading">

                <div class="section-heading">
                    <div>
                        <h2 id="personalInfoHeading">Personal information</h2>
                        <p>Your registered details and contact information.</p>
                    </div>

                    <a href="<%= contextPath %>/settings"
                       class="secondary-button">
                        Edit details
                    </a>
                </div>

                <div class="profile-details-grid">
                    <div class="detail-card">
                        <span class="detail-label">Phone number</span>
                        <p class="detail-value"><%= escapeHtml(phoneNumber) %></p>
                    </div>

                    <div class="detail-card">
                        <span class="detail-label">Address</span>
                        <p class="detail-value"><%= escapeHtml(addressLine) %></p>
                        <span class="detail-description">Street and address details</span>
                    </div>

                    <div class="detail-card">
                        <span class="detail-label">City / Region</span>
                        <p class="detail-value"><%= escapeHtml(cityRegion) %></p>
                    </div>

                    <div class="detail-card">
                        <span class="detail-label">Country</span>
                        <p class="detail-value"><%= escapeHtml(country) %></p>
                    </div>
                </div>

                <p class="profile-note">
                    Contact and address details can be added when profile
                    editing is connected.
                </p>
            </section>

            <!-- Account details and security -->
            <div class="profile-columns">

                <section class="profile-panel"
                         aria-labelledby="accountDetailsHeading">

                    <div class="section-heading">
                        <div>
                            <h2 id="accountDetailsHeading">Account details</h2>
                            <p>Information linked to your dayWise account.</p>
                        </div>
                    </div>

                    <div class="profile-activity-list">
                        <div class="profile-activity-item">
                            <span class="activity-icon">♙</span>
                            <div>
                                <strong>Registered name</strong>
                                <p><%= escapeHtml(fullName) %></p>
                            </div>
                        </div>

                        <div class="profile-activity-item">
                            <span class="activity-icon green">✉</span>
                            <div>
                                <strong>Primary email</strong>
                                <p>
                                    <%= email.isEmpty()
                                            ? "Not available"
                                            : escapeHtml(email) %>
                                </p>
                            </div>
                        </div>

                        <div class="profile-activity-item">
                            <span class="activity-icon blue">▦</span>
                            <div>
                                <strong>Workspace access</strong>
                                <p>
                                    Open your tasks, projects, goals,
                                    reminders, and focus sessions.
                                </p>
                                <a class="inline-action"
                                   href="<%= contextPath %>/dashboard">
                                    Go to dashboard →
                                </a>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="profile-panel"
                         aria-labelledby="securityHeading">

                    <div class="section-heading">
                        <div>
                            <h2 id="securityHeading">Account and security</h2>
                            <p>Manage your account preferences safely.</p>
                        </div>
                    </div>

                    <div class="profile-activity-list">
                        <div class="profile-activity-item">
                            <span class="activity-icon">⚙</span>
                            <div>
                                <strong>Account preferences</strong>
                                <p>
                                    Review the settings available in your workspace.
                                </p>
                            </div>
                        </div>

                        <div class="profile-activity-item">
                            <span class="activity-icon orange">▣</span>
                            <div>
                                <strong>Session safety</strong>
                                <p>
                                    Sign out when you finish using a shared computer.
                                </p>
                            </div>
                        </div>
                    </div>

                    <a href="<%= contextPath %>/settings"
                       class="primary-button settings-button">
                        <span>⚙</span>
                        <span>Open Settings</span>
                        <span class="button-arrow">→</span>
                    </a>
                </section>
            </div>

            <!-- Productivity workspace -->
            <section class="profile-section productivity-section"
                     aria-labelledby="productivityHeading">

                <div class="section-heading">
                    <div>
                        <h2 id="productivityHeading">Your productivity workspace</h2>
                        <p>Quick access to the tools that help you move forward.</p>
                    </div>
                </div>

                <div class="productivity-grid">
                    <a class="productivity-card"
                       href="<%= contextPath %>/tasks">
                        <span class="productivity-icon task-icon">▤</span>
                        <span class="productivity-label">TASKS</span>
                        <strong>My Tasks <span>→</span></strong>
                        <span class="productivity-description">
                            Organize your daily priorities and tasks.
                        </span>
                    </a>

                    <a class="productivity-card"
                       href="<%= contextPath %>/projects">
                        <span class="productivity-icon project-icon">▦</span>
                        <span class="productivity-label">PROJECTS</span>
                        <strong>My Projects <span>→</span></strong>
                        <span class="productivity-description">
                            Keep related work organized together.
                        </span>
                    </a>

                    <a class="productivity-card"
                       href="<%= contextPath %>/goals">
                        <span class="productivity-icon goal-icon">◎</span>
                        <span class="productivity-label">GOALS</span>
                        <strong>My Goals <span>→</span></strong>
                        <span class="productivity-description">
                            Keep track of the goals you want to achieve.
                        </span>
                    </a>

                    <a class="productivity-card"
                       href="<%= contextPath %>/focus-sessions">
                        <span class="productivity-icon focus-icon">◷</span>
                        <span class="productivity-label">FOCUS</span>
                        <strong>Focus Sessions <span>→</span></strong>
                        <span class="productivity-description">
                            Set aside time for focused work.
                        </span>
                    </a>
                </div>
            </section>

            <!-- Member badges and social links -->
            <section class="profile-columns profile-extras">

                <div class="profile-panel">
                    <div class="section-heading">
                        <div>
                            <h2>Member badges</h2>
                            <p>Recognition and milestones for your workspace.</p>
                        </div>
                    </div>

                    <div class="badge-list">
                        <span class="member-badge">
                            <span>✦</span>
                            dayWise Member
                        </span>

                        <span class="member-badge badge-muted">
                            <span>◎</span>
                            More milestones coming
                        </span>
                    </div>

                    <p class="profile-note">
                        Achievement badges can be connected to real task
                        and goal progress when that feature is implemented.
                    </p>
                </div>

                <div class="profile-panel">
                    <div class="section-heading">
                        <div>
                            <h2>Social and website links</h2>
                            <p>Keep your professional links together.</p>
                        </div>
                    </div>

                    <div class="social-link-list">
                        <a class="social-link-row"
                           href="https://www.linkedin.com/in/gogul6006/"
                           target="_blank"
                           rel="noopener noreferrer">
                            <span class="social-icon">in</span>
                            <div>
                                <strong>LinkedIn</strong>
                                <p>View my LinkedIn profile ↗</p>
                            </div>
                        </a>

                        <a class="social-link-row"
                           href="https://github.com/gogulrajendran13-stack"
                           target="_blank"
                           rel="noopener noreferrer">
                            <span class="social-icon">GH</span>
                            <div>
                                <strong>GitHub</strong>
                                <p>Explore my GitHub projects ↗</p>
                            </div>
                        </a>

                        <div class="social-link-row">
                            <span class="social-icon">↗</span>
                            <div>
                                <strong>Personal website</strong>
                                <p>Not added yet</p>
                            </div>
                        </div>
                    </div>

                    <a href="<%= contextPath %>/settings"
                       class="secondary-button social-edit-button">
                        Manage profile links
                    </a>
                </div>
            </section>

            <!-- Account management -->
            <section class="profile-section"
                     aria-labelledby="accountManagementHeading">

                <div class="section-heading">
                    <div>
                        <h2 id="accountManagementHeading">Account management</h2>
                        <p>Quick access to your account and workspace.</p>
                    </div>
                </div>

                <div class="account-action-list">
                    <a href="<%= contextPath %>/settings"
                       class="account-action">
                        <span class="action-icon">⚙</span>
                        <span class="action-text">
                            <strong>Preferences and settings</strong>
                            <span>Review the available dayWise settings.</span>
                        </span>
                        <span class="action-arrow">→</span>
                    </a>

                    <a href="<%= contextPath %>/notifications"
                       class="account-action">
                        <span class="action-icon">♧</span>
                        <span class="action-text">
                            <strong>Notifications</strong>
                            <span>Open your notification center.</span>
                        </span>
                        <span class="action-arrow">→</span>
                    </a>

                    <a href="<%= contextPath %>/dashboard"
                       class="account-action">
                        <span class="action-icon">⌂</span>
                        <span class="action-text">
                            <strong>Back to dashboard</strong>
                            <span>Return to your productivity overview.</span>
                        </span>
                        <span class="action-arrow">→</span>
                    </a>

                    <a href="<%= contextPath %>/logout"
                       class="account-action logout-action">
                        <span class="action-icon">⇥</span>
                        <span class="action-text">
                            <strong>Log out</strong>
                            <span>End your current dayWise session.</span>
                        </span>
                        <span class="action-arrow">→</span>
                    </a>
                </div>
            </section>

        </div>
        <!-- End .profile-content -->

    </main>
    <!-- IMPORTANT: main content ends here -->

</div>
<!-- IMPORTANT: sidebar and main content container ends here -->

<!-- =========================================================
     FULL-WIDTH FOOTER
     This footer is outside both .main-content and .app-container.
     It can span the complete page width, including the sidebar area.
     ========================================================= -->
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
            <h2>Workspace</h2>
            <a href="<%= contextPath %>/dashboard">Dashboard</a>
            <a href="<%= contextPath %>/tasks">My Tasks</a>
            <a href="<%= contextPath %>/projects">Projects</a>
            <a href="<%= contextPath %>/categories">Categories</a>
        </div>

        <div class="footer-column">
            <h2>Productivity</h2>
            <a href="<%= contextPath %>/goals">Goals</a>
            <a href="<%= contextPath %>/focus-sessions">Focus Sessions</a>
            <a href="<%= contextPath %>/recurring-tasks">Recurring Tasks</a>
            <a href="<%= contextPath %>/reminders">Reminders</a>
        </div>

        <div class="footer-column">
            <h2>Account</h2>
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
<!-- End full-width footer -->

<!-- Mobile sidebar interaction -->
<script>
(function () {
    const menuToggle = document.getElementById("menuToggle");
    const sidebar = document.getElementById("sidebar");

    if (!menuToggle || !sidebar) {
        return;
    }

    menuToggle.addEventListener("click", function () {
        const isOpen = sidebar.classList.toggle("sidebar-open");

        menuToggle.setAttribute("aria-expanded", String(isOpen));
        menuToggle.setAttribute(
            "aria-label",
            isOpen ? "Close navigation" : "Open navigation"
        );
    });

    document.addEventListener("keydown", function (event) {
        if (
            event.key === "Escape" &&
            sidebar.classList.contains("sidebar-open")
        ) {
            sidebar.classList.remove("sidebar-open");
            menuToggle.setAttribute("aria-expanded", "false");
            menuToggle.setAttribute("aria-label", "Open navigation");
        }
    });
})();
</script>

</body>
</html>