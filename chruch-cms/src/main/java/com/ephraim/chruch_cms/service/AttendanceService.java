package com.ephraim.chruch_cms.service;

import com.ephraim.chruch_cms.dto.AttendanceSummaryResponse;
import com.ephraim.chruch_cms.dto.AttendanceUpsertRequest;
import com.ephraim.chruch_cms.model.*;
import com.ephraim.chruch_cms.repository.AttendanceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AttendanceService {

    private final AttendanceRepository attendanceRepository;
    private final EventService eventService;
    private final MemberService memberService;

    public List<Attendance> listAttendance(UUID eventId) {
        eventService.getEvent(eventId); // verify event exists
        return attendanceRepository.findByEventId(eventId);
    }

    public Attendance recordAttendance(UUID eventId, AttendanceUpsertRequest request) {
        Event event = eventService.getEvent(eventId);
        Member member = memberService.getMember(request.getMemberId());

        Attendance attendance = attendanceRepository.findByEventIdAndMemberId(eventId, request.getMemberId())
                .orElseGet(() -> {
                    Attendance newRecord = new Attendance();
                    newRecord.setEvent(event);
                    newRecord.setMember(member);
                    return newRecord;
                });

        attendance.setStatus(request.getStatus());
        return attendanceRepository.save(attendance);
    }

    public AttendanceSummaryResponse getSummary(UUID eventId) {
        eventService.getEvent(eventId); // verify event exists

        int presentCount = attendanceRepository.countByEventIdAndStatus(eventId, AttendanceStatus.PRESENT);
        int absentCount = attendanceRepository.countByEventIdAndStatus(eventId, AttendanceStatus.ABSENT);
        int totalMarked = presentCount + absentCount;

        return new AttendanceSummaryResponse(eventId, presentCount, absentCount, totalMarked);
    }
}
