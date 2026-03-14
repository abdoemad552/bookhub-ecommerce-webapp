package com.iti.jets.listener;

import com.iti.jets.config.DataSourceConfig;
import com.iti.jets.config.JPAConfig;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

public class ApplicationStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Creating EntityManagerFactory...");
        JPAConfig.getEntityManagerFactory();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Destroying EntityManagerFactory...");
        JPAConfig.closeEntityManagerFactory();
    }
}
