
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // =====================================================
    // SECTION 01: CHECK LOGIN SESSION
    // =====================================================
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // =====================================================
    // SECTION 02: USER NAME AND DATE
    // =====================================================
    String fullName = (String) session.getAttribute("fullName");

    if (fullName == null || fullName.isBlank()) {
        fullName = "there";
    }

    String[] nameParts = fullName.trim().split("\\s+");
    String firstName = nameParts.length > 0 ? nameParts[0] : "there";

    String safeFirstName = firstName
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");

    java.time.ZoneId zone = java.time.ZoneId.of("Asia/Kolkata");
    java.time.LocalDate today = java.time.LocalDate.now(zone);
    java.time.LocalTime currentTime = java.time.LocalTime.now(zone);

    String greeting;
    if (currentTime.getHour() < 12) {
        greeting = "Good morning";
    } else if (currentTime.getHour() < 17) {
        greeting = "Good afternoon";
    } else {
        greeting = "Good evening";
    }

    String todayDate = today.format(
        java.time.format.DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy")
    );

    String footerYear = String.valueOf(today.getYear());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- SECTION 03: PAGE SETTINGS -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | dayWise</title>

    <!-- SECTION 04: DASHBOARD CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/dashboard.css">
</head>

<body>

<!-- =====================================================
     SECTION 05: APPLICATION LAYOUT
     ===================================================== -->
<div class="app-layout">

    <!-- =================================================
         SECTION 06: SIDEBAR AND LOGO
         ================================================= -->
    <aside class="sidebar" id="sidebar">

        <a class="brand"
           href="${pageContext.request.contextPath}/dashboard"
           aria-label="dayWise dashboard">
            <span class="brand-icon" aria-hidden="true">✓</span>
            <span class="brand-name">day<span>Wise</span></span>
        </a>

        <!-- SECTION 07: SIDEBAR NAVIGATION -->
        <nav class="sidebar-navigation" aria-label="Main navigation">

            <p class="nav-label">Workspace</p>

            <ul class="nav-list">
                <li>
                    <a class="nav-link active"
                       aria-current="page"
                       href="${pageContext.request.contextPath}/dashboard">
                        <span class="nav-icon" aria-hidden="true">▦</span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/tasks">
                        <span class="nav-icon" aria-hidden="true">☑</span>
                        <span>My Tasks</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/projects">
                        <span class="nav-icon" aria-hidden="true">▤</span>
                        <span>Projects</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/categories">
                        <span class="nav-icon" aria-hidden="true">◈</span>
                        <span>Categories</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/recurring-tasks">
                        <span class="nav-icon" aria-hidden="true">↻</span>
                        <span>Recurring Tasks</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/calendar">
                        <span class="nav-icon" aria-hidden="true">▦</span>
                        <span>Calendar</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/analytics">
                        <span class="nav-icon" aria-hidden="true">▥</span>
                        <span>Analytics</span>
                    </a>
                </li>
            </ul>

            <p class="nav-label">Productivity</p>

            <ul class="nav-list">
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/goals">
                        <span class="nav-icon" aria-hidden="true">◎</span>
                        <span>My Goals</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/focus-sessions">
                        <span class="nav-icon" aria-hidden="true">◷</span>
                        <span>Focus Sessions</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/reminders">
                        <span class="nav-icon" aria-hidden="true">♧</span>
                        <span>Reminders</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/notifications">
                        <span class="nav-icon" aria-hidden="true">♢</span>
                        <span>Notifications</span>
                    </a>
                </li>
            </ul>

            <p class="nav-label">Account</p>

            <ul class="nav-list">
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                        <span class="nav-icon" aria-hidden="true">♙</span>
                        <span>My Profile</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="${pageContext.request.contextPath}/settings">
                        <span class="nav-icon" aria-hidden="true">⚙</span>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>

        </nav>

        <!-- SECTION 08: SIGN OUT -->
        <div class="sidebar-bottom">
            <form class="logout-form"
                  action="${pageContext.request.contextPath}/logout"
                  method="post">
                <button class="logout-button" type="submit">
                    <span aria-hidden="true">↪</span>
                    Sign out
                </button>
            </form>
        </div>

    </aside>

    <!-- SECTION 09: MOBILE SIDEBAR OVERLAY -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- =================================================
         SECTION 10: MAIN CONTENT
         ================================================= -->
    <main class="main-content">

        <!-- SECTION 11: HEADER, BREADCRUMB, SEARCH AND PROFILE -->
        <header class="topbar">

            <div class="topbar-left">
                <button class="mobile-menu-button"
                        id="menuButton"
                        type="button"
                        aria-label="Open navigation"
                        aria-controls="sidebar"
                        aria-expanded="false">☰</button>

                <div class="breadcrumb">
                    <span>Workspace</span>
                    <span class="breadcrumb-separator">/</span>
                    <strong>Dashboard</strong>
                </div>
            </div>

            <div class="topbar-right">

                <!-- Dashboard search -->
                <label class="header-search">
                    <span class="search-symbol" aria-hidden="true">⌕</span>
                    <input type="search"
                           id="dashboardSearch"
                           placeholder="Search dashboard..."
                           aria-label="Search dashboard">
                </label>

                <!-- Notifications -->
                <a class="notification-button"
                   href="${pageContext.request.contextPath}/notifications"
                   aria-label="Open notifications">
                    <span aria-hidden="true">♧</span>
                    <span class="notification-dot" aria-hidden="true"></span>
                </a>

                <!-- User profile -->
                <a class="profile-chip"
                   href="${pageContext.request.contextPath}/profile">
                    <span class="avatar"><%= safeFirstName.substring(0, 1).toUpperCase(java.util.Locale.ROOT) %></span>
                    <span class="profile-details">
                        <strong><%= safeFirstName %></strong>
                        <span>Personal workspace</span>
                    </span>
                </a>

            </div>
        </header>

        <!-- =================================================
             SECTION 12: DASHBOARD BODY
             ================================================= -->
        <div class="dashboard-content">

            <!-- =================================================
                 SECTION 13: GREETING, TAGLINE, DATE AND TASK BUTTON
                 Date appears immediately before Create New Task.
                 ================================================= -->
            
<!-- SECTION 13: GREETING, TAGLINE, DATE AND TASK BUTTON -->
<section class="welcome-row">

    <!-- Greeting and tagline on the left -->
    <div class="welcome-copy">
        <h1>
            Have a great day,
            <span><%= safeFirstName %>!</span>
            <span class="greeting-sparkle" aria-hidden="true">✦</span>
        </h1>

        <p class="welcome-subtitle">Let's make today productive.</p>
    </div>

    <!-- Date and task button on the right, on the same row -->
    <div class="welcome-actions">
        <div class="welcome-date">
            <p class="today-date"><%= todayDate %></p>
            <p class="date-caption">Have a great day!</p>
        </div>

        <a class="primary-button"
           href="${pageContext.request.contextPath}/tasks">
            <span aria-hidden="true">＋</span>
            Create New Task
        </a>
    </div>

</section>


            <!-- SECTION 14: TODAY AT A GLANCE -->
            <section class="today-overview" aria-label="Today's shortcuts">

                <div class="today-intro">
                    <span class="today-icon" aria-hidden="true">✦</span>
                    <div>
                        <p class="mini-label">YOUR DAY</p>
                        <h2>Today at a glance</h2>
                    </div>
                </div>

                <!-- Tasks shortcut -->
                <a class="today-metric" href="${pageContext.request.contextPath}/tasks">
                    <span class="metric-icon tasks-metric" aria-hidden="true">☑</span>
                    <div>
                        <strong>Tasks</strong>
                        <span>My task list</span>
                    </div>
                    <span aria-hidden="true">↗</span>
                </a>

                <!-- Calendar shortcut -->
                <a class="today-metric" href="${pageContext.request.contextPath}/calendar">
                    <span class="metric-icon focus-metric" aria-hidden="true">▦</span>
                    <div>
                        <strong>Calendar</strong>
                        <span>Plan your day</span>
                    </div>
                    <span aria-hidden="true">↗</span>
                </a>

                <!-- Focus shortcut -->
                <a class="today-metric" href="${pageContext.request.contextPath}/focus-sessions">
                    <span class="metric-icon goals-metric" aria-hidden="true">◷</span>
                    <div>
                        <strong>Focus</strong>
                        <span>Focus sessions</span>
                    </div>
                    <span aria-hidden="true">↗</span>
                </a>

            </section>

            <!-- SECTION 15: MAIN FEATURE CARDS -->
            <section class="dashboard-section" aria-labelledby="workspaceHeading">

                <!-- "YOUR TOOLS" label removed -->
                <div class="section-heading">
                    <h2 id="workspaceHeading">Your workspace</h2>
                </div>

                <div class="quick-grid">

                    <!-- Calendar card -->
                    <a class="quick-card quick-card-tasks searchable-card"
                       href="${pageContext.request.contextPath}/calendar"
                       data-search="calendar schedule events dates planning">
                        <span class="quick-icon" aria-hidden="true">▦</span>
                        <span class="quick-card-heading">
                            <strong>Calendar</strong>
                            <span aria-hidden="true">↗</span>
                        </span>
                        <span class="quick-card-description">View and organize your schedule.</span>
                    </a>

                    <!-- Analytics card -->
                    <a class="quick-card quick-card-projects searchable-card"
                       href="${pageContext.request.contextPath}/analytics"
                       data-search="analytics graph chart activity statistics progress">
                        <span class="quick-icon" aria-hidden="true">▥</span>
                        <span class="quick-card-heading">
                            <strong>Analytics</strong>
                            <span aria-hidden="true">↗</span>
                        </span>
                        <span class="quick-card-description">Explore your productivity trends.</span>
                    </a>

                    <!-- Focus Mode card -->
                    <a class="quick-card quick-card-goals searchable-card"
                       href="${pageContext.request.contextPath}/focus-sessions"
                       data-search="focus mode timer concentration sessions">
                        <span class="quick-icon" aria-hidden="true">◷</span>
                        <span class="quick-card-heading">
                            <strong>Focus Mode</strong>
                            <span aria-hidden="true">↗</span>
                        </span>
                        <span class="quick-card-description">Start a focused work session.</span>
                    </a>

                </div>
            </section>

            <!-- SECTION 16: QUICK ACCESS -->
            <section class="dashboard-section" aria-labelledby="quickAccessHeading">

                <!-- "QUICK LINKS" label removed -->
                <div class="section-heading">
                    <h2 id="quickAccessHeading">Quick access</h2>
                </div>

                <div class="quick-access-grid">

                    <a class="access-card searchable-card"
                       href="${pageContext.request.contextPath}/projects"
                       data-search="projects workspace">
                        <span class="access-icon" aria-hidden="true">▤</span>
                        <strong>Projects</strong>
                        <span>Organize work</span>
                        <span class="access-arrow" aria-hidden="true">↗</span>
                    </a>

                    <a class="access-card searchable-card"
                       href="${pageContext.request.contextPath}/recurring-tasks"
                       data-search="recurring tasks routine repeat">
                        <span class="access-icon" aria-hidden="true">↻</span>
                        <strong>Recurring Tasks</strong>
                        <span>Build routines</span>
                        <span class="access-arrow" aria-hidden="true">↗</span>
                    </a>

                    <a class="access-card searchable-card"
                       href="${pageContext.request.contextPath}/reminders"
                       data-search="reminders notifications alerts">
                        <span class="access-icon" aria-hidden="true">♧</span>
                        <strong>Reminders</strong>
                        <span>View reminders</span>
                        <span class="access-arrow" aria-hidden="true">↗</span>
                    </a>

                    <a class="access-card searchable-card"
                       href="${pageContext.request.contextPath}/categories"
                       data-search="categories organize tasks">
                        <span class="access-icon" aria-hidden="true">◈</span>
                        <strong>Categories</strong>
                        <span>Organize tasks</span>
                        <span class="access-arrow" aria-hidden="true">↗</span>
                    </a>

                </div>
            </section>

            <!-- SECTION 17: WEEKLY ACTIVITY AND ANALYTICS -->
            <section class="dashboard-section" aria-labelledby="activityHeading">

                <!-- "YOUR PROGRESS" label removed -->
                <div class="section-heading">
                    <h2 id="activityHeading">Weekly activity</h2>
                    <a class="text-link" href="${pageContext.request.contextPath}/analytics">
                        View analytics →
                    </a>
                </div>

                <div class="analytics-grid">

                    <!-- SECTION 18: CLICKABLE WEEKLY BAR CHART -->
                    <article class="chart-card">

                        <div class="chart-card-heading">
                            <h3>Activity across the week</h3>
                            <span class="chart-badge">Weekly view</span>
                        </div>

                        <div class="chart-placeholder">
                            <div class="chart-y-labels" aria-hidden="true">
                                <span>High</span>
                                <span>Medium</span>
                                <span>Low</span>
                            </div>

                            <div class="chart-area">
                                <div class="chart-grid-line line-one"></div>
                                <div class="chart-grid-line line-two"></div>
                                <div class="chart-grid-line line-three"></div>

                                <div class="chart-bars">

                                    <button type="button" class="chart-column"
                                            data-day="Monday" data-level="Low"
                                            aria-pressed="false" aria-label="Select Monday">
                                        <span class="chart-bar bar-one"></span><span>Mon</span>
                                    </button>

                                    <button type="button" class="chart-column"
                                            data-day="Tuesday" data-level="High"
                                            aria-pressed="false" aria-label="Select Tuesday">
                                        <span class="chart-bar bar-two"></span><span>Tue</span>
                                    </button>

                                    <button type="button" class="chart-column"
                                            data-day="Wednesday" data-level="Medium"
                                            aria-pressed="false" aria-label="Select Wednesday">
                                        <span class="chart-bar bar-three"></span><span>Wed</span>
                                    </button>

                                    <button type="button" class="chart-column"
                                            data-day="Thursday" data-level="High"
                                            aria-pressed="false" aria-label="Select Thursday">
                                        <span class="chart-bar bar-four"></span><span>Thu</span>
                                    </button>

                                    <button type="button" class="chart-column"
                                            data-day="Friday" data-level="Medium"
                                            aria-pressed="false" aria-label="Select Friday">
                                        <span class="chart-bar bar-five"></span><span>Fri</span>
                                    </button>

                                    <button type="button" class="chart-column"
                                            data-day="Saturday" data-level="Low"
                                            aria-pressed="false" aria-label="Select Saturday">
                                        <span class="chart-bar bar-six"></span><span>Sat</span>
                                    </button>

                                    <button type="button" class="chart-column"
                                            data-day="Sunday" data-level="Medium"
                                            aria-pressed="false" aria-label="Select Sunday">
                                        <span class="chart-bar bar-seven"></span><span>Sun</span>
                                    </button>

                                </div>
                            </div>
                        </div>

                        <!-- Chart selection feedback -->
                        <p class="chart-selection" id="chartSelection" aria-live="polite">
                            Select a day to highlight its activity level.
                        </p>

                        <!-- Data disclaimer -->
                        <p class="chart-note">
                            Illustrative chart. Real task activity has not yet been connected to the database.
                        </p>

                    </article>

                    <!-- SECTION 19: PRODUCTIVITY SUMMARY PANEL -->
                    <article class="insight-card">

                        <div class="insight-topline">
                            <span class="insight-icon" aria-hidden="true">◷</span>
                            <span>PRODUCTIVITY SNAPSHOT</span>
                        </div>

                        <h3>Make time for what matters</h3>
                        <p class="insight-description">
                            Your productivity tools are ready when you are.
                        </p>

                        <ul class="insight-list">
                            <li><span class="insight-dot green"></span><span>Plan tasks in your calendar</span></li>
                            <li><span class="insight-dot orange"></span><span>Set aside time to focus</span></li>
                            <li><span class="insight-dot coral"></span><span>Review progress in Analytics</span></li>
                        </ul>

                        <a class="insight-link" href="${pageContext.request.contextPath}/focus-sessions">
                            Open Focus Sessions →
                        </a>

                    </article>
                </div>
            </section>

        </div>
        <!-- END SECTION 12: DASHBOARD BODY -->

    </main>
</div>

<!-- =====================================================
     SECTION 20: FULL-WIDTH FOOTER
     ===================================================== -->
<footer class="site-footer">

    <div class="footer-main">

        <!-- Footer brand -->
        <section class="footer-about">
            <a class="footer-brand" href="${pageContext.request.contextPath}/dashboard">
                <span class="footer-brand-icon" aria-hidden="true">✓</span>
                day<span>Wise</span>
            </a>
            <h2>Your day, your way.</h2>
            <p>A personal space for tasks, planning and focused work.</p>
            <p class="footer-tagline">Plan. Focus. Get Things Done.</p>
        </section>

        <!-- Footer Explore links -->
        <section class="footer-column">
            <h2>Explore</h2>
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/tasks">My Tasks</a>
            <a href="${pageContext.request.contextPath}/projects">Projects</a>
            <a href="${pageContext.request.contextPath}/calendar">Calendar</a>
        </section>

        <!-- Footer Productivity links -->
        <section class="footer-column">
            <h2>Productivity</h2>
            <a href="${pageContext.request.contextPath}/analytics">Analytics</a>
            <a href="${pageContext.request.contextPath}/focus-sessions">Focus Sessions</a>
            <a href="${pageContext.request.contextPath}/reminders">Reminders</a>
            <a href="${pageContext.request.contextPath}/categories">Categories</a>
        </section>

        <!-- Footer Account links -->
        <section class="footer-column">
            <h2>Account</h2>
            <a href="${pageContext.request.contextPath}/profile">My Profile</a>
            <a href="${pageContext.request.contextPath}/settings">Settings</a>
            <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
        </section>

    </div>

    <!-- Copyright row -->
    <div class="footer-bottom">
        <p>© <%= footerYear %> dayWise. All rights reserved.</p>
        <p>Plan. Focus. Get Things Done.</p>
    </div>
</footer>

<!-- =====================================================
     SECTION 21: JAVASCRIPT INTERACTIONS
     ===================================================== -->
<script>
(function () {

    // SECTION 21A: MOBILE SIDEBAR
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebarOverlay");
    const menuButton = document.getElementById("menuButton");

    function openMenu() {
        if (!sidebar || !overlay || !menuButton) return;

        sidebar.classList.add("open");
        overlay.classList.add("open");
        menuButton.setAttribute("aria-expanded", "true");
        menuButton.setAttribute("aria-label", "Close navigation");
    }

    function closeMenu() {
        if (!sidebar || !overlay || !menuButton) return;

        sidebar.classList.remove("open");
        overlay.classList.remove("open");
        menuButton.setAttribute("aria-expanded", "false");
        menuButton.setAttribute("aria-label", "Open navigation");
    }

    if (sidebar && overlay && menuButton) {
        menuButton.addEventListener("click", function () {
            sidebar.classList.contains("open") ? closeMenu() : openMenu();
        });

        overlay.addEventListener("click", closeMenu);

        sidebar.querySelectorAll(".nav-link").forEach(function (link) {
            link.addEventListener("click", closeMenu);
        });

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") closeMenu();
        });

        window.addEventListener("resize", function () {
            if (window.innerWidth > 700) closeMenu();
        });
    }

    // SECTION 21B: DASHBOARD SEARCH
    const searchInput = document.getElementById("dashboardSearch");
    const searchableCards = document.querySelectorAll(".searchable-card");

    if (searchInput) {
        searchInput.addEventListener("input", function () {
            const query = searchInput.value.trim().toLowerCase();

            searchableCards.forEach(function (card) {
                const searchableText = (
                    card.innerText + " " +
                    (card.getAttribute("data-search") || "")
                ).toLowerCase();

                card.hidden = query !== "" && !searchableText.includes(query);
            });
        });
    }

    // SECTION 21C: WEEKLY CHART INTERACTION
    const chartButtons = document.querySelectorAll(".chart-column");
    const chartSelection = document.getElementById("chartSelection");

    chartButtons.forEach(function (button) {
        button.addEventListener("click", function () {

            chartButtons.forEach(function (otherButton) {
                otherButton.classList.remove("selected");
                otherButton.setAttribute("aria-pressed", "false");
            });

            button.classList.add("selected");
            button.setAttribute("aria-pressed", "true");

            if (chartSelection) {
                chartSelection.textContent =
                    button.getAttribute("data-day") + " selected — " +
                    button.getAttribute("data-level") +
                    " illustrative activity. Real task data is not connected yet.";
            }
        });
    });

})();
</script>

</body>
</html>
