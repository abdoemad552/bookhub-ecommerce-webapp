package com.iti.jets.service.generic;

import java.util.List;

public interface BaseService<T, ID> {
    T findById(ID id);

    List<T> findAll();

    List<T> findAll(int pageNumber, int pageSize);

    void delete(ID id);

    long count();

    boolean existsById(ID id);
}