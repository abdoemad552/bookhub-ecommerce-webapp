package com.iti.jets.model.dto.response;

import com.iti.jets.model.entity.Book;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class BookCardDTO {
    private long id;
    private String title;
    private List<AuthorDTO> authors;
    private String description;
    private double averageRating;
    private BigDecimal price;
    private String coverPicUrl;
    private int stockQuantity;

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
            book.getPrice(),
            book.getImageUrl(),
            book.getStockQuantity()
        );
    }
}
