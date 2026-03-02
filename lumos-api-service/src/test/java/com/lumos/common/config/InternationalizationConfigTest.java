package com.lumos.common.config;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Locale;

import org.junit.jupiter.api.Test;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.test.util.ReflectionTestUtils;

class InternationalizationConfigTest {

    private final InternationalizationConfig config = new InternationalizationConfig();

    @Test
    void messageSource_createsBundleWithExpectedEncoding() {
        final var messageSource = this.config.messageSource();

        assertInstanceOf(ReloadableResourceBundleMessageSource.class, messageSource);
        final var reloadable = (ReloadableResourceBundleMessageSource) messageSource;
        assertEquals(ConfigConstants.I18N_ENCODING, ReflectionTestUtils.getField(reloadable, "defaultEncoding"));
    }

    @Test
    void localeResolver_setsDefaultLocale() {
        final LocaleResolver localeResolver = this.config.localeResolver();

        assertInstanceOf(SessionLocaleResolver.class, localeResolver);
        final var resolver = (SessionLocaleResolver) localeResolver;
        assertEquals(
                new Locale(ConfigConstants.I18N_DEFAULT_LANGUAGE, ConfigConstants.I18N_DEFAULT_COUNTRY),
                ReflectionTestUtils.getField(resolver, "defaultLocale"));
    }

    @Test
    void localeChangeInterceptor_usesConfiguredParamName() {
        final var interceptor = this.config.localeChangeInterceptor();

        assertEquals(ConfigConstants.I18N_PARAM_LANG, interceptor.getParamName());
    }

    @Test
    @SuppressWarnings("unchecked")
    void addInterceptors_registersLocaleChangeInterceptor() throws Exception {
        final var registry = new InterceptorRegistry();

        this.config.addInterceptors(registry);

        final Field field = InterceptorRegistry.class.getDeclaredField("registrations");
        field.setAccessible(true);
        final var registrations = (List<Object>) field.get(registry);
        assertEquals(1, registrations.size());

        final var registration = registrations.get(0);
        final var interceptorField = registration.getClass().getDeclaredField("interceptor");
        interceptorField.setAccessible(true);
        final var interceptor = (HandlerInterceptor) interceptorField.get(registration);
        assertInstanceOf(LocaleChangeInterceptor.class, interceptor);
    }
}
