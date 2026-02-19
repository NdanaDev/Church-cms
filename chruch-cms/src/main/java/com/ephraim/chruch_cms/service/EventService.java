package com.ephraim.chruch_cms.service;

import com.ephraim.chruch_cms.dto.EventCreateRequest;
import com.ephraim.chruch_cms.dto.EventUpdateRequest;
import com.ephraim.chruch_cms.exception.ResourceNotFoundException;
import com.ephraim.chruch_cms.model.Event;
import com.ephraim.chruch_cms.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;

    public List<Event> listEvents(LocalDate from, LocalDate to) {
        OffsetDateTime fromDt = from != null ? from.atStartOfDay().atOffset(ZoneOffset.UTC) : null;
        OffsetDateTime toDt = to != null ? to.plusDays(1).atStartOfDay().atOffset(ZoneOffset.UTC) : null;

        if (fromDt != null && toDt != null) {
            return eventRepository.findByDateRange(fromDt, toDt);
        } else if (fromDt != null) {
            return eventRepository.findFromDate(fromDt);
        } else if (toDt != null) {
            return eventRepository.findToDate(toDt);
        } else {
            return eventRepository.findAll(Sort.by("eventDateTime").ascending());
        }
    }

    public Event getEvent(UUID id) {
        return eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found: " + id));
    }

    public Event createEvent(EventCreateRequest request) {
        Event event = new Event();
        event.setTitle(request.getTitle());
        event.setDescription(request.getDescription());
        event.setEventDateTime(request.getEventDateTime());
        event.setLocation(request.getLocation());
        return eventRepository.save(event);
    }

    public Event updateEvent(UUID id, EventUpdateRequest request) {
        Event event = getEvent(id);

        if (request.getTitle() != null) event.setTitle(request.getTitle());
        if (request.getDescription() != null) event.setDescription(request.getDescription());
        if (request.getEventDateTime() != null) event.setEventDateTime(request.getEventDateTime());
        if (request.getLocation() != null) event.setLocation(request.getLocation());

        return eventRepository.save(event);
    }

    public void deleteEvent(UUID id) {
        Event event = getEvent(id);
        eventRepository.delete(event);
    }
}
