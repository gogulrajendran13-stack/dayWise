
package com.dayWise;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.dayWise.util.DBConnection;

public class DBConnectionTest {

    public static void main(String[] args) {

        System.out.println("Testing dayWise database connection...");

        try (Connection connection = DBConnection.getConnection()) {

            System.out.println("Connection successful!");

            try (Statement statement = connection.createStatement();
                 ResultSet resultSet =
                         statement.executeQuery("SELECT DATABASE()")) {

                if (resultSet.next()) {
                    System.out.println(
                        "Connected database: " + resultSet.getString(1)
                    );
                }
            }

        } catch (Exception e) {
            System.err.println("Database connection failed.");
            System.err.println("Reason: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
