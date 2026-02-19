package com.ephraim.chruch_cms.dto;

import lombok.Data;

import java.time.OffsetDateTime;

@Data
public class EventUpdateRequest {

    private String title;
    private String description;
    private OffsetDateTime eventDateTime;
    private String location;
}
