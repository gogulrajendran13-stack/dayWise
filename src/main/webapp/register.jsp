
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
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
    <title>Create Account | dayWise</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/register.css">
</head>
<body>

<main class="register-page">

    <!-- Background decorations -->
    <div class="background-grid" aria-hidden="true"></div>
    <div class="coral-circle" aria-hidden="true"></div>
    <div class="orbit orbit-one" aria-hidden="true"></div>
    <div class="orbit orbit-two" aria-hidden="true"></div>

    <span class="floating-spark spark-one" aria-hidden="true">✦</span>
    <span class="floating-spark spark-two" aria-hidden="true">✧</span>
    <span class="floating-spark spark-three" aria-hidden="true">✦</span>

    <!-- Left branding and illustration -->
    <section class="signup-visual">

        <a class="brand" href="${pageContext.request.contextPath}/login"
           aria-label="dayWise sign in page">
            <span class="brand-icon">✓</span>
            <span class="brand-name">dayWise</span>
        </a>

        <div class="visual-caption">
            <span class="caption-dot"></span>
            A FRESH START
        </div>

        <h1>
            Make room for
            <span>your next big thing.</span>
        </h1>

        <p class="visual-description">
            Bring your tasks, goals and routines together.
            Build a rhythm that works for you, one day at a time.
        </p>

        <!-- Decorative weekly planner -->
        <div class="visual-art" aria-hidden="true">

            <div class="art-circle"></div>

            <div class="art-calendar">
                <div class="calendar-top">
                    <span></span><span></span><span></span>
                </div>

                <div class="calendar-title">YOUR WEEK</div>

                <div class="calendar-grid">
                    <span class="day-label">M</span>
                    <span class="day-label">T</span>
                    <span class="day-label">W</span>
                    <span class="day-label">T</span>
                    <span class="day-label">F</span>

                    <span class="completed">✓</span>
                    <span class="completed">✓</span>
                    <span class="active-day">✓</span>
                    <span></span>
                    <span></span>
                </div>

                <div class="calendar-progress">
                    <span></span>
                </div>

                <div class="calendar-note">One step at a time</div>
            </div>

            <!-- Clock -->
            <div class="art-clock">
                <span class="clock-hand hour-hand"></span>
                <span class="clock-hand minute-hand"></span>
                <span class="clock-center"></span>
            </div>

            <!-- Floating completed-task badge -->
            <div class="art-check">✓</div>

            <!-- Small progress indicator -->
            <div class="mini-progress">
                <span class="mini-progress-icon">↗</span>
                <span>
                    <strong>Daily progress</strong>
                    <small>Keep moving forward</small>
                </span>
            </div>

            <div class="art-sparkle">✦</div>
        </div>

        <div class="visual-footer">
            <span class="footer-line"></span>
            Plan with purpose. Progress with confidence.
        </div>
    </section>

    <!-- Registration form -->
    <section class="register-card">

        <div class="form-heading">
            <div class="form-symbol">✦</div>

            <div class="step-label">
                <span class="step-dot"></span>
                YOUR JOURNEY STARTS HERE
            </div>

            <h2>Create your account</h2>
            <p>Start building better days with dayWise.</p>
        </div>

        <% if (errorMessage != null && !errorMessage.isBlank()) { %>
            <div class="form-message" role="alert">
                <%= safeError %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register"
              method="post"
              autocomplete="on">

            <div class="form-group">
                <label for="fullName">Full name</label>
                <div class="input-shell">
                    <span class="input-icon" aria-hidden="true">♙</span>
                    <input type="text"
                           id="fullName"
                           name="fullName"
                           placeholder="Enter your full name"
                           autocomplete="name"
                           maxlength="100"
                           required>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email address</label>
                <div class="input-shell">
                    <span class="input-icon" aria-hidden="true">✉</span>
                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="you@example.com"
                           autocomplete="email"
                           maxlength="150"
                           required>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Create password</label>
                <div class="input-shell">
                    <span class="input-icon" aria-hidden="true">⌑</span>
                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="At least 8 characters"
                           autocomplete="new-password"
                           minlength="8"
                           required>
                    <button class="password-toggle"
                            type="button"
                            data-target="password"
                            aria-label="Show password"
                            aria-pressed="false">Show</button>
                </div>
                <small class="field-hint">
                    Use at least 8 characters.
                </small>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm password</label>
                <div class="input-shell">
                    <span class="input-icon" aria-hidden="true">⌑</span>
                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           placeholder="Enter your password again"
                           autocomplete="new-password"
                           minlength="8"
                           required>
                    <button class="password-toggle"
                            type="button"
                            data-target="confirmPassword"
                            aria-label="Show confirm password"
                            aria-pressed="false">Show</button>
                </div>
            </div>

            <label class="terms-row">
                <input type="checkbox"
                       name="termsAccepted"
                       value="true"
                       required>
                <span>
                    I agree to use dayWise responsibly and understand that
                    my account information will be used to provide the service.
                </span>
            </label>

            <button type="submit" class="create-button">
                <span>Create my account</span>
                <span class="button-arrow">→</span>
            </button>
        </form>

        <!-- Sign-in link appears only here, inside the card -->
        <div class="signin-prompt">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </div>

        <div class="form-bottom">
            <span class="bottom-check">✓</span>
            Your next productive day starts here.
        </div>

    </section>
</main>

<script>
    document.querySelectorAll(".password-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            const input = document.getElementById(button.dataset.target);
            const showing = input.type === "text";

            input.type = showing ? "password" : "text";
            button.textContent = showing ? "Show" : "Hide";
            button.setAttribute("aria-pressed", String(!showing));
            button.setAttribute(
                "aria-label",
                showing ? "Show password" : "Hide password"
            );
        });
    });

    const form = document.querySelector(".register-card form");
    const password = document.getElementById("password");
    const confirmPassword = document.getElementById("confirmPassword");

    form.addEventListener("submit", function (event) {
        if (password.value !== confirmPassword.value) {
            event.preventDefault();
            confirmPassword.setCustomValidity("Passwords do not match.");
            confirmPassword.reportValidity();
        } else {
            confirmPassword.setCustomValidity("");
        }
    });

    confirmPassword.addEventListener("input", function () {
        this.setCustomValidity("");
    });
</script>

</body>
</html>
