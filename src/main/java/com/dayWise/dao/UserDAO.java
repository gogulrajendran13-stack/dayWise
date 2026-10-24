
package com.dayWise.dao;

import com.dayWise.model.User;

public interface UserDAO {

    // Register a new user
    boolean registerUser(User user);

    // Find a user using their email address
    User getUserByEmail(String email);

    // Find a user using their unique ID
    User getUserById(long userId);

    // Update a user's profile information
    boolean updateUser(User user);

    // Update a user's password hash
    boolean updatePassword(long userId, String passwordHash);

    // Check whether an email address is already registered
    boolean emailExists(String email);
}
