package com.iti.jets.model.dto.request;

import com.iti.jets.model.enums.AddressType;
import com.iti.jets.model.enums.Government;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class AddressRequestDTO {

    private AddressType addressType;
    private Government government;
    private String city;
    private String street;
    private String buildingNo;
    private String description;
}