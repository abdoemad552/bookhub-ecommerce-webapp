package com.iti.jets.repository.implementation;

import com.iti.jets.config.JPAConfig;
import com.iti.jets.model.dto.response.InventoryStatusDTO;
import com.iti.jets.model.dto.response.TopCategoryDTO;
import com.iti.jets.model.dto.response.UserRoleStatsDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Category;
import com.iti.jets.repository.interfaces.StatsRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Tuple;
import jakarta.persistence.criteria.*;

import java.math.BigDecimal;
import java.util.List;

public class StatsRepositoryImpl implements StatsRepository {

    @Override
    public BigDecimal getTotalRevenue() {
        EntityManager em = JPAConfig.getEntityManager();
        return em.createQuery("""
            SELECT COALESCE(SUM(o.totalPrice), 0)
            FROM Order o
            """
            , BigDecimal.class).getSingleResult();
    }

    @Override
    public long getOrdersCount() {
        EntityManager em = JPAConfig.getEntityManager();
        return em.createQuery("""
            SELECT COUNT(o)
            FROM Order o
            """
            , Long.class).getSingleResult();
    }

    @Override
    public long getBooksCount() {
        EntityManager em = JPAConfig.getEntityManager();
        return em.createQuery("""
            SELECT COUNT(b)
            FROM Book b
            """
            , Long.class).getSingleResult();
    }

    @Override
    public List<TopCategoryDTO> getTopCategories() {
        EntityManager em = JPAConfig.getEntityManager();
        CriteriaBuilder cb = em.getCriteriaBuilder();

        CriteriaQuery<Tuple> cq = cb.createTupleQuery();

        Root<Book> book = cq.from(Book.class);
        Join<Book, Category> category = book.join("category");

        Expression<Long> countExp = cb.count(book);

        cq.multiselect(
            category.get("name").alias("name"),
            countExp.alias("count")
        );

        cq.groupBy(category.get("name"));
        cq.orderBy(cb.desc(countExp));

        List<Tuple> categoryCounts = em.createQuery(cq).getResultList();

        long total = categoryCounts.stream()
            .mapToLong(t -> t.get("count", Long.class))
            .sum();

        return categoryCounts.stream()
            .map(t -> new TopCategoryDTO(
                t.get("name", String.class),
                t.get("count", Long.class) * 100.0 / total
            ))
            .toList();
    }

    @Override
    public UserRoleStatsDTO getUserRoleStats() {
        EntityManager em = JPAConfig.getEntityManager();
        return em.createQuery("""
            SELECT new com.iti.jets.model.dto.response.UserRoleStatsDTO(
            SUM(CASE WHEN u.role = 'ADMIN' THEN 1 ELSE 0 END),
            SUM(CASE WHEN u.role = 'USER' THEN 1 ELSE 0 END)
            )
            FROM User u
            """
        , UserRoleStatsDTO.class).getSingleResult();
    }

    @Override
    public InventoryStatusDTO getInventoryStats() {
        EntityManager em = JPAConfig.getEntityManager();
        return em.createQuery("""
            SELECT new com.iti.jets.model.dto.response.InventoryStatusDTO(
                SUM(CASE WHEN b.stockQuantity > 10 THEN 1 ELSE 0 END),
                SUM(CASE WHEN b.soldQuantity BETWEEN 1 AND 10 THEN 1 ELSE 0 END),
                SUM(CASE WHEN b.stockQuantity = 0 THEN 1 ELSE 0 END)
            )
            FROM Book b
            """
        , InventoryStatusDTO.class).getSingleResult();
    }
}
