package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.service.generic.BaseService;

import java.util.List;

public interface BookService extends BaseService<Book, Long> {

    List<Book> findAll(int pageNumber, int pageSize, BookFilterDTO filter);

    List<BookCardDTO> findAllCards(int pageNumber, int pageSize, BookFilterDTO filter);

    List<Book> findAllFeatured();
}
