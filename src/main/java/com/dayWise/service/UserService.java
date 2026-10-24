
package com.dayWise.service;

import com.dayWise.model.User;

public interface UserService {

    // Register a user using their original password
    boolean registerUser(
            String fullName,
            String email,
            String rawPassword);

    // Authenticate a user using their email and password
    User loginUser(String email, String rawPassword);

    // Retrieve a user's profile
    User getUserProfile(long userId);

    // Update a user's profile information
    boolean updateUserProfile(User user);

    // Change a user's password after verifying the current password
    boolean changePassword(
            long userId,
            String currentPassword,
            String newPassword);
}
