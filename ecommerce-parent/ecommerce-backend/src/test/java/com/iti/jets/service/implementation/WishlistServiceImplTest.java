package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.User;
import com.iti.jets.model.entity.Wishlist;
import com.iti.jets.model.entity.WishlistId;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.repository.interfaces.WishlistRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("WishlistServiceImpl Tests")
class WishlistServiceImplTest {

    @Mock
    private WishlistRepository wishlistRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private BookRepository bookRepository;

    @InjectMocks
    private WishlistServiceImpl wishlistService;

    private User mockUser;
    private Book mockBook;
    private WishlistId mockWishlistId;
    private Wishlist mockWishlist;

    @BeforeEach
    void setUp() {
        mockUser = new User();
        mockUser.setId(1L);
        mockUser.setUsername("john_doe");

        mockBook = new Book();
        mockBook.setId(10L);
        mockBook.setTitle("Clean Code");
        mockBook.setPrice(new BigDecimal("29.99"));
        mockBook.setStockQuantity(5);
        mockBook.setAverageRating(4.2);
        mockBook.setBookAuthors(Set.of());

        mockWishlistId = WishlistId.builder()
                .userId(1L)
                .bookId(10L)
                .build();

        mockWishlist = Wishlist.builder()
                .id(mockWishlistId)
                .user(mockUser)
                .book(mockBook)
                .build();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // addToWishlist
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("addToWishlist")
    class AddToWishlist {

        @Test
        @DisplayName("returns false when userId is null")
        void returnsFalse_whenUserIdNull() {
            assertFalse(wishlistService.addToWishlist(null, 10));
            verifyNoInteractions(wishlistRepository);
        }

        @Test
        @DisplayName("returns false when bookId is null")
        void returnsFalse_whenBookIdNull() {
            assertFalse(wishlistService.addToWishlist(1, null));
            verifyNoInteractions(wishlistRepository);
        }

        @Test
        @DisplayName("returns true immediately when item already in wishlist")
        void returnsTrue_whenAlreadyExists() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(true);

            assertTrue(wishlistService.addToWishlist(1, 10));
            verify(wishlistRepository, never()).save(any());
        }

        @Test
        @DisplayName("returns false when user not found")
        void returnsFalse_whenUserNotFound() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(false);
            when(userRepository.findById(1L)).thenReturn(Optional.empty());
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));

            assertFalse(wishlistService.addToWishlist(1, 10));
            verify(wishlistRepository, never()).save(any());
        }

        @Test
        @DisplayName("returns false when book not found")
        void returnsFalse_whenBookNotFound() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(false);
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.empty());

            assertFalse(wishlistService.addToWishlist(1, 10));
            verify(wishlistRepository, never()).save(any());
        }

        @Test
        @DisplayName("saves wishlist and returns true when user and book found")
        void savesWishlist_andReturnsTrue() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(false);
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));

            assertTrue(wishlistService.addToWishlist(1, 10));
            verify(wishlistRepository).save(any(Wishlist.class));
        }

        @Test
        @DisplayName("saves wishlist with correct user and book")
        void savesWishlist_withCorrectUserAndBook() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(false);
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));

            wishlistService.addToWishlist(1, 10);

            ArgumentCaptor<Wishlist> captor = ArgumentCaptor.forClass(Wishlist.class);
            verify(wishlistRepository).save(captor.capture());
            assertEquals(mockUser, captor.getValue().getUser());
            assertEquals(mockBook, captor.getValue().getBook());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // removeFromWishlist
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("removeFromWishlist")
    class RemoveFromWishlist {

        @Test
        @DisplayName("returns false when userId is null")
        void returnsFalse_whenUserIdNull() {
            assertFalse(wishlistService.removeFromWishlist(null, 10));
            verifyNoInteractions(wishlistRepository);
        }

        @Test
        @DisplayName("returns false when bookId is null")
        void returnsFalse_whenBookIdNull() {
            assertFalse(wishlistService.removeFromWishlist(1, null));
            verifyNoInteractions(wishlistRepository);
        }

        @Test
        @DisplayName("returns false when item is not in wishlist")
        void returnsFalse_whenNotInWishlist() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(false);

            assertFalse(wishlistService.removeFromWishlist(1, 10));
            verify(wishlistRepository, never()).deleteById(any());
        }

        @Test
        @DisplayName("deletes item and returns true when item is in wishlist")
        void deletesItem_andReturnsTrue() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(true);

            assertTrue(wishlistService.removeFromWishlist(1, 10));
            verify(wishlistRepository).deleteById(any(WishlistId.class));
        }

        @Test
        @DisplayName("deletes with correct composite key")
        void deletesWithCorrectKey() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(true);

            wishlistService.removeFromWishlist(1, 10);

            ArgumentCaptor<WishlistId> captor = ArgumentCaptor.forClass(WishlistId.class);
            verify(wishlistRepository).deleteById(captor.capture());
            assertEquals(1L, captor.getValue().getUserId());
            assertEquals(10L, captor.getValue().getBookId());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // isInWishlist
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("isInWishlist")
    class IsInWishlist {

        @Test
        @DisplayName("returns false when userId is null")
        void returnsFalse_whenUserIdNull() {
            assertFalse(wishlistService.isInWishlist(null, 10));
            verifyNoInteractions(wishlistRepository);
        }

        @Test
        @DisplayName("returns false when bookId is null")
        void returnsFalse_whenBookIdNull() {
            assertFalse(wishlistService.isInWishlist(1, null));
            verifyNoInteractions(wishlistRepository);
        }

        @Test
        @DisplayName("returns true when item exists in wishlist")
        void returnsTrue_whenInWishlist() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(true);

            assertTrue(wishlistService.isInWishlist(1, 10));
        }

        @Test
        @DisplayName("returns false when item not in wishlist")
        void returnsFalse_whenNotInWishlist() {
            when(wishlistRepository.existsById(any(WishlistId.class))).thenReturn(false);

            assertFalse(wishlistService.isInWishlist(1, 10));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findWishlistBooks
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findWishlistBooks")
    class FindWishlistBooks {

        @Test
        @DisplayName("returns empty list when userId is null")
        void returnsEmptyList_whenUserIdNull() {
            List<BookCardDTO> result = wishlistService.findWishlistBooks(null);

            assertTrue(result.isEmpty());
            verifyNoInteractions(wishlistRepository);
        }

        @Test
        @DisplayName("returns empty list when wishlist is empty")
        void returnsEmptyList_whenWishlistEmpty() {
            when(wishlistRepository.findAllByUserId(1L)).thenReturn(List.of());

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertTrue(result.isEmpty());
        }

        @Test
        @DisplayName("returns list of BookCardDTOs for each wishlist entry")
        void returnsBookCardDTOs_forWishlistEntries() {
            when(wishlistRepository.findAllByUserId(1L)).thenReturn(List.of(mockWishlist));

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertEquals(1, result.size());
            assertEquals(mockBook.getId(), result.get(0).getId());
            assertEquals(mockBook.getTitle(), result.get(0).getTitle());
        }

        @Test
        @DisplayName("maps book price to BookCardDTO correctly")
        void mapsPrice_correctly() {
            when(wishlistRepository.findAllByUserId(1L)).thenReturn(List.of(mockWishlist));

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertEquals(new BigDecimal("29.99"), result.get(0).getPrice());
        }

        @Test
        @DisplayName("defaults price to ZERO when book price is null")
        void defaultsPriceToZero_whenNull() {
            mockBook.setPrice(null);
            when(wishlistRepository.findAllByUserId(1L)).thenReturn(List.of(mockWishlist));

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertEquals(BigDecimal.ZERO, result.get(0).getPrice());
        }

        @Test
        @DisplayName("defaults stockQuantity to 0 when null")
        void defaultsStockQuantity_whenNull() {
            mockBook.setStockQuantity(null);
            when(wishlistRepository.findAllByUserId(1L)).thenReturn(List.of(mockWishlist));

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertEquals(0, result.get(0).getStockQuantity());
        }

        @Test
        @DisplayName("defaults averageRating to 0 when null")
        void defaultsAverageRating_whenNull() {
            mockBook.setAverageRating(null);
            when(wishlistRepository.findAllByUserId(1L)).thenReturn(List.of(mockWishlist));

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertEquals(0L, result.get(0).getAverageRating());
        }

        @Test
        @DisplayName("rounds averageRating correctly")
        void roundsAverageRating_correctly() {
            mockBook.setAverageRating(3.7);
            when(wishlistRepository.findAllByUserId(1L)).thenReturn(List.of(mockWishlist));

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertEquals(4L, result.get(0).getAverageRating());
        }

        @Test
        @DisplayName("returns empty authors list when bookAuthors is null")
        void returnsEmptyAuthors_whenBookAuthorsNull() {
            mockBook.setBookAuthors(null);
            when(wishlistRepository.findAllByUserId(1L)).thenReturn(List.of(mockWishlist));

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertTrue(result.get(0).getAuthors().isEmpty());
        }

        @Test
        @DisplayName("maps multiple wishlist books correctly")
        void mapsMultipleBooks_correctly() {
            Book secondBook = new Book();
            secondBook.setId(20L);
            secondBook.setTitle("Refactoring");
            secondBook.setPrice(new BigDecimal("35.00"));
            secondBook.setStockQuantity(3);
            secondBook.setAverageRating(4.5);
            secondBook.setBookAuthors(Set.of());

            Wishlist secondWishlist = Wishlist.builder()
                    .id(WishlistId.builder().userId(1L).bookId(20L).build())
                    .user(mockUser)
                    .book(secondBook)
                    .build();

            when(wishlistRepository.findAllByUserId(1L))
                    .thenReturn(List.of(mockWishlist, secondWishlist));

            List<BookCardDTO> result = wishlistService.findWishlistBooks(1L);

            assertEquals(2, result.size());
        }
    }
}
