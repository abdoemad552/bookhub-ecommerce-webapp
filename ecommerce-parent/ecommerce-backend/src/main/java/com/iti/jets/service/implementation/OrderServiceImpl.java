package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.request.PlaceOrderRequestDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.dto.response.factory.ResponseFactory;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Order;
import com.iti.jets.model.entity.OrderItem;
import com.iti.jets.model.entity.User;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.CartRepository;
import com.iti.jets.repository.interfaces.OrderRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.Optional;

public class OrderServiceImpl extends ContextHandler implements OrderService {

    private static final Logger LOGGER = LoggerFactory.getLogger(OrderServiceImpl.class);

    private final UserRepository userRepository;
    private final OrderRepository orderRepository;
    private final BookRepository bookRepository;
    private final CartRepository cartRepository;

    public OrderServiceImpl(OrderRepository orderRepository,
                            UserRepository userRepository,
                            BookRepository bookRepository,
                            CartRepository cartRepository) {
        this.orderRepository = orderRepository;
        this.userRepository = userRepository;
        this.bookRepository = bookRepository;
        this.cartRepository = cartRepository;
    }

    @Override
    public BaseResponse<String> placeOrder(PlaceOrderRequestDTO request) {
        return executeInContext(() -> {

            Optional<User> userOpt = userRepository.findById(request.getUserId());
            if (userOpt.isEmpty()) {
                return ResponseFactory.failure("Invalid User");
            }

            Order orderEntity = buildOrderEntity(request, userOpt.get());
            orderRepository.update(orderEntity);

            // Update the current user
            if (!updateCurrentUserData(userOpt.get(), orderEntity, request.getTotalPrice())) {
                return ResponseFactory.failure("Insufficient Credit Limit");
            }

            // Delete the current active cart for this user
            cartRepository.deleteByUserId(userOpt.get().getId());

            // Form the order code from ID
            String orderCode = "ORD-" + orderEntity.getCreatedAt().getYear() + "-" + orderEntity.getId();
            return ResponseFactory.success("Order Saved Successfully", orderCode);
        });
    }

    private Order buildOrderEntity(PlaceOrderRequestDTO request, User user) {
        Order orderEntity = Order.builder()
                .user(user)
                .createdAt(request.getCreatedAt())
                .status(request.getStatus())
                .totalPrice(BigDecimal.valueOf(request.getTotalPrice()))
                .build();

        // Persist the order first to generate its ID
        orderRepository.save(orderEntity);

        // Add the order items to the order entity
        for (var item : request.getItems()) {
            Book book = bookRepository.findById(item.getBookId())
                    .orElseThrow(() -> new RuntimeException("Book not found"));

            orderEntity.addItem(OrderItem.builder()
                    .order(orderEntity)
                    .book(book)
                    .currentPrice(BigDecimal.valueOf(item.getCurrentPrice()))
                    .quantity(item.getQuantity())
                    .build()
            );
        }

        return orderEntity;
    }

    private boolean updateCurrentUserData(User user, Order orderEntity, double totalPrice) {
        double newCredit = user.getCreditLimit().doubleValue() - totalPrice;
        if (newCredit < 0) {
            return false;
        }
        user.setCreditLimit(BigDecimal.valueOf(newCredit));
        user.addOrder(orderEntity);
        userRepository.update(user);

        return true;
    }
}