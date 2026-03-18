package com.iti.jets.mapper;

import com.iti.jets.model.dto.response.AddressDTO;
import com.iti.jets.model.entity.Address;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface AddressMapper {

    AddressMapper INSTANCE = Mappers.getMapper(AddressMapper.class);

    AddressDTO toDTO(Address address);
}
