package com.iti.jets.model.enums;

public enum Government {
    CAIRO("Cairo", 0),
    GIZA("Giza", 0),
    ALEXANDRIA("Alexandria", 30),
    MENOFIA("Menofia", 25),
    BEHEIRA("Beheira", 25),
    ISMAILIA("Ismailia", 20),
    FAYOUM("Fayoum", 20),
    PORT_SAID("Port_Said", 30);

    private final String prettyName;
    private final Integer shipping;

    Government(String prettyName, Integer shipping) {
        this.prettyName = prettyName;
        this.shipping = shipping;
    }

    public String getPrettyName() {
        return this.prettyName;
    }

    public Integer getShipping() {
        return shipping;
    }
}
