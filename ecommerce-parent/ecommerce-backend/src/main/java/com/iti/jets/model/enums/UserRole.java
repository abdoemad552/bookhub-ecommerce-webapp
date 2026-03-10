package com.iti.jets.model.enums;

public enum UserRole {
    ADMIN,
    USER;

    public String getPrettyName() {
        String lower = this.name().toLowerCase();
        return Character.toUpperCase(lower.charAt(0)) + lower.substring(1);
    }
}
