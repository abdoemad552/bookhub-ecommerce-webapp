package com.iti.jets.model.dto.response;

import com.iti.jets.model.entity.Book;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
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
    private long id;
    private String title;
    private List<AuthorDTO> authors;
    private String description;
    private double averageRating;
    private int exactAverageRating;
    private BigDecimal price;
    private String coverPicUrl;
    private int stockQuantity;
    private String imageUrl;
    // TODO: Tags...

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

    public String getCoverPicUrl() {
        return imageUrl;
    }

    public static BookCardDTO from(Book book) {
        return new BookCardDTO(
            book.getId(),
            book.getTitle(),
            book.getBookAuthors()
                .stream()
                .map(bo -> AuthorDTO.builder()
                    .id(bo.getAuthor().getId())
                    .name(bo.getAuthor().getName())
                    .build()
                )
                .toList(),
            book.getDescription(),
            book.getAverageRating(),
            book.getAverageRating().intValue(),
            book.getPrice(),
            book.getImageUrl(),
            book.getStockQuantity()
        );
    }
}
