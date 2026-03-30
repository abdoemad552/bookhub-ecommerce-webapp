package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.BookAddRequestDTO;
import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookAddResponseDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.dto.response.BookSummaryDTO;
import com.iti.jets.model.dto.response.PageResponseDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.service.generic.BaseService;

import java.util.List;
import java.util.Optional;

public interface BookService extends BaseService<Book, Long> {

    List<Book> findAll(int pageNumber, int pageSize, BookFilterDTO filter);

    List<BookCardDTO> findAllCards(int pageNumber, int pageSize, BookFilterDTO filter);

    List<Book> findAllFeatured();

    PageResponseDTO<BookSummaryDTO> findAllSummary(int page, int size);

    PageResponseDTO<BookCardDTO> findAllBookCard(int page, int size, BookFilterDTO filter);

    Optional<BookAddResponseDTO> addBook(BookAddRequestDTO addRequest);

    void updateCoverUrl(Long bookId, String coverUrl);

    PageResponseDTO<BookCardDTO> findAuthoredBooks(Long authorId, int page, int size);

    Long countAuthoredBooks(Long authorId);
}
