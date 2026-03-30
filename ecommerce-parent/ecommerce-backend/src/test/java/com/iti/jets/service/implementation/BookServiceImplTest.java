package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.request.BookAddRequestDTO;
import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookAddResponseDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.dto.response.BookSummaryDTO;
import com.iti.jets.model.dto.response.PageResponseDTO;
import com.iti.jets.model.entity.*;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.CategoryRepository;
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
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("BookServiceImpl Tests")
class BookServiceImplTest {

    @Mock
    private BookRepository bookRepository;

    @Mock
    private CategoryRepository categoryRepository;

    @InjectMocks
    private BookServiceImpl bookService;

    private Book mockBook;
    private Category mockCategory;

    @BeforeEach
    void setUp() {
        mockCategory = Category.builder()
                .name("Fiction")
                .build();
        mockCategory.setId(1L);

        mockBook = new Book();
        mockBook.setId(10L);
        mockBook.setTitle("Clean Code");
        mockBook.setIsbn("978-0132350884");
        mockBook.setPrice(new BigDecimal("39.99"));
        mockBook.setStockQuantity(20);
        mockBook.setAverageRating(4.5);
        mockBook.setCategory(mockCategory);
        mockBook.setBookAuthors(Set.of());
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findById
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findById")
    class FindById {

        @Test
        @DisplayName("returns Book when found")
        void returnsBook_whenFound() {
            when(bookRepository.findById(10L)).thenReturn(Optional.of(mockBook));

            Book result = bookService.findById(10L);

            assertNotNull(result);
            assertEquals(10L, result.getId());
        }

        @Test
        @DisplayName("returns null when not found")
        void returnsNull_whenNotFound() {
            when(bookRepository.findById(99L)).thenReturn(Optional.empty());

            assertNull(bookService.findById(99L));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAll (paged, no filter)
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAll paged")
    class FindAllPaged {

        @Test
        @DisplayName("returns list of books from repository")
        void returnsBooks() {
            when(bookRepository.findAll(0, 10)).thenReturn(List.of(mockBook));

            List<Book> result = bookService.findAll(0, 10);

            assertEquals(1, result.size());
            assertEquals(mockBook, result.get(0));
        }

        @Test
        @DisplayName("returns empty list when no books on page")
        void returnsEmptyList_whenNoBooksOnPage() {
            when(bookRepository.findAll(5, 10)).thenReturn(List.of());

            assertTrue(bookService.findAll(5, 10).isEmpty());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAllSummary
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAllSummary")
    class FindAllSummary {

        @Test
        @DisplayName("returns empty content when repository returns no books")
        void returnsEmptyContent_whenNoBooksFound() {
            when(bookRepository.findAllSummary(0, 10)).thenReturn(List.of());
            when(bookRepository.count()).thenReturn(0L);

            PageResponseDTO<BookSummaryDTO> result = bookService.findAllSummary(0, 10);

            assertTrue(result.getContent().isEmpty());
            assertEquals(0L, result.getTotalPages());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAllBookCard
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAllBookCard")
    class FindAllBookCard {

        @Test
        @DisplayName("returns PageResponseDTO with BookCardDTOs and correct count")
        void returnsPageResponse_withBookCards() {
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of(mockBook));
            when(bookRepository.count(filter)).thenReturn(1L);

            PageResponseDTO<BookCardDTO> result = bookService.findAllBookCard(0, 10, filter);

            assertNotNull(result);
            assertEquals(1, result.getContent().size());
            assertEquals(1L, result.getTotalPages());
        }

        @Test
        @DisplayName("returns empty page when no books match filter")
        void returnsEmptyPage_whenNoMatch() {
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of());
            when(bookRepository.count(filter)).thenReturn(0L);

            PageResponseDTO<BookCardDTO> result = bookService.findAllBookCard(0, 10, filter);

            assertTrue(result.getContent().isEmpty());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // delete
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("delete delegates deleteById to repository")
    void delete_delegatesToRepository() {
        bookService.delete(10L);

        verify(bookRepository).deleteById(10L);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // existsById
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("existsById")
    class ExistsById {

        @Test
        @DisplayName("returns true when book exists")
        void returnsTrue_whenExists() {
            when(bookRepository.existsById(10L)).thenReturn(true);

            assertTrue(bookService.existsById(10L));
        }

        @Test
        @DisplayName("returns false when book does not exist")
        void returnsFalse_whenNotExists() {
            when(bookRepository.existsById(99L)).thenReturn(false);

            assertFalse(bookService.existsById(99L));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAll with filter
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAll with filter")
    class FindAllWithFilter {

        @Test
        @DisplayName("delegates to repository with filter")
        void delegatesToRepository_withFilter() {
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of(mockBook));

            List<Book> result = bookService.findAll(0, 10, filter);

            assertEquals(1, result.size());
            verify(bookRepository).findAll(0, 10, filter);
        }

        @Test
        @DisplayName("returns empty list when no books match filter")
        void returnsEmpty_whenNoMatch() {
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of());

            assertTrue(bookService.findAll(0, 10, filter).isEmpty());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAllCards
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAllCards")
    class FindAllCards {

        @Test
        @DisplayName("maps books to BookCardDTOs")
        void mapsBooksToBookCardDTOs() {
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of(mockBook));

            List<BookCardDTO> result = bookService.findAllCards(0, 10, filter);

            assertEquals(1, result.size());
            assertEquals(mockBook.getId(), result.get(0).getId());
            assertEquals(mockBook.getTitle(), result.get(0).getTitle());
        }

        @Test
        @DisplayName("returns empty list when no books match")
        void returnsEmpty_whenNoMatch() {
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of());

            assertTrue(bookService.findAllCards(0, 10, filter).isEmpty());
        }

        @Test
        @DisplayName("defaults price to ZERO when book price is null")
        void defaultsPriceToZero_whenNull() {
            mockBook.setPrice(null);
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of(mockBook));

            List<BookCardDTO> result = bookService.findAllCards(0, 10, filter);

            assertEquals(BigDecimal.ZERO, result.get(0).getPrice());
        }

        @Test
        @DisplayName("defaults stockQuantity to 0 when null")
        void defaultsStockQuantity_whenNull() {
            mockBook.setStockQuantity(null);
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of(mockBook));

            List<BookCardDTO> result = bookService.findAllCards(0, 10, filter);

            assertEquals(0, result.get(0).getStockQuantity());
        }

        @Test
        @DisplayName("defaults averageRating to 0 when null")
        void defaultsAverageRating_whenNull() {
            mockBook.setAverageRating(null);
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of(mockBook));

            List<BookCardDTO> result = bookService.findAllCards(0, 10, filter);

            assertEquals(0L, result.get(0).getAverageRating());
        }

        @Test
        @DisplayName("rounds averageRating correctly")
        void roundsAverageRating_correctly() {
            mockBook.setAverageRating(3.6);
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of(mockBook));

            List<BookCardDTO> result = bookService.findAllCards(0, 10, filter);

            assertEquals(4L, result.get(0).getAverageRating());
        }

        @Test
        @DisplayName("returns empty authors list when bookAuthors is null")
        void returnsEmptyAuthors_whenBookAuthorsNull() {
            mockBook.setBookAuthors(null);
            BookFilterDTO filter = new BookFilterDTO();
            when(bookRepository.findAll(0, 10, filter)).thenReturn(List.of(mockBook));

            List<BookCardDTO> result = bookService.findAllCards(0, 10, filter);

            assertTrue(result.get(0).getAuthors().isEmpty());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAllFeatured
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAllFeatured")
    class FindAllFeatured {

        @Test
        @DisplayName("returns featured books from repository")
        void returnsFeaturedBooks() {
            when(bookRepository.findAllFeatured()).thenReturn(List.of(mockBook));

            List<Book> result = bookService.findAllFeatured();

            assertEquals(1, result.size());
            verify(bookRepository).findAllFeatured();
        }

        @Test
        @DisplayName("returns empty list when no featured books")
        void returnsEmpty_whenNoFeatured() {
            when(bookRepository.findAllFeatured()).thenReturn(List.of());

            assertTrue(bookService.findAllFeatured().isEmpty());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // addBook
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("addBook")
    class AddBook {

        private BookAddRequestDTO validRequest;

        @BeforeEach
        void init() {
            validRequest = new BookAddRequestDTO();
            validRequest.setTitle("  Effective Java  ");
            validRequest.setIsbn("978-0134685991");
            validRequest.setDescription("  A must-read  ");
            validRequest.setPrice(new BigDecimal("49.99"));
            validRequest.setStockQuantity(10);
            validRequest.setPublishDate(LocalDate.of(2018, 1, 6));
            validRequest.setCategory("Programming");
            validRequest.setAuthors(List.of("Joshua Bloch"));
        }

        @Test
        @DisplayName("returns empty Optional when ISBN already exists")
        void returnsEmpty_whenIsbnAlreadyExists() {
            when(bookRepository.findByIsbn("978-0134685991")).thenReturn(Optional.of(mockBook));

            Optional<BookAddResponseDTO> result = bookService.addBook(validRequest);

            assertTrue(result.isEmpty());
            verify(bookRepository, never()).save(any());
        }

        @Test
        @DisplayName("creates new category when it does not exist")
        void createsNewCategory_whenNotFound() {
            Category newCategory = Category.builder().name("Programming").build();
            newCategory.setId(5L);

            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName("Programming")).thenReturn(Optional.empty());
            when(categoryRepository.save(any(Category.class))).thenReturn(newCategory);
            when(bookRepository.save(any(Book.class))).thenReturn(mockBook);

            bookService.addBook(validRequest);

            verify(categoryRepository).save(any(Category.class));
        }

        @Test
        @DisplayName("reuses existing category when found")
        void reusesExistingCategory_whenFound() {
            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName("Programming")).thenReturn(Optional.of(mockCategory));
            when(bookRepository.save(any(Book.class))).thenReturn(mockBook);

            bookService.addBook(validRequest);

            verify(categoryRepository, never()).save(any());
        }

        @Test
        @DisplayName("saves book and returns Optional with response DTO")
        void savesBook_andReturnsDTO() {
            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName("Programming")).thenReturn(Optional.of(mockCategory));
            when(bookRepository.save(any(Book.class))).thenReturn(mockBook);

            Optional<BookAddResponseDTO> result = bookService.addBook(validRequest);

            assertTrue(result.isPresent());
            assertEquals(mockBook.getId(), result.get().getBookId());
            verify(bookRepository).save(any(Book.class));
        }

        @Test
        @DisplayName("trims title and description before saving")
        void trimsFields_beforeSaving() {
            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName(anyString())).thenReturn(Optional.of(mockCategory));
            when(bookRepository.save(any(Book.class))).thenAnswer(inv -> inv.getArgument(0));

            bookService.addBook(validRequest);

            ArgumentCaptor<Book> captor = ArgumentCaptor.forClass(Book.class);
            verify(bookRepository).save(captor.capture());
            assertEquals("Effective Java", captor.getValue().getTitle());
            assertEquals("A must-read", captor.getValue().getDescription());
        }

        @Test
        @DisplayName("trims category name before lookup")
        void trimsCategoryName_beforeLookup() {
            validRequest.setCategory("  Programming  ");
            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName("Programming")).thenReturn(Optional.of(mockCategory));
            when(bookRepository.save(any(Book.class))).thenReturn(mockBook);

            bookService.addBook(validRequest);

            verify(categoryRepository).findByName("Programming");
        }

        @Test
        @DisplayName("adds authors to book entity")
        void addsAuthors_toBookEntity() {
            validRequest.setAuthors(List.of("Joshua Bloch", "Brian Goetz"));

            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName(anyString())).thenReturn(Optional.of(mockCategory));
            when(bookRepository.save(any(Book.class))).thenAnswer(inv -> inv.getArgument(0));

            bookService.addBook(validRequest);

            ArgumentCaptor<Book> captor = ArgumentCaptor.forClass(Book.class);
            verify(bookRepository).save(captor.capture());
            assertEquals(2, captor.getValue().getBookAuthors().size());
        }

        @Test
        @DisplayName("skips blank author names")
        void skipsBlankAuthors() {
            validRequest.setAuthors(List.of("Joshua Bloch", "  ", ""));

            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName(anyString())).thenReturn(Optional.of(mockCategory));
            when(bookRepository.save(any(Book.class))).thenAnswer(inv -> inv.getArgument(0));

            bookService.addBook(validRequest);

            ArgumentCaptor<Book> captor = ArgumentCaptor.forClass(Book.class);
            verify(bookRepository).save(captor.capture());
            // only "Joshua Bloch" should be added
            assertEquals(1, captor.getValue().getBookAuthors().size());
        }

        @Test
        @DisplayName("handles null authors list without error")
        void handlesNullAuthorsList() {
            validRequest.setAuthors(null);

            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName(anyString())).thenReturn(Optional.of(mockCategory));
            when(bookRepository.save(any(Book.class))).thenAnswer(inv -> inv.getArgument(0));

            assertDoesNotThrow(() -> bookService.addBook(validRequest));
        }

        @Test
        @DisplayName("handles null description without error")
        void handlesNullDescription() {
            validRequest.setDescription(null);

            when(bookRepository.findByIsbn(anyString())).thenReturn(Optional.empty());
            when(categoryRepository.findByName(anyString())).thenReturn(Optional.of(mockCategory));
            when(bookRepository.save(any(Book.class))).thenAnswer(inv -> inv.getArgument(0));

            ArgumentCaptor<Book> captor = ArgumentCaptor.forClass(Book.class);
            bookService.addBook(validRequest);
            verify(bookRepository).save(captor.capture());
            assertNull(captor.getValue().getDescription());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // updateCoverUrl
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("updateCoverUrl delegates to repository")
    void updateCoverUrl_delegatesToRepository() {
        bookService.updateCoverUrl(10L, "http://example.com/cover.jpg");

        verify(bookRepository).updateCoverUrl(10L, "http://example.com/cover.jpg");
    }
}
