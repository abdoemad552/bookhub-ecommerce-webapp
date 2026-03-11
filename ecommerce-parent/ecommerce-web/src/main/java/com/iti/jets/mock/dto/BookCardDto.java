package com.iti.jets.mock.dto;

public class BookCardDto {
    private String title;
    private String author;
    private String description;
    private double averageRating;
    private double price;
    private String coverPicUrl;

    public BookCardDto(String title, String author, String description, double averageRating, double price, String coverPicUrl) {
        this.title = title;
        this.author = author;
        this.description = description;
        this.averageRating = averageRating;
        this.price = price;
        this.coverPicUrl = coverPicUrl;
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
}
