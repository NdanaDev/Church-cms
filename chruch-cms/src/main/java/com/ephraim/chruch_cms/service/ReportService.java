package com.ephraim.chruch_cms.service;

import com.ephraim.chruch_cms.dto.ReportsSummaryResponse;
import com.ephraim.chruch_cms.model.AttendanceStatus;
import com.ephraim.chruch_cms.repository.AttendanceRepository;
import com.ephraim.chruch_cms.repository.EventRepository;
import com.ephraim.chruch_cms.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.temporal.TemporalAdjusters;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final MemberRepository memberRepository;
    private final EventRepository eventRepository;
    private final AttendanceRepository attendanceRepository;

    public ReportsSummaryResponse getSummary() {
        long totalMembers = memberRepository.count();
        long upcomingEvents = eventRepository.countByEventDateTimeAfter(OffsetDateTime.now());

        // Weekly attendance: current week starting Monday
        LocalDate weekStart = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        OffsetDateTime weekStartDt = weekStart.atStartOfDay().atOffset(ZoneOffset.UTC);
        OffsetDateTime weekEndDt = weekStart.plusDays(7).atStartOfDay().atOffset(ZoneOffset.UTC);

        int presentCount = attendanceRepository.countByStatusAndRecordedAtBetween(
                AttendanceStatus.PRESENT, weekStartDt, weekEndDt);

        // Count distinct events that have attendance records this week
        int totalAttendanceThisWeek = attendanceRepository.countByRecordedAtBetween(weekStartDt, weekEndDt);
        // Use event count from the event repo for events this week
        int eventsCount = eventRepository.findByDateRange(weekStartDt, weekEndDt).size();

        ReportsSummaryResponse.WeeklyAttendance weekly =
                new ReportsSummaryResponse.WeeklyAttendance(weekStart, presentCount, eventsCount);

        return new ReportsSummaryResponse(totalMembers, upcomingEvents, weekly);
    }
}
