package com.iti.jets.service.implementation;

import com.iti.jets.mapper.CategoryMapper;
import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.model.entity.Category;
import com.iti.jets.model.entity.User;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Optional;

public class CategoryServiceImpl extends ContextHandler implements CategoryService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CategoryServiceImpl.class);

    private final CategoryRepository categoryRepository;
    private final CategoryMapper categoryMapper;

    public CategoryServiceImpl(CategoryRepository categoryRepository,
                               CategoryMapper categoryMapper) {
        this.categoryRepository = categoryRepository;
        this.categoryMapper = categoryMapper;
    }

    @Override
    public CategoryDTO findById(Long id) {
        return executeInContext(() -> {
            Optional<Category> categoryOpt = categoryRepository.findById(id);
            if (categoryOpt.isPresent()) {
                return categoryMapper.toDTO(categoryOpt.get());
            } else {
                return null;
            }
        });
    }

    @Override
    public List<CategoryDTO> findAll() {
        return executeInContext(() -> {
            return categoryRepository.findAll().stream()
                    .map(categoryMapper::toDTO)
                    .toList();
        });
    }

    @Override
    public List<CategoryDTO> findAll(int pageNumber, int pageSize) {
        return executeInContext(() -> categoryRepository
                .findAll(pageNumber, pageSize)
                .stream()
                .map(categoryMapper::toDTO)
                .toList()
        );
    }

    @Override
    public void delete(Long id) {
        executeInContext(() -> {
            Optional<Category> categoryOpt = categoryRepository.findById(id);
            if (categoryOpt.isPresent()) {
                categoryRepository.delete(categoryOpt.get());
            }
        });
    }

    @Override
    public long count() {
        return executeInContext(categoryRepository::count);
    }

    @Override
    public boolean existsById(Long id) {
        return executeInContext(() -> categoryRepository.existsById(id));
    }
}
