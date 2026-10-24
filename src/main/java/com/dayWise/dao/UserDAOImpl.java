
package com.dayWise.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.dayWise.model.User;
import com.dayWise.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    // Register a new user in the database
    @Override
    public boolean registerUser(User user) {

        String sql = "INSERT INTO users "
                + "(full_name, email, password_hash, account_status) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, user.getFullName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPasswordHash());
            statement.setString(4, "ACTIVE");

            int rowsInserted = statement.executeUpdate();

            return rowsInserted > 0;

        } catch (SQLException e) {
            System.err.println("Error registering user.");
            e.printStackTrace();
            return false;
        }
    }

    // Find a user by email address
    @Override
    public User getUserByEmail(String email) {

        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapUser(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving user by email.");
            e.printStackTrace();
        }

        return null;
    }

    // Find a user by their unique database ID
    @Override
    public User getUserById(long userId) {

        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapUser(resultSet);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving user by ID.");
            e.printStackTrace();
        }

        return null;
    }

    // Update a user's name and email address
    @Override
    public boolean updateUser(User user) {

        String sql = "UPDATE users "
                + "SET full_name = ?, email = ? "
                + "WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, user.getFullName());
            statement.setString(2, user.getEmail());
            statement.setLong(3, user.getUserId());

            int rowsUpdated = statement.executeUpdate();

            return rowsUpdated > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user profile.");
            e.printStackTrace();
            return false;
        }
    }

    // Update the stored password hash
    @Override
    public boolean updatePassword(long userId, String passwordHash) {

        String sql = "UPDATE users "
                + "SET password_hash = ? "
                + "WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, passwordHash);
            statement.setLong(2, userId);

            int rowsUpdated = statement.executeUpdate();

            return rowsUpdated > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user password.");
            e.printStackTrace();
            return false;
        }
    }

    // Check whether an email address is already registered
    @Override
    public boolean emailExists(String email) {

        String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (SQLException e) {
            System.err.println("Error checking email address.");
            e.printStackTrace();
            return false;
        }
    }

    // Convert a database row into a Java User object
    private User mapUser(ResultSet resultSet) throws SQLException {

        User user = new User();

        user.setUserId(resultSet.getLong("user_id"));
        user.setFullName(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPasswordHash(resultSet.getString("password_hash"));
        user.setAccountStatus(resultSet.getString("account_status"));
        user.setCreatedAt(resultSet.getTimestamp("created_at"));
        user.setUpdatedAt(resultSet.getTimestamp("updated_at"));

        return user;
    }
}
