package com.iti.jets.model.enums;

public enum UserRole {
    ADMIN("Admin"),
    USER("User");

    private final String prettyName;

    UserRole(String prettyName) {
        this.prettyName = prettyName;
    }

    public String getPrettyName() {
        return this.prettyName;
    }
}
