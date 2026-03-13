package com.lumos.common.config;

import java.util.Locale;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

@Configuration
public class InternationalizationConfig implements WebMvcConfigurer {

    @Bean
    MessageSource messageSource() {
        final var messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasename(ConfigConstants.I18N_BASENAME);
        messageSource.setDefaultEncoding(ConfigConstants.I18N_ENCODING);

        // Return the shared message source so validation and error handlers resolve localized text consistently.
        return messageSource;
    }

    @Bean
    LocaleResolver localeResolver() {
        final var localeResolver = new SessionLocaleResolver();
        final var defaultLocale = new Locale(ConfigConstants.I18N_DEFAULT_LANGUAGE,
                ConfigConstants.I18N_DEFAULT_COUNTRY);
        localeResolver.setDefaultLocale(defaultLocale);

        // Return the session-based locale resolver so requests default to the configured locale until overridden.
        return localeResolver;
    }

    @Bean
    LocaleChangeInterceptor localeChangeInterceptor() {
        final var interceptor = new LocaleChangeInterceptor();
        interceptor.setParamName(ConfigConstants.I18N_PARAM_LANG);
        // Return the interceptor that lets clients switch locale through the configured query parameter.
        return interceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(this.localeChangeInterceptor());
    }
}
