package com.lumos.folder.repository.specification;

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
import com.lumos.folder.entity.Folder;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

class FolderSpecificationsTest {

    @Test
    void byParentAndKeyword_returnsComposedSpecification() {
        final Specification<Folder> specification = FolderSpecifications.byParentAndKeyword(10L, "folder");

        assertNotNull(specification);
    }

    @Test
    void byParentAndKeyword_withNullParent_filtersRootFolders() {
        final var specification = FolderSpecifications.byParentAndKeyword(null, "");
        final var root = mockRoot();
        final var query = mock(CriteriaQuery.class);
        final var builder = mockBuilderForRootAndBlankKeyword(root);

        final var predicate = specification.toPredicate(root, query, builder);

        assertNotNull(predicate);
    }

    @Test
    void byParentAndKeyword_withKeyword_buildsLikePredicate() {
        final var specification = FolderSpecifications.byParentAndKeyword(10L, "  Folder  ");
        final var root = mockRoot();
        final var query = mock(CriteriaQuery.class);
        final var builder = mockBuilderForParentAndKeyword(root);

        final var predicate = specification.toPredicate(root, query, builder);

        assertNotNull(predicate);
    }

    @Test
    void toSortedPageable_defaultsToNameAscendingWhenSortIsNull() {
        final var pageable = PageRequest.of(1, 30);

        final var sorted = FolderSpecifications.toSortedPageable(pageable, null, null);

        assertEquals(1, sorted.getPageNumber());
        assertEquals(30, sorted.getPageSize());
        assertEquals(Sort.Direction.ASC, sorted.getSort().getOrderFor("name").getDirection());
    }

    @Test
    void toSortedPageable_supportsCreatedAtDescending() {
        final var pageable = PageRequest.of(0, 10);

        final var sorted = FolderSpecifications.toSortedPageable(pageable, SortBy.CREATED_AT, SortType.DESC);

        assertEquals(Sort.Direction.DESC, sorted.getSort().getOrderFor("createdAt").getDirection());
    }

    @SuppressWarnings("unchecked")
    private Root<Folder> mockRoot() {
        final Root<Folder> root = mock(Root.class);
        final Path<Object> deletedAtPath = mock(Path.class);
        final Path<Object> parentPath = mock(Path.class);
        final Path<Object> parentIdPath = mock(Path.class);
        final Path<Object> namePath = mock(Path.class);
        when(root.get("deletedAt")).thenReturn(deletedAtPath);
        when(root.get("parent")).thenReturn(parentPath);
        when(parentPath.get("id")).thenReturn(parentIdPath);
        when(root.get("name")).thenReturn(namePath);
        
        return root;
    }

    @SuppressWarnings("unchecked")
    private CriteriaBuilder mockBuilderForRootAndBlankKeyword(Root<Folder> root) {
        final CriteriaBuilder builder = mock(CriteriaBuilder.class);
        final Predicate activePredicate = mock(Predicate.class);
        final Predicate rootPredicate = mock(Predicate.class);
        final Predicate conjunctionPredicate = mock(Predicate.class);
        final Predicate finalPredicate = mock(Predicate.class);
        final Path<Object> deletedAtPath = root.get("deletedAt");
        final Path<Object> parentPath = root.get("parent");
        when(builder.isNull(eq(deletedAtPath))).thenReturn(activePredicate);
        when(builder.isNull(eq(parentPath))).thenReturn(rootPredicate);
        when(builder.conjunction()).thenReturn(conjunctionPredicate);
        when(builder.and(activePredicate, rootPredicate)).thenReturn(finalPredicate);
        when(builder.and(finalPredicate, conjunctionPredicate)).thenReturn(finalPredicate);
        
        return builder;
    }

    @SuppressWarnings("unchecked")
    private CriteriaBuilder mockBuilderForParentAndKeyword(Root<Folder> root) {
        final CriteriaBuilder builder = mock(CriteriaBuilder.class);
        final Predicate activePredicate = mock(Predicate.class);
        final Predicate parentPredicate = mock(Predicate.class);
        final Predicate likePredicate = mock(Predicate.class);
        final Predicate finalPredicate = mock(Predicate.class);
        final Path<Object> deletedAtPath = root.get("deletedAt");
        final Path<Object> parentIdPath = root.get("parent").get("id");
        final Expression<String> namePath = castToExpression(root.get("name"));
        final Expression<String> lowerExpression = mock(Expression.class);
        when(builder.isNull(eq(deletedAtPath))).thenReturn(activePredicate);
        when(builder.equal(eq(parentIdPath), eq(10L))).thenReturn(parentPredicate);
        when(builder.lower(eq(namePath))).thenReturn(lowerExpression);
        when(builder.like(eq(lowerExpression), eq("%folder%"))).thenReturn(likePredicate);
        when(builder.and(activePredicate, parentPredicate)).thenReturn(finalPredicate);
        when(builder.and(finalPredicate, likePredicate)).thenReturn(finalPredicate);
        
        return builder;
    }

    @SuppressWarnings("unchecked")
    private Expression<String> castToExpression(Object value) {
        
        return (Expression<String>) value;
    }
}
