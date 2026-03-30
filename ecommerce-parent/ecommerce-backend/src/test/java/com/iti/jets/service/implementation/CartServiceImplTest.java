package com.iti.jets.service.implementation;

import com.iti.jets.mapper.CartMapper;
import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Cart;
import com.iti.jets.model.entity.CartItem;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.CartRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CartServiceImpl Tests")
class CartServiceImplTest {

    @Mock
    private CartRepository cartRepository;

    @Mock
    private BookRepository bookRepository;

    @Mock
    private CartMapper cartMapper;

    @InjectMocks
    private CartServiceImpl cartService;

    private Cart mockCart;
    private CartDTO mockCartDTO;
    private Book mockBook;

    @BeforeEach
    void setUp() {
        mockCart = new Cart();
        mockCart.setId(1L);

        mockCartDTO = new CartDTO();

        mockBook = new Book();
        mockBook.setId(10L);
        mockBook.setTitle("Clean Code");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findById
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findById")
    class FindById {

        @Test
        @DisplayName("returns Cart when found")
        void returnsCart_whenFound() {
            when(cartRepository.findById(1L)).thenReturn(Optional.of(mockCart));

            Cart result = cartService.findById(1L);

            assertNotNull(result);
            assertEquals(mockCart, result);
        }

        @Test
        @DisplayName("returns null when not found")
        void returnsNull_whenNotFound() {
            when(cartRepository.findById(99L)).thenReturn(Optional.empty());

            assertNull(cartService.findById(99L));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findByUserId
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findByUserId")
    class FindByUserId {

        @Test
        @DisplayName("returns null immediately when userId is null")
        void returnsNull_whenUserIdNull() {
            Cart result = cartService.findByUserId(null);

            assertNull(result);
            verifyNoInteractions(cartRepository);
        }

        @Test
        @DisplayName("returns Cart when found by userId")
        void returnsCart_whenFound() {
            when(cartRepository.findByUserId(5)).thenReturn(Optional.of(mockCart));

            Cart result = cartService.findByUserId(5);

            assertNotNull(result);
            assertEquals(mockCart, result);
        }

        @Test
        @DisplayName("returns null when cart not found for userId")
        void returnsNull_whenNotFound() {
            when(cartRepository.findByUserId(99)).thenReturn(Optional.empty());

            assertNull(cartService.findByUserId(99));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // getItemsCount
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("getItemsCount delegates to repository")
    void getItemsCount_delegatesToRepository() {
        when(cartRepository.getItemsCount(5)).thenReturn(3);

        assertEquals(3, cartService.getItemsCount(5));
        verify(cartRepository).getItemsCount(5);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // createTransientCartItem
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("createTransientCartItem")
    class CreateTransientCartItem {

        @Test
        @DisplayName("returns CartItem with book and quantity when book exists")
        void returnsCartItem_whenBookFound() {
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));

            CartItem result = cartService.createTransientCartItem(10, 2);

            assertNotNull(result);
            assertEquals(mockBook, result.getBook());
            assertEquals(2, result.getQuantity());
        }

        @Test
        @DisplayName("returns CartItem with null book when book not found")
        void returnsCartItemWithNullBook_whenBookNotFound() {
            when(bookRepository.findById(99L)).thenReturn(Optional.empty());

            CartItem result = cartService.createTransientCartItem(99, 1);

            assertNotNull(result);
            assertNull(result.getBook());
            assertEquals(1, result.getQuantity());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // addToCart (without quantity)
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("addToCart")
    class AddToCart {

        @Test
        @DisplayName("returns true when item added successfully (no quantity)")
        void returnsTrue_whenAdded() {
            when(cartRepository.addToCart(5, 10)).thenReturn(true);

            assertTrue(cartService.addToCart(5, 10));
        }

        @Test
        @DisplayName("returns false when add fails (no quantity)")
        void returnsFalse_whenAddFails() {
            when(cartRepository.addToCart(5, 10)).thenReturn(false);

            assertFalse(cartService.addToCart(5, 10));
        }

        @Test
        @DisplayName("returns true when item added with quantity")
        void returnsTrue_whenAddedWithQuantity() {
            when(cartRepository.addToCart(5, 10, 3)).thenReturn(true);

            assertTrue(cartService.addToCart(5, 10, 3));
        }

        @Test
        @DisplayName("returns false when add with quantity fails")
        void returnsFalse_whenAddWithQuantityFails() {
            when(cartRepository.addToCart(5, 10, 3)).thenReturn(false);

            assertFalse(cartService.addToCart(5, 10, 3));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // removeFromCart
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("removeFromCart")
    class RemoveFromCart {

        @Test
        @DisplayName("returns true when item removed successfully (no quantity)")
        void returnsTrue_whenRemoved() {
            when(cartRepository.removeFromCart(5, 10)).thenReturn(true);

            assertTrue(cartService.removeFromCart(5, 10));
        }

        @Test
        @DisplayName("returns false when remove fails (no quantity)")
        void returnsFalse_whenRemoveFails() {
            when(cartRepository.removeFromCart(5, 10)).thenReturn(false);

            assertFalse(cartService.removeFromCart(5, 10));
        }

        @Test
        @DisplayName("returns true when item removed with quantity")
        void returnsTrue_whenRemovedWithQuantity() {
            when(cartRepository.removeFromCart(5, 10, 2)).thenReturn(true);

            assertTrue(cartService.removeFromCart(5, 10, 2));
        }

        @Test
        @DisplayName("returns false when remove with quantity fails")
        void returnsFalse_whenRemoveWithQuantityFails() {
            when(cartRepository.removeFromCart(5, 10, 2)).thenReturn(false);

            assertFalse(cartService.removeFromCart(5, 10, 2));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // loadOrderSummary
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("loadOrderSummary")
    class LoadOrderSummary {

        @Test
        @DisplayName("returns failure when cart not found for user")
        void returnsFailure_whenCartNotFound() {
            when(cartRepository.findByUserId(99)).thenReturn(Optional.empty());

            BaseResponse<CartDTO> result = cartService.loadOrderSummary(99L);

            assertFalse(result.isSuccess());
            assertEquals("Invalid user", result.getMessage());
        }

        @Test
        @DisplayName("returns success with CartDTO when cart found")
        void returnsSuccess_whenCartFound() {
            when(cartRepository.findByUserId(1)).thenReturn(Optional.of(mockCart));
            when(cartMapper.toDTO(mockCart)).thenReturn(mockCartDTO);

            BaseResponse<CartDTO> result = cartService.loadOrderSummary(1L);

            assertTrue(result.isSuccess());
            assertEquals(mockCartDTO, result.getData());
        }
    }
}
