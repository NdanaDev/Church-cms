package com.ephraim.chruch_cms.controller;

import com.ephraim.chruch_cms.dto.MemberCreateRequest;
import com.ephraim.chruch_cms.dto.MemberUpdateRequest;
import com.ephraim.chruch_cms.dto.PagedMembersResponse;
import com.ephraim.chruch_cms.model.Member;
import com.ephraim.chruch_cms.service.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/members")
@PreAuthorize("isAuthenticated()")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @GetMapping
    public PagedMembersResponse listMembers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String q) {
        return memberService.listMembers(page, size, q);
    }

    @PostMapping
    public ResponseEntity<Member> createMember(@Valid @RequestBody MemberCreateRequest request) {
        Member member = memberService.createMember(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(member);
    }

    @GetMapping("/{memberId}")
    public Member getMember(@PathVariable UUID memberId) {
        return memberService.getMember(memberId);
    }

    @PutMapping("/{memberId}")
    public Member updateMember(@PathVariable UUID memberId,
                               @Valid @RequestBody MemberUpdateRequest request) {
        return memberService.updateMember(memberId, request);
    }

    @DeleteMapping("/{memberId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteMember(@PathVariable UUID memberId) {
        memberService.deleteMember(memberId);
    }
}
