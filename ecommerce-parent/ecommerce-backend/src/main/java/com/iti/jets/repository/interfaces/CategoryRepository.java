package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.Category;
import com.iti.jets.repository.generic.BaseRepository;

import java.util.Collection;
import java.util.Optional;
import java.util.Set;

public interface CategoryRepository extends BaseRepository<Category, Long> {

    Optional<Category> findByName(String category);

    Set<Long> filterExists(Collection<Long> ids);
}