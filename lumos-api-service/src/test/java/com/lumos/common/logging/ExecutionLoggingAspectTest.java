package com.lumos.common.logging;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.slf4j.MDC;

@ExtendWith(MockitoExtension.class)
class ExecutionLoggingAspectTest {

    @Mock
    private ProceedingJoinPoint joinPoint;

    @Mock
    private MethodSignature methodSignature;

    private final ExecutionLoggingAspect aspect = new ExecutionLoggingAspect();

    @AfterEach
    void clearMdc() {
        MDC.clear();
    }

    @Test
    void applicationLayerBean_pointcutMethodExecutes() {
        this.aspect.applicationLayerBean();
    }

    @Test
    void skipTraceLogging_pointcutMethodExecutes() {
        this.aspect.skipTraceLogging();
    }

    @Test
    void logMethodExecution_returnsProceedResult() throws Throwable {
        when(this.joinPoint.getSignature()).thenReturn(this.methodSignature);
        when(this.methodSignature.getDeclaringTypeName()).thenReturn("com.lumos.folder.service.impl.FolderServiceImpl");
        when(this.methodSignature.getName()).thenReturn("getFolders");
        when(this.joinPoint.getArgs()).thenReturn(new Object[] { "arg" });
        when(this.joinPoint.proceed()).thenReturn("ok");

        final var result = this.aspect.logMethodExecution(this.joinPoint);

        assertEquals("ok", result);
    }

    @Test
    void logMethodExecution_rethrowsExceptionFromProceed() throws Throwable {
        when(this.joinPoint.getSignature()).thenReturn(this.methodSignature);
        when(this.methodSignature.getDeclaringTypeName()).thenReturn("com.lumos.deck.controller.DeckController");
        when(this.methodSignature.getName()).thenReturn("createDeck");
        when(this.joinPoint.getArgs()).thenReturn(new Object[] { 10L });
        when(this.joinPoint.proceed()).thenThrow(new IllegalStateException("failed"));

        assertThrows(IllegalStateException.class, () -> this.aspect.logMethodExecution(this.joinPoint));
    }
}
