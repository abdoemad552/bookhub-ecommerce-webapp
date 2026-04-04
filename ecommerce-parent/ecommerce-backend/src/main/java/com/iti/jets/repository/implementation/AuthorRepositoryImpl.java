package com.iti.jets.repository.implementation;

import com.iti.jets.model.dto.response.AuthorStatsDTO;
import com.iti.jets.model.entity.Author;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.AuthorRepository;

import java.util.Optional;

public class AuthorRepositoryImpl extends BaseRepositoryImpl<Author, Long>
        implements AuthorRepository {

    @Override
    public AuthorStatsDTO getAuthorStats(Long authorId) {
        return executeReadOnly(em -> em
            .createQuery("""
            SELECT new com.iti.jets.model.dto.response.AuthorStatsDTO(
                COUNT(DISTINCT ba.book.id),
                COALESCE(AVG(r.rating), 0.0),
                COUNT(r.id)
            )
            FROM BookAuthor ba
            LEFT JOIN Review r ON r.book = ba.book
            WHERE ba.author.id = :authorId
            """, AuthorStatsDTO.class)
            .setParameter("authorId", authorId)
            .getSingleResult()
        );
    }

    @Override
    public Optional<Author> findByName(String name) {
        return executeReadOnly(em -> em
            .createQuery("SELECT a FROM Author a WHERE a.name = :name", Author.class)
            .setParameter("name", name)
            .getResultStream()
            .findFirst()
        );
    }
}
