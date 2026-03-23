package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.request.BookAddRequestDTO;
import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookAddResponseDTO;
import com.iti.jets.model.entity.Author;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Category;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.BookService;

import java.util.List;
import java.util.Optional;

public class BookServiceImpl extends ContextHandler implements BookService {

    private final BookRepository bookRepository;
    private final CategoryRepository categoryRepository;

    public BookServiceImpl(BookRepository bookRepository, CategoryRepository categoryRepository) {
        this.bookRepository = bookRepository;
        this.categoryRepository = categoryRepository;
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
    public List<Book> findAllFeatured() {
        return executeInContext(bookRepository::findAllFeatured);
    }

    @Override
    public Optional<BookAddResponseDTO> addBook(BookAddRequestDTO addRequest) {

        if (bookRepository.findByIsbn(addRequest.getIsbn()).isPresent()) {
            return Optional.empty();
        }

        Category category = findOrCreateCategory(addRequest.getCategory());

//        String imagePath = saveImage(addRequest.getImageBytes(), addRequest.getImageFileName());

        Book book = toEntity(addRequest, category);

        Book saved = bookRepository.save(book);

        return Optional.of(new BookAddResponseDTO(saved.getId(), null));
    }

    @Override
    public void updateCoverUrl(Long bookId, String coverUrl) {
        executeInContext(() -> bookRepository.updateCoverUrl(bookId, coverUrl));
    }

    private Category findOrCreateCategory(String category) {
        return categoryRepository.findByName(category.trim())
            .orElseGet(() -> {
                Category newCategory = Category.builder()
                    .name(category.trim())
                    .build();
                return categoryRepository.save(newCategory);
            });
    }

    private Book toEntity(BookAddRequestDTO dto, Category category) {
        Book book = new Book();
        book.setTitle(dto.getTitle().trim());
        book.setDescription(dto.getDescription() != null ? dto.getDescription().trim() : null);
        book.setPrice(dto.getPrice());
        book.setStockQuantity(dto.getStockQuantity());
        book.setPublishDate(dto.getPublishDate());
        book.setIsbn(dto.getIsbn().trim());
        book.setCategory(category);
        book.setBookType(dto.getBookType());
        book.setPages(dto.getPages());

        if (dto.getAuthors() != null) {
            dto.getAuthors().stream()
                .filter(name -> name != null && !name.isBlank())
                .map(name -> {
                    Author author = new Author();
                    author.setName(name);
                    return author;
                })
                .forEach(book::addAuthor);  // keeps bidirectional ref in sync
        }

        return book;
    }
}
