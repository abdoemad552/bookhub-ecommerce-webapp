package com.iti.jets.mapper;

import com.iti.jets.model.dto.response.*;
import com.iti.jets.model.entity.Address;
import com.iti.jets.model.entity.Category;
import com.iti.jets.model.entity.User;

import java.util.Collections;
import java.util.Set;
import java.util.stream.Collectors;


public class UserMapper {

    private static final UserMapper INSTANCE = new UserMapper();

    private UserMapper() {
    }

    public static UserMapper getInstance() {
        return INSTANCE;
    }

    public UserDTO toDTO(User user) {
        if (user == null) return null;

        return UserDTO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .role(user.getRole())
                .profilePicUrl(user.getProfilePicUrl())
                .birthDate(user.getBirthDate())
                .job(user.getJob())
                .creditLimit(user.getCreditLimit())
                .emailNotifications(user.getEmailNotifications())
                .build();
    }

    public UserInterestsDTO toUserInterestsDTO(User user) {
        if (user == null) return null;

        return UserInterestsDTO.builder()
                .userId(user.getId())
                .interests(mapCategories(user))
                .build();
    }

    public UserAddressesDTO toUserAddressesDTO(User user) {
        if (user == null) return null;

        return UserAddressesDTO.builder()
                .userId(user.getId())
                .addresses(mapAddresses(user))
                .build();
    }

    public UserDetailsDTO toUserDetailsDTO(User user) {
        if (user == null) return null;

        return UserDetailsDTO.builder()
                .user(toDTO(user))
                .addresses(mapAddresses(user))
                .interests(mapCategories(user))
                .build();
    }

    public AddressDTO toAddressDTO(Address address) {
        if (address == null) return null;

        return AddressDTO.builder()
                .id(address.getId())
                .street(address.getStreet())
                .city(address.getCity())
                .buildingNo(address.getBuildingNo())
                .government(address.getGovernment())
                .addressType(address.getAddressType())
                .description(address.getDescription())
                .build();
    }

    public CategoryDTO toCategoryDTO(Category category) {
        if (category == null) return null;

        return CategoryDTO.builder()
                .id(category.getId())
                .name(category.getName())
                .description(category.getDescription())
                .build();
    }

    // Helper Methods
    private Set<AddressDTO> mapAddresses(User user) {
        if (user.getAddresses() == null || user.getAddresses().isEmpty()) {
            return Collections.emptySet();
        }
        return user.getAddresses()
                .stream()
                .map(this::toAddressDTO)
                .collect(Collectors.toSet());
    }

    private Set<CategoryDTO> mapCategories(User user) {
        if (user.getInterests() == null || user.getInterests().isEmpty()) {
            return Collections.emptySet();
        }
        // uses special getter from User entity
        return user.getCategories()
                .stream()
                .map(this::toCategoryDTO)
                .collect(Collectors.toSet());
    }
}