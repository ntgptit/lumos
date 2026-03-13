package com.lumos.common.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumos.common.dto.response.HealthResponse;
import com.lumos.common.mapper.HealthResponseMapper;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

final class HealthControllerConst {

    private HealthControllerConst() {
    }

    static final String HEALTH_PATH = "/api/v1/health";
    static final String UP_STATUS = "UP";
}

/**
 * Health check endpoints.
 */
@RestController
@RequiredArgsConstructor
@Tag(name = "Health", description = "Health check APIs")
@RequestMapping(HealthControllerConst.HEALTH_PATH)
public class HealthController {

    private final HealthResponseMapper healthResponseMapper;

    /**
     * Return the current application health status.
     *
     * @return health response payload
     */
    @Operation(summary = "Get health status")
    @GetMapping
    public ResponseEntity<HealthResponse> getHealth() {
        final var response = this.healthResponseMapper.toHealthResponse(HealthControllerConst.UP_STATUS);
        // Return a simple liveness payload so infrastructure checks can verify the service is up.
        return ResponseEntity.ok(response);
    }
}
