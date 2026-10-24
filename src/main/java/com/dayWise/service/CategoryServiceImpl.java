
package com.dayWise.service;

import java.util.Collections;
import java.util.List;

import com.dayWise.dao.CategoryDAO;
import com.dayWise.dao.CategoryDAOImpl;
import com.dayWise.model.Category;

/**
 * Implements business rules for category management.
 */
public class CategoryServiceImpl implements CategoryService {

    private static final String DEFAULT_COLOR = "#A78BFA";

    private final CategoryDAO categoryDAO;

    public CategoryServiceImpl() {
        this(new CategoryDAOImpl());
    }

    public CategoryServiceImpl(CategoryDAO categoryDAO) {
        if (categoryDAO == null) {
            throw new IllegalArgumentException(
                    "CategoryDAO cannot be null.");
        }

        this.categoryDAO = categoryDAO;
    }

    @Override
    public boolean addCategory(long userId, String categoryName,
            String categoryColor) {

        if (userId <= 0 || categoryName == null) {
            return false;
        }

        categoryName = categoryName.trim();

        if (categoryName.isEmpty() || categoryName.length() > 80) {
            return false;
        }

        if (categoryDAO.categoryExists(userId, categoryName)) {
            return false;
        }

        String color = normalizeColor(categoryColor);

        Category category =
                new Category(userId, categoryName, color);

        return categoryDAO.addCategory(category);
    }

    @Override
    public List<Category> getCategoriesByUserId(long userId) {

        if (userId <= 0) {
            return Collections.emptyList();
        }

        List<Category> categories =
                categoryDAO.getCategoriesByUserId(userId);

        return categories != null
                ? categories : Collections.emptyList();
    }

    @Override
    public Category getCategoryById(long categoryId, long userId) {

        if (categoryId <= 0 || userId <= 0) {
            return null;
        }

        // Confirm ownership before returning a category.
        List<Category> categories =
                categoryDAO.getCategoriesByUserId(userId);

        if (categories == null) {
            return null;
        }

        for (Category category : categories) {
            if (category.getCategoryId() == categoryId) {
                return category;
            }
        }

        return null;
    }

    @Override
    public boolean updateCategory(long categoryId, long userId,
            String categoryName, String categoryColor) {

        if (categoryId <= 0 || userId <= 0
                || categoryName == null) {
            return false;
        }

        categoryName = categoryName.trim();

        if (categoryName.isEmpty() || categoryName.length() > 80) {
            return false;
        }

        Category existingCategory =
                getCategoryById(categoryId, userId);

        if (existingCategory == null) {
            return false;
        }

        Category duplicate =
                findCategoryByName(userId, categoryName);

        if (duplicate != null
                && duplicate.getCategoryId() != categoryId) {
            return false;
        }

        existingCategory.setCategoryName(categoryName);
        existingCategory.setCategoryColor(
                normalizeColor(categoryColor));

        return categoryDAO.updateCategory(existingCategory);
    }

    @Override
    public boolean deleteCategory(long categoryId, long userId) {

        if (categoryId <= 0 || userId <= 0) {
            return false;
        }

        // Check ownership before deleting.
        Category category = getCategoryById(categoryId, userId);

        if (category == null) {
            return false;
        }

        return categoryDAO.deleteCategory(categoryId, userId);
    }

    private Category findCategoryByName(long userId,
            String categoryName) {

        List<Category> categories =
                categoryDAO.getCategoriesByUserId(userId);

        if (categories == null) {
            return null;
        }

        for (Category category : categories) {
            if (category.getCategoryName() != null
                    && category.getCategoryName()
                            .equalsIgnoreCase(categoryName)) {
                return category;
            }
        }

        return null;
    }

    private String normalizeColor(String color) {

        if (color == null || color.trim().isEmpty()) {
            return DEFAULT_COLOR;
        }

        color = color.trim();

        // Accept standard six-digit hexadecimal colors only.
        if (color.matches("^#[0-9A-Fa-f]{6}$")) {
            return color.toUpperCase();
        }

        return DEFAULT_COLOR;
    }
}
