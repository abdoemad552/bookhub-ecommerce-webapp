package com.iti.jets.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class JPAConfig {

    private static EntityManagerFactory emf;

    private JPAConfig() {
    }

    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (emf == null) {
            try {
                // Load properties file
                Properties props = new Properties();
                props.load(JPAConfig.class.getClassLoader()
                        .getResourceAsStream("application.properties"));

                // Configure connection pooling
                Map<String, Object> configOverrides = new HashMap<>();
                configOverrides.put("jakarta.persistence.nonJtaDataSource", DataSourceConfig.getDataSource());

                // Create entity manager factory
                emf = Persistence.createEntityManagerFactory("book_hub", configOverrides);

            } catch (Exception e) {
                throw new RuntimeException("Failed to initialize EntityManagerFactory", e);
            }
        }
        return emf;
    }

    public static EntityManager getEntityManager() {
        return getEntityManagerFactory().createEntityManager();
    }

    public static void closeEntityManagerFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}