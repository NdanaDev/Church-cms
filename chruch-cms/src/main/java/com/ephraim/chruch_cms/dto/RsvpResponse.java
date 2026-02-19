package com.ephraim.chruch_cms.dto;

import com.ephraim.chruch_cms.model.RsvpStatus;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.OffsetDateTime;
import java.util.UUID;

@Data
@AllArgsConstructor
public class RsvpResponse {

    private UUID eventId;
    private UUID memberId;
    private RsvpStatus status;
    private OffsetDateTime respondedAt;
}
