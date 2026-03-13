package com.lumos.flashcard.repository.specification;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;
import com.lumos.flashcard.entity.Flashcard;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FlashcardSpecifications {

    private static final String ATTRIBUTE_DELETED_AT = "deletedAt";
    private static final String ATTRIBUTE_DECK = "deck";
    private static final String ATTRIBUTE_ID = "id";
    private static final String ATTRIBUTE_FRONT_TEXT = "frontText";
    private static final String ATTRIBUTE_BACK_TEXT = "backText";
    private static final String ATTRIBUTE_CREATED_AT = "createdAt";
    private static final String ATTRIBUTE_UPDATED_AT = "updatedAt";
    private static final String LIKE_PATTERN_TEMPLATE = "%%%s%%";

    public static Specification<Flashcard> byDeckAndKeyword(Long deckId, String searchQuery) {
        
        return Specification
                .where(isActive())
                .and(hasDeck(deckId))
                .and(textContains(searchQuery));
    }

    public static Pageable toSortedPageable(Pageable pageable, SortBy sortBy, SortType sortType) {
        final var resolvedSortBy = resolveSortBy(sortBy);
        final var resolvedSortType = resolveSortType(resolvedSortBy, sortType);
        final var resolvedSort = resolveSort(resolvedSortBy, resolvedSortType);
        
        return PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), resolvedSort);
    }

    private static Specification<Flashcard> isActive() {
        
        return (root, query, builder) -> builder.isNull(root.get(ATTRIBUTE_DELETED_AT));
    }

    private static Specification<Flashcard> hasDeck(Long deckId) {
        
        return (root, query, builder) -> builder.equal(root.get(ATTRIBUTE_DECK).get(ATTRIBUTE_ID), deckId);
    }

    private static Specification<Flashcard> textContains(String searchQuery) {
        
        return (root, query, builder) -> {
            // Skip keyword filter when search query is blank.
            if (StringUtils.isBlank(searchQuery)) {
                
                return builder.conjunction();
            }
            final var normalizedKeyword = StringUtils.lowerCase(StringUtils.trim(searchQuery));
            final var likePattern = String.format(LIKE_PATTERN_TEMPLATE, normalizedKeyword);
            final var frontTextLike = builder.like(builder.lower(root.get(ATTRIBUTE_FRONT_TEXT)), likePattern);
            final var backTextLike = builder.like(builder.lower(root.get(ATTRIBUTE_BACK_TEXT)), likePattern);
            
            return builder.or(frontTextLike, backTextLike);
        };
    }

    private static SortBy resolveSortBy(SortBy sortBy) {
        // Default sort field is created_at when client omits sortBy.
        if (sortBy == null) {
            
            return SortBy.CREATED_AT;
        }
        
        return sortBy;
    }

    private static SortType resolveSortType(SortBy sortBy, SortType sortType) {
        // Keep explicit direction from client.
        if (sortType != null) {
            
            return sortType;
        }
        // FRONT_TEXT and NAME default to ascending.
        if (sortBy == SortBy.FRONT_TEXT || sortBy == SortBy.NAME) {
            
            return SortType.ASC;
        }
        // Timestamp fields default to descending.
        return SortType.DESC;
    }

    private static Sort resolveSort(SortBy sortBy, SortType sortType) {
        // UPDATED_AT field uses timestamp order with id as stable tie-breaker.
        if (sortBy == SortBy.UPDATED_AT) {
            
            return resolveUpdatedAtSort(sortType);
        }
        // FRONT_TEXT and NAME use lexical order on front_text.
        if (sortBy == SortBy.FRONT_TEXT || sortBy == SortBy.NAME) {
            
            return resolveFrontTextSort(sortType);
        }
        // CREATED_AT fallback.
        return resolveCreatedAtSort(sortType);
    }

    private static Sort resolveFrontTextSort(SortType sortType) {
        // Descending token maps to case-insensitive front_text descending.
        if (sortType == SortType.DESC) {
            
            return Sort.by(Sort.Order.desc(ATTRIBUTE_FRONT_TEXT).ignoreCase(), Sort.Order.asc(ATTRIBUTE_ID));
        }
        
        return Sort.by(Sort.Order.asc(ATTRIBUTE_FRONT_TEXT).ignoreCase(), Sort.Order.asc(ATTRIBUTE_ID));
    }

    private static Sort resolveCreatedAtSort(SortType sortType) {
        // Descending token maps to newest flashcard first.
        if (sortType == SortType.DESC) {
            
            return Sort.by(Sort.Order.desc(ATTRIBUTE_CREATED_AT), Sort.Order.asc(ATTRIBUTE_ID));
        }
        
        return Sort.by(Sort.Order.asc(ATTRIBUTE_CREATED_AT), Sort.Order.asc(ATTRIBUTE_ID));
    }

    private static Sort resolveUpdatedAtSort(SortType sortType) {
        // Descending token maps to recently updated flashcard first.
        if (sortType == SortType.DESC) {
            
            return Sort.by(Sort.Order.desc(ATTRIBUTE_UPDATED_AT), Sort.Order.asc(ATTRIBUTE_ID));
        }
        
        return Sort.by(Sort.Order.asc(ATTRIBUTE_UPDATED_AT), Sort.Order.asc(ATTRIBUTE_ID));
    }
}
