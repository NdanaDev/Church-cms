package com.ephraim.chruch_cms.dto;

import com.ephraim.chruch_cms.model.AttendanceStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class AttendanceUpsertRequest {

    @NotNull
    private UUID memberId;

    @NotNull
    private AttendanceStatus status;
}
