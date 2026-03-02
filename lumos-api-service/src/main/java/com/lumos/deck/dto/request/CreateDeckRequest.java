package com.lumos.deck.dto.request;

import com.lumos.deck.constant.DeckConstants;
import com.lumos.deck.constant.ValidationMessageKeys;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateDeckRequest(
        @NotBlank(message = ValidationMessageKeys.DECK_NAME_REQUIRED)
        @Size(max = DeckConstants.NAME_MAX_LENGTH, message = ValidationMessageKeys.DECK_NAME_MAX_LENGTH)
        String name,
        @Size(max = DeckConstants.DESCRIPTION_MAX_LENGTH, message = ValidationMessageKeys.DECK_DESCRIPTION_MAX_LENGTH)
        String description
) {
}
