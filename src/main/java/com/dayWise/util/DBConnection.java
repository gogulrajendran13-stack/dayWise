
package com.dayWise.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBConnection {

    private static final String CONFIG_FILE = "db.properties";

    private DBConnection() {
        // Prevent object creation for this utility class.
    }

    public static Connection getConnection() throws SQLException {

        Properties properties = new Properties();

        try (InputStream input = DBConnection.class
                .getClassLoader()
                .getResourceAsStream(CONFIG_FILE)) {

            if (input == null) {
                throw new SQLException(
                    "db.properties was not found in src/main/resources."
                );
            }

            properties.load(input);

        } catch (IOException e) {
            throw new SQLException(
                "Unable to read database configuration.", e
            );
        }

        String driver = properties.getProperty("db.driver");
        String url = properties.getProperty("db.url");
        String username = properties.getProperty("db.username");
        String password = properties.getProperty("db.password");

        if (isBlank(driver) || isBlank(url)
                || isBlank(username) || password == null) {
            throw new SQLException(
                "Database settings are incomplete. Check db.properties."
            );
        }

        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC driver is missing. Check Maven Dependencies.", e
            );
        }

        return DriverManager.getConnection(url, username, password);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
