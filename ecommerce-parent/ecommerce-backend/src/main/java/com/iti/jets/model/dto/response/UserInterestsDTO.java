package com.iti.jets.model.dto.response;

import lombok.*;

import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserInterestsDTO {

    private Long userId;
    private Set<CategoryDTO> interests;
}