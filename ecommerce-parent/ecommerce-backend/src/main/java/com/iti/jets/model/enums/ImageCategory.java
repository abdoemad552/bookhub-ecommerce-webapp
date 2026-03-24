package com.iti.jets.model.enums;

public enum ImageCategory {

    PROFILE("profiles"),
    BOOK("books");

    private final String folder;

    ImageCategory(String folder) {
        this.folder = folder;
    }

    public String getFolder() {
        return folder;
    }
}
