package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.generic.BaseService;

import java.util.Collection;
import java.util.Set;

public interface CategoryService extends BaseService<CategoryDTO, Long> {

    Set<Long> filterExists(Collection<Long> ids);

    BaseResponse<Void> addCategory(String name);
}
