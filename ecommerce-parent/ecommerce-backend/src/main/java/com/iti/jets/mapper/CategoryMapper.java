package com.iti.jets.mapper;

import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.model.entity.Category;

public class CategoryMapper {

    private static final CategoryMapper INSTANCE = new CategoryMapper();

    private CategoryMapper() {
    }

    public static CategoryMapper getInstance() {
        return INSTANCE;
    }

    public CategoryDTO toDTO(Category category) {
        return CategoryDTO.builder()
                .id(category.getId())
                .name(category.getName())
                .description(category.getDescription())
                .build();
    }
}
