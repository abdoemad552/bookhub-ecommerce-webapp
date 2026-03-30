package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.request.ReviewRequestDTO;
import com.iti.jets.model.dto.response.ReviewDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Review;
import com.iti.jets.model.entity.User;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.ReviewRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ReviewServiceImpl Tests")
class ReviewServiceImplTest {

    @Mock
    private ReviewRepository reviewRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private BookRepository bookRepository;

    @InjectMocks
    private ReviewServiceImpl reviewService;

    private User mockUser;
    private Book mockBook;
    private Review mockReview;

    @BeforeEach
    void setUp() {
        mockUser = new User();
        mockUser.setId(1L);
        mockUser.setUsername("john_doe");
        mockUser.setFirstName("John");
        mockUser.setLastName("Doe");

        mockBook = new Book();
        mockBook.setId(10L);
        mockBook.setTitle("Clean Code");
        mockBook.setRatingCount(4);
        mockBook.setAverageRating(4.0);

        mockReview = Review.builder()
                .id(100L)
                .user(mockUser)
                .book(mockBook)
                .rating(5)
                .comment("Great book!")
                .createdAt(LocalDateTime.now())
                .build();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findById
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findById")
    class FindById {

        @Test
        @DisplayName("returns ReviewDTO when review found")
        void returnsReviewDTO_whenFound() {
            when(reviewRepository.findById(100L)).thenReturn(Optional.of(mockReview));

            ReviewDTO result = reviewService.findById(100L);

            assertNotNull(result);
            assertEquals(100L, result.getId());
            assertEquals(1L, result.getUserId());
            assertEquals("John Doe", result.getUserFullName());
            assertEquals(5, result.getRating());
        }

        @Test
        @DisplayName("returns null when review not found")
        void returnsNull_whenNotFound() {
            when(reviewRepository.findById(999L)).thenReturn(Optional.empty());

            assertNull(reviewService.findById(999L));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // delete (by id)
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("delete by id")
    class DeleteById {

        @Test
        @DisplayName("does nothing when id is null")
        void doesNothing_whenIdNull() {
            reviewService.delete(null);

            verifyNoInteractions(reviewRepository);
        }

        @Test
        @DisplayName("does nothing when review not found")
        void doesNothing_whenReviewNotFound() {
            when(reviewRepository.findById(999L)).thenReturn(Optional.empty());

            reviewService.delete(999L);

            verify(reviewRepository, never()).deleteById(any());
        }

        @Test
        @DisplayName("deletes review and updates book rating when found")
        void deletesReview_andUpdatesBookRating() {
            when(reviewRepository.findById(100L)).thenReturn(Optional.of(mockReview));

            reviewService.delete(100L);

            verify(reviewRepository).deleteById(100L);
            verify(bookRepository).update(mockBook);
        }

        @Test
        @DisplayName("resets book rating to zero when only one review existed")
        void resetsBookRating_whenOnlyOneReviewExisted() {
            mockBook.setRatingCount(1);
            mockBook.setAverageRating(5.0);

            when(reviewRepository.findById(100L)).thenReturn(Optional.of(mockReview));

            reviewService.delete(100L);

            assertEquals(0, mockBook.getRatingCount());
            assertEquals(0.0, mockBook.getAverageRating());
        }

        @Test
        @DisplayName("recalculates book rating correctly when multiple reviews exist")
        void recalculatesRating_whenMultipleReviewsExist() {
            // 4 reviews at avg 4.0 → total = 16; removing rating 4 → 3 reviews at avg 4.0
            mockBook.setRatingCount(4);
            mockBook.setAverageRating(4.0);
            mockReview = Review.builder()
                    .id(100L).user(mockUser).book(mockBook)
                    .rating(4).comment("good").createdAt(LocalDateTime.now())
                    .build();

            when(reviewRepository.findById(100L)).thenReturn(Optional.of(mockReview));

            reviewService.delete(100L);

            assertEquals(3, mockBook.getRatingCount());
            assertEquals(4.0, mockBook.getAverageRating(), 0.01);
            verify(bookRepository).update(mockBook);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // count / existsById
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("count returns repository count")
    void count_returnsRepositoryCount() {
        when(reviewRepository.count()).thenReturn(15L);

        assertEquals(15L, reviewService.count());
    }

    @Nested
    @DisplayName("existsById")
    class ExistsById {

        @Test
        @DisplayName("returns true when review exists")
        void returnsTrue_whenExists() {
            when(reviewRepository.existsById(100L)).thenReturn(true);

            assertTrue(reviewService.existsById(100L));
        }

        @Test
        @DisplayName("returns false when review does not exist")
        void returnsFalse_whenNotExists() {
            when(reviewRepository.existsById(999L)).thenReturn(false);

            assertFalse(reviewService.existsById(999L));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // getBookReviews
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("getBookReviews")
    class GetBookReviews {

        @Test
        @DisplayName("returns list of ReviewDTOs for given book")
        void returnsReviewDTOs_forBook() {
            when(reviewRepository.findAllByBookId(10, 0, 10))
                    .thenReturn(List.of(mockReview));

            List<ReviewDTO> result = reviewService.getBookReviews(10, 0, 10);

            assertEquals(1, result.size());
            assertEquals(100L, result.get(0).getId());
        }

        @Test
        @DisplayName("returns empty list when no reviews for book")
        void returnsEmptyList_whenNoReviews() {
            when(reviewRepository.findAllByBookId(10, 0, 10)).thenReturn(List.of());

            List<ReviewDTO> result = reviewService.getBookReviews(10, 0, 10);

            assertTrue(result.isEmpty());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // getUserBookReview
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("getUserBookReview")
    class GetUserBookReview {

        @Test
        @DisplayName("returns null when userId is null")
        void returnsNull_whenUserIdNull() {
            assertNull(reviewService.getUserBookReview(null, 10));
            verifyNoInteractions(reviewRepository);
        }

        @Test
        @DisplayName("returns null when bookId is null")
        void returnsNull_whenBookIdNull() {
            assertNull(reviewService.getUserBookReview(1, null));
            verifyNoInteractions(reviewRepository);
        }

        @Test
        @DisplayName("returns ReviewDTO when review found")
        void returnsReviewDTO_whenFound() {
            when(reviewRepository.findByUserIdAndBookId(1, 10))
                    .thenReturn(Optional.of(mockReview));

            ReviewDTO result = reviewService.getUserBookReview(1, 10);

            assertNotNull(result);
            assertEquals(100L, result.getId());
        }

        @Test
        @DisplayName("returns null when no review found for user and book")
        void returnsNull_whenNotFound() {
            when(reviewRepository.findByUserIdAndBookId(1, 10)).thenReturn(Optional.empty());

            assertNull(reviewService.getUserBookReview(1, 10));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // submitReview
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("submitReview")
    class SubmitReview {

        private ReviewRequestDTO validRequest;

        @BeforeEach
        void init() {
            validRequest = new ReviewRequestDTO();
            validRequest.setUserId(1);
            validRequest.setBookId(10);
            validRequest.setRating(5);
            validRequest.setComment("Excellent!");
        }

        @Test
        @DisplayName("returns null when request is null")
        void returnsNull_whenRequestNull() {
            assertNull(reviewService.submitReview(null));
        }

        @Test
        @DisplayName("returns null when userId is null")
        void returnsNull_whenUserIdNull() {
            validRequest.setUserId(null);
            assertNull(reviewService.submitReview(validRequest));
        }

        @Test
        @DisplayName("returns null when bookId is null")
        void returnsNull_whenBookIdNull() {
            validRequest.setBookId(null);
            assertNull(reviewService.submitReview(validRequest));
        }

        @Test
        @DisplayName("returns null when rating is null")
        void returnsNull_whenRatingNull() {
            validRequest.setRating(null);
            assertNull(reviewService.submitReview(validRequest));
        }

        @Test
        @DisplayName("returns null when rating is below 1")
        void returnsNull_whenRatingBelowOne() {
            validRequest.setRating(0);
            assertNull(reviewService.submitReview(validRequest));
        }

        @Test
        @DisplayName("returns null when rating is above 5")
        void returnsNull_whenRatingAboveFive() {
            validRequest.setRating(6);
            assertNull(reviewService.submitReview(validRequest));
        }

        @Test
        @DisplayName("returns null when user not found")
        void returnsNull_whenUserNotFound() {
            when(userRepository.findById(1L)).thenReturn(Optional.empty());
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));

            assertNull(reviewService.submitReview(validRequest));
        }

        @Test
        @DisplayName("returns null when book not found")
        void returnsNull_whenBookNotFound() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.empty());

            assertNull(reviewService.submitReview(validRequest));
        }

        @Test
        @DisplayName("returns null when review already exists for user and book")
        void returnsNull_whenReviewAlreadyExists() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(reviewRepository.findByUserIdAndBookId(1, 10))
                    .thenReturn(Optional.of(mockReview));

            assertNull(reviewService.submitReview(validRequest));
            verify(reviewRepository, never()).save(any());
        }

        @Test
        @DisplayName("saves review and updates book rating on success")
        void savesReview_andUpdatesBookRating() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(reviewRepository.findByUserIdAndBookId(1, 10)).thenReturn(Optional.empty());
            when(reviewRepository.save(any(Review.class))).thenReturn(mockReview);

            ReviewDTO result = reviewService.submitReview(validRequest);

            assertNotNull(result);
            verify(reviewRepository).save(any(Review.class));
            verify(bookRepository).update(mockBook);
        }

        @Test
        @DisplayName("increments book rating count on new review")
        void incrementsRatingCount_onNewReview() {
            int initialCount = mockBook.getRatingCount(); // 4
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(reviewRepository.findByUserIdAndBookId(1, 10)).thenReturn(Optional.empty());
            when(reviewRepository.save(any(Review.class))).thenReturn(mockReview);

            reviewService.submitReview(validRequest);

            assertEquals(initialCount + 1, mockBook.getRatingCount());
        }

        @Test
        @DisplayName("trims whitespace from comment before saving")
        void trimsComment_beforeSaving() {
            validRequest.setComment("  Great!  ");

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(reviewRepository.findByUserIdAndBookId(1, 10)).thenReturn(Optional.empty());
            when(reviewRepository.save(any(Review.class))).thenAnswer(inv -> {
                Review saved = inv.getArgument(0);
                assertEquals("Great!", saved.getComment());
                return mockReview;
            });

            reviewService.submitReview(validRequest);
        }

        @Test
        @DisplayName("saves review with null comment when comment is null")
        void savesNullComment_whenCommentNull() {
            validRequest.setComment(null);

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));
            when(reviewRepository.findByUserIdAndBookId(1, 10)).thenReturn(Optional.empty());
            when(reviewRepository.save(any(Review.class))).thenAnswer(inv -> {
                Review saved = inv.getArgument(0);
                assertNull(saved.getComment());
                return mockReview;
            });

            reviewService.submitReview(validRequest);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // deleteReview (by userId + bookId)
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("deleteReview by userId and bookId")
    class DeleteReview {

        @Test
        @DisplayName("returns false when userId is null")
        void returnsFalse_whenUserIdNull() {
            assertFalse(reviewService.deleteReview(null, 10));
            verifyNoInteractions(reviewRepository);
        }

        @Test
        @DisplayName("returns false when bookId is null")
        void returnsFalse_whenBookIdNull() {
            assertFalse(reviewService.deleteReview(1, null));
            verifyNoInteractions(reviewRepository);
        }

        @Test
        @DisplayName("returns false when review not found")
        void returnsFalse_whenReviewNotFound() {
            when(reviewRepository.findByUserIdAndBookId(1, 10)).thenReturn(Optional.empty());

            assertFalse(reviewService.deleteReview(1, 10));
            verify(reviewRepository, never()).delete(any());
        }

        @Test
        @DisplayName("deletes review and updates book rating when found")
        void deletesReview_andUpdatesBookRating() {
            when(reviewRepository.findByUserIdAndBookId(1, 10))
                    .thenReturn(Optional.of(mockReview));

            boolean result = reviewService.deleteReview(1, 10);

            assertTrue(result);
            verify(reviewRepository).delete(mockReview);
            verify(bookRepository).update(mockBook);
        }

        @Test
        @DisplayName("resets book rating to zero when last review is deleted")
        void resetsBookRating_whenLastReview() {
            mockBook.setRatingCount(1);
            mockBook.setAverageRating(5.0);

            when(reviewRepository.findByUserIdAndBookId(1, 10))
                    .thenReturn(Optional.of(mockReview));

            reviewService.deleteReview(1, 10);

            assertEquals(0, mockBook.getRatingCount());
            assertEquals(0.0, mockBook.getAverageRating());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // toDTO — fullName fallback logic
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("toDTO fullName resolution")
    class ToDTOFullName {

        @Test
        @DisplayName("uses username as fullName when both firstName and lastName are blank")
        void usesUsername_whenNamesBlank() {
            mockUser.setFirstName("");
            mockUser.setLastName(null);

            when(reviewRepository.findById(100L)).thenReturn(Optional.of(mockReview));

            ReviewDTO result = reviewService.findById(100L);

            assertEquals("john_doe", result.getUserFullName());
        }

        @Test
        @DisplayName("builds fullName from firstName and lastName when both present")
        void buildsFullName_whenBothNamesPresent() {
            when(reviewRepository.findById(100L)).thenReturn(Optional.of(mockReview));

            ReviewDTO result = reviewService.findById(100L);

            assertEquals("John Doe", result.getUserFullName());
        }

        @Test
        @DisplayName("uses only firstName when lastName is null")
        void usesFirstNameOnly_whenLastNameNull() {
            mockUser.setLastName(null);

            when(reviewRepository.findById(100L)).thenReturn(Optional.of(mockReview));

            ReviewDTO result = reviewService.findById(100L);

            assertEquals("John", result.getUserFullName());
        }
    }
}
