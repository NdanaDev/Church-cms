package com.ephraim.chruch_cms.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;

@Data
@AllArgsConstructor
public class ReportsSummaryResponse {

    private long totalMembers;
    private long upcomingEvents;
    private WeeklyAttendance weeklyAttendance;

    @Data
    @AllArgsConstructor
    public static class WeeklyAttendance {
        private LocalDate weekStart;
        private int presentCount;
        private int eventsCount;
    }
}
