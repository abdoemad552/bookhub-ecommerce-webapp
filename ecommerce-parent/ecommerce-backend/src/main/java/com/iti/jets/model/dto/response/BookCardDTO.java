package com.iti.jets.model.dto.response;

import java.util.List;

public class BookCardDTO {
    private String title;
    private List<AuthorDTO> authors;
    private double averageRating;
    // At most 255 characters...
    private String description;
    private double price;
    private int stockQuantity;
    // TODO: Tags...
}
