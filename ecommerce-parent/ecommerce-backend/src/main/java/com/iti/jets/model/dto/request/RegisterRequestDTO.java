package com.iti.jets.model.dto.request;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class RegisterRequestDTO {

    private String username;
    private String email;
    private String password;
    // TODO: Not needed...
    private String confirmPassword;
    private String firstName;
    private String lastName;
    private LocalDate birthDate;
    private String job;
    private BigDecimal creditLimit;

    private Set<Long> categoryIds;
}
