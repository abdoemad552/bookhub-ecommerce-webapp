package com.iti.jets.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
@AllArgsConstructor
public class PageResponseDTO<T> {

    private static final int DELTA = 2;

    private final List<T> content;
    private final int     page;
    private final int     size;
    private final long    totalElements;
    private final int     totalPages;
    private final int     left;
    private final int     right;

    public PageResponseDTO(List<T> content, int page, int size, long totalElements) {
        this.content       = content;
        this.page          = page;
        this.size          = size;
        this.totalElements = totalElements;
        this.totalPages    = (size == 0) ? 0 : (int) Math.ceil((double) totalElements / size);
        this.left          = Math.max(1, page - DELTA);
        this.right         = Math.min(this.totalPages, page + DELTA);
    }
}
