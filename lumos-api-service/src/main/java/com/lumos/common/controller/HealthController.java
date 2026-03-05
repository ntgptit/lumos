package com.lumos.common.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

final class HealthControllerConst {

    private HealthControllerConst() {
    }

    static final String HEALTH_PATH = "/v1/health";
    static final String UP_STATUS = "UP";
}

record HealthResponse(String status) {
}

@RestController
@RequestMapping(HealthControllerConst.HEALTH_PATH)
public class HealthController {

    @GetMapping
    public ResponseEntity<HealthResponse> getHealth() {
        final var response = new HealthResponse(HealthControllerConst.UP_STATUS);
        return ResponseEntity.ok(response);
    }
}
