package com.lumos;

import static org.mockito.Mockito.mockStatic;

import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;
import org.springframework.boot.SpringApplication;

class LumosApiServiceApplicationMainTest {

    @Test
    void main_callsSpringApplicationRun() {
        final var args = new String[] { "--spring.main.web-application-type=none" };
        try (MockedStatic<SpringApplication> springApplication = mockStatic(SpringApplication.class)) {
            LumosApiServiceApplication.main(args);

            springApplication.verify(() -> SpringApplication.run(LumosApiServiceApplication.class, args));
        }
    }
}
