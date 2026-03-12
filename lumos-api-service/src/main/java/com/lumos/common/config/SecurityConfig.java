package com.lumos.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.lumos.auth.security.JwtAuthenticationFilter;

@Configuration
public class SecurityConfig {

    private static final String[] PUBLIC_ENDPOINTS = {
            "/api/v1/health",
            "/api/v1/auth/register",
            "/api/v1/auth/login",
            "/api/v1/auth/refresh",
            "/swagger-ui/**",
            "/v3/api-docs/**"
    };

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationFilter jwtAuthenticationFilter)
            throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable);
        http
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers(PUBLIC_ENDPOINTS)
                        .permitAll()
                        .anyRequest()
                        .authenticated());
        http
                .httpBasic(AbstractHttpConfigurer::disable);
        http
                .formLogin(AbstractHttpConfigurer::disable);
        http
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
        http
                .anonymous(Customizer.withDefaults());
        http
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        return http
                .build();
    }
}
