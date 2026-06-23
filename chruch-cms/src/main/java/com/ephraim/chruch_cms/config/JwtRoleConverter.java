package com.ephraim.chruch_cms.config;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.Map;
import java.util.Set;

/**
 * Maps the application role carried in a Supabase JWT to a Spring Security
 * authority of the form {@code ROLE_<ROLE>} so that {@code hasRole(...)} and
 * {@code hasAnyRole(...)} expressions work in {@code @PreAuthorize} guards.
 *
 * <p>The role is looked up in the top-level {@code role} claim first. Because
 * Supabase populates that claim with its own values ({@code authenticated},
 * {@code anon}, {@code service_role}), those are ignored and the application
 * role is instead read from {@code app_metadata.role} and then
 * {@code user_metadata.role}.
 */
@Component
public class JwtRoleConverter implements Converter<Jwt, AbstractAuthenticationToken> {

    private static final Set<String> SUPABASE_RESERVED_ROLES =
            Set.of("authenticated", "anon", "service_role");

    @Override
    public AbstractAuthenticationToken convert(Jwt jwt) {
        String role = extractRole(jwt);
        Set<GrantedAuthority> authorities = (role == null || role.isBlank())
                ? Collections.emptySet()
                : Set.of(new SimpleGrantedAuthority("ROLE_" + role.trim().toUpperCase()));
        return new JwtAuthenticationToken(jwt, authorities);
    }

    private String extractRole(Jwt jwt) {
        String role = jwt.getClaimAsString("role");
        if (role != null && !role.isBlank() && !SUPABASE_RESERVED_ROLES.contains(role)) {
            return role;
        }
        String fromApp = roleFromMap(jwt.getClaim("app_metadata"));
        if (fromApp != null) {
            return fromApp;
        }
        return roleFromMap(jwt.getClaim("user_metadata"));
    }

    private String roleFromMap(Object claim) {
        if (claim instanceof Map<?, ?> map) {
            Object role = map.get("role");
            return role != null ? role.toString() : null;
        }
        return null;
    }
}
