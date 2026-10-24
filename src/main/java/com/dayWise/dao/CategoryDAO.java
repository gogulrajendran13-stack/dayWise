
package com.dayWise.dao;

import java.util.List;

import com.dayWise.model.Category;

public interface CategoryDAO {

    // Create a category for a specific user
    boolean addCategory(Category category);

    // Retrieve all categories belonging to a user
    List<Category> getCategoriesByUserId(long userId);

    // Find a category using its unique ID
    Category getCategoryById(long categoryId);

    // Update a category's name and color
    boolean updateCategory(Category category);

    // Delete a category using its ID
    boolean deleteCategory(long categoryId, long userId);

    // Check whether a category name already exists for a user
    boolean categoryExists(long userId, String categoryName);
}
