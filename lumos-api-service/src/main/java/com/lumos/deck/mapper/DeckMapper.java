package com.lumos.deck.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import com.lumos.deck.dto.response.AuditMetadataResponse;
import com.lumos.deck.dto.response.DeckResponse;
import com.lumos.deck.entity.Deck;
import com.lumos.folder.entity.Folder;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface DeckMapper {

    @Mapping(target = "folderId", source = "folder.id")
    @Mapping(target = "audit", expression = "java(toAuditMetadata(deck))")
    DeckResponse toDeckResponse(Deck deck);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "version", ignore = true)
    @Mapping(target = "folder", source = "folder")
    @Mapping(target = "name", source = "name")
    @Mapping(target = "description", source = "description")
    @Mapping(target = "flashcardCount", source = "flashcardCount")
    Deck toDeckEntity(Folder folder, String name, String description, Integer flashcardCount);

    default AuditMetadataResponse toAuditMetadata(Deck deck) {
        return new AuditMetadataResponse(deck.getCreatedAt(), deck.getUpdatedAt());
    }
}
