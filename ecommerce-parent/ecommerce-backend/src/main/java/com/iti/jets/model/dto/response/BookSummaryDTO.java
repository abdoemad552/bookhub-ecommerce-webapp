package com.iti.jets.model.dto.response;

import com.iti.jets.model.entity.Book;
import com.iti.jets.model.enums.BookType;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class BookSummaryDTO {
    private final long              id;
    private final String            isbn;
    private final String            title;
    private final String            description;
    private final List<AuthorDTO>   authors;
    private final BigDecimal        price;
    private final int               stockQuantity;
    private final String            category;
    private final BookType          bookType;
    private final int               pages;
    private final LocalDate         publishDate;
    private final String            coverUrl;

    public static BookSummaryDTO from(Book book) {
        return BookSummaryDTO.builder()
            .id(book.getId())
            .isbn(book.getIsbn())
            .title(book.getTitle())
            .description(book.getDescription())
            .authors(book.getBookAuthors()
                .stream()
                .map(bo -> AuthorDTO.builder()
                    .id(bo.getAuthor().getId())
                    .name(bo.getAuthor().getName())
                    .build()
                )
                .toList()
            )
            .price(book.getPrice())
            .stockQuantity(book.getStockQuantity())
            .category(book.getCategory().getName())
            .bookType(book.getBookType())
            .pages(book.getPages())
            .publishDate(book.getPublishDate())
            .coverUrl(book.getImageUrl())
            .build();
    }
}
