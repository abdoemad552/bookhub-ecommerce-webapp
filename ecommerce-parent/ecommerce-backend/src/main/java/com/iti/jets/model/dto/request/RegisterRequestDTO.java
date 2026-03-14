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

    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private String password;
    private String confirmPassword;
    private LocalDate birthDate;
    private String job;
    private BigDecimal creditLimit;
    private Boolean emailNotifications;

    private Set<Long> categoryIds;
}
