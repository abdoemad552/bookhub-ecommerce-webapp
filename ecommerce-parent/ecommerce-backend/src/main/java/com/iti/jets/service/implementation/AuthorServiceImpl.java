package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.response.AuthorDTO;
import com.iti.jets.model.dto.response.AuthorStatsDTO;
import com.iti.jets.repository.interfaces.AuthorRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.AuthorService;

public class AuthorServiceImpl extends ContextHandler implements AuthorService {

    private final AuthorRepository authorRepository;

    public AuthorServiceImpl(AuthorRepository authorRepository) {
        this.authorRepository = authorRepository;
    }

    @Override
    public AuthorDTO findById(Long authorId) {
        return executeInContext(() -> authorRepository.findById(authorId).map(AuthorDTO::from).orElse(null));
    }

    @Override
    public AuthorStatsDTO getAuthorStats(Long authorId) {
        return executeInContext(() -> authorRepository.getAuthorStats(authorId));
    }
}
