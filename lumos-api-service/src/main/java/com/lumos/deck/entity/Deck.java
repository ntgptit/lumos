package com.lumos.deck.entity;

import com.lumos.common.entity.AuditEntity;
import com.lumos.deck.constant.DeckConstants;
import com.lumos.folder.entity.Folder;

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
@Table(name = "decks")
public class Deck extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "folder_id", nullable = false)
    private Folder folder;

    @Column(name = "name", nullable = false, length = DeckConstants.NAME_MAX_LENGTH)
    private String name;

    @Column(name = "description", nullable = false, length = DeckConstants.DESCRIPTION_MAX_LENGTH)
    private String description;

    @Column(name = "flashcard_count", nullable = false)
    private Integer flashcardCount;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
