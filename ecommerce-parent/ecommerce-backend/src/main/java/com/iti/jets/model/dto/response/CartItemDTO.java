package com.iti.jets.model.dto.response;

import java.util.List;

public class CartItemDTO {
    private int bookId;
    private int quantity;
    private String bookTitle;
    private String bookCoverUrl;
    private List<AuthorDTO> authors;
    private double price;
    private int amount;
}
