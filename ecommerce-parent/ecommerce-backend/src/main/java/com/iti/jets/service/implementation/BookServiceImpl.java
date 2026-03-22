package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.request.BookAddRequestDTO;
import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookAddResponseDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.BookService;

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
    public List<Book> findAllFeatured() {
        return executeInContext(() -> bookRepository.findAllFeatured());
    }

    @Override
    public BookAddResponseDTO addBook(BookAddRequestDTO addRequest) {
        // TODO: Implement it...
        return null;
    }
}
