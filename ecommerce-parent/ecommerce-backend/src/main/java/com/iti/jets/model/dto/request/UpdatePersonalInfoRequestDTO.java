package com.iti.jets.model.dto.request;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UpdatePersonalInfoRequestDTO {

    private String firstName;
    private String lastName;
    private String job;
    private LocalDate birthDate;
}