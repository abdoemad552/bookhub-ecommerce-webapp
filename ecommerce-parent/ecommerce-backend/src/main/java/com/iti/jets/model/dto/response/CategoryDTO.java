package com.iti.jets.model.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CategoryDTO {

    private Long id;
    private String name;
    private String description;
}
