package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.response.AuthorDTO;
import com.iti.jets.model.dto.response.AuthorStatsDTO;
import com.iti.jets.service.generic.BaseService;

public interface AuthorService extends BaseService<AuthorDTO, Long> {

    AuthorStatsDTO getAuthorStats(Long authorId);
}
