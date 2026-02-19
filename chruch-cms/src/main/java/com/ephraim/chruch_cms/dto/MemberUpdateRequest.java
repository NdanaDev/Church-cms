package com.ephraim.chruch_cms.dto;

import com.ephraim.chruch_cms.model.MemberStatus;
import com.ephraim.chruch_cms.model.Role;
import lombok.Data;

import java.time.LocalDate;

@Data
public class MemberUpdateRequest {

    private String fullName;
    private String email;
    private String phone;
    private Role role;
    private MemberStatus status;
    private LocalDate joinDate;
}
