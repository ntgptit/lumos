package com.lumos.auth.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.lumos.auth.exception.UnauthorizedAccessException;

@Component
public class AuthenticatedUserProvider {

    public Long getCurrentUserId() {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        // Reject requests that are not associated with an authenticated security context.
        if (authentication == null) {
            // Stop immediately because downstream services require a resolved authenticated user id.
            throw new UnauthorizedAccessException();
        }
        final Object principal = authentication.getPrincipal();
        // Accept only the auth principal shape that is issued by the JWT filter.
        if (principal instanceof AuthUserPrincipal authUserPrincipal) {
            // Return the authenticated user id that downstream services use as the ownership key.
            return authUserPrincipal.userId();
        }
        // Stop immediately when the security context carries an unexpected principal implementation.
        throw new UnauthorizedAccessException();
    }
}
