package com.iti.jets.model.dto.request;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class LoginRequestDTO {

    private String usernameOrEmail;
    private String password;
}
