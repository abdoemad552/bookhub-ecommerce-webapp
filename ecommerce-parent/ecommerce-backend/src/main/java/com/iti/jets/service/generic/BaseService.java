package com.iti.jets.service.generic;

import java.util.List;

public interface BaseService<T, ID> {
    default T findById(ID id) {
        return null;
    }

    default List<T> findAll() {
        return List.of();
    }

    default List<T> findAll(int pageNumber, int pageSize) {
        return List.of();
    }

    default void delete(ID id) {
    }

    default long count() {
        return 0;
    }

    default boolean existsById(ID id) {
        return false;
    }
}
