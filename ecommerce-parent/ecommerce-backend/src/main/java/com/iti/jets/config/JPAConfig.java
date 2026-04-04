package com.iti.jets.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.HashMap;
import java.util.Map;

public class JPAConfig {

    private static volatile EntityManagerFactory emf;

    private static final ThreadLocal<EntityManager> threadLocalEM = new ThreadLocal<>();

    private JPAConfig() {
    }

    public static EntityManagerFactory getEntityManagerFactory() {
        if (emf == null) {
            synchronized (JPAConfig.class) {
                if (emf == null) {
                    try {
                        // Configure connection pooling
                        Map<String, Object> configOverrides = new HashMap<>();
                        configOverrides.put("jakarta.persistence.nonJtaDataSource", DataSourceConfig.getDataSource());

                        // Create entity manager factory
                        emf = Persistence.createEntityManagerFactory("book_hub", configOverrides);

                    } catch (Exception e) {
                        throw new RuntimeException("Failed to initialize EntityManagerFactory", e);
                    }
                }
            }
        }
        return emf;
    }

    public static EntityManager getEntityManager() {
        EntityManager em = threadLocalEM.get();
        if (em == null || !em.isOpen()) {
            em = getEntityManagerFactory().createEntityManager();
            threadLocalEM.set(em);
        }
        return em;
    }

    public static void closeEntityManager() {
        EntityManager em = threadLocalEM.get();
        try {
            if (em != null && em.isOpen()) {
                em.close();
            }
        } finally {
            threadLocalEM.remove();
        }
    }

    public static void closeEntityManagerFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
            emf = null;
        }
    }
}