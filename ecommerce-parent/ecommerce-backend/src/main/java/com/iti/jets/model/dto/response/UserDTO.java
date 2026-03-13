package com.iti.jets.model.dto.response;

import com.iti.jets.model.enums.UserRole;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserDTO {

    private Long id;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private UserRole role;
    private String profilePicUrl;
    private LocalDate birthDate;
    private String job;
    private BigDecimal creditLimit;
    private Boolean emailNotifications;
}