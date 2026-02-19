package com.ephraim.chruch_cms.controller;

import com.ephraim.chruch_cms.dto.AnnouncementCreateRequest;
import com.ephraim.chruch_cms.model.Announcement;
import com.ephraim.chruch_cms.service.AnnouncementService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/announcements")
@PreAuthorize("isAuthenticated()")
@RequiredArgsConstructor
public class AnnouncementController {

    private final AnnouncementService announcementService;

    @GetMapping
    public List<Announcement> listAnnouncements() {
        return announcementService.listAnnouncements();
    }

    @PostMapping
    public ResponseEntity<Announcement> createAnnouncement(
            @Valid @RequestBody AnnouncementCreateRequest request,
            @AuthenticationPrincipal Jwt jwt) {
        Announcement announcement = announcementService.createAnnouncement(
                request, jwt.getSubject());
        return ResponseEntity.status(HttpStatus.CREATED).body(announcement);
    }
}
