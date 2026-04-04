package com.iti.jets.model.entity;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class AddressConverter implements AttributeConverter<Address, String> {

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public String convertToDatabaseColumn(Address address) {
        try {
            return mapper.writeValueAsString(address);
        } catch (Exception e) {
            throw new RuntimeException("Error converting address to JSON", e);
        }
    }

    @Override
    public Address convertToEntityAttribute(String json) {
        try {
            return mapper.readValue(json, Address.class);
        } catch (Exception e) {
            throw new RuntimeException("Error converting JSON to address", e);
        }
    }
}