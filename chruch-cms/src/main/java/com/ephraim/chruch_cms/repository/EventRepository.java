package com.ephraim.chruch_cms.repository;

import com.ephraim.chruch_cms.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public interface EventRepository extends JpaRepository<Event, UUID> {

    @Query("SELECT e FROM Event e WHERE e.eventDateTime >= :from AND e.eventDateTime <= :to ORDER BY e.eventDateTime")
    List<Event> findByDateRange(@Param("from") OffsetDateTime from, @Param("to") OffsetDateTime to);

    @Query("SELECT e FROM Event e WHERE e.eventDateTime >= :from ORDER BY e.eventDateTime")
    List<Event> findFromDate(@Param("from") OffsetDateTime from);

    @Query("SELECT e FROM Event e WHERE e.eventDateTime <= :to ORDER BY e.eventDateTime")
    List<Event> findToDate(@Param("to") OffsetDateTime to);

    long countByEventDateTimeAfter(OffsetDateTime dateTime);
}
