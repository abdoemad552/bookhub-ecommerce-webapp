package com.iti.jets.model.enums;

public enum AddressType {
    HOME("Home"),
    WORK("Work"),
    SHIPPING("Shipping"),
    ONLINE("Online");

    private final String prettyName;

    AddressType(String prettyName) {
        this.prettyName = prettyName;
    }

    public String getPrettyName() {
        return prettyName;
    }
}
