package com.lumos.study.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.lumos.study.entity.StudySessionItem;

public interface StudySessionItemRepository extends JpaRepository<StudySessionItem, Long> {

    List<StudySessionItem> findAllByFlashcardIdAndDeletedAtIsNullOrderByStudySessionIdAscSequenceIndexAsc(Long flashcardId);

    List<StudySessionItem> findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(Long studySessionId);
}
