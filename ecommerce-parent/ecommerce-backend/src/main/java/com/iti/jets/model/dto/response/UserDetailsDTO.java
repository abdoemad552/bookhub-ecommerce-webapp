package com.iti.jets.model.dto.response;

import lombok.*;

import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserDetailsDTO {

    private UserDTO user;
    private Set<AddressDTO> addresses;
    private Set<CategoryDTO> interests;
}
