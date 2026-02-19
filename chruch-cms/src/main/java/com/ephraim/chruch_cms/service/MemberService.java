package com.ephraim.chruch_cms.service;

import com.ephraim.chruch_cms.dto.MemberCreateRequest;
import com.ephraim.chruch_cms.dto.MemberUpdateRequest;
import com.ephraim.chruch_cms.dto.PagedMembersResponse;
import com.ephraim.chruch_cms.exception.ResourceNotFoundException;
import com.ephraim.chruch_cms.model.Member;
import com.ephraim.chruch_cms.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    public PagedMembersResponse listMembers(int page, int size, String q) {
        PageRequest pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());

        Page<Member> result = (q != null && !q.isBlank())
                ? memberRepository.search(q, pageable)
                : memberRepository.findAll(pageable);

        return new PagedMembersResponse(
                result.getContent(),
                result.getNumber(),
                result.getSize(),
                result.getTotalElements(),
                result.getTotalPages()
        );
    }

    public Member getMember(UUID id) {
        return memberRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found: " + id));
    }

    public Member createMember(MemberCreateRequest request) {
        Member member = new Member();
        member.setFullName(request.getFullName());
        member.setEmail(request.getEmail());
        member.setPhone(request.getPhone());
        member.setRole(request.getRole());
        member.setStatus(request.getStatus());
        member.setJoinDate(request.getJoinDate() != null ? request.getJoinDate() : LocalDate.now());
        return memberRepository.save(member);
    }

    public Member updateMember(UUID id, MemberUpdateRequest request) {
        Member member = getMember(id);

        if (request.getFullName() != null) member.setFullName(request.getFullName());
        if (request.getEmail() != null) member.setEmail(request.getEmail());
        if (request.getPhone() != null) member.setPhone(request.getPhone());
        if (request.getRole() != null) member.setRole(request.getRole());
        if (request.getStatus() != null) member.setStatus(request.getStatus());
        if (request.getJoinDate() != null) member.setJoinDate(request.getJoinDate());

        return memberRepository.save(member);
    }

    public void deleteMember(UUID id) {
        Member member = getMember(id);
        memberRepository.delete(member);
    }
}
