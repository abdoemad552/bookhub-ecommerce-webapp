package com.iti.jets.model.enums;

public enum OrderStatus {
    CONFIRMED("Confirmed"),
    PROCESSING("Processing"),
    DELIVERED("Delivered"),
    CANCELLED("Canceled");

    private final String prettyName;

    OrderStatus(String prettyName) {
        this.prettyName = prettyName;
    }

    public String getPrettyName() {
        return this.prettyName;
    }
}
