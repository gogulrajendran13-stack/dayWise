
package com.dayWise.service;

import java.util.List;

import com.dayWise.model.Category;

/**
 * Defines business operations for managing user categories.
 */
public interface CategoryService {

    boolean addCategory(long userId, String categoryName,
            String categoryColor);

    List<Category> getCategoriesByUserId(long userId);

    Category getCategoryById(long categoryId, long userId);

    boolean updateCategory(long categoryId, long userId,
            String categoryName, String categoryColor);

    boolean deleteCategory(long categoryId, long userId);
}
