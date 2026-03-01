package com.lumos.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;

@Configuration
public class OpenApiConfig {

    private static final String API_TITLE = "Lumos API Service";
    private static final String API_DESCRIPTION = "API documentation for Lumos services";
    private static final String API_VERSION = "v1";

    @Bean
    OpenAPI lumosOpenApi() {
        return new OpenAPI()
                .info(
                        new Info()
                                .title(API_TITLE)
                                .description(API_DESCRIPTION)
                                .version(API_VERSION));
    }
}
