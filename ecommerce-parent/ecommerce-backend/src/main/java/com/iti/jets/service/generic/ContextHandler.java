package com.iti.jets.service.generic;

import com.iti.jets.config.JPAConfig;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.function.Supplier;

/**
 * Base service class providing a standardized execution context for service methods.
 *
 * <p>
 * The main purpose of this class is to **manage the lifecycle of the EntityManager**
 * at the service layer. By opening and closing the EntityManager per service method.
 * </p>
 */
public abstract class ContextHandler {

    private static final Logger LOGGER = LoggerFactory.getLogger(ContextHandler.class);

    /**
     * Executes a write operation within the service context.
     *
     * @param action the operation to execute
     */
    protected void executeInContext(Runnable action) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        boolean weStartedIt = !tx.isActive();
        try {
            if (weStartedIt) tx.begin();
            action.run();
            if (weStartedIt) tx.commit();
        } catch (Exception e) {
            if (weStartedIt && tx.isActive()) tx.rollback();
            LOGGER.error("Unexpected service error", e);
            throw new RuntimeException(e.getMessage());
        } finally {
            if (weStartedIt) JPAConfig.closeEntityManager();
        }
    }
    
    /**
     * Executes a read operation within the service context and returns a result.
     *
     * @param query a Supplier providing the result
     * @param <R>   the return type
     * @return the result of the query
     */
    protected <R> R executeInContext(Supplier<R> query) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        boolean weStartedIt = !tx.isActive();
        try {
            if (weStartedIt) tx.begin();
            R result = query.get();
            if (weStartedIt) tx.commit();
            return result;
        } catch (Exception e) {
            if (weStartedIt && tx.isActive()) tx.rollback();
            LOGGER.error("Unexpected service error", e);
            throw new RuntimeException(e.getMessage());
        } finally {
            if (weStartedIt) JPAConfig.closeEntityManager();
        }
    }
}