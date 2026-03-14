package com.lumos.deck.mapper;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import com.lumos.deck.dto.response.DeckResponse;
import com.lumos.deck.entity.Deck;
import com.lumos.folder.entity.Folder;

@Primary
@Component
public class DeckMapperSpringAdapter implements DeckMapper {

    @Override
    public DeckResponse toDeckResponse(Deck deck) {
        final var folderId = this.resolveFolderId(deck.getFolder());
        final var audit = this.toAuditMetadata(deck);
        
        return new DeckResponse(
                deck.getId(),
                folderId,
                deck.getName(),
                deck.getDescription(),
                deck.getFlashcardCount(),
                audit);
    }

    @Override
    public Deck toDeckEntity(Folder folder, String name, String description, Integer flashcardCount) {
        final var deck = new Deck();
        deck.setFolder(folder);
        deck.setName(name);
        deck.setDescription(description);
        deck.setFlashcardCount(flashcardCount);
        
        return deck;
    }

    private Long resolveFolderId(Folder folder) {
        // Folder id is absent only when deck entity is incomplete.
        if (folder == null) {
            
            return null;
        }
        
        return folder.getId();
    }
}
