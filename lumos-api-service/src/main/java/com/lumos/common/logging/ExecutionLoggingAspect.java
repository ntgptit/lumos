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

@Aspect
@Component
@Order(Ordered.LOWEST_PRECEDENCE)
public class ExecutionLoggingAspect {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExecutionLoggingAspect.class);
    private static final String TRACE_ID_KEY = "traceId";
    private static final String TRACE_ID_B3_KEY = "X-B3-TraceId";
    private static final String TRACE_ID_FALLBACK = "N/A";

    @Pointcut("within(@org.springframework.stereotype.Service *) || within(@org.springframework.web.bind.annotation.RestController *)")
    public void applicationLayerBean() {
    }

    @Pointcut("@annotation(com.lumos.common.logging.SkipTraceLogging)")
    public void skipTraceLogging() {
    }

    @Around("execution(public * *(..)) && applicationLayerBean() && !skipTraceLogging()")
    public Object logMethodExecution(ProceedingJoinPoint joinPoint) throws Throwable {
        String methodName = resolveMethodName(joinPoint);
        String traceId = resolveTraceId();
        int argCount = joinPoint.getArgs().length;
        long startNanoTime = System.nanoTime();

        LOGGER.info("AOP_START method={} argCount={} traceId={}", methodName, argCount, traceId);
        try {
            Object result = joinPoint.proceed();
            long durationMs = toMillis(startNanoTime);
            LOGGER.info("AOP_END method={} status=SUCCESS durationMs={} traceId={}", methodName, durationMs, traceId);
            return result;
        } catch (Throwable throwable) {
            long durationMs = toMillis(startNanoTime);
            String errorType = throwable.getClass().getSimpleName();
            String errorMessage = throwable.getMessage();
            LOGGER.error(
                    "AOP_END method={} status=ERROR durationMs={} errorType={} errorMessage={} traceId={}",
                    methodName,
                    durationMs,
                    errorType,
                    errorMessage,
                    traceId
            );
            throw throwable;
        }
    }

    private String resolveMethodName(ProceedingJoinPoint joinPoint) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        String declaringType = signature.getDeclaringTypeName();
        String method = signature.getName();
        return declaringType + "." + method;
    }

    private String resolveTraceId() {
        String traceId = MDC.get(TRACE_ID_KEY);
        // Prefer traceId set by application logging context.
        if (hasText(traceId)) {
            return traceId;
        }

        String b3TraceId = MDC.get(TRACE_ID_B3_KEY);
        // Fallback to B3 propagation key if application traceId is absent.
        if (hasText(b3TraceId)) {
            return b3TraceId;
        }

        return TRACE_ID_FALLBACK;
    }

    private boolean hasText(String value) {
        return StringUtils.isNotBlank(value);
    }

    private long toMillis(long startNanoTime) {
        long elapsedNano = System.nanoTime() - startNanoTime;
        return elapsedNano / 1_000_000L;
    }
}
