package com.iti.jets.model.dto.response;

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
    private Long id;
    private String title;
    private List<AuthorDTO> authors;
    private double averageRating;
    // At most 255 characters...
    private String description;
    private double price;
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
}
