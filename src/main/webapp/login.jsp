
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String registered = request.getParameter("registered");
    String loggedOut = request.getParameter("logout");

    String safeError = "";
    if (errorMessage != null) {
        safeError = errorMessage
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <title>Sign In | dayWise</title>

    </head>

<body>

    <!-- ===== Navigation ===== -->
    <header class="navbar">
        <a class="brand" href="${pageContext.request.contextPath}/home">
            <span class="brand-icon">✓</span>
            <span>day<span>Wise</span></span>
        </a>

        <a class="nav-link" href="${pageContext.request.contextPath}/register">
            Create account
        </a>
    </header>

    <main class="page-container">
    
    
<!-- Productivity-themed background decorations -->
<div class="productivity-decoration decoration-tasks" aria-hidden="true">
    <span class="decoration-icon">✓</span>
    <span class="decoration-title">Tasks completed</span>
    <span class="decoration-line"></span>
    <span class="decoration-line short"></span>
</div>

<div class="productivity-decoration decoration-progress" aria-hidden="true">
    <span class="progress-ring">78%</span>
    <span class="decoration-title">Daily progress</span>
</div>

<div class="productivity-decoration decoration-focus" aria-hidden="true">
    <span class="decoration-icon">◷</span>
    <span class="decoration-title">Focus time</span>
    <span class="decoration-subtitle">Stay in the zone</span>
</div>

<div class="productivity-decoration decoration-goals" aria-hidden="true">
    <span class="decoration-icon">◎</span>
    <span class="decoration-title">Goals & routines</span>
    <span class="decoration-subtitle">Small steps matter</span>
</div>
    
    
    
<!-- LEFT CARD: Planning and organization -->
<aside class="login-side-card left-card">
    <div class="side-card-icon">✓</div>

    <h3>Your day, organized.</h3>

    <p>
        Bring your daily responsibilities together and
        make every day more productive with dayWise.
    </p>

    <ul class="side-feature-list">
        <li><span>✓</span> Manage tasks and projects</li>
        <li><span>✓</span> Set goals and recurring tasks</li>
        <li><span>✓</span> Never miss important reminders</li>
    </ul>
</aside>

<!-- RIGHT CARD: Focus and progress -->
<aside class="login-side-card right-card">
    <div class="side-card-icon">✦</div>

    <h3>Make progress daily.</h3>

    <p>
        Build better habits, protect your focus time,
        and celebrate small steps toward your goals.
    </p>

    <ul class="side-feature-list">
        <li><span>✦</span> Track focused work sessions</li>
        <li><span>✦</span> Monitor your daily progress</li>
        <li><span>✦</span> Build consistent routines</li>
    </ul>
</aside>
    

        <!-- ===== Welcome and productivity preview ===== -->
        <section class="welcome-section">
            <div class="eyebrow">
                <span class="eyebrow-dot"></span>
                YOUR DAY, YOUR WAY
            </div>

            <h1>Make every day <span>count.</span></h1>

            <p class="welcome-description">
                Bring your tasks, goals, and daily routines together.
                Build better habits, stay focused, and make meaningful
                progress one day at a time.
            </p>

            <div class="preview-card">
                <div class="preview-heading">
                    <span>Your daily focus</span>
                    <span class="today-label">A fresh start ✦</span>
                </div>

                <div class="preview-task completed-task">
                    <span class="task-check completed">✓</span>
                    <div>
                        <div class="task-name">Plan your priorities</div>
                        <div class="task-time">Start with what matters</div>
                    </div>
                </div>

                <div class="preview-task">
                    <span class="task-check"></span>
                    <div>
                        <div class="task-name">Focus on your next task</div>
                        <div class="task-time">One step at a time</div>
                    </div>
                </div>

                <div class="preview-task">
                    <span class="task-check"></span>
                    <div>
                        <div class="task-name">Make time for your goals</div>
                        <div class="task-time">Progress over perfection</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== Login form ===== -->
        <section class="login-card">
            <div class="form-heading">
                <h2>Welcome back!</h2>
                <p>Sign in to pick up where you left off.</p>
            </div>

            <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                <div class="message error-message" role="alert">
                    <%= safeError %>
                </div>
            <% } %>

            <% if ("1".equals(registered)) { %>
                <div class="message success-message" role="status">
                    Your account was created successfully. Please sign in.
                </div>
            <% } %>

            <% if ("1".equals(loggedOut)) { %>
                <div class="message success-message" role="status">
                    You have signed out successfully.
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login"
                  method="post" autocomplete="on">

                <div class="form-group">
                    <label for="email">Email address</label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="you@example.com"
                        autocomplete="email"
                        maxlength="150"
                        required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>
                </div>

                <div class="form-options">
                    <label class="remember-option">
                        <input type="checkbox" name="rememberMe" value="true">
                        Remember me
                    </label>

                    <a class="forgot-link"
                       href="${pageContext.request.contextPath}/forgot-password">
                        Forgot password?
                    </a>
                </div>

                <button class="login-button" type="submit">
                    Sign in to dayWise →
                </button>
            </form>

            <p class="register-prompt">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register">
                    Create one
                </a>
            </p>

            <div class="form-footer">
                A little progress each day adds up to big results.
            </div>
        </section>

    </main>

</body>
</html>
