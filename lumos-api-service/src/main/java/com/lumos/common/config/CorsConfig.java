package com.lumos.common.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
@EnableConfigurationProperties(CorsProperties.class)
public class CorsConfig implements WebMvcConfigurer {

    private final CorsProperties corsProperties;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping(ConfigConstants.CORS_PATH_PATTERN)
                .allowedOrigins(this.corsProperties.allowedOrigins().toArray(String[]::new))
                .allowedMethods(this.corsProperties.allowedMethods().toArray(String[]::new))
                .allowedHeaders(this.corsProperties.allowedHeaders().toArray(String[]::new))
                .exposedHeaders(this.corsProperties.exposedHeaders().toArray(String[]::new))
                .allowCredentials(this.corsProperties.allowCredentials()).maxAge(this.corsProperties.maxAgeSeconds());
    }
}
