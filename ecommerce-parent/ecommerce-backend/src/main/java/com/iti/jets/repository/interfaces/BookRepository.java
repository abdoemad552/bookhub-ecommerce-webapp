package com.iti.jets.repository.interfaces;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.repository.generic.BaseRepository;
import com.iti.jets.service.generic.BaseService;

import java.util.List;

public interface BookRepository extends BaseRepository<Book, Long> {

    List<Book> findAll(int pageNumber, int pageSize, BookFilterDTO filter);

    List<Book> findAllFeatured();
}
