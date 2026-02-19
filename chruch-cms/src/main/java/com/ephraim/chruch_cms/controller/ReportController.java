package com.ephraim.chruch_cms.controller;

import com.ephraim.chruch_cms.dto.ReportsSummaryResponse;
import com.ephraim.chruch_cms.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/reports")
@PreAuthorize("isAuthenticated()")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @GetMapping("/summary")
    public ReportsSummaryResponse getSummary() {
        return reportService.getSummary();
    }
}
