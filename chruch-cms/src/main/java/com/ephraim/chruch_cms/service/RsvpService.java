package com.ephraim.chruch_cms.service;

import com.ephraim.chruch_cms.dto.RsvpRequest;
import com.ephraim.chruch_cms.dto.RsvpResponse;
import com.ephraim.chruch_cms.model.Event;
import com.ephraim.chruch_cms.model.Member;
import com.ephraim.chruch_cms.model.Rsvp;
import com.ephraim.chruch_cms.repository.RsvpRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RsvpService {

    private final RsvpRepository rsvpRepository;
    private final EventService eventService;
    private final MemberService memberService;

    public RsvpResponse rsvp(UUID eventId, UUID memberId, RsvpRequest request) {
        Event event = eventService.getEvent(eventId);
        Member member = memberService.getMember(memberId);

        Rsvp rsvp = rsvpRepository.findByEventIdAndMemberId(eventId, memberId)
                .orElseGet(() -> {
                    Rsvp newRsvp = new Rsvp();
                    newRsvp.setEvent(event);
                    newRsvp.setMember(member);
                    return newRsvp;
                });

        rsvp.setStatus(request.getStatus());
        rsvp = rsvpRepository.save(rsvp);

        return new RsvpResponse(
                event.getId(),
                member.getId(),
                rsvp.getStatus(),
                rsvp.getRespondedAt()
        );
    }
}
