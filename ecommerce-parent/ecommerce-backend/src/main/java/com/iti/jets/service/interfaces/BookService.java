package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.BookAddRequestDTO;
import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookAddResponseDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.service.generic.BaseService;

import java.util.List;

public interface BookService extends BaseService<Book, Long> {

    List<Book> findAll(int pageNumber, int pageSize, BookFilterDTO filter);

    List<Book> findAllFeatured();

    BookAddResponseDTO addBook(BookAddRequestDTO addRequest);
}
