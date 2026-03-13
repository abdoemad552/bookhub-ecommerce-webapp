package com.iti.jets.model.enums;

public enum Government {
    CAIRO("Cairo"),
    GIZA("Giza"),
    ALEXANDRIA("Alexandria"),
    MENOFIA("Menofia"),
    BEHEIRA("Beheira"),
    ISMAILIA("Ismailia"),
    FAYOUM("Fayoum"),
    PORT_SAID("Port Said");

    private final String prettyName;

    Government(String prettyName) {
        this.prettyName = prettyName;
    }

    public String getPrettyName() {
        return this.prettyName;
    }
}
