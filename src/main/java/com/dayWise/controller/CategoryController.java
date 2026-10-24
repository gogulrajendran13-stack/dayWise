
package com.dayWise.controller;

import java.io.IOException;
import java.util.List;

import com.dayWise.model.Category;
import com.dayWise.service.CategoryService;
import com.dayWise.service.CategoryServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/categories")
public class CategoryController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        categoryService = new CategoryServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long userId = getUserId(request);

        if (userId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        List<Category> categories =
                categoryService.getCategoriesByUserId(userId);

        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/categories.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Long userId = getUserId(request);

        if (userId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            redirect(request, response, "invalidAction");
            return;
        }

        try {
            boolean success;

            switch (action) {
                case "add":
                    success = addCategory(request, userId);
                    break;

                case "update":
                    success = updateCategory(request, userId);
                    break;

                case "delete":
                    success = deleteCategory(request, userId);
                    break;

                default:
                    redirect(request, response, "invalidAction");
                    return;
            }

            redirect(request, response,
                    success ? "success" : "failed");

        } catch (RuntimeException exception) {
            getServletContext().log(
                    "Category operation failed.", exception);

            redirect(request, response, "failed");
        }
    }

    private boolean addCategory(
            HttpServletRequest request, long userId) {

        String name = request.getParameter("categoryName");
        String color = request.getParameter("categoryColor");

        if (isBlank(name)) {
            return false;
        }

        if (isBlank(color)) {
            color = "#A78BFA";
        }

        return categoryService.addCategory(
                userId, name.trim(), color.trim());
    }

    private boolean updateCategory(
            HttpServletRequest request, long userId) {

        Long categoryId = parsePositiveLong(
                request.getParameter("categoryId"));

        String name = request.getParameter("categoryName");
        String color = request.getParameter("categoryColor");

        if (categoryId == null || isBlank(name)) {
            return false;
        }

        // Verify ownership before updating.
        Category existingCategory =
                categoryService.getCategoryById(
                        categoryId, userId);

        if (existingCategory == null) {
            return false;
        }

        if (isBlank(color)) {
            color = existingCategory.getCategoryColor();
        }

        return categoryService.updateCategory(
                categoryId, userId, name.trim(), color.trim());
    }

    private boolean deleteCategory(
            HttpServletRequest request, long userId) {

        Long categoryId = parsePositiveLong(
                request.getParameter("categoryId"));

        if (categoryId == null) {
            return false;
        }

        return categoryService.deleteCategory(
                categoryId, userId);
    }

    private Long getUserId(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object value = session.getAttribute("userId");

        if (!(value instanceof Number)) {
            return null;
        }

        long userId = ((Number) value).longValue();

        return userId > 0 ? userId : null;
    }

    private Long parsePositiveLong(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            long number = Long.parseLong(value.trim());
            return number > 0 ? number : null;
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void redirect(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/categories?message=" + message);
    }
}
