package com.ephraim.chruch_cms.repository;

import com.ephraim.chruch_cms.model.Member;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.UUID;

public interface MemberRepository extends JpaRepository<Member, UUID> {

    @Query("SELECT m FROM Member m WHERE "
         + "LOWER(m.fullName) LIKE LOWER(CONCAT('%', :q, '%')) OR "
         + "LOWER(m.email) LIKE LOWER(CONCAT('%', :q, '%')) OR "
         + "LOWER(m.phone) LIKE LOWER(CONCAT('%', :q, '%'))")
    Page<Member> search(@Param("q") String q, Pageable pageable);
}
