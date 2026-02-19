package com.ephraim.chruch_cms.repository;

import com.ephraim.chruch_cms.model.Attendance;
import com.ephraim.chruch_cms.model.AttendanceStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface AttendanceRepository extends JpaRepository<Attendance, UUID> {

    List<Attendance> findByEventId(UUID eventId);

    Optional<Attendance> findByEventIdAndMemberId(UUID eventId, UUID memberId);

    int countByEventIdAndStatus(UUID eventId, AttendanceStatus status);

    int countByEventId(UUID eventId);

    int countByStatusAndRecordedAtBetween(AttendanceStatus status, OffsetDateTime from, OffsetDateTime to);

    int countByRecordedAtBetween(OffsetDateTime from, OffsetDateTime to);
}
