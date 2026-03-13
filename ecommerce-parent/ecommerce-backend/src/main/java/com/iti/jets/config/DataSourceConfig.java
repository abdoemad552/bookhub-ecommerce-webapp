package com.iti.jets.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.util.Properties;

public class DataSourceConfig {

    private static final HikariDataSource dataSource;

    static {
        try {
            // Load properties file
            Properties props = new Properties();
            props.load(DataSourceConfig.class.getClassLoader()
                    .getResourceAsStream("application.properties"));

            // Configure HikariCP
            HikariConfig hikariConfig = new HikariConfig();
            hikariConfig.setDriverClassName("com.mysql.cj.jdbc.Driver");
            hikariConfig.setJdbcUrl(props.getProperty("db.url"));
            hikariConfig.setUsername(props.getProperty("db.username"));
            hikariConfig.setPassword(props.getProperty("db.password"));

            hikariConfig.setMaximumPoolSize(20);
            hikariConfig.setMinimumIdle(5);
            hikariConfig.setIdleTimeout(300000);
            hikariConfig.setPoolName("BookHubPool");

            dataSource = new HikariDataSource(hikariConfig);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private DataSourceConfig() {
    }

    public static HikariDataSource getDataSource() {
        return dataSource;
    }

    public static void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
