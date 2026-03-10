package com.iti.jets.model.enums;

public enum Government {
    CAIRO,
    GIZA,
    ALEXANDRIA,
    MENOFIA,
    BEHEIRA,
    ISMAILIA,
    FAYOUM,
    PORT_SAID;

    public String getPrettyName() {
        String lower = this.name().toLowerCase();
        return Character.toUpperCase(lower.charAt(0)) + lower.substring(1);
    }
}
