package com.lumos.deck.service;

import java.util.List;

import org.springframework.data.domain.Pageable;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.deck.dto.request.CreateDeckRequest;
import com.lumos.deck.dto.request.UpdateDeckRequest;
import com.lumos.deck.dto.response.DeckResponse;

public interface DeckService {

    DeckResponse createDeck(Long folderId, CreateDeckRequest request);

    DeckResponse updateDeck(Long folderId, Long deckId, UpdateDeckRequest request);

    void deleteDeck(Long folderId, Long deckId);

    List<DeckResponse> getDecks(Long folderId, SearchRequest searchRequest, Pageable pageable);
}
