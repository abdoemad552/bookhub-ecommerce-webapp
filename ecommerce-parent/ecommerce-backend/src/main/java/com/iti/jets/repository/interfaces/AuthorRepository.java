package com.iti.jets.repository.interfaces;

import com.iti.jets.model.dto.response.AuthorStatsDTO;
import com.iti.jets.model.entity.Author;
import com.iti.jets.repository.generic.BaseRepository;

public interface AuthorRepository extends BaseRepository<Author, Long> {

    AuthorStatsDTO getAuthorStats(Long authorId);
}
