package com.lumos.common.config;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.lang.reflect.Field;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

class CorsConfigTest {

    @Test
    @SuppressWarnings("unchecked")
    void addCorsMappings_registersConfiguredCorsValues() throws Exception {
        final var properties = new CorsProperties(
                List.of("http://localhost:3000"),
                List.of("GET", "POST"),
                List.of("Content-Type", "Authorization"),
                List.of("X-Trace-Id"),
                true,
                3600L);
        final var config = new CorsConfig(properties);
        final var registry = new CorsRegistry();

        config.addCorsMappings(registry);

        final var registrationsField = CorsRegistry.class.getDeclaredField("registrations");
        registrationsField.setAccessible(true);
        final var registrations = (List<Object>) registrationsField.get(registry);
        assertEquals(1, registrations.size());

        final var registration = registrations.get(0);
        assertEquals(ConfigConstants.CORS_PATH_PATTERN, readField(registration, "pathPattern"));

        final var corsConfiguration = (CorsConfiguration) readField(registration, "config");
        assertEquals(properties.allowedOrigins(), corsConfiguration.getAllowedOriginPatterns());
        assertEquals(properties.allowedMethods(), corsConfiguration.getAllowedMethods());
        assertEquals(properties.allowedHeaders(), corsConfiguration.getAllowedHeaders());
        assertEquals(properties.exposedHeaders(), corsConfiguration.getExposedHeaders());
        assertEquals(Boolean.TRUE, corsConfiguration.getAllowCredentials());
        assertEquals(properties.maxAgeSeconds(), corsConfiguration.getMaxAge());
    }

    private Object readField(Object target, String fieldName) throws Exception {
        final Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        
        return field.get(target);
    }
}
