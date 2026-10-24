
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dayWise.model.Category;
import com.dayWise.util.DBConnection;

public class CategoryDAOImpl implements CategoryDAO {

    // Add a new category for a user
    @Override
    public boolean addCategory(Category category) {

        String sql = "INSERT INTO categories "
                + "(user_id, category_name, category_color) "
                + "VALUES (?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, category.getUserId());
            statement.setString(2, category.getCategoryName());
            statement.setString(3, category.getCategoryColor());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error adding category.");
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve all categories belonging to a user
    @Override
    public List<Category> getCategoriesByUserId(long userId) {

        List<Category> categories = new ArrayList<>();

        String sql = "SELECT * FROM categories "
                + "WHERE user_id = ? ORDER BY category_name";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    categories.add(mapCategory(resultSet));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving categories.");
            e.printStackTrace();
        }

        return categories;
    }

    // Retrieve one category by its ID
    @Override
    public Category getCategoryById(long categoryId) {

        String sql = "SELECT * FROM categories WHERE category_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, categoryId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapCategory(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving category by ID.");
            e.printStackTrace();
        }

        return null;
    }

    // Update a category's name and color
    @Override
    public boolean updateCategory(Category category) {

        String sql = "UPDATE categories "
                + "SET category_name = ?, category_color = ? "
                + "WHERE category_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, category.getCategoryName());
            statement.setString(2, category.getCategoryColor());
            statement.setLong(3, category.getCategoryId());
            statement.setLong(4, category.getUserId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating category.");
            e.printStackTrace();
            return false;
        }
    }

    // Delete a category only if it belongs to the specified user
    @Override
    public boolean deleteCategory(long categoryId, long userId) {

        String sql = "DELETE FROM categories "
                + "WHERE category_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, categoryId);
            statement.setLong(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting category.");
            e.printStackTrace();
            return false;
        }
    }

    // Check whether a category name already exists for a user
    @Override
    public boolean categoryExists(long userId, String categoryName) {

        String sql = "SELECT 1 FROM categories "
                + "WHERE user_id = ? AND category_name = ? LIMIT 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);
            statement.setString(2, categoryName);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (SQLException e) {
            System.err.println("Error checking category.");
            e.printStackTrace();
            return false;
        }
    }

    // Convert a database row into a Category object
    private Category mapCategory(ResultSet resultSet)
            throws SQLException {

        Category category = new Category();

        category.setCategoryId(resultSet.getLong("category_id"));
        category.setUserId(resultSet.getLong("user_id"));
        category.setCategoryName(
                resultSet.getString("category_name"));
        category.setCategoryColor(
                resultSet.getString("category_color"));
        category.setCreatedAt(
                resultSet.getTimestamp("created_at"));

        return category;
    }
}
