package com.iti.jets.model.dto.response;

import com.iti.jets.model.entity.Book;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import lombok.Builder;
import lombok.ToString;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class BookCardDTO {
    private Long            id;
    private String          title;
    private List<AuthorDTO> authors;
    private String          description;
    private double          averageRating;
    private int             exactAverageRating;
    private BigDecimal      price;
    private String          coverPicUrl;
    private int             stockQuantity;

    public String getAuthor() {
        if (authors == null || authors.isEmpty()) {
            return "";
        }

        return authors.stream()
            .filter(Objects::nonNull)
            .map(AuthorDTO::getName)
            .filter(name -> name != null && !name.isBlank())
            .collect(Collectors.joining(", "));
    }

    public static BookCardDTO from(Book book) {
        double averageRating = book.getAverageRating() == null ? 0.0 : book.getAverageRating();
        int exactAverageRating = Math.max(0, Math.min(5, (int) Math.floor(averageRating)));

        return new BookCardDTO(
            book.getId(),
            book.getTitle(),
            (book.getBookAuthors() == null ? List.<com.iti.jets.model.entity.BookAuthor>of() : book.getBookAuthors())
                .stream()
                .filter(Objects::nonNull)
                .map(com.iti.jets.model.entity.BookAuthor::getAuthor)
                .filter(Objects::nonNull)
                .filter(author -> author.getName() != null && !author.getName().isBlank())
                .map(author -> AuthorDTO.builder()
                    .id(author.getId())
                    .name(author.getName())
                    .build()
                )
                .toList(),
            book.getDescription(),
            averageRating,
            exactAverageRating,
            book.getPrice() == null ? BigDecimal.ZERO : book.getPrice(),
            book.getImageUrl(),
            book.getStockQuantity() == null ? 0 : book.getStockQuantity()
        );
    }
}
