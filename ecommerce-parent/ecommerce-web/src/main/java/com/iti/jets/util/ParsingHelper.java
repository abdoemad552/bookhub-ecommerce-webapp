package com.iti.jets.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class ParsingHelper {

    private static final Logger LOGGER = LoggerFactory.getLogger(ParsingHelper.class);

    public static LocalDate parseDate(String value) {
        if (value == null || value.isBlank()) return null;
        try {
            return LocalDate.parse(value);
        } catch (DateTimeParseException e) {
            LOGGER.warn("Invalid date format: {}", value);
            return null;
        }
    }

    public static BigDecimal parseBigDecimal(String value) {
        if (value == null || value.isBlank()) return BigDecimal.ZERO;
        try {
            BigDecimal v = new BigDecimal(value);
            return v.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : v;
        } catch (NumberFormatException e) {
            LOGGER.warn("Invalid BigDecimal value: {}", value);
            return BigDecimal.ZERO;
        }
    }
}
