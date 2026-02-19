package com.ephraim.chruch_cms.controller;

import com.ephraim.chruch_cms.dto.EventCreateRequest;
import com.ephraim.chruch_cms.dto.EventUpdateRequest;
import com.ephraim.chruch_cms.dto.RsvpRequest;
import com.ephraim.chruch_cms.dto.RsvpResponse;
import com.ephraim.chruch_cms.model.Event;
import com.ephraim.chruch_cms.service.EventService;
import com.ephraim.chruch_cms.service.RsvpService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/events")
@PreAuthorize("isAuthenticated()")
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;
    private final RsvpService rsvpService;

    @GetMapping
    public List<Event> listEvents(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        return eventService.listEvents(from, to);
    }

    @PostMapping
    public ResponseEntity<Event> createEvent(@Valid @RequestBody EventCreateRequest request) {
        Event event = eventService.createEvent(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(event);
    }

    @GetMapping("/{eventId}")
    public Event getEvent(@PathVariable UUID eventId) {
        return eventService.getEvent(eventId);
    }

    @PutMapping("/{eventId}")
    public Event updateEvent(@PathVariable UUID eventId,
                             @Valid @RequestBody EventUpdateRequest request) {
        return eventService.updateEvent(eventId, request);
    }

    @DeleteMapping("/{eventId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteEvent(@PathVariable UUID eventId) {
        eventService.deleteEvent(eventId);
    }

    @PostMapping("/{eventId}/rsvp")
    public RsvpResponse rsvp(@PathVariable UUID eventId,
                             @RequestParam UUID memberId,
                             @Valid @RequestBody RsvpRequest request) {
        return rsvpService.rsvp(eventId, memberId, request);
    }
}
