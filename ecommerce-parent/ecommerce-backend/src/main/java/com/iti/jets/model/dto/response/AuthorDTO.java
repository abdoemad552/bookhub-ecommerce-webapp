package com.iti.jets.model.dto.response;

import com.iti.jets.model.entity.Author;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class AuthorDTO {
    private Long id;
    private String name;

    public static AuthorDTO from(Author author) {
        return AuthorDTO.builder()
            .id(author.getId())
            .name(author.getName())
            .build();
    }
}
