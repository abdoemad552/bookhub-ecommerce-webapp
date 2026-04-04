package com.iti.jets.repository.implementation;

import com.iti.jets.model.entity.Category;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.CategoryRepository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

public class CategoryRepositoryImpl extends BaseRepositoryImpl<Category, Long> implements CategoryRepository {

    @Override
    public Optional<Category> findByName(String name) {
        return executeReadOnly(em -> em
            .createQuery("SELECT c FROM Category c WHERE c.name = :name", Category.class)
            .setParameter("name", name)
            .getResultStream()
            .findFirst()
        );
    }

    @Override
    public Set<Long> filterExists(Collection<Long> ids) {
        return executeReadOnly(em -> em.createQuery(
                "SELECT c.id FROM Category c WHERE c.id IN :ids", Long.class
            )
            .setParameter("ids", ids)
            .getResultStream()
            .collect(Collectors.toSet())
        );
    }
}