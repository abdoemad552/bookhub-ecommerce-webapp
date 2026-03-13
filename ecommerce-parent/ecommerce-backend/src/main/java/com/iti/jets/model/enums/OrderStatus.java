package com.iti.jets.model.enums;

public enum OrderStatus {
    PENDING("Pending"),
    PAID("Paid"),
    CANCELLED("Canceled"),
    SHIPPED("Shipped"),
    DELIVERED("Delivered");

    private final String prettyName;

    OrderStatus(String prettyName) {
        this.prettyName = prettyName;
    }

    public String getPrettyName() {
        return this.prettyName;
    }
}
