package com.iti.jets.service.implementation;

import com.iti.jets.mapper.UserMapper;
import com.iti.jets.model.dto.request.PlaceOrderRequestDTO;
import com.iti.jets.model.dto.response.OrderDTO;
import com.iti.jets.model.dto.response.OrderItemDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserOrderHistoryDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.entity.*;
import com.iti.jets.model.enums.AddressType;
import com.iti.jets.model.enums.Government;
import com.iti.jets.model.enums.OrderStatus;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.CartRepository;
import com.iti.jets.repository.interfaces.OrderRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrderServiceImpl Tests")
class OrderServiceImplTest {

    @Mock
    private OrderRepository orderRepository;
    @Mock
    private UserRepository userRepository;
    @Mock
    private BookRepository bookRepository;
    @Mock
    private CartRepository cartRepository;
    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private OrderServiceImpl orderService;

    private User mockUser;
    private Book mockBook;
    private Order mockOrder;
    private UserDTO mockUserDTO;

    @BeforeEach
    void setUp() {
        mockUser = new User();
        mockUser.setId(1L);
        mockUser.setUsername("john_doe");
        mockUser.setCreditLimit(new BigDecimal("500.00"));
        mockUser.setOrders(new HashSet<>());

        mockBook = new Book();
        mockBook.setId(10L);
        mockBook.setTitle("Clean Code");
        mockBook.setStockQuantity(5);
        mockBook.setPrice(new BigDecimal("39.99"));

        mockOrder = Order.builder()
                .id(100L)
                .user(mockUser)
                .status(OrderStatus.PROCESSING)
                .totalPrice(new BigDecimal("79.98"))
                .createdAt(LocalDateTime.now())
                .items(new HashSet<>())
                .build();

        mockUserDTO = new UserDTO();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // placeOrder
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("placeOrder")
    class PlaceOrder {

        private PlaceOrderRequestDTO buildValidRequest() {
            OrderItemDTO item = new OrderItemDTO();
            item.setBookId(10L);
            item.setQuantity(2);
            item.setCurrentPrice(39.99);

            PlaceOrderRequestDTO req = new PlaceOrderRequestDTO();
            req.setUserId(1L);
            req.setTotalPrice(79.98);
            req.setCreatedAt(LocalDateTime.now());
            req.setStatus(OrderStatus.PROCESSING);
            req.setGovernment(Government.CAIRO);
            req.setCity("Cairo");
            req.setStreet("El-Tahrir");
            req.setBuildingNo("1");
            req.setAddressType(AddressType.HOME);
            req.setItems(Set.of(item));
            return req;
        }

        @Test
        @DisplayName("returns failure when request is null")
        void returnsFailure_whenRequestNull() {
            BaseResponse<String> result = orderService.placeOrder(null);

            assertFalse(result.isSuccess());
            assertEquals("Your cart is empty or already checked out.", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when user not found")
        void returnsFailure_whenUserNotFound() {
            PlaceOrderRequestDTO req = buildValidRequest();
            when(userRepository.findById(1L)).thenReturn(Optional.empty());

            BaseResponse<String> result = orderService.placeOrder(req);

            assertFalse(result.isSuccess());
            assertEquals("Invalid User", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when book not found in order items")
        void returnsFailure_whenBookNotFound() {
            PlaceOrderRequestDTO req = buildValidRequest();
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.empty());

            BaseResponse<String> result = orderService.placeOrder(req);

            assertFalse(result.isSuccess());
            assertTrue(result.getMessage().contains("Book not found"));
        }

        @Test
        @DisplayName("returns failure when book is out of stock")
        void returnsFailure_whenBookOutOfStock() {
            mockBook.setStockQuantity(0);
            PlaceOrderRequestDTO req = buildValidRequest();
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(bookRepository.deductStock(10L, 2)).thenReturn(0);

            BaseResponse<String> result = orderService.placeOrder(req);

            assertFalse(result.isSuccess());
            assertTrue(result.getMessage().contains("out of stock"));
        }

        @Test
        @DisplayName("returns failure when stock insufficient (not zero but less than requested)")
        void returnsFailure_whenInsufficientStock() {
            mockBook.setStockQuantity(1); // has some, but not enough
            PlaceOrderRequestDTO req = buildValidRequest();
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(bookRepository.deductStock(10L, 2)).thenReturn(0);

            BaseResponse<String> result = orderService.placeOrder(req);

            assertFalse(result.isSuccess());
            assertTrue(result.getMessage().contains("Only"));
            assertTrue(result.getMessage().contains(mockBook.getTitle()));
        }

        @Test
        @DisplayName("returns failure when user has insufficient credit limit")
        void returnsFailure_whenInsufficientCredit() {
            mockUser.setCreditLimit(new BigDecimal("10.00")); // less than 79.98
            PlaceOrderRequestDTO req = buildValidRequest();

            Order savedOrder = Order.builder()
                    .id(100L).user(mockUser).status(OrderStatus.PROCESSING)
                    .totalPrice(new BigDecimal("79.98"))
                    .createdAt(req.getCreatedAt()).items(new HashSet<>()).build();

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(bookRepository.deductStock(10L, 2)).thenReturn(1);
            when(orderRepository.save(any(Order.class))).thenReturn(savedOrder);

            BaseResponse<String> result = orderService.placeOrder(req);

            assertFalse(result.isSuccess());
            assertEquals("Insufficient Credit Limit", result.getMessage());
        }

        @Test
        @DisplayName("places order successfully and returns order code")
        void placesOrder_successfully() {
            PlaceOrderRequestDTO req = buildValidRequest();

            Order savedOrder = Order.builder()
                    .id(100L).user(mockUser).status(OrderStatus.PROCESSING)
                    .totalPrice(new BigDecimal("79.98"))
                    .createdAt(req.getCreatedAt()).items(new HashSet<>()).build();

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(bookRepository.deductStock(10L, 2)).thenReturn(1);
            when(orderRepository.save(any(Order.class))).thenReturn(savedOrder);
            when(orderRepository.update(any(Order.class))).thenReturn(savedOrder);
            when(userRepository.update(any(User.class))).thenReturn(mockUser);

            BaseResponse<String> result = orderService.placeOrder(req);

            assertTrue(result.isSuccess());
            assertNotNull(result.getData());
            assertTrue(result.getData().startsWith("ORD-"));
        }

        @Test
        @DisplayName("clears cart after successful order")
        void clearsCart_afterSuccessfulOrder() {
            PlaceOrderRequestDTO req = buildValidRequest();

            Order savedOrder = Order.builder()
                    .id(100L).user(mockUser).status(OrderStatus.PROCESSING)
                    .totalPrice(new BigDecimal("79.98"))
                    .createdAt(req.getCreatedAt()).items(new HashSet<>()).build();

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(bookRepository.deductStock(10L, 2)).thenReturn(1);
            when(orderRepository.save(any(Order.class))).thenReturn(savedOrder);
            when(orderRepository.update(any(Order.class))).thenReturn(savedOrder);
            when(userRepository.update(any(User.class))).thenReturn(mockUser);

            orderService.placeOrder(req);

            verify(cartRepository).deleteByUserId(mockUser.getId());
        }

        @Test
        @DisplayName("deducts total price from user credit limit on success")
        void deductsFromCreditLimit_onSuccess() {
            PlaceOrderRequestDTO req = buildValidRequest();

            Order savedOrder = Order.builder()
                    .id(100L).user(mockUser).status(OrderStatus.PROCESSING)
                    .totalPrice(new BigDecimal("79.98"))
                    .createdAt(req.getCreatedAt()).items(new HashSet<>()).build();

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(bookRepository.deductStock(10L, 2)).thenReturn(1);
            when(orderRepository.save(any(Order.class))).thenReturn(savedOrder);
            when(orderRepository.update(any(Order.class))).thenReturn(savedOrder);
            when(userRepository.update(any(User.class))).thenReturn(mockUser);

            orderService.placeOrder(req);

            // 500.00 - 79.98 = 420.02
            assertEquals(new BigDecimal("420.02"), mockUser.getCreditLimit());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // loadOrderDetails
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("loadOrderDetails")
    class LoadOrderDetails {

        @BeforeEach
        void setupOrderItems() {
            Book book = new Book();
            book.setId(10L);
            book.setTitle("Clean Code");
            book.setImageUrl("cover.jpg");

            OrderItem item = OrderItem.builder()
                    .book(book)
                    .quantity(1)
                    .currentPrice(new BigDecimal("39.99"))
                    .build();

            mockOrder.setItems(new HashSet<>(Set.of(item)));
            mockOrder.setShippingAddress(new Address());
        }

        @Test
        @DisplayName("returns failure when order not found")
        void returnsFailure_whenOrderNotFound() {
            when(orderRepository.findById(999L)).thenReturn(Optional.empty());

            BaseResponse<OrderDTO> result = orderService.loadOrderDetails(999L);

            assertFalse(result.isSuccess());
            assertEquals("Invalid Order ID", result.getMessage());
        }

        @Test
        @DisplayName("returns success with OrderDTO when order found")
        void returnsSuccess_whenOrderFound() {
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));

            BaseResponse<OrderDTO> result = orderService.loadOrderDetails(100L);

            assertTrue(result.isSuccess());
            assertNotNull(result.getData());
            assertEquals(100L, result.getData().getOrderId());
        }

        @Test
        @DisplayName("order code format is ORD-{year}-{id}")
        void orderCode_hasCorrectFormat() {
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));

            BaseResponse<OrderDTO> result = orderService.loadOrderDetails(100L);

            String expectedCode = "ORD-" + mockOrder.getCreatedAt().getYear() + "-100";
            assertEquals(expectedCode, result.getData().getOrderCode());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // getOrderStatus (by id)
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("getOrderStatus by id")
    class GetOrderStatusById {

        @Test
        @DisplayName("returns CANCELLED when order not found")
        void returnsCancelled_whenOrderNotFound() {
            when(orderRepository.findById(999L)).thenReturn(Optional.empty());

            assertEquals(OrderStatus.CANCELLED, orderService.getOrderStatus(999L));
        }

        @Test
        @DisplayName("returns CANCELLED for a cancelled order")
        void returnsCancelled_forCancelledOrder() {
            mockOrder.setStatus(OrderStatus.CANCELLED);
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));

            assertEquals(OrderStatus.CANCELLED, orderService.getOrderStatus(100L));
        }

        @Test
        @DisplayName("returns DELIVERED for a delivered order")
        void returnsDelivered_forDeliveredOrder() {
            mockOrder.setStatus(OrderStatus.DELIVERED);
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));

            assertEquals(OrderStatus.DELIVERED, orderService.getOrderStatus(100L));
        }

        @Test
        @DisplayName("returns PROCESSING for recent order (< 5 days old)")
        void returnsProcessing_forRecentOrder() {
            mockOrder.setStatus(OrderStatus.PROCESSING);
            mockOrder.setCreatedAt(LocalDateTime.now().minusDays(1)); // 1 day ago
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));

            assertEquals(OrderStatus.PROCESSING, orderService.getOrderStatus(100L));
        }

        @Test
        @DisplayName("returns DELIVERED and persists status for old order (>= 5 days)")
        void returnsDelivered_andPersists_forOldOrder() {
            mockOrder.setStatus(OrderStatus.PROCESSING);
            // Note: duration is between(now, createdAt) — needs createdAt in the future relative to now
            // for duration.toDays() >= 5, createdAt must be > now by 5 days
            mockOrder.setCreatedAt(LocalDateTime.now().plusDays(6));
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));
            when(orderRepository.update(mockOrder)).thenReturn(mockOrder);

            OrderStatus result = orderService.getOrderStatus(100L);

            assertEquals(OrderStatus.DELIVERED, result);
            assertEquals(OrderStatus.DELIVERED, mockOrder.getStatus());
            verify(orderRepository).update(mockOrder);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // cancelOrder (by Order entity)
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("cancelOrder by Order entity")
    class CancelOrderByEntity {

        @Test
        @DisplayName("returns failure when order already cancelled")
        void returnsFailure_whenAlreadyCancelled() {
            mockOrder.setStatus(OrderStatus.CANCELLED);

            BaseResponse<Void> result = orderService.cancelOrder(mockOrder);

            assertFalse(result.isSuccess());
            assertEquals("Order is already cancelled before", result.getMessage());
            verify(orderRepository, never()).update(any());
        }

        @Test
        @DisplayName("returns failure when order already delivered")
        void returnsFailure_whenAlreadyDelivered() {
            mockOrder.setStatus(OrderStatus.DELIVERED);

            BaseResponse<Void> result = orderService.cancelOrder(mockOrder);

            assertFalse(result.isSuccess());
            assertEquals("Order is already delivered, can not be cancelled", result.getMessage());
            verify(orderRepository, never()).update(any());
        }

        @Test
        @DisplayName("cancels order and refunds credit limit")
        void cancelsOrder_andRefundsCreditLimit() {
            mockOrder.setStatus(OrderStatus.PROCESSING);
            mockUser.setCreditLimit(new BigDecimal("200.00"));
            when(orderRepository.update(mockOrder)).thenReturn(mockOrder);
            when(userRepository.update(mockUser)).thenReturn(mockUser);

            BaseResponse<Void> result = orderService.cancelOrder(mockOrder);

            assertTrue(result.isSuccess());
            assertEquals(OrderStatus.CANCELLED, mockOrder.getStatus());
            // 200 + 79.98 = 279.98
            assertEquals(new BigDecimal("279.98"), mockUser.getCreditLimit());
        }

        @Test
        @DisplayName("persists both order and user after cancellation")
        void persistsOrderAndUser_afterCancellation() {
            mockOrder.setStatus(OrderStatus.PROCESSING);
            when(orderRepository.update(mockOrder)).thenReturn(mockOrder);
            when(userRepository.update(mockUser)).thenReturn(mockUser);

            orderService.cancelOrder(mockOrder);

            verify(orderRepository).update(mockOrder);
            verify(userRepository).update(mockUser);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // cancelOrder (by orderId)
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("cancelOrder by orderId")
    class CancelOrderById {

        @Test
        @DisplayName("returns failure when order not found")
        void returnsFailure_whenOrderNotFound() {
            when(orderRepository.findById(999L)).thenReturn(Optional.empty());

            BaseResponse<Void> result = orderService.cancelOrder(999L);

            assertFalse(result.isSuccess());
            assertEquals("Invalid Order", result.getMessage());
        }

        @Test
        @DisplayName("delegates to cancelOrder(Order) when order found")
        void delegates_whenOrderFound() {
            mockOrder.setStatus(OrderStatus.PROCESSING);
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));
            when(orderRepository.update(mockOrder)).thenReturn(mockOrder);
            when(userRepository.update(mockUser)).thenReturn(mockUser);

            BaseResponse<Void> result = orderService.cancelOrder(100L);

            assertTrue(result.isSuccess());
            assertEquals(OrderStatus.CANCELLED, mockOrder.getStatus());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // isOrderOwnedByUser
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("isOrderOwnedByUser")
    class IsOrderOwnedByUser {

        @Test
        @DisplayName("returns false when order not found")
        void returnsFalse_whenOrderNotFound() {
            when(orderRepository.findById(999L)).thenReturn(Optional.empty());

            assertFalse(orderService.isOrderOwnedByUser(999L, 1L));
        }

        @Test
        @DisplayName("returns true when order belongs to user")
        void returnsTrue_whenOrderBelongsToUser() {
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));

            assertTrue(orderService.isOrderOwnedByUser(100L, 1L));
        }

        @Test
        @DisplayName("returns false when order belongs to different user")
        void returnsFalse_whenOrderBelongsToDifferentUser() {
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));

            assertFalse(orderService.isOrderOwnedByUser(100L, 99L));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAllByUserId
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAllByUserId")
    class FindAllByUserId {

        @BeforeEach
        void setupOrderForDTO() {
            mockOrder.setItems(new HashSet<>());
            mockOrder.setShippingAddress(new Address());
        }

        @Test
        @DisplayName("returns empty list when userId is null")
        void returnsEmptyList_whenUserIdNull() {
            List<OrderDTO> result = orderService.findAllByUserId(null);

            assertTrue(result.isEmpty());
            verifyNoInteractions(orderRepository);
        }

        @Test
        @DisplayName("returns mapped OrderDTOs for given userId")
        void returnsMappedDTOs_forUserId() {
            when(orderRepository.findAllByUserId(1L)).thenReturn(List.of(mockOrder));

            List<OrderDTO> result = orderService.findAllByUserId(1L);

            assertEquals(1, result.size());
            assertEquals(100L, result.get(0).getOrderId());
        }

        @Test
        @DisplayName("returns empty list when user has no orders")
        void returnsEmptyList_whenNoOrders() {
            when(orderRepository.findAllByUserId(1L)).thenReturn(List.of());

            assertTrue(orderService.findAllByUserId(1L).isEmpty());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // loadOrderHistory
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("loadOrderHistory")
    class LoadOrderHistory {

        @Test
        @DisplayName("returns failure when user not found")
        void returnsFailure_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            BaseResponse<UserOrderHistoryDTO> result = orderService.loadOrderHistory(99L);

            assertFalse(result.isSuccess());
            assertEquals("Invalid User", result.getMessage());
        }

        @Test
        @DisplayName("returns success with empty history when user has no orders")
        void returnsSuccess_withEmptyHistory() {
            mockUser.setOrders(new HashSet<>());
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserOrderHistoryDTO> result = orderService.loadOrderHistory(1L);

            assertTrue(result.isSuccess());
            assertEquals(0, result.getData().getTotalOrders());
            assertEquals(0.0, result.getData().getTotalSpent());
        }

        @Test
        @DisplayName("calculates totalSpent excluding cancelled orders")
        void calculatesTotalSpent_excludingCancelled() {
            Order processingOrder = Order.builder()
                    .id(1L).user(mockUser).status(OrderStatus.PROCESSING)
                    .totalPrice(new BigDecimal("100.00"))
                    .createdAt(LocalDateTime.now()).items(new HashSet<>()).build();

            Order cancelledOrder = Order.builder()
                    .id(2L).user(mockUser).status(OrderStatus.CANCELLED)
                    .totalPrice(new BigDecimal("50.00"))
                    .createdAt(LocalDateTime.now()).items(new HashSet<>()).build();

            mockUser.setOrders(new HashSet<>(Set.of(processingOrder, cancelledOrder)));
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserOrderHistoryDTO> result = orderService.loadOrderHistory(1L);

            assertTrue(result.isSuccess());
            assertEquals(2, result.getData().getTotalOrders());
            assertEquals(100.0, result.getData().getTotalSpent(), 0.001);
        }

        @Test
        @DisplayName("includes all orders in recentOrders set regardless of status")
        void includesAllOrders_inRecentOrders() {
            Order processingOrder = Order.builder()
                    .id(1L).user(mockUser).status(OrderStatus.PROCESSING)
                    .totalPrice(new BigDecimal("100.00"))
                    .createdAt(LocalDateTime.now()).items(new HashSet<>()).build();

            Order cancelledOrder = Order.builder()
                    .id(2L).user(mockUser).status(OrderStatus.CANCELLED)
                    .totalPrice(new BigDecimal("50.00"))
                    .createdAt(LocalDateTime.now()).items(new HashSet<>()).build();

            mockUser.setOrders(new HashSet<>(Set.of(processingOrder, cancelledOrder)));
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserOrderHistoryDTO> result = orderService.loadOrderHistory(1L);

            assertEquals(2, result.getData().getRecentOrders().size());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // getOwnedUser
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("getOwnedUser")
    class GetOwnedUser {

        @Test
        @DisplayName("returns null when order not found")
        void returnsNull_whenOrderNotFound() {
            when(orderRepository.findById(999L)).thenReturn(Optional.empty());

            assertNull(orderService.getOwnedUser(999L));
        }

        @Test
        @DisplayName("returns UserDTO of the order's owner")
        void returnsUserDTO_whenOrderFound() {
            when(orderRepository.findById(100L)).thenReturn(Optional.of(mockOrder));
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            UserDTO result = orderService.getOwnedUser(100L);

            assertNotNull(result);
            verify(userMapper).toDTO(mockUser);
        }
    }
}
