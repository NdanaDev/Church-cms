package com.ephraim.chruch_cms.repository;

import com.ephraim.chruch_cms.model.Rsvp;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface RsvpRepository extends JpaRepository<Rsvp, UUID> {

    Optional<Rsvp> findByEventIdAndMemberId(UUID eventId, UUID memberId);
}
