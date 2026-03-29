package com.iti.jets.model.dto.request;

import lombok.*;

import java.time.LocalDate;
import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"currentPassword", "newPassword", "confirmNewPassword"})
public class UpdatePersonalInfoRequestDTO {

    private String firstName;
    private String lastName;
    private String job;
    private LocalDate birthDate;
    private Boolean emailNotifications;
    private String currentPassword;
    private String newPassword;
    private String confirmNewPassword;
    private Set<Long> interestIds;
}
