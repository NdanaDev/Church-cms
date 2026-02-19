package com.ephraim.chruch_cms.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.OffsetDateTime;

@Data
public class EventCreateRequest {

    @NotBlank
    private String title;

    private String description;

    @NotNull
    private OffsetDateTime eventDateTime;

    private String location;
}
