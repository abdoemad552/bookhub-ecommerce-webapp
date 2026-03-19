package com.iti.jets.repository.implementation;

import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Cart;
import com.iti.jets.model.entity.CartItem;
import com.iti.jets.model.entity.User;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.CartRepository;
import jakarta.persistence.EntityManager;

import java.math.BigDecimal;
import java.util.Optional;

public class CartRepositoryImpl extends BaseRepositoryImpl<Cart, Long> implements CartRepository {

    @Override
    public Optional<Cart> findById(Long id) {
        return executeReadOnly(em ->
                em.createQuery(
                                "SELECT DISTINCT c FROM Cart c " +
                                        "LEFT JOIN FETCH c.user " +
                                        "LEFT JOIN FETCH c.items i " +
                                        "LEFT JOIN FETCH i.book " +
                                        "LEFT JOIN FETCH i.book.bookAuthors ba " +
                                        "LEFT JOIN FETCH ba.author " +
                                        "WHERE c.id = :id",
                                getEntityClass()
                        )
                        .setParameter("id", id)
                        .getResultStream()
                        .findFirst()
        );
    }

    @Override
    public int getItemsCount(Integer userId) {
        if (userId == null) {
            return 0;
        }

        Long itemsCount = executeReadOnly(em ->
                em.createQuery(
                                "SELECT COALESCE(SUM(ci.quantity), 0) " +
                                        "FROM CartItem ci " +
                                        "JOIN ci.cart c " +
                                        "WHERE c.user.id = :userId",
                                Long.class
                        )
                        .setParameter("userId", Long.valueOf(userId))
                        .getSingleResult()
        );

        return itemsCount.intValue();
    }

    @Override
    public Optional<Cart> findByUserId(Integer userId) {
        return executeReadOnly(em -> findManagedCartByUserId(em, userId));
    }

    @Override
    public boolean addToCart(Integer userId, Integer bookId) {
        return addToCart(userId, bookId, 1);
    }

    @Override
    public boolean addToCart(Integer userId, Integer bookId, Integer quantity) {
        if (userId == null || bookId == null) {
            return false;
        }

        return executeInTransaction(em -> {
            int safeQuantity = quantity == null || quantity <= 0 ? 1 : quantity;

            User user = em.find(User.class, Long.valueOf(userId));
            Book book = em.find(Book.class, Long.valueOf(bookId));

            if (user == null || book == null) {
                return false;
            }

            Cart cart = findManagedCartByUserId(em, userId)
                    .orElseGet(() -> createCart(em, user));

            CartItem existingItem = cart.getItems()
                    .stream()
                    .filter(item -> item.getBook().getId().equals(book.getId()))
                    .findFirst()
                    .orElse(null);

            if (existingItem == null) {
                CartItem cartItem = CartItem.builder()
                        .cart(cart)
                        .book(book)
                        .quantity(safeQuantity)
                        .build();
                cart.getItems().add(cartItem);
                em.persist(cartItem);
            } else {
                existingItem.setQuantity(existingItem.getQuantity() + safeQuantity);
            }

            recalculateTotalPrice(cart);
            em.merge(cart);
            em.flush();

            return true;
        });
    }


    @Override
    public boolean removeFromCart(Integer userId, Integer bookId) {
        return removeFromCart(userId, bookId, 1);
    }

    @Override
    public boolean removeFromCart(Integer userId, Integer bookId, Integer quantity) {
        if (userId == null || bookId == null) {
            return false;
        }

        return executeInTransaction(em -> {
            int safeQuantity = quantity == null || quantity <= 0 ? 1 : quantity;
            Cart cart = findManagedCartByUserId(em, userId).orElse(null);

            if (cart == null) {
                return false;
            }

            CartItem existingItem = findManagedCartItem(cart, bookId);

            if (existingItem == null) {
                return false;
            }

            if (existingItem.getQuantity() <= safeQuantity) {
                removeManagedCartItem(em, cart, existingItem);
            } else {
                existingItem.setQuantity(existingItem.getQuantity() - safeQuantity);
            }

            recalculateTotalPrice(cart);
            em.merge(cart);
            em.flush();

            return true;
        });
    }

    private Optional<Cart> findManagedCartByUserId(EntityManager em, Integer userId) {
        if (userId == null) {
            return Optional.empty();
        }

        return em.createQuery(
                        "SELECT DISTINCT c FROM Cart c " +
                                "LEFT JOIN FETCH c.user " +
                                "LEFT JOIN FETCH c.items i " +
                                "LEFT JOIN FETCH i.book " +
                                "LEFT JOIN FETCH i.book.bookAuthors ba " +
                                "LEFT JOIN FETCH ba.author " +
                                "WHERE c.user.id = :userId",
                        getEntityClass()
                )
                .setParameter("userId", Long.valueOf(userId))
                .getResultStream()
                .findFirst();
    }

    private CartItem findManagedCartItem(Cart cart, Integer bookId) {
        if (cart == null || bookId == null) {
            return null;
        }

        return cart.getItems()
                .stream()
                .filter(item -> item.getBook().getId().equals(Long.valueOf(bookId)))
                .findFirst()
                .orElse(null);
    }

    private void removeManagedCartItem(EntityManager em, Cart cart, CartItem cartItem) {
        cart.getItems().remove(cartItem);
        em.remove(cartItem);
    }

    private Cart createCart(EntityManager em, User user) {
        Cart cart = Cart.builder()
                .user(user)
                .totalPrice((double) 0)
                .build();
        em.persist(cart);
        em.flush();
        return cart;
    }

    private void recalculateTotalPrice(Cart cart) {
        BigDecimal totalPrice = cart.getItems()
                .stream()
                .map(item -> item.getBook().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        cart.setTotalPrice(totalPrice.doubleValue());
    }
}
