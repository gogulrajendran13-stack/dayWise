
package com.dayWise.service;

import java.security.GeneralSecurityException;

import com.dayWise.dao.UserDAO;
import com.dayWise.dao.UserDAOImpl;
import com.dayWise.model.User;
import com.dayWise.util.PasswordUtil;

/**
 * Implements user-related business logic for dayWise.
 */
public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;

    /**
     * Default constructor uses the existing DAO implementation.
     */
    public UserServiceImpl() {
        this(new UserDAOImpl());
    }

    /**
     * Allows a DAO to be supplied, which is useful for testing.
     */
    public UserServiceImpl(UserDAO userDAO) {
        if (userDAO == null) {
            throw new IllegalArgumentException(
                    "UserDAO cannot be null.");
        }

        this.userDAO = userDAO;
    }

    /**
     * Registers a user after validating input and hashing the password.
     */
    @Override
    public boolean registerUser(String fullName, String email,
            String rawPassword) {

        if (fullName == null || email == null
                || rawPassword == null) {
            return false;
        }

        fullName = fullName.trim();
        email = email.trim();

        if (fullName.isEmpty() || fullName.length() > 100) {
            return false;
        }

        if (!isValidEmail(email)) {
            return false;
        }

        if (!isValidPassword(rawPassword)) {
            return false;
        }

        try {
            if (userDAO.emailExists(email)) {
                return false;
            }

            String passwordHash =
                    PasswordUtil.hashPassword(rawPassword);

            User user = new User(fullName, email, passwordHash);

            return userDAO.registerUser(user);

        } catch (GeneralSecurityException exception) {
            // Do not log or expose the raw password.
            return false;
        }
    }

    /**
     * Authenticates a user and returns the profile without its password hash.
     */
    @Override
    public User loginUser(String email, String rawPassword) {

        if (email == null || rawPassword == null
                || email.trim().isEmpty()
                || rawPassword.isEmpty()) {
            return null;
        }

        User user = userDAO.getUserByEmail(email.trim());

        if (user == null) {
            return null;
        }

        if (!"ACTIVE".equalsIgnoreCase(user.getAccountStatus())) {
            return null;
        }

        if (!PasswordUtil.verifyPassword(
                rawPassword, user.getPasswordHash())) {
            return null;
        }

        // Never pass the stored password hash to the controller or JSP.
        user.setPasswordHash(null);

        return user;
    }

    /**
     * Returns a user's profile without the password hash.
     */
    @Override
    public User getUserProfile(long userId) {

        if (userId <= 0) {
            return null;
        }

        User user = userDAO.getUserById(userId);

        if (user != null) {
            user.setPasswordHash(null);
        }

        return user;
    }

    /**
     * Updates the user's name and email after validation.
     */
    @Override
    public boolean updateUserProfile(User user) {

        if (user == null || user.getUserId() <= 0
                || user.getFullName() == null
                || user.getEmail() == null) {
            return false;
        }

        String fullName = user.getFullName().trim();
        String email = user.getEmail().trim();

        if (fullName.isEmpty() || fullName.length() > 100
                || !isValidEmail(email)) {
            return false;
        }

        User existingUser = userDAO.getUserById(user.getUserId());

        if (existingUser == null) {
            return false;
        }

        if (!email.equalsIgnoreCase(existingUser.getEmail())
                && userDAO.emailExists(email)) {
            return false;
        }

        user.setFullName(fullName);
        user.setEmail(email);

        return userDAO.updateUser(user);
    }

    /**
     * Verifies the current password before saving a new password hash.
     */
    @Override
    public boolean changePassword(long userId, String currentPassword,
            String newPassword) {

        if (userId <= 0 || currentPassword == null
                || currentPassword.isEmpty()
                || !isValidPassword(newPassword)) {
            return false;
        }

        User user = userDAO.getUserById(userId);

        if (user == null
                || !PasswordUtil.verifyPassword(
                        currentPassword, user.getPasswordHash())) {
            return false;
        }

        try {
            String newHash = PasswordUtil.hashPassword(newPassword);

            return userDAO.updatePassword(userId, newHash);

        } catch (GeneralSecurityException exception) {
            return false;
        }
    }

    /**
     * Basic email validation for the registration/profile forms.
     */
    private boolean isValidEmail(String email) {

        if (email == null || email.length() > 150) {
            return false;
        }

        return email.matches(
                "^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+"
                + "@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}"
                + "[A-Za-z0-9])?(?:\\.[A-Za-z0-9]"
                + "(?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$");
    }

    /**
     * Requires at least eight characters.
     */
    private boolean isValidPassword(String password) {

        return password != null
                && password.length() >= 8
                && password.length() <= 128;
    }
}
