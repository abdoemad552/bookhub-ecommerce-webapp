package com.iti.jets.model.dto.response;

import lombok.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookAddResponseDTO {
    private Long bookId;
    private String coverUrl;
}
