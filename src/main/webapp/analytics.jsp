
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.dayWise.model.User" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Map<String, Object> analytics =
        (Map<String, Object>) request.getAttribute("analytics");

    if (analytics == null) {
        response.sendRedirect(request.getContextPath() + "/analytics");
        return;
    }

    String contextPath = request.getContextPath();

    String fullName = "User";
    Object sessionUser = session.getAttribute("user");

    if (sessionUser instanceof User) {
        User currentUser = (User) sessionUser;
        if (currentUser.getFullName() != null
                && !currentUser.getFullName().trim().isEmpty()) {
            fullName = currentUser.getFullName().trim();
        }
    } else if (session.getAttribute("fullName") != null) {
        fullName = String.valueOf(session.getAttribute("fullName"));
    }

    String initial = fullName.isEmpty()
        ? "U"
        : fullName.substring(0, 1).toUpperCase();

    int totalTasks = ((Number) analytics.get("totalTasks")).intValue();
    int completedTasks =
        ((Number) analytics.get("completedTasks")).intValue();
    int pendingTasks =
        ((Number) analytics.get("pendingTasks")).intValue();

    double completionRate =
        ((Number) analytics.get("completionRate")).doubleValue();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics | dayWise</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/analytics.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

<div class="app-layout">

    <!-- Sidebar -->
    <aside class="sidebar">

        <a class="brand" href="<%= contextPath %>/dashboard">
            <span class="brand-icon">✓</span>
            <span>dayWise</span>
        </a>

        <nav class="sidebar-nav">

            <p class="nav-label">WORKSPACE</p>
            <a class="nav-link" href="<%= contextPath %>/dashboard">
                <span class="nav-icon">▦</span> Dashboard
            </a>
            <a class="nav-link" href="<%= contextPath %>/tasks">
                <span class="nav-icon">☑</span> My Tasks
            </a>
            <a class="nav-link" href="<%= contextPath %>/projects">
                <span class="nav-icon">▤</span> Projects
            </a>
            <a class="nav-link" href="<%= contextPath %>/categories">
                <span class="nav-icon">◇</span> Categories
            </a>
            <a class="nav-link" href="<%= contextPath %>/recurring-tasks">
                <span class="nav-icon">↻</span> Recurring Tasks
            </a>

            <p class="nav-label">PRODUCTIVITY</p>
            <a class="nav-link" href="<%= contextPath %>/reminders">
                <span class="nav-icon">♧</span> Reminders
            </a>
            <a class="nav-link" href="<%= contextPath %>/notifications">
                <span class="nav-icon">♢</span> Notifications
            </a>
            <a class="nav-link" href="<%= contextPath %>/goals">
                <span class="nav-icon">◎</span> Goals
            </a>
            <a class="nav-link" href="<%= contextPath %>/focus-sessions">
                <span class="nav-icon">◷</span> Focus Sessions
            </a>
            <a class="nav-link" href="<%= contextPath %>/calendar">
                <span class="nav-icon">▦</span> Calendar
            </a>
            <a class="nav-link active"
               href="<%= contextPath %>/analytics">
                <span class="nav-icon">▥</span> Analytics
            </a>

            <p class="nav-label">ACCOUNT</p>
            <a class="nav-link" href="<%= contextPath %>/profile">
                <span class="nav-icon">♙</span> Profile
            </a>
            <a class="nav-link" href="<%= contextPath %>/settings">
                <span class="nav-icon">⚙</span> Settings
            </a>

        </nav>

        <div class="sidebar-bottom">
            <a class="nav-link logout-link"
               href="<%= contextPath %>/logout">
                <span class="nav-icon">⇥</span> Logout
            </a>
        </div>

    </aside>

    <!-- Main page -->
    <div class="page-column">

        <header class="topbar">
            <div class="breadcrumb">
                Workspace <span>/</span> <strong>Analytics</strong>
            </div>

            <div class="profile-chip">
                <div class="profile-avatar"><%= initial %></div>
                <div class="profile-details">
                    <strong><%= fullName %></strong>
                    <span>Personal workspace</span>
                </div>
            </div>
        </header>

        <main class="main-content">

            <section class="page-heading">
                <div>
                    <span class="eyebrow">YOUR PRODUCTIVITY AT A GLANCE</span>
                    <h1>Analytics</h1>
                    <p>Understand your progress and build better daily habits.</p>
                </div>
            </section>

            <!-- Summary cards -->
            <section class="stats-grid">

                <article class="stat-card">
                    <div class="stat-icon purple-icon">▦</div>
                    <p>Total tasks</p>
                    <h2><%= totalTasks %></h2>
                    <span>All your tasks</span>
                </article>

                <article class="stat-card">
                    <div class="stat-icon green-icon">✓</div>
                    <p>Completed tasks</p>
                    <h2><%= completedTasks %></h2>
                    <span>Tasks marked completed</span>
                </article>

                <article class="stat-card">
                    <div class="stat-icon amber-icon">◷</div>
                    <p>Pending tasks</p>
                    <h2><%= pendingTasks %></h2>
                    <span>To do or in progress</span>
                </article>

                <article class="stat-card">
                    <div class="stat-icon violet-icon">◎</div>
                    <p>Completion rate</p>
                    <h2><%= String.format(java.util.Locale.US, "%.1f", completionRate) %>%</h2>
                    <span>Completed out of all tasks</span>
                </article>

            </section>

            <!-- Monthly bar chart -->
            <section class="charts-grid">

                <article class="chart-card chart-wide">
                    <div class="card-heading">
                        <div>
                            <h2>Monthly Task Progress</h2>
                            <p>Completed and remaining tasks created each month</p>
                        </div>
                        <span class="chart-badge">Last 6 months</span>
                    </div>
                    <div class="chart-container chart-tall">
                        <canvas id="monthlyChart"></canvas>
                    </div>
                </article>

                <!-- Weekly line chart -->
                <article class="chart-card">
                    <div class="card-heading">
                        <div>
                            <h2>Productivity Trend</h2>
                            <p>Tasks completed each week</p>
                        </div>
                    </div>
                    <div class="chart-container">
                        <canvas id="weeklyChart"></canvas>
                    </div>
                </article>

                <!-- Doughnut chart -->
                <article class="chart-card">
                    <div class="card-heading">
                        <div>
                            <h2>Overall Progress</h2>
                            <p>Completed tasks compared with all other tasks</p>
                        </div>
                    </div>

                    <div class="chart-container">
                        <canvas id="progressChart"></canvas>
                    </div>

                    <div class="chart-footnote">
                        <span class="legend-dot purple-dot"></span>
                        Completed
                        <span class="legend-dot pale-dot"></span>
                        Remaining
                    </div>
                </article>

                <!-- Status pie chart -->
                <article class="chart-card chart-wide">
                    <div class="card-heading">
                        <div>
                            <h2>Task Status Breakdown</h2>
                            <p>See how your tasks are distributed by status</p>
                        </div>
                    </div>

                    <div class="status-chart-layout">
                        <div class="chart-container status-chart">
                            <canvas id="statusChart"></canvas>
                        </div>
                        <div class="status-explanation">
                            <div>
                                <span class="legend-dot purple-dot"></span>
                                <span>To Do</span>
                            </div>
                            <div>
                                <span class="legend-dot amber-dot"></span>
                                <span>In Progress</span>
                            </div>
                            <div>
                                <span class="legend-dot green-dot"></span>
                                <span>Completed</span>
                            </div>
                            <div>
                                <span class="legend-dot red-dot"></span>
                                <span>Cancelled</span>
                            </div>
                        </div>
                    </div>
                </article>

            </section>

            <p class="data-note">
                Analytics are calculated from the tasks in your dayWise account.
            </p>

        </main>

        

    </div>
</div>

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



<script>
    // Data supplied by AnalyticsController from the logged-in user's tasks.
    const monthlyLabels = <%= request.getAttribute("monthlyLabelsJson") %>;
    const monthlyCompleted = <%= request.getAttribute("monthlyCompletedJson") %>;
    const monthlyRemaining = <%= request.getAttribute("monthlyRemainingJson") %>;

    const weeklyLabels = <%= request.getAttribute("weeklyLabelsJson") %>;
    const weeklyCompleted = <%= request.getAttribute("weeklyCompletedJson") %>;

    const statusLabels = <%= request.getAttribute("statusLabelsJson") %>;
    const statusCounts = <%= request.getAttribute("statusCountsJson") %>;

    Chart.defaults.font.family = "Inter, Segoe UI, Arial, sans-serif";
    Chart.defaults.color = "#77718a";

    const purple = "#8064e6";
    const lightPurple = "#dcd1ff";
    const green = "#269b79";
    const amber = "#e2aa32";
    const red = "#dc706c";

    // Monthly bar chart.
    new Chart(document.getElementById("monthlyChart"), {
        type: "bar",
        data: {
            labels: monthlyLabels,
            datasets: [
                {
                    label: "Completed",
                    data: monthlyCompleted,
                    backgroundColor: purple,
                    borderRadius: 6,
                    maxBarThickness: 28
                },
                {
                    label: "Remaining",
                    data: monthlyRemaining,
                    backgroundColor: lightPurple,
                    borderRadius: 6,
                    maxBarThickness: 28
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: { mode: "index", intersect: false },
            plugins: {
                legend: {
                    position: "bottom",
                    labels: { usePointStyle: true, boxWidth: 8, padding: 18 }
                }
            },
            scales: {
                x: { grid: { display: false } },
                y: {
                    beginAtZero: true,
                    ticks: { precision: 0 },
                    grid: { color: "#f0edf7" }
                }
            }
        }
    });

    // Weekly productivity line chart.
    new Chart(document.getElementById("weeklyChart"), {
        type: "line",
        data: {
            labels: weeklyLabels,
            datasets: [{
                label: "Completed tasks",
                data: weeklyCompleted,
                borderColor: purple,
                backgroundColor: "rgba(128, 100, 230, 0.12)",
                fill: true,
                tension: 0.35,
                borderWidth: 3,
                pointRadius: 4,
                pointHoverRadius: 6,
                pointBackgroundColor: purple
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: { grid: { display: false } },
                y: {
                    beginAtZero: true,
                    ticks: { precision: 0 },
                    grid: { color: "#f0edf7" }
                }
            }
        }
    });

    // Doughnut chart for overall completion.
    new Chart(document.getElementById("progressChart"), {
        type: "doughnut",
        data: {
            labels: ["Completed", "Remaining"],
            datasets: [{
                data: [
                    <%= completedTasks %>,
                    <%= Math.max(0, totalTasks - completedTasks) %>
                ],
                backgroundColor: [purple, "#e9e2fb"],
                borderWidth: 0,
                hoverOffset: 5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: "72%",
            plugins: {
                legend: { display: false },
                tooltip: { enabled: true }
            }
        },
        plugins: [{
            id: "centerText",
            afterDraw(chart) {
                const { ctx, chartArea } = chart;
                if (!chartArea) return;

                const centerX = (chartArea.left + chartArea.right) / 2;
                const centerY = (chartArea.top + chartArea.bottom) / 2;

                ctx.save();
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.fillStyle = "#302950";
                ctx.font = "700 26px Inter, Segoe UI, Arial";
                ctx.fillText(
                    "<%= String.format(java.util.Locale.US, "%.0f", completionRate) %>%",
                    centerX,
                    centerY - 4
                );
                ctx.fillStyle = "#89829c";
                ctx.font = "12px Inter, Segoe UI, Arial";
                ctx.fillText("completed", centerX, centerY + 19);
                ctx.restore();
            }
        }]
    });

    // Pie chart for task status.
    new Chart(document.getElementById("statusChart"), {
        type: "pie",
        data: {
            labels: statusLabels,
            datasets: [{
                data: statusCounts,
                backgroundColor: [purple, amber, green, red],
                borderColor: "#ffffff",
                borderWidth: 4,
                hoverOffset: 7
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            }
        }
    });
</script>

</body>
</html>
