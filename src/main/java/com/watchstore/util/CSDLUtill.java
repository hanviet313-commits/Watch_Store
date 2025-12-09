package com.watchstore.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class CSDLUtill {
    private static final String URL = "jdbc:mysql://localhost:3306/watch_store?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASS = "3333";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.out.println("Error loading MySQL JDBC Driver: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("Database connection successful");
            return conn;
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
            throw e;
        }
    }
}