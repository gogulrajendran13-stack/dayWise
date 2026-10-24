
package com.dayWise.util;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * Utility class for securely hashing and verifying passwords.
 * Passwords are never stored as plain text.
 */
public final class PasswordUtil {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final String FORMAT = "pbkdf2_sha256";

    private static final int ITERATIONS = 210_000;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 256;

    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordUtil() {
        // Prevent creating objects of this utility class.
    }

    /**
     * Converts a raw password into a salted password hash.
     */
    public static String hashPassword(String rawPassword)
            throws GeneralSecurityException {

        if (rawPassword == null || rawPassword.isEmpty()) {
            throw new IllegalArgumentException(
                    "Password cannot be empty.");
        }

        byte[] salt = new byte[SALT_LENGTH];
        RANDOM.nextBytes(salt);

        byte[] hash = deriveHash(rawPassword.toCharArray(), salt,
                ITERATIONS);

        String saltText = Base64.getEncoder().encodeToString(salt);
        String hashText = Base64.getEncoder().encodeToString(hash);

        return FORMAT + "$" + ITERATIONS + "$"
                + saltText + "$" + hashText;
    }

    /**
     * Checks a raw password against a previously stored hash.
     */
    public static boolean verifyPassword(String rawPassword,
            String storedHash) {

        if (rawPassword == null || storedHash == null) {
            return false;
        }

        String[] parts = storedHash.split("\\$", -1);

        if (parts.length != 4 || !FORMAT.equals(parts[0])) {
            return false;
        }

        try {
            int iterations = Integer.parseInt(parts[1]);

            // Reject invalid or unexpectedly expensive hash settings.
            if (iterations < 1 || iterations > 1_000_000) {
                return false;
            }

            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expectedHash =
                    Base64.getDecoder().decode(parts[3]);

            if (salt.length < 16 || expectedHash.length != 32) {
                return false;
            }

            byte[] actualHash = deriveHash(
                    rawPassword.toCharArray(), salt, iterations);

            return MessageDigest.isEqual(expectedHash, actualHash);

        } catch (GeneralSecurityException
                | IllegalArgumentException exception) {
            return false;
        }
    }

    /**
     * Derives a cryptographic hash from the password and salt.
     */
    private static byte[] deriveHash(char[] password, byte[] salt,
            int iterations) throws GeneralSecurityException {

        PBEKeySpec specification = new PBEKeySpec(
                password, salt, iterations, KEY_LENGTH);

        try {
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance(ALGORITHM);

            return factory.generateSecret(specification).getEncoded();

        } finally {
            specification.clearPassword();
            java.util.Arrays.fill(password, '\0');
        }
    }
}
