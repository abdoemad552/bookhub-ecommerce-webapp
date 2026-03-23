package com.iti.jets.mock.dto;

public class BookCardDto {
    private int id;
    private String title;
    private String author;
    private String description;
    private double averageRating;
    private double price;
    private String coverPicUrl;
    private int stockQuantity;

    public BookCardDto(int id, String title, String author, String description, double averageRating, double price, String coverPicUrl, int stockQuantity) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.description = description;
        this.averageRating = averageRating;
        this.price = price;
        this.coverPicUrl = coverPicUrl;
        this.stockQuantity = stockQuantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getCoverPicUrl() {
        return coverPicUrl;
    }

    public void setCoverPicUrl(String coverPicUrl) {
        this.coverPicUrl = coverPicUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
}
