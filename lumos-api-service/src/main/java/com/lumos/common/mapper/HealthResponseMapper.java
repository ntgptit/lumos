package com.lumos.common.mapper;

import org.springframework.stereotype.Component;

import com.lumos.common.dto.response.HealthResponse;

@Component
public class HealthResponseMapper {

    public HealthResponse toHealthResponse(String status) {
        return new HealthResponse(status);
    }
}
