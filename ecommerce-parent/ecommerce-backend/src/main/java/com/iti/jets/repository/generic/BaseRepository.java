package com.iti.jets.repository.generic;

import java.util.List;
import java.util.Optional;

public interface BaseRepository<T, ID> {

    T save(T entity);

    T update(T entity);

    Optional<T> findById(ID id);

    List<T> findAll();

    List<T> findAll(int pageNumber, int pageSize);

    void delete(T entity);

    void deleteById(ID id);

    long count();

    boolean existsById(ID id);
}