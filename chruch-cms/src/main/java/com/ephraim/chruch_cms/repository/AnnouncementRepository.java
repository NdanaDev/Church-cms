package com.ephraim.chruch_cms.repository;

import com.ephraim.chruch_cms.model.Announcement;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface AnnouncementRepository extends JpaRepository<Announcement, UUID> {

    List<Announcement> findAllByOrderByCreatedAtDesc();
}
