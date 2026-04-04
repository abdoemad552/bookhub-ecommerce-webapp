package com.iti.jets.repository.interfaces;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.repository.generic.BaseRepository;

import java.util.List;
import java.util.Optional;

public interface BookRepository extends BaseRepository<Book, Long> {

    List<Book> findAll(int pageNumber, int pageSize, BookFilterDTO filter);

    long count(BookFilterDTO filter);

    List<Book> findAllFeatured();

    List<Book> findAllSummary(int page, int size);

    Optional<Book> findByIsbn(String isbn);

    void updateCoverUrl(Long bookId, String coverUrl);

    int deductStock(Long bookId, int quantity);

    List<Book> findAuthoredBooks(Long authorId, int page, int size);

    Long countAuthoredBooks(Long authorId);
}
