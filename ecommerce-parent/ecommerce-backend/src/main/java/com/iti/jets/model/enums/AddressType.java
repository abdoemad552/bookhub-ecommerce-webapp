package com.iti.jets.model.enums;

public enum AddressType {
    SHIPPING("Shipping"),
    HOME("Home"),
    WORK("Work");

    private final String prettyName;

    AddressType(String prettyName) {
        this.prettyName = prettyName;
    }

    public String getPrettyName() {
        return prettyName;
    }
}
