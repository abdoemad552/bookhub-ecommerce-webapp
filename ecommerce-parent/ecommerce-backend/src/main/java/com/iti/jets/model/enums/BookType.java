package com.iti.jets.model.enums;

public enum BookType {
    PAPERBACK("Paperback"),
    HARDCOVER("Hardcover"),
    EBOOK("E-Book");

    private final String prettyName;

    BookType(String prettyName) {
        this.prettyName = prettyName;
    }

    public String getPrettyName() {
        return prettyName;
    }
}
