package com.lumos.common.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class HealthControllerTest {

    @Test
    void getHealth_returnsUpStatus() {
        final var controller = new HealthController();

        final var response = controller.getHealth();

        assertEquals(200, response.getStatusCode().value());
        assertEquals("UP", response.getBody().status());
    }
}
