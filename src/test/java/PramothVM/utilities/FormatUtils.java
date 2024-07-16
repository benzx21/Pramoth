package PramothVM.utilities;

import PramothVM.constants.Utility;
import org.apache.commons.lang3.StringUtils;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

import static PramothVM.constants.Utility.*;


public final class FormatUtils {

    public static String getString(String value) {
        return isNullOrEmpty(value) ? "" : value;
    }

    public static boolean isNullOrEmpty(String value) {
        return value == null || value.isBlank();
    }

    public static long dateToEpoch(LocalDateTime date) {
        return date.toEpochSecond(ZoneOffset.UTC);
    }

    public static LocalDate toLocalDateNull(String value) {
        if (isNullOrEmpty(value)) {
            return null;
        }
        return LocalDate.parse(value.trim(), DateTimeFormatter.ofPattern(DATE_FORMAT_DDMMMYYYY));
    }

    public static String localDateToString(LocalDate date, String format) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(format);
        return date.format(formatter);
    }

    public static String formatStringDate(final String value) {
        return formatStringDate(value, DATE_FORMATTER_YYYYMMDD);
    }

    public static String formatStringDate(String value, DateTimeFormatter formatter) {
        if (isNullOrEmpty(value)) {
            return null;
        }

        String oldFormat;
        if (value.contains(":")) {
            oldFormat = DATE_TIME_FORMAT_DDMMYYYY_HHMMSS;
        } else if (value.contains("-")) {
            oldFormat = DATE_FORMAT_DDMMMYYYY;
        } else {
            oldFormat = DATE_FORMAT_DDMMYYYY;
        }

        return LocalDate
                .parse(value, DateTimeFormatter.ofPattern(oldFormat))
                .format(formatter);
    }

    public static String resolveDateValue(final String name, final String value, final String format) {
        //TODO remove unused param name
        return resolveDateValue(value, format);
    }

    public static String resolveDateValue(final String value, String format) {
        if (StringUtils.isEmpty(format)) {
            format = DATE_FORMAT_DDMMMYYYY;
        }

        if (!value.startsWith("@dateDR(T") && !value.startsWith("@dateDRS(T") && !value.startsWith("@dateD(T") &&
                !value.startsWith("@date(T") && !value.startsWith("T")) {
            return value;
        }

        LocalDate today = LocalDate.now();
        final String daysOffset = value.replaceAll("[^-0-9]", "");

        if (daysOffset.isBlank()) {
            return localDateToString(today, format);
        }

        long offset = Long.parseLong(daysOffset);
        int step = Long.signum(offset); // -1:Negatives 1:Positives
        long days = Math.abs(offset); // Numbers of days to add or subtract

        do {
            today = today.plusDays(step);
            if (!(today.getDayOfWeek() == DayOfWeek.SATURDAY || today.getDayOfWeek() == DayOfWeek.SUNDAY)) {
                --days;
            }
        } while (days > 0);

        return localDateToString(today, format);
    }

    public static String replaceDateValue(String value) {
        if (value.contains("@date")) {
            String date = value.substring(value.indexOf("@"), value.lastIndexOf(")") + 1);
            value = value.replace(date, resolveValue("Report", date));
        }

        return value;
    }

    public static String resolveAbsValue(final String name, final String value) {
        //TODO remove unused param name
        if (!value.startsWith("@abs(")) {
            return value;
        }

        final String parameter = value.substring(5, value.indexOf(")"));

        return parameter.replace("-", "");
    }

    public static String resolveValue(final String name, final String value) {

        if (value == null) {
            return null;
        }

        if (value.startsWith("@dateDR(T")) {
            return resolveDateValue(name, value, Utility.DATE_FORMAT_YYYYMMDD_WITHOUT);
        }

        if (value.startsWith("@dateDRS(T")) {
            return resolveDateValue(name, value, Utility.DATE_FORMAT_DDMMYYYY_WITHOUT);
        }

        if (value.startsWith("@dateD(T")) {
            return resolveDateValue(name, value, Utility.DATE_FORMAT_MMDDYYYY);
        }

        if (value.startsWith("@date(T")) {
            return resolveDateValue(name, value, Utility.DATE_FORMAT_DDMMMYYYY);
        }

        if (value.startsWith("@abs(")) {
            return resolveAbsValue(name, value);
        }

        return value;
    }
}
