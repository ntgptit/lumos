package com.lumos.common.logging;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import java.util.concurrent.TimeUnit;

@Aspect
@Component
@Order(Ordered.LOWEST_PRECEDENCE)
public class ExecutionLoggingAspect {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExecutionLoggingAspect.class);

    private static final String LOG_EVENT_START = "START";
    private static final String LOG_EVENT_END = "END";
    private static final String LOG_STATUS_SUCCESS = "SUCCESS";
    private static final String LOG_STATUS_ERROR = "ERROR";
    private static final String LOG_LATENCY_NORMAL = "NORMAL";
    private static final String LOG_LATENCY_SLOW = "SLOW";
    private static final String LOG_LAYER_SERVICE = "SERVICE";
    private static final String LOG_LAYER_CONTROLLER = "CONTROLLER";
    private static final String LOG_LAYER_APPLICATION = "APPLICATION";

    private static final String LOG_START_TEMPLATE =
            "EXEC event={} layer={} method={} argCount={} traceId={}";
    private static final String LOG_SUCCESS_TEMPLATE =
            "EXEC event={} layer={} method={} argCount={} status={} latency={} durationMs={} traceId={}";
    private static final String LOG_ERROR_TEMPLATE =
            "EXEC event={} layer={} method={} argCount={} status={} durationMs={} errorType={} errorMessage={} traceId={}";

    private static final String TRACE_ID_KEY = "traceId";
    private static final String TRACE_ID_B3_KEY = "X-B3-TraceId";
    private static final String TRACE_ID_FALLBACK = "N/A";
    private static final String ERROR_MESSAGE_FALLBACK = "N/A";
    private static final int MAX_ERROR_MESSAGE_LENGTH = 240;
    private static final long SLOW_EXECUTION_THRESHOLD_MS = 300L;

    @Pointcut("within(@org.springframework.stereotype.Service *) || within(@org.springframework.web.bind.annotation.RestController *)")
    public void applicationLayerBean() {
    }

    @Pointcut("@annotation(com.lumos.common.logging.SkipTraceLogging)")
    public void skipTraceLogging() {
    }

    @Around("execution(public * *(..)) && applicationLayerBean() && !skipTraceLogging()")
    public Object logMethodExecution(ProceedingJoinPoint joinPoint) throws Throwable {
        final String methodName = resolveMethodName(joinPoint);
        final String layerName = resolveLayerName(methodName);
        final String traceId = resolveTraceId();
        final int argCount = joinPoint.getArgs().length;
        final long startNanoTime = System.nanoTime();

        // Emit start log only at debug level to reduce production noise.
        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug(
                    LOG_START_TEMPLATE,
                    LOG_EVENT_START,
                    layerName,
                    methodName,
                    argCount,
                    traceId
            );
        }
        try {
            final Object result = joinPoint.proceed();
            final long durationMs = toMillis(startNanoTime);
            final String latencyClass = resolveLatencyClass(durationMs);

            // Escalate slow successful executions to WARN for production observability.
            if (isSlowExecution(durationMs)) {
                LOGGER.warn(
                        LOG_SUCCESS_TEMPLATE,
                        LOG_EVENT_END,
                        layerName,
                        methodName,
                        argCount,
                        LOG_STATUS_SUCCESS,
                        latencyClass,
                        durationMs,
                        traceId
                );
                return result;
            }

            LOGGER.info(
                    LOG_SUCCESS_TEMPLATE,
                    LOG_EVENT_END,
                    layerName,
                    methodName,
                    argCount,
                    LOG_STATUS_SUCCESS,
                    latencyClass,
                    durationMs,
                    traceId
            );
            return result;
        } catch (Throwable throwable) {
            final long durationMs = toMillis(startNanoTime);
            final String errorType = throwable.getClass().getSimpleName();
            final String errorMessage = resolveErrorMessage(throwable);
            LOGGER.error(
                    LOG_ERROR_TEMPLATE,
                    LOG_EVENT_END,
                    layerName,
                    methodName,
                    argCount,
                    LOG_STATUS_ERROR,
                    durationMs,
                    errorType,
                    errorMessage,
                    traceId
            );
            throw throwable;
        }
    }

    private String resolveMethodName(ProceedingJoinPoint joinPoint) {
        final MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        final String declaringType = signature.getDeclaringTypeName();
        final String method = signature.getName();
        return declaringType + "." + method;
    }

    private String resolveLayerName(String methodName) {
        // Service layer path marker takes precedence when method belongs to service package.
        if (StringUtils.contains(methodName, ".service.")) {
            return LOG_LAYER_SERVICE;
        }
        // Controller layer path marker is used for REST endpoint executions.
        if (StringUtils.contains(methodName, ".controller.")) {
            return LOG_LAYER_CONTROLLER;
        }
        return LOG_LAYER_APPLICATION;
    }

    private String resolveTraceId() {
        final String traceId = MDC.get(TRACE_ID_KEY);
        // Prefer traceId set by application logging context.
        if (hasText(traceId)) {
            return traceId;
        }

        final String b3TraceId = MDC.get(TRACE_ID_B3_KEY);
        // Fallback to B3 propagation key if application traceId is absent.
        if (hasText(b3TraceId)) {
            return b3TraceId;
        }

        return TRACE_ID_FALLBACK;
    }

    private boolean hasText(String value) {
        return StringUtils.isNotBlank(value);
    }

    private String resolveLatencyClass(long durationMs) {
        // Mark requests slower than threshold for warning-level observability.
        if (isSlowExecution(durationMs)) {
            return LOG_LATENCY_SLOW;
        }
        return LOG_LATENCY_NORMAL;
    }

    private boolean isSlowExecution(long durationMs) {
        return durationMs >= SLOW_EXECUTION_THRESHOLD_MS;
    }

    private String resolveErrorMessage(Throwable throwable) {
        final String message = throwable.getMessage();
        // Keep a stable fallback when exception message is blank.
        if (!hasText(message)) {
            return ERROR_MESSAGE_FALLBACK;
        }
        final String normalizedMessage = StringUtils.normalizeSpace(message);
        // Return as-is when message already fits the log payload size.
        if (normalizedMessage.length() <= MAX_ERROR_MESSAGE_LENGTH) {
            return normalizedMessage;
        }
        return normalizedMessage.substring(0, MAX_ERROR_MESSAGE_LENGTH) + "...";
    }

    private long toMillis(long startNanoTime) {
        final long elapsedNano = System.nanoTime() - startNanoTime;
        return TimeUnit.NANOSECONDS.toMillis(elapsedNano);
    }
}
