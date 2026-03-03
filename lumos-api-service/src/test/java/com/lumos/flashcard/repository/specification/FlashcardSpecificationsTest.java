package com.lumos.flashcard.repository.specification;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;
import com.lumos.flashcard.entity.Flashcard;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

class FlashcardSpecificationsTest {

    @Test
    void byDeckAndKeyword_returnsComposedSpecification() {
        final Specification<Flashcard> specification = FlashcardSpecifications.byDeckAndKeyword(10L, "front");

        assertNotNull(specification);
    }

    @Test
    void byDeckAndKeyword_withBlankKeyword_usesConjunctionPredicate() {
        final var specification = FlashcardSpecifications.byDeckAndKeyword(10L, "   ");
        final var root = mockRoot();
        final var query = mock(CriteriaQuery.class);
        final var builder = mockBuilderForBlankKeyword(root);

        final var predicate = specification.toPredicate(root, query, builder);

        assertNotNull(predicate);
    }

    @Test
    void byDeckAndKeyword_withKeyword_buildsOrLikePredicate() {
        final var specification = FlashcardSpecifications.byDeckAndKeyword(10L, "  Front  ");
        final var root = mockRoot();
        final var query = mock(CriteriaQuery.class);
        final var builder = mockBuilderForKeyword(root);

        final var predicate = specification.toPredicate(root, query, builder);

        assertNotNull(predicate);
    }

    @Test
    void toSortedPageable_defaultsToCreatedAtDescendingWhenSortIsNull() {
        final var pageable = PageRequest.of(2, 25);

        final var sorted = FlashcardSpecifications.toSortedPageable(pageable, null, null);

        assertEquals(2, sorted.getPageNumber());
        assertEquals(25, sorted.getPageSize());
        assertEquals(Sort.Direction.DESC, sorted.getSort().getOrderFor("createdAt").getDirection());
    }

    @Test
    void toSortedPageable_supportsUpdatedAtAscending() {
        final var pageable = PageRequest.of(0, 10);

        final var sorted = FlashcardSpecifications.toSortedPageable(pageable, SortBy.UPDATED_AT, SortType.ASC);

        assertEquals(Sort.Direction.ASC, sorted.getSort().getOrderFor("updatedAt").getDirection());
    }

    @Test
    void toSortedPageable_supportsFrontTextDescending() {
        final var pageable = PageRequest.of(0, 10);

        final var sorted = FlashcardSpecifications.toSortedPageable(pageable, SortBy.FRONT_TEXT, SortType.DESC);

        assertEquals(Sort.Direction.DESC, sorted.getSort().getOrderFor("frontText").getDirection());
    }

    @SuppressWarnings("unchecked")
    private Root<Flashcard> mockRoot() {
        final Root<Flashcard> root = mock(Root.class);
        final Path<Object> deletedAtPath = mock(Path.class);
        final Path<Object> deckPath = mock(Path.class);
        final Path<Object> deckIdPath = mock(Path.class);
        final Path<Object> frontTextPath = mock(Path.class);
        final Path<Object> backTextPath = mock(Path.class);
        when(root.get("deletedAt")).thenReturn(deletedAtPath);
        when(root.get("deck")).thenReturn(deckPath);
        when(deckPath.get("id")).thenReturn(deckIdPath);
        when(root.get("frontText")).thenReturn(frontTextPath);
        when(root.get("backText")).thenReturn(backTextPath);
        return root;
    }

    @SuppressWarnings("unchecked")
    private CriteriaBuilder mockBuilderForBlankKeyword(Root<Flashcard> root) {
        final CriteriaBuilder builder = mock(CriteriaBuilder.class);
        final Predicate activePredicate = mock(Predicate.class);
        final Predicate deckPredicate = mock(Predicate.class);
        final Predicate conjunctionPredicate = mock(Predicate.class);
        final Predicate finalPredicate = mock(Predicate.class);
        final Path<Object> deletedAtPath = root.get("deletedAt");
        final Path<Object> deckIdPath = root.get("deck").get("id");
        when(builder.isNull(eq(deletedAtPath))).thenReturn(activePredicate);
        when(builder.equal(eq(deckIdPath), eq(10L))).thenReturn(deckPredicate);
        when(builder.conjunction()).thenReturn(conjunctionPredicate);
        when(builder.and(activePredicate, deckPredicate)).thenReturn(finalPredicate);
        when(builder.and(finalPredicate, conjunctionPredicate)).thenReturn(finalPredicate);
        return builder;
    }

    @SuppressWarnings("unchecked")
    private CriteriaBuilder mockBuilderForKeyword(Root<Flashcard> root) {
        final CriteriaBuilder builder = mock(CriteriaBuilder.class);
        final Predicate activePredicate = mock(Predicate.class);
        final Predicate deckPredicate = mock(Predicate.class);
        final Predicate frontLikePredicate = mock(Predicate.class);
        final Predicate backLikePredicate = mock(Predicate.class);
        final Predicate textPredicate = mock(Predicate.class);
        final Predicate finalPredicate = mock(Predicate.class);
        final Path<Object> deletedAtPath = root.get("deletedAt");
        final Path<Object> deckIdPath = root.get("deck").get("id");
        final Expression<String> frontTextPath = castToExpression(root.get("frontText"));
        final Expression<String> backTextPath = castToExpression(root.get("backText"));
        final Expression<String> lowerFrontText = mock(Expression.class);
        final Expression<String> lowerBackText = mock(Expression.class);
        when(builder.isNull(eq(deletedAtPath))).thenReturn(activePredicate);
        when(builder.equal(eq(deckIdPath), eq(10L))).thenReturn(deckPredicate);
        when(builder.lower(eq(frontTextPath))).thenReturn(lowerFrontText);
        when(builder.lower(eq(backTextPath))).thenReturn(lowerBackText);
        when(builder.like(eq(lowerFrontText), eq("%front%"))).thenReturn(frontLikePredicate);
        when(builder.like(eq(lowerBackText), eq("%front%"))).thenReturn(backLikePredicate);
        when(builder.or(frontLikePredicate, backLikePredicate)).thenReturn(textPredicate);
        when(builder.and(activePredicate, deckPredicate)).thenReturn(finalPredicate);
        when(builder.and(finalPredicate, textPredicate)).thenReturn(finalPredicate);
        return builder;
    }

    @SuppressWarnings("unchecked")
    private Expression<String> castToExpression(Object value) {
        return (Expression<String>) value;
    }
}
