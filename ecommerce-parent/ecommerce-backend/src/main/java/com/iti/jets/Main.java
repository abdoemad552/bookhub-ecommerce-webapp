package com.iti.jets;

import com.iti.jets.config.JPAConfig;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;

public class Main {
    public static void main(String[] args) {
        EntityManagerFactory factory = JPAConfig.getEntityManagerFactory();
        EntityManager manager = factory.createEntityManager();
    }
}
