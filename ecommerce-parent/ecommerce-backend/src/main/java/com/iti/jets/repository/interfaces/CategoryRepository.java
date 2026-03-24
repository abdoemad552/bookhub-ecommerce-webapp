package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.Category;
import com.iti.jets.repository.generic.BaseRepository;

import java.util.Optional;

public interface CategoryRepository extends BaseRepository<Category, Long> {

    Optional<Category> findByName(String category);
}