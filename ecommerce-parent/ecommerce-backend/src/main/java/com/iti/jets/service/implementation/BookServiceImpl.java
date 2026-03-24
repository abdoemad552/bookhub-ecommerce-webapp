package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.AuthorDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.BookService;

import java.util.Comparator;
import java.util.List;

public class BookServiceImpl extends ContextHandler implements BookService {

    private final BookRepository bookRepository;

    public BookServiceImpl(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    @Override
    public Book findById(Long id) {
        return executeInContext(() -> bookRepository.findById(id).orElse(null));
    }

    @Override
    public List<Book> findAll(int pageNumber, int pageSize) {
        return executeInContext(() -> bookRepository.findAll(pageNumber, pageSize));
    }

    @Override
    public void delete(Long id) {
        executeInContext(() -> bookRepository.deleteById(id));
    }

    @Override
    public boolean existsById(Long id) {
        return executeInContext(() -> bookRepository.existsById(id));
    }

    @Override
    public List<Book> findAll(int pageNumber, int pageSize, BookFilterDTO filter) {
        return executeInContext(() -> bookRepository.findAll(pageNumber, pageSize, filter));
    }

    @Override
    public List<BookCardDTO> findAllCards(int pageNumber, int pageSize, BookFilterDTO filter) {
        return executeInContext(() -> bookRepository.findAll(pageNumber, pageSize, filter)
                .stream()
                .map(this::toBookCardDto)
                .toList()
        );
    }

    @Override
    public List<Book> findAllFeatured() {
        return executeInContext(() -> bookRepository.findAllFeatured());
    }

    private BookCardDTO toBookCardDto(Book book) {
        List<AuthorDTO> authorDtos = book.getBookAuthors() == null ? List.of()
                : book.getBookAuthors().stream()
                .map(bookAuthor -> bookAuthor.getAuthor())
                .filter(author -> author != null && author.getName() != null && !author.getName().isBlank())
                .collect(java.util.stream.Collectors.toMap(
                        author -> author.getId(),
                        author -> {
                            AuthorDTO dto = new AuthorDTO();
                            dto.setId(author.getId());
                            dto.setName(author.getName());
                            return dto;
                        },
                        (existing,newOne) -> existing
                ))
                .values().stream()
                .sorted(Comparator.comparing(AuthorDTO::getName))
                .toList();

        return BookCardDTO.builder()
                .id(book.getId())
                .title(book.getTitle())
                .authors(authorDtos)
                .averageRating(book.getAverageRating() == null ? 0 : Math.round(book.getAverageRating()))
                .description(book.getDescription())
                .price(book.getPrice() == null ? 0.0 : book.getPrice().doubleValue())
                .stockQuantity(book.getStockQuantity() == null ? 0 : book.getStockQuantity())
                .build();
    }
}
