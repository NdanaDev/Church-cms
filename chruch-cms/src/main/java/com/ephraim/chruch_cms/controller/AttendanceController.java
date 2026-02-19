package com.ephraim.chruch_cms.controller;

import com.ephraim.chruch_cms.dto.AttendanceSummaryResponse;
import com.ephraim.chruch_cms.dto.AttendanceUpsertRequest;
import com.ephraim.chruch_cms.model.Attendance;
import com.ephraim.chruch_cms.service.AttendanceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/events/{eventId}/attendance")
@PreAuthorize("isAuthenticated()")
@RequiredArgsConstructor
public class AttendanceController {

    private final AttendanceService attendanceService;

    @GetMapping
    public List<Attendance> listAttendance(@PathVariable UUID eventId) {
        return attendanceService.listAttendance(eventId);
    }

    @PostMapping
    public Attendance recordAttendance(@PathVariable UUID eventId,
                                       @Valid @RequestBody AttendanceUpsertRequest request) {
        return attendanceService.recordAttendance(eventId, request);
    }

    @GetMapping("/summary")
    public AttendanceSummaryResponse getSummary(@PathVariable UUID eventId) {
        return attendanceService.getSummary(eventId);
    }
}
