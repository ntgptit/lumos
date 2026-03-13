package com.lumos.flashcard.mapper;

import java.util.List;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import com.lumos.deck.entity.Deck;
import com.lumos.flashcard.dto.response.FlashcardPageResponse;
import com.lumos.flashcard.dto.response.FlashcardResponse;
import com.lumos.flashcard.entity.Flashcard;

@Primary
@Component
public class FlashcardMapperSpringAdapter implements FlashcardMapper {

    @Override
    public FlashcardResponse toFlashcardResponse(Flashcard flashcard) {
        final var deckId = this.resolveDeckId(flashcard.getDeck());
        final var audit = this.toAuditMetadata(flashcard);
        
        return new FlashcardResponse(
                flashcard.getId(),
                deckId,
                flashcard.getFrontText(),
                flashcard.getBackText(),
                flashcard.getFrontLangCode(),
                flashcard.getBackLangCode(),
                flashcard.getPronunciation(),
                flashcard.getNote(),
                flashcard.getIsBookmarked(),
                audit);
    }

    @Override
    public Flashcard toFlashcardEntity(
            Deck deck,
            String frontText,
            String backText,
            String frontLangCode,
            String backLangCode,
            String pronunciation,
            String note,
            Boolean isBookmarked) {
        final var flashcard = new Flashcard();
        flashcard.setDeck(deck);
        flashcard.setFrontText(frontText);
        flashcard.setBackText(backText);
        flashcard.setFrontLangCode(frontLangCode);
        flashcard.setBackLangCode(backLangCode);
        flashcard.setPronunciation(pronunciation);
        flashcard.setNote(note);
        flashcard.setIsBookmarked(isBookmarked);
        
        return flashcard;
    }

    @Override
    public FlashcardPageResponse toFlashcardPageResponse(
            List<FlashcardResponse> items,
            int page,
            int size,
            long totalElements,
            int totalPages,
            boolean hasNext,
            boolean hasPrevious) {
        
        return new FlashcardPageResponse(items, page, size, totalElements, totalPages, hasNext, hasPrevious);
    }

    private Long resolveDeckId(Deck deck) {
        // Deck id is absent only when flashcard entity is incomplete.
        if (deck == null) {
            
            return null;
        }
        
        return deck.getId();
    }
}
