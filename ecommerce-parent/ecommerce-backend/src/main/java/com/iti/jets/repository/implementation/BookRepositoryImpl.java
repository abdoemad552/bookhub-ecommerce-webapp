package com.iti.jets.repository.implementation;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.BookRepository;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Order;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

public class BookRepositoryImpl extends BaseRepositoryImpl<Book, Long> implements BookRepository {

    @Override
    public Optional<Book> findById(Long id) {
        return executeReadOnly(em ->
                em.createQuery(
                                "SELECT DISTINCT b FROM Book b " +
                                        "LEFT JOIN FETCH b.category " +
                                        "LEFT JOIN FETCH b.bookAuthors ba " +
                                        "LEFT JOIN FETCH ba.author " +
                                        "WHERE b.id = :id",
                                getEntityClass()
                        )
                        .setParameter("id", id)
                        .getResultStream()
                        .findFirst()
        );
    }

    @Override
    public List<Book> findAll(int pageNumber, int pageSize, BookFilterDTO filter) {
        return executeReadOnly(em -> {
            CriteriaBuilder criteriaBuilder = em.getCriteriaBuilder();
            CriteriaQuery<Book> criteriaQuery = criteriaBuilder.createQuery(getEntityClass());
            Root<Book> bookRoot = criteriaQuery.from(getEntityClass());

            bookRoot.fetch("category", JoinType.LEFT);
            bookRoot.fetch("bookAuthors", JoinType.LEFT).fetch("author", JoinType.LEFT);

            List<Predicate> predicates = new ArrayList<>();

            if (filter != null) {
                if (filter.getCategory() != null && !filter.getCategory().isBlank()) {
                    Join<Object, Object> categoryJoin = bookRoot.join("category", JoinType.LEFT);
                    predicates.add(
                            criteriaBuilder.equal(
                                    criteriaBuilder.lower(categoryJoin.get("name")),
                                    filter.getCategory().trim().toLowerCase(Locale.ROOT)
                            )
                    );
                }

                if (filter.getMinPrice() > 0) {
                    predicates.add(
                            criteriaBuilder.greaterThanOrEqualTo(
                                    bookRoot.get("price"),
                                    BigDecimal.valueOf(filter.getMinPrice())
                            )
                    );
                }

                if (filter.getMaxPrice() > 0) {
                    predicates.add(
                            criteriaBuilder.lessThanOrEqualTo(
                                    bookRoot.get("price"),
                                    BigDecimal.valueOf(filter.getMaxPrice())
                            )
                    );
                }

                if (filter.getSearchQuery() != null && !filter.getSearchQuery().isBlank()) {
                    String normalizedSearchQuery = "%" + filter.getSearchQuery().trim().toLowerCase(Locale.ROOT) + "%";
                    predicates.add(
                            criteriaBuilder.or(
                                    criteriaBuilder.like(criteriaBuilder.lower(bookRoot.get("title")), normalizedSearchQuery),
                                    criteriaBuilder.like(criteriaBuilder.lower(bookRoot.get("description")), normalizedSearchQuery)
                            )
                    );
                }
            }

            List<Order> orderBy = buildOrderBy(criteriaBuilder, bookRoot, filter);

            criteriaQuery.select(bookRoot)
                    .distinct(true)
                    .orderBy(orderBy);

            if (!predicates.isEmpty()) {
                criteriaQuery.where(predicates.toArray(new Predicate[0]));
            }

            TypedQuery<Book> query = em.createQuery(criteriaQuery);

            int safePageNumber = Math.max(pageNumber, 1);
            int safePageSize = Math.max(pageSize, 1);
            query.setFirstResult((safePageNumber - 1) * safePageSize);
            query.setMaxResults(safePageSize);

            return query.getResultList();
        });
    }

    @Override
    public List<Book> findAllFeatured() {
        return executeReadOnly(em ->
                em.createQuery(
                                "SELECT DISTINCT b FROM Book b " +
                                        "LEFT JOIN FETCH b.category " +
                                        "LEFT JOIN FETCH b.bookAuthors ba " +
                                        "LEFT JOIN FETCH ba.author " +
                                        "ORDER BY COALESCE(b.averageRating, 0) DESC, COALESCE(b.soldQuantity, 0) DESC, b.title ASC",
                                getEntityClass()
                        )
                        .setMaxResults(12)
                        .getResultList()
        );
    }

    @Override
    public Optional<Book> findByIsbn(String isbn) {
        return executeReadOnly(em -> em
            .createQuery("SELECT b FROM Book b WHERE b.isbn = :isbn", Book.class)
            .setParameter("isbn", isbn)
            .getResultStream()
            .findFirst()
        );
    }

    private List<Order> buildOrderBy(CriteriaBuilder criteriaBuilder, Root<Book> bookRoot, BookFilterDTO filter) {
        String sortCriteria = filter == null || filter.getSortCriteria() == null
                ? "featured"
                : filter.getSortCriteria().trim().toLowerCase(Locale.ROOT);

        List<Order> orderBy = new ArrayList<>();

        switch (sortCriteria) {
            case "price-low-to-high" -> orderBy.add(criteriaBuilder.asc(bookRoot.get("price")));
            case "price-high-to-low" -> orderBy.add(criteriaBuilder.desc(bookRoot.get("price")));
            case "rating" -> orderBy.add(criteriaBuilder.desc(criteriaBuilder.coalesce(bookRoot.get("averageRating"), 0.0)));
            default -> {
                orderBy.add(criteriaBuilder.desc(criteriaBuilder.coalesce(bookRoot.get("averageRating"), 0.0)));
                orderBy.add(criteriaBuilder.desc(criteriaBuilder.coalesce(bookRoot.get("soldQuantity"), 0)));
            }
        }

        orderBy.add(criteriaBuilder.asc(bookRoot.get("title")));
        return orderBy;
    }
}
