package com.lumos.flashcard.entity;

import com.lumos.common.entity.AuditEntity;
import com.lumos.deck.entity.Deck;
import com.lumos.flashcard.constant.FlashcardConstants;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "flashcards")
public class Flashcard extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "deck_id", nullable = false)
    private Deck deck;

    @Column(name = "front_text", nullable = false, length = FlashcardConstants.FRONT_TEXT_MAX_LENGTH)
    private String frontText;

    @Column(name = "back_text", nullable = false, length = FlashcardConstants.BACK_TEXT_MAX_LENGTH)
    private String backText;

    @Column(name = "front_lang_code", length = FlashcardConstants.LANGUAGE_CODE_MAX_LENGTH)
    private String frontLangCode;

    @Column(name = "back_lang_code", length = FlashcardConstants.LANGUAGE_CODE_MAX_LENGTH)
    private String backLangCode;

    @Column(name = "pronunciation", nullable = false, length = FlashcardConstants.PRONUNCIATION_MAX_LENGTH)
    private String pronunciation;

    @Column(name = "note", nullable = false, length = FlashcardConstants.NOTE_MAX_LENGTH)
    private String note;

    @Column(name = "is_bookmarked", nullable = false)
    private Boolean isBookmarked;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
