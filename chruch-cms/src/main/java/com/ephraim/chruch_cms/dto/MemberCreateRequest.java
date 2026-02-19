package com.ephraim.chruch_cms.dto;

import com.ephraim.chruch_cms.model.MemberStatus;
import com.ephraim.chruch_cms.model.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class MemberCreateRequest {

    @NotBlank
    private String fullName;

    @NotBlank
    @Email
    private String email;

    private String phone;

    @NotNull
    private Role role;

    private MemberStatus status = MemberStatus.ACTIVE;

    private LocalDate joinDate;
}
