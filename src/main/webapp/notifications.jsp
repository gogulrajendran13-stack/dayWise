
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.dayWise.model.Notification" %>

<%!
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
    // Check whether the user is logged in.
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();

    // Get the logged-in user's display name.
    String fullName = (String) session.getAttribute("fullName");

    if (fullName == null || fullName.isBlank()) {
        fullName = "User";
    }

    String firstName = fullName.trim().split("\\s+")[0];
    String safeFirstName = escapeHtml(firstName);
    String firstInitial = escapeHtml(
        firstName.substring(0, 1).toUpperCase(Locale.ROOT)
    );

    // Get notifications supplied by the controller.
    List<Notification> notifications =
        (List<Notification>) request.getAttribute("notifications");

    if (notifications == null) {
        notifications = java.util.Collections.emptyList();
    }

    int unreadCount = 0;

    for (Notification notification : notifications) {
        if (!notification.isRead()) {
            unreadCount++;
        }
    }

    java.time.format.DateTimeFormatter dateTimeFormatter =
        java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Notifications | dayWise</title>

    <!-- Notifications page stylesheet -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/notifications.css">
</head>

<body>

<!-- =====================================================
     MAIN APP LAYOUT
     Sidebar and main content are inside this container.
     The shared footer is outside this container.
     ===================================================== -->
<div class="app-layout">

    <!-- ================= SIDEBAR ================= -->
    <aside class="sidebar" id="sidebar">

        <!-- Brand -->
        <a class="brand" href="<%= contextPath %>/dashboard">
            <span class="brand-icon">✓</span>
            <span class="brand-name">dayWise</span>
        </a>

        <!-- Sidebar navigation -->
        <nav class="sidebar-nav" aria-label="Main navigation">

            <!-- Workspace section -->
            <p class="nav-label">WORKSPACE</p>

            <a class="nav-link"
               href="<%= contextPath %>/dashboard">
                <span class="nav-icon">⌂</span>
                <span>Dashboard</span>
            </a>

            <a class="nav-link"
               href="<%= contextPath %>/tasks">
                <span class="nav-icon">▤</span>
                <span>My Tasks</span>
            </a>

            <a class="nav-link"
               href="<%= contextPath %>/projects">
                <span class="nav-icon">▦</span>
                <span>Projects</span>
            </a>

            <a class="nav-link"
               href="<%= contextPath %>/categories">
                <span class="nav-icon">◇</span>
                <span>Categories</span>
            </a>

            <!-- Productivity section -->
            <p class="nav-label">PRODUCTIVITY</p>

            <a class="nav-link"
               href="<%= contextPath %>/recurring-tasks">
                <span class="nav-icon">↻</span>
                <span>Recurring Tasks</span>
            </a>

            <a class="nav-link"
               href="<%= contextPath %>/reminders">
                <span class="nav-icon">◷</span>
                <span>Reminders</span>
            </a>

            <a class="nav-link active"
               href="<%= contextPath %>/notifications"
               aria-current="page">
                <span class="nav-icon">♧</span>
                <span>Notifications</span>

                <% if (unreadCount > 0) { %>
                    <span class="nav-count"><%= unreadCount %></span>
                <% } %>
            </a>

            <a class="nav-link"
               href="<%= contextPath %>/goals">
                <span class="nav-icon">◎</span>
                <span>Goals</span>
            </a>

            <a class="nav-link"
               href="<%= contextPath %>/focus-sessions">
                <span class="nav-icon">◷</span>
                <span>Focus Sessions</span>
            </a>

            <!-- Account section -->
            <p class="nav-label">ACCOUNT</p>

            <a class="nav-link"
               href="<%= contextPath %>/profile">
                <span class="nav-icon">♙</span>
                <span>Profile</span>
            </a>

            <a class="nav-link"
               href="<%= contextPath %>/user-settings">
                <span class="nav-icon">⚙</span>
                <span>Settings</span>
            </a>

        </nav>

        <!-- Sidebar logout -->
        <div class="sidebar-bottom">
            <form action="<%= contextPath %>/logout"
                  method="post"
                  class="logout-form">

                <button type="submit" class="logout-button">
                    <span class="nav-icon">⇥</span>
                    <span>Logout</span>
                </button>

            </form>
        </div>

    </aside>
    <!-- =============== END SIDEBAR =============== -->


    <!-- Mobile sidebar overlay -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>


    <!-- ============== MAIN PAGE COLUMN ============== -->
    <div class="page-column">

        <main class="main-content">

            <!-- Topbar -->
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
                        <span class="breadcrumb-divider">/</span>
                        <strong>Notifications</strong>
                    </div>

                </div>

                <!-- Logged-in user profile -->
                
<!-- Logged-in user profile: replace the old "Stay on track" section -->
<a class="profile-chip"
   href="<%= contextPath %>/profile">

    <span class="avatar"><%= firstInitial %></span>

    <span class="profile-details">
        <span class="profile-name"><%= safeFirstName %></span>
        <span class="profile-label">Personal workspace</span>
    </span>

</a>


            </header>
            <!-- End topbar -->


            <!-- Page content -->
            <div class="page-content">

                <!-- Page heading -->
                <section class="page-heading">

                    <div>
                        <p class="eyebrow">YOUR UPDATES</p>

                        <h1>Notifications</h1>

                        <p class="page-description">
                            Keep track of important updates and task activity.
                        </p>
                    </div>

                    <div class="notification-summary">
                        <span class="summary-label">
                            Unread notifications
                        </span>

                        <strong class="summary-number">
                            <%= unreadCount %>
                        </strong>
                    </div>

                </section>


                <!-- Notification toolbar -->
                <section class="notification-toolbar">

                    <div class="toolbar-heading">
                        <h2>All notifications</h2>

                        <span class="notification-total">
                            <%= notifications.size() %> total
                        </span>
                    </div>

                    <form action="<%= contextPath %>/notifications"
                          method="post"
                          class="notification-action-form">

                        <input type="hidden"
                               name="action"
                               value="markAllRead">

                        <button type="submit"
                                class="secondary-button"
                                <%= unreadCount == 0 ? "disabled" : "" %>>
                            Mark all as read
                        </button>

                    </form>

                </section>


                <!-- Success feedback -->
                <% if ("success".equals(request.getParameter("status"))) { %>

                    <div class="feedback-message success-message"
                         role="status">
                        Notification action completed successfully.
                    </div>

                <% } %>


                <!-- Error feedback -->
                <% if ("error".equals(request.getParameter("status"))) { %>

                    <div class="feedback-message error-message"
                         role="alert">
                        We couldn't complete that action. Please try again.
                    </div>

                <% } %>


                <!-- Notifications list -->
                <section class="notification-list"
                         aria-label="Your notifications">

                    <% if (notifications.isEmpty()) { %>

                        <!-- Empty state -->
                        <div class="empty-state">

                            <div class="empty-state-icon">♧</div>

                            <h2>You're all caught up!</h2>

                            <p>
                                When something important happens, your
                                notifications will appear here.
                            </p>

                            <a href="<%= contextPath %>/dashboard"
                               class="primary-button">
                                Back to dashboard
                            </a>

                        </div>

                    <% } else { %>

                        <!-- Display each notification -->
                        <% for (Notification notification : notifications) {

                            String title = notification.getTitle() == null
                                ? "Notification"
                                : notification.getTitle();

                            String message = notification.getMessage() == null
                                ? ""
                                : notification.getMessage();

                            String type = notification.getNotificationType() == null
                                ? "GENERAL"
                                : notification.getNotificationType()
                                    .replace('_', ' ');

                            Timestamp createdAt = notification.getCreatedAt();

                            boolean isRead = notification.isRead();

                        %>

                            <article class="notification-card <%= isRead ? "is-read" : "is-unread" %>">

                                <!-- Notification icon -->
                                <div class="notification-icon">

                                    <% if (notification.getNotificationType() != null
                                            && notification.getNotificationType()
                                                .toUpperCase(Locale.ROOT)
                                                .contains("REMINDER")) { %>

                                        ◷

                                    <% } else { %>

                                        ♧

                                    <% } %>

                                </div>


                                <!-- Notification details -->
                                <div class="notification-content">

                                    <div class="notification-title-row">

                                        <h3><%= escapeHtml(title) %></h3>

                                        <% if (!isRead) { %>
                                            <span class="unread-indicator">
                                                New
                                            </span>
                                        <% } %>

                                    </div>

                                    <p class="notification-message"><%= escapeHtml(message) %></p>

                                    <div class="notification-meta">

                                        <span class="notification-type">
                                            <%= escapeHtml(type) %>
                                        </span>

                                        <% if (createdAt != null) { %>

                                            <span class="notification-time">
                                                <%= createdAt.toLocalDateTime()
                                                    .format(dateTimeFormatter) %>
                                            </span>

                                        <% } %>

                                        <% if (notification.getTaskId() != null) { %>

                                            <span class="related-task">
                                                Task #<%= notification.getTaskId() %>
                                            </span>

                                        <% } %>

                                    </div>

                                </div>


                                <!-- Notification actions -->
                                <div class="notification-actions">

                                    <% if (!isRead) { %>

                                        <form action="<%= contextPath %>/notifications"
                                              method="post">

                                            <input type="hidden"
                                                   name="action"
                                                   value="markRead">

                                            <input type="hidden"
                                                   name="notificationId"
                                                   value="<%= notification.getNotificationId() %>">

                                            <button type="submit"
                                                    class="text-button">
                                                Mark as read
                                            </button>

                                        </form>

                                    <% } %>


                                    <form action="<%= contextPath %>/notifications"
                                          method="post"
                                          onsubmit="return confirm('Delete this notification?');">

                                        <input type="hidden"
                                               name="action"
                                               value="delete">

                                        <input type="hidden"
                                               name="notificationId"
                                               value="<%= notification.getNotificationId() %>">

                                        <button type="submit"
                                                class="delete-button">
                                            Delete
                                        </button>

                                    </form>

                                </div>

                            </article>

                        <% } %>

                    <% } %>

                </section>
                <!-- End notification list -->

            </div>
            <!-- End page-content -->

        </main>

    </div>
    <!-- ============ END MAIN PAGE COLUMN ============ -->

</div>
<!-- ============== END APP LAYOUT ============== -->


<!-- =====================================================
     SHARED FOOTER
     This footer is outside app-layout, so it spans
     the full width of the page, including beneath sidebar.
     ===================================================== -->
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
                Organize tasks, plan projects, build routines, and make
                focused progress throughout your day.
            </p>

            <p class="footer-tagline">
                Make every day count.
            </p>

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
            <a href="<%= contextPath %>/user-settings">Settings</a>
            <a href="<%= contextPath %>/notifications">Notifications</a>
            <a href="<%= contextPath %>/logout">Logout</a>

        </div>

    </div>


    <div class="footer-bottom">

        <p>
            &copy; <%= java.time.Year.now().getValue() %>
            dayWise. All rights reserved.
        </p>

        <p>
            Plan mindfully. Focus deeply. Make progress.
        </p>

    </div>

</footer>
<!-- ============== END SHARED FOOTER ============== -->


<!-- Mobile sidebar interaction -->
<script>
(function () {

    const menuToggle = document.getElementById("menuToggle");
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebarOverlay");

    if (!menuToggle || !sidebar || !overlay) {
        return;
    }

    function closeSidebar() {
        sidebar.classList.remove("sidebar-open");
        overlay.classList.remove("overlay-open");

        menuToggle.setAttribute("aria-expanded", "false");
        menuToggle.setAttribute("aria-label", "Open navigation");
    }

    menuToggle.addEventListener("click", function () {

        const isOpen = sidebar.classList.toggle("sidebar-open");

        overlay.classList.toggle("overlay-open", isOpen);

        menuToggle.setAttribute("aria-expanded", String(isOpen));

        menuToggle.setAttribute(
            "aria-label",
            isOpen ? "Close navigation" : "Open navigation"
        );

    });

    overlay.addEventListener("click", closeSidebar);

    document.querySelectorAll(".sidebar .nav-link").forEach(function (link) {
        link.addEventListener("click", closeSidebar);
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeSidebar();
        }
    });

    window.addEventListener("resize", function () {
        if (window.innerWidth > 900) {
            closeSidebar();
        }
    });

})();
</script>

</body>
</html>
