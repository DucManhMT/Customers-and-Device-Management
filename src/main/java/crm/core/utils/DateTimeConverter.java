package crm.core.utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class DateTimeConverter {
    public static LocalDateTime toStartOfDay(LocalDate date) {
        return date.atStartOfDay();
    }

    public static LocalDateTime toEndOfDay(LocalDate date) {
        return date.atTime(LocalTime.MAX).minusSeconds(1);
    }

    public static LocalDate toDate(LocalDateTime dateTime) {
        return dateTime.toLocalDate();
    }
}
