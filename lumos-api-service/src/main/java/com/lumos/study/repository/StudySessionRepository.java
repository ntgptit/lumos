package com.lumos.study.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.lumos.study.entity.StudySession;

public interface StudySessionRepository extends JpaRepository<StudySession, Long> {

    Optional<StudySession> findByIdAndDeletedAtIsNull(Long id);
}
