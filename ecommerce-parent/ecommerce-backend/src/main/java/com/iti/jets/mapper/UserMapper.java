package com.iti.jets.mapper;

import com.iti.jets.model.dto.UserDTO;
import com.iti.jets.model.entity.UserEntity;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface UserMapper {

    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    UserDTO toDTO(UserEntity user);

    UserEntity toEntity(UserDTO userDTO);
}
