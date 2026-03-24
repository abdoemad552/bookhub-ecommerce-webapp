package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.request.PlaceOrderRequestDTO;
import com.iti.jets.model.dto.response.OrderDTO;
import com.iti.jets.model.dto.response.OrderItemDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.dto.response.factory.ResponseFactory;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Order;
import com.iti.jets.model.entity.OrderItem;
import com.iti.jets.model.entity.User;
import com.iti.jets.model.enums.OrderStatus;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.CartRepository;
import com.iti.jets.repository.interfaces.OrderRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;

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

    @Override
    public BaseResponse<OrderDTO> loadOrderDetails(Long orderId) {
        return executeInContext(() -> {
            Optional<Order> orderOpt = orderRepository.findById(orderId);

            if (orderOpt.isEmpty()) {
                return ResponseFactory.failure("Invalid Order ID");
            }
            Order order = orderOpt.get();

            OrderDTO orderDto = buildOrderDTO(order);

            return ResponseFactory.success("Order Details Loaded",
                    orderDto);
        });
    }

    @Override
    public OrderStatus getOrderStatus(Long orderId) {
        return executeInContext(() -> {
            Optional<Order> orderOpt = orderRepository.findById(orderId);

            if (orderOpt.isEmpty()) {
                return OrderStatus.CANCELLED;
            }
            Order order = orderOpt.get();
            return getOrderStatus(order);
        });
    }

    @Override
    public OrderStatus getOrderStatus(Order order) {
        return executeInContext(() -> {
            if (order.getStatus() == OrderStatus.CANCELLED ||
                    order.getStatus() == OrderStatus.DELIVERED) {
                return order.getStatus();
            }

            LocalDateTime t1 = LocalDateTime.now();
            LocalDateTime t2 = order.getCreatedAt();

            Duration duration = Duration.between(t1, t2);

            if (duration.toDays() >= 5) {
                order.setStatus(OrderStatus.DELIVERED);
                orderRepository.update(order);

                return OrderStatus.DELIVERED;
            } else {
                return OrderStatus.PROCESSING;
            }
        });
    }

    @Override
    public BaseResponse<Void> cancelOrder(Order order) {
        return executeInContext(() -> {
            if (order.getStatus() == OrderStatus.CANCELLED) {
                return ResponseFactory.failure("Order is already cancelled before");
            }

            if (order.getStatus() == OrderStatus.DELIVERED) {
                return ResponseFactory.failure("Order is already delivered, can not be cancelled");
            }

            order.setStatus(OrderStatus.CANCELLED);
            orderRepository.update(order);

            return ResponseFactory.success("Order cancelled successfully");
        });
    }

    @Override
    public BaseResponse<Void> cancelOrder(Long orderId) {
        return executeInContext(() -> {
            Optional<Order> orderOpt = orderRepository.findById(orderId);

            if (orderOpt.isEmpty()) {
                return ResponseFactory.failure("Invalid Order");
            }
            Order order = orderOpt.get();
            return cancelOrder(order);
        });
    }

    @Override
    public boolean isOrderOwnedByUser(Long orderId, Long userId) {
        return executeInContext(() -> {
            Optional<Order> orderOpt = orderRepository.findById(orderId);

            if (orderOpt.isEmpty()) {
                return false;
            }
            Order order = orderOpt.get();

            return Objects.equals(order.getUser().getId(), userId);
        });
    }

    @Override
    public List<OrderDTO> findAllByUserId(Long userId) {
        if (userId == null) {
            return List.of();
        }

        return executeInContext(() -> orderRepository.findAllByUserId(userId)
                .stream()
                .map(this::buildOrderDTO)
                .toList());
    }

    // Helpers
    private OrderDTO buildOrderDTO(Order order) {
        Set<OrderItemDTO> items = new HashSet<>();
        for (OrderItem item : order.getItems()) {
            items.add(
                    OrderItemDTO.builder()
                            .bookId(item.getBook().getId())
                            .bookTittle(item.getBook().getTitle())
                            .imageUrl(item.getBook().getImageUrl())
                            .quantity(item.getQuantity())
                            .currentPrice(item.getCurrentPrice().doubleValue())
                            .build()
            );
        }

        return OrderDTO.builder()
                .orderId(order.getId())
                .userId(order.getUser().getId())
                .orderCode("ORD-" + order.getCreatedAt().getYear() + "-" + order.getId())
                .createdAt(order.getCreatedAt())
                .orderStatus(getOrderStatus(order))
                .totalPrice(order.getTotalPrice().doubleValue())
                .shippingPrice(0)
                .items(items)
                .build();
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

            // Update book data
            book.setStockQuantity(book.getStockQuantity() - item.getQuantity());
            book.setStockQuantity(book.getStockQuantity() + item.getQuantity());
            bookRepository.update(book);
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