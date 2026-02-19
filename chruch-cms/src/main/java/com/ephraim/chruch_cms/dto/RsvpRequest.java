package com.ephraim.chruch_cms.dto;

import com.ephraim.chruch_cms.model.RsvpStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class RsvpRequest {

    @NotNull
    private RsvpStatus status;
}
