package com.ephraim.chruch_cms.dto;

import com.ephraim.chruch_cms.model.Member;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class PagedMembersResponse {

    private List<Member> items;
    private int page;
    private int size;
    private long totalItems;
    private int totalPages;
}
