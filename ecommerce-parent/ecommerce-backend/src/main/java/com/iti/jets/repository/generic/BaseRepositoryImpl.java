package com.iti.jets.repository.generic;

import com.iti.jets.config.JPAConfig;
import com.iti.jets.exception.RepositoryException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.ParameterizedType;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;

public class BaseRepositoryImpl<T, ID> implements BaseRepository<T, ID> {

    private static final Logger LOGGER = LoggerFactory.getLogger(BaseRepositoryImpl.class);
    private final Class<T> entityClass;

    @SuppressWarnings("unchecked")
    protected BaseRepositoryImpl() {
        this.entityClass = (Class<T>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[0];
    }

    // Generic method for write operations (save, update, delete)
    protected <R> R executeInTransaction(Function<EntityManager, R> action) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // Begin only if not already active
            if (!tx.isActive()) {
                tx.begin();
            }

            R result = action.apply(em);
            tx.commit();
            return result;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RepositoryException("Transaction failed for " + entityClass.getSimpleName(), e);
        }
    }

    // Generic method for read-only operations
    protected <R> R executeReadOnly(Function<EntityManager, R> action) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return action.apply(em);
        } catch (Exception e) {
            throw new RepositoryException("Read operation failed for " + entityClass.getSimpleName(), e);
        }
    }

    @Override
    public T save(T entity) {
        return executeInTransaction(em -> {
            em.persist(entity);
            em.flush();
            return entity;
        });
    }

    @Override
    public T update(T entity) {
        return executeInTransaction(em -> {
            T merged = em.merge(entity);
            em.flush();
            return merged;
        });
    }

    @Override
    public Optional<T> findById(ID id) {
        return executeReadOnly(em ->
                Optional.ofNullable(em.find(entityClass, id))
        );
    }

    @Override
    public List<T> findAll() {
        return executeReadOnly(em -> {
            String jpql = "SELECT e FROM " + entityClass.getSimpleName() + " e";
            TypedQuery<T> query = em.createQuery(jpql, entityClass);

            return query.getResultList();
        });
    }

    @Override
    public List<T> findAll(int pageNumber, int pageSize) {
        return executeReadOnly(em -> {
            String jpql = "SELECT e FROM " + entityClass.getSimpleName() + " e";
            TypedQuery<T> query = em.createQuery(jpql, entityClass);

            // Calculate the offset (starts from 1)
            int offset = (pageNumber - 1) * pageSize;
            query.setFirstResult(offset);
            query.setMaxResults(pageSize);

            return query.getResultList();
        });
    }

    @Override
    public void delete(T entity) {
        executeInTransaction(em -> {
            T managedEntity = em.contains(entity) ? entity : em.merge(entity);
            em.remove(managedEntity);

            return null;
        });
    }

    @Override
    public void deleteById(ID id) {
        executeInTransaction(em -> {
            T entity = em.find(entityClass, id);
            if (em.contains(entity)) {
                em.remove(entity);
            } else {
                LOGGER.warn("DeleteById — entity not found with ID: {}", id);
            }
            return null;
        });
    }

    @Override
    public long count() {
        return executeReadOnly(em -> {
            String jpql = "SELECT COUNT(e) FROM " + entityClass.getSimpleName() + " e";
            return em.createQuery(jpql, Long.class).getSingleResult();
        });
    }

    @Override
    public boolean existsById(ID id) {
        return findById(id).isPresent();
    }

    protected Class<T> getEntityClass() {
        return entityClass;
    }
}