package com.lumos.deck.repository.specification;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;
import com.lumos.deck.entity.Deck;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

class DeckSpecificationsTest {

    @Test
    void byFolderAndKeyword_returnsComposedSpecification() {
        final var specification = DeckSpecifications
                .byFolderAndKeyword(10L, "deck");

        assertNotNull(specification);
    }

    @Test
    void byFolderAndKeyword_withBlankKeyword_usesConjunctionPredicate() {
        final var specification = DeckSpecifications
                .byFolderAndKeyword(10L, "   ");
        final var root = this
                .mockRoot();
        final var query = mock(CriteriaQuery.class);
        final var builder = this
                .mockBuilderForBlankKeyword(root);

        final var predicate = specification
                .toPredicate(root, query, builder);

        assertNotNull(predicate);
    }

    @Test
    void byFolderAndKeyword_withKeyword_buildsLikePredicate() {
        final var specification = DeckSpecifications
                .byFolderAndKeyword(10L, "  Deck  ");
        final var root = this
                .mockRoot();
        final var query = mock(CriteriaQuery.class);
        final var builder = this
                .mockBuilderForKeyword(root);

        final var predicate = specification
                .toPredicate(root, query, builder);

        assertNotNull(predicate);
    }

    @Test
    void toSortedPageable_defaultsToNameAscendingWhenSortIsNull() {
        final var pageable = PageRequest
                .of(2, 25);

        final var sorted = DeckSpecifications
                .toSortedPageable(pageable, null, null);

        assertEquals(2, sorted
                .getPageNumber());
        assertEquals(25, sorted
                .getPageSize());
        assertEquals(Sort.Direction.ASC, sorted
                .getSort()
                .getOrderFor("name")
                .getDirection());
    }

    @Test
    void toSortedPageable_supportsCreatedAtDescending() {
        final var pageable = PageRequest
                .of(0, 10);

        final var sorted = DeckSpecifications
                .toSortedPageable(pageable, SortBy.CREATED_AT, SortType.DESC);

        assertEquals(Sort.Direction.DESC, sorted
                .getSort()
                .getOrderFor("createdAt")
                .getDirection());
    }

    @SuppressWarnings("unchecked")
    private Root<Deck> mockRoot() {
        final Root<Deck> root = mock(Root.class);
        final Path<Object> deletedAtPath = mock(Path.class);
        final Path<Object> folderPath = mock(Path.class);
        final Path<Object> folderIdPath = mock(Path.class);
        final Path<Object> namePath = mock(Path.class);
        when(root
                .get("deletedAt"))
                .thenReturn(deletedAtPath);
        when(root
                .get("folder"))
                .thenReturn(folderPath);
        when(folderPath
                .get("id"))
                .thenReturn(folderIdPath);
        when(root
                .get("name"))
                .thenReturn(namePath);

        return root;
    }

    private CriteriaBuilder mockBuilderForBlankKeyword(Root<Deck> root) {
        final var builder = mock(CriteriaBuilder.class);
        final var activePredicate = mock(Predicate.class);
        final var folderPredicate = mock(Predicate.class);
        final var conjunctionPredicate = mock(Predicate.class);
        final var finalPredicate = mock(Predicate.class);
        final Path<Object> deletedAtPath = root
                .get("deletedAt");
        final Path<Object> folderIdPath = root
                .get("folder")
                .get("id");
        when(builder
                .isNull(eq(deletedAtPath)))
                .thenReturn(activePredicate);
        when(builder
                .equal(eq(folderIdPath), eq(10L)))
                .thenReturn(folderPredicate);
        when(builder
                .conjunction())
                .thenReturn(conjunctionPredicate);
        when(builder
                .and(activePredicate, folderPredicate))
                .thenReturn(finalPredicate);
        when(builder
                .and(finalPredicate, conjunctionPredicate))
                .thenReturn(finalPredicate);

        return builder;
    }

    @SuppressWarnings("unchecked")
    private CriteriaBuilder mockBuilderForKeyword(Root<Deck> root) {
        final var builder = mock(CriteriaBuilder.class);
        final var activePredicate = mock(Predicate.class);
        final var folderPredicate = mock(Predicate.class);
        final var likePredicate = mock(Predicate.class);
        final var finalPredicate = mock(Predicate.class);
        final Path<Object> deletedAtPath = root
                .get("deletedAt");
        final Path<Object> folderIdPath = root
                .get("folder")
                .get("id");
        final var namePath = this
                .castToExpression(root
                        .get("name"));
        final Expression<String> lowerExpression = mock(Expression.class);
        when(builder
                .isNull(eq(deletedAtPath)))
                .thenReturn(activePredicate);
        when(builder
                .equal(eq(folderIdPath), eq(10L)))
                .thenReturn(folderPredicate);
        when(builder
                .lower(eq(namePath)))
                .thenReturn(lowerExpression);
        when(builder
                .like(eq(lowerExpression), eq("%deck%")))
                .thenReturn(likePredicate);
        when(builder
                .and(activePredicate, folderPredicate))
                .thenReturn(finalPredicate);
        when(builder
                .and(finalPredicate, likePredicate))
                .thenReturn(finalPredicate);

        return builder;
    }

    @SuppressWarnings("unchecked")
    private Expression<String> castToExpression(Object value) {

        return (Expression<String>) value;
    }
}
