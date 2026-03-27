package com.iti.jets.model.enums;

public enum Government {
    CAIRO("Cairo", 0),
    GIZA("Giza", 0),
    ALEXANDRIA("Alexandria", 30),
    MENOFIA("Menofia", 25),
    BEHEIRA("Beheira", 25),
    ISMAILIA("Ismailia", 20),
    FAYOUM("Fayoum", 20),
    PORT_SAID("Port Said", 30);

    private final String prettyName;
    private final Integer shipping;

    Government(String prettyName, Integer shipping) {
        this.prettyName = prettyName;
        this.shipping = shipping;
    }

    public static Government fromPrettyName(String prettyName) {
        for (Government gov : Government.values()) {
            if (gov.prettyName.equalsIgnoreCase(prettyName)) {
                return gov;
            }
        }
        throw new IllegalArgumentException("No enum constant for prettyName: " + prettyName);
    }

    public String getPrettyName() {
        return this.prettyName;
    }

    public Integer getShipping() {
        return shipping;
    }
}
