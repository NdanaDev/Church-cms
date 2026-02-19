package com.ephraim.chruch_cms.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class AttendanceSummaryResponse {

    private UUID eventId;
    private int presentCount;
    private int absentCount;
    private int totalMarked;
}
