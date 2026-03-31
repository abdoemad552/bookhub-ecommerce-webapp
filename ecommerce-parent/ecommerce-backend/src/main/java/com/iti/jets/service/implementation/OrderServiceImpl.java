package com.iti.jets.service.implementation;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.iti.jets.mapper.UserMapper;
import com.iti.jets.model.dto.request.PlaceOrderRequestDTO;
import com.iti.jets.model.dto.response.OrderDTO;
import com.iti.jets.model.dto.response.OrderItemDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserOrderHistoryDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.dto.response.factory.ResponseFactory;
import com.iti.jets.model.entity.*;
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
    private final UserMapper userMapper;

    public OrderServiceImpl(OrderRepository orderRepository,
                            UserRepository userRepository,
                            BookRepository bookRepository,
                            CartRepository cartRepository,
                            UserMapper userMapper) {
        this.orderRepository = orderRepository;
        this.userRepository = userRepository;
        this.bookRepository = bookRepository;
        this.cartRepository = cartRepository;
        this.userMapper = userMapper;
    }

    @Override
    public BaseResponse<String> placeOrder(PlaceOrderRequestDTO request) {
        try {
            return executeInContext(() -> {

                if (request == null) {
                    return ResponseFactory.failure("Your cart is empty or already checked out.");
                }

                Optional<User> userOpt = userRepository.findById(request.getUserId());
                if (userOpt.isEmpty()) {
                    return ResponseFactory.failure("Invalid User");
                }

                BaseResponse<Order> res = buildOrderEntity(request, userOpt.get());
                if (res.isFailure()) {
                    throw new RuntimeException(res.getMessage()); // trigger rollback
                }

                Order orderEntity = res.getData();
                orderRepository.update(orderEntity);

                if (!updateCurrentUserData(userOpt.get(), orderEntity, request.getTotalPrice())) {
                    throw new RuntimeException("Insufficient Credit Limit"); // trigger rollback
                }

                cartRepository.deleteByUserId(userOpt.get().getId());

                String orderCode = "ORD-" + orderEntity.getCreatedAt().getYear() + "-" + orderEntity.getId();
                return ResponseFactory.success("Order Saved Successfully", orderCode);
            });

        } catch (RuntimeException e) {
            // Catches all failures (stock, credit limit, book not found, etc.)
            return ResponseFactory.failure(e.getMessage());
        }
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

            return ResponseFactory.success("Order Details Loaded", orderDto);
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
            order.getUser().setCreditLimit(order.getUser().getCreditLimit().add(order.getTotalPrice()));
            orderRepository.update(order);
            userRepository.update(order.getUser());

            // Update book stock quantity
            Set<OrderItem> items = order.getItems();
            for(var item : items){
                item.getBook().setStockQuantity(item.getBook().getStockQuantity() + item.getQuantity());
                item.getBook().setSoldQuantity(item.getBook().getSoldQuantity() - item.getQuantity());
                bookRepository.update(item.getBook());
            }

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

    @Override
    public BaseResponse<UserOrderHistoryDTO> loadOrderHistory(Long userId) {
        return executeInContext(() -> {
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                return ResponseFactory.failure("Invalid User");
            }

            User user = userOpt.get();
            Set<Order> orders = user.getOrders();
            Set<OrderDTO> orderDtos = new HashSet<>();
            double totalSpent = 0;

            for (Order order : orders) {

                if (order.getStatus() != OrderStatus.CANCELLED) {
                    totalSpent += order.getTotalPrice().doubleValue();
                }
                orderDtos.add(
                        OrderDTO.builder()
                                .orderId(order.getId())
                                .orderStatus(order.getStatus())
                                .orderCode("ORD-" + order.getCreatedAt().getYear() + "-" + order.getId())
                                .createdAt(order.getCreatedAt())
                                .totalPrice(order.getTotalPrice().doubleValue())
                                .build()
                );
            }

            UserOrderHistoryDTO userOrderHistoryDto = UserOrderHistoryDTO.builder()
                    .totalOrders(orders.size())
                    .totalSpent(totalSpent)
                    .recentOrders(orderDtos)
                    .build();

            return ResponseFactory.success("Orders Loaded", userOrderHistoryDto);
        });
    }

    @Override
    public UserDTO getOwnedUser(Long orderId) {
        return executeInContext(() -> {
            Optional<Order> orderOpt = orderRepository.findById(orderId);
            if (orderOpt.isEmpty()) {
                return null;
            }

            Order order = orderOpt.get();
            return userMapper.toDTO(order.getUser());
        });
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

        ObjectMapper mapper = new ObjectMapper();
        String addressJson;
        try {
            addressJson = mapper.writeValueAsString(order.getShippingAddress());
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
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
                .shippingAddress(addressJson)
                .build();
    }

    private BaseResponse<Order> buildOrderEntity(PlaceOrderRequestDTO request, User user) {

        // Build Shipping address
        Address shippingAddress = Address.builder()
                .government(request.getGovernment())
                .addressType(request.getAddressType())
                .city(request.getCity())
                .street(request.getStreet())
                .buildingNo(request.getBuildingNo())
                .description(request.getDescription())
                .build();

        // Build order entity
        Order orderEntity = Order.builder()
                .user(user)
                .createdAt(request.getCreatedAt())
                .status(request.getStatus())
                .totalPrice(BigDecimal.valueOf(request.getTotalPrice()))
                .shippingAddress(shippingAddress)
                .build();

        // Add the order items to the order entity
        for (var item : request.getItems()) {

            Book book = bookRepository.findById(item.getBookId())
                    .orElseThrow(() -> new RuntimeException("Book not found: " + item.getBookId()));

            // Atomic check + deduct in ONE query — no race condition!
            int rowsUpdated = bookRepository.deductStock(
                    item.getBookId(),
                    item.getQuantity()
            );

            if (rowsUpdated == 0) {
                if(book.getStockQuantity() <= 0){
                    throw new RuntimeException(
                            "This Book: " + book.getTitle() +
                                    " is out of stock"
                    );
                }
                // Stock not enough OR someone else just took the last copy
                throw new RuntimeException(
                        "Only " + book.getStockQuantity() +
                                " items available from: " + book.getTitle()
                );
            }

            // Stock deducted safely — add item to order
            orderEntity.addItem(OrderItem.builder()
                    .order(orderEntity)
                    .book(book)
                    .currentPrice(BigDecimal.valueOf(item.getCurrentPrice()))
                    .quantity(item.getQuantity())
                    .build()
            );
        }

        // Final step to avoid tx issue
        orderRepository.save(orderEntity);

        return ResponseFactory.success("Order entity formed", orderEntity);
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