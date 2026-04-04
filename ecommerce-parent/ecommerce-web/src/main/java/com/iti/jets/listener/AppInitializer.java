package com.iti.jets.listener;

import com.iti.jets.config.JPAConfig;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebListener
public class AppInitializer implements ServletContextListener {

    private static final Logger LOGGER = LoggerFactory.getLogger(AppInitializer.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Creating Entity Manager Factory...");
        JPAConfig.getEntityManagerFactory();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Destroying Entity Manager Factory...");
        JPAConfig.closeEntityManagerFactory();
    }
}
