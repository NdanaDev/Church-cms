package com.ephraim.chruch_cms.service;

import com.ephraim.chruch_cms.dto.AnnouncementCreateRequest;
import com.ephraim.chruch_cms.model.Announcement;
import com.ephraim.chruch_cms.repository.AnnouncementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AnnouncementService {

    private final AnnouncementRepository announcementRepository;

    public List<Announcement> listAnnouncements() {
        return announcementRepository.findAllByOrderByCreatedAtDesc();
    }

    public Announcement createAnnouncement(AnnouncementCreateRequest request, String createdBy) {
        Announcement announcement = new Announcement();
        announcement.setTitle(request.getTitle());
        announcement.setContent(request.getContent());
        announcement.setCreatedBy(createdBy);
        return announcementRepository.save(announcement);
    }
}
