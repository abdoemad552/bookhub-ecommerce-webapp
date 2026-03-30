package com.iti.jets.service.generic;

import com.iti.jets.config.JPAConfig;
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
        try {
            action.run();
        } catch (Exception e) {
            LOGGER.error("Unexpected service error", e);
            throw new RuntimeException(e.getMessage());
        } finally {
            JPAConfig.closeEntityManager();
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
        try {
            return query.get();
        } catch (Exception e) {
            LOGGER.error("Unexpected service error", e);
            throw new RuntimeException(e.getMessage());
        } finally {
            JPAConfig.closeEntityManager();
        }
    }
}