package com.iti.jets.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class responsible for hashing and verifying passwords.
 * <p>
 * This class MUST be used only on the server side.
 * Plain-text passwords must never be stored or logged.
 */
public final class PasswordHasher {

    /** BCrypt work factor (cost) */
    private static final int WORK_FACTOR = 12;

    // Prevent instantiation
    private PasswordHasher() {
        throw new UnsupportedOperationException("Utility class");
    }

    /**
     * Hashes a plain-text password using BCrypt.
     *
     * @param plainPassword the raw password
     * @return Bcrypt hash
     * @throws IllegalArgumentException if password is null or blank
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isBlank()) {
            throw new IllegalArgumentException("Password must not be null or blank");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORK_FACTOR));
    }

    /**
     * Verifies a plain-text password against a stored BCrypt hash.
     *
     * @param plainPassword the raw password provided by the user
     * @param hashedPassword the stored Bcrypt hash
     * @return true if password matches, false otherwise
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || plainPassword.isBlank()) {
            return false;
        }
        if (hashedPassword == null || hashedPassword.isBlank()) {
            return false;
        }

        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}