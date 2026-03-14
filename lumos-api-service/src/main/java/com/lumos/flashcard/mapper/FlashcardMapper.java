package com.lumos.flashcard.mapper;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import com.lumos.deck.entity.Deck;
import com.lumos.flashcard.dto.response.AuditMetadataResponse;
import com.lumos.flashcard.dto.response.FlashcardPageResponse;
import com.lumos.flashcard.dto.response.FlashcardResponse;
import com.lumos.flashcard.entity.Flashcard;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface FlashcardMapper {

    @Mapping(target = "deckId", source = "deck.id")
    @Mapping(target = "audit", expression = "java(toAuditMetadata(flashcard))")
    FlashcardResponse toFlashcardResponse(Flashcard flashcard);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "version", ignore = true)
    @Mapping(target = "deck", source = "deck")
    @Mapping(target = "frontText", source = "frontText")
    @Mapping(target = "backText", source = "backText")
    @Mapping(target = "frontLangCode", source = "frontLangCode")
    @Mapping(target = "backLangCode", source = "backLangCode")
    @Mapping(target = "pronunciation", source = "pronunciation")
    @Mapping(target = "note", source = "note")
    @Mapping(target = "isBookmarked", source = "isBookmarked")
    Flashcard toFlashcardEntity(
            Deck deck,
            String frontText,
            String backText,
            String frontLangCode,
            String backLangCode,
            String pronunciation,
            String note,
            Boolean isBookmarked);

    FlashcardPageResponse toFlashcardPageResponse(
            List<FlashcardResponse> items,
            int page,
            int size,
            long totalElements,
            int totalPages,
            boolean hasNext,
            boolean hasPrevious);

    default AuditMetadataResponse toAuditMetadata(Flashcard flashcard) {
        
        return new AuditMetadataResponse(flashcard.getCreatedAt(), flashcard.getUpdatedAt());
    }
}
