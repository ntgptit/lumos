package com.lumos.folder.repository.specification;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;
import com.lumos.folder.entity.Folder;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FolderSpecifications {

    private static final String ATTRIBUTE_DELETED_AT = "deletedAt";
    private static final String ATTRIBUTE_PARENT = "parent";
    private static final String ATTRIBUTE_ID = "id";
    private static final String ATTRIBUTE_NAME = "name";
    private static final String ATTRIBUTE_CREATED_AT = "createdAt";
    private static final String LIKE_PATTERN_TEMPLATE = "%%%s%%";

    public static Specification<Folder> byParentAndKeyword(Long parentId, String searchQuery) {
        return Specification
                .where(isActive())
                .and(hasParent(parentId))
                .and(nameContains(searchQuery));
    }

    public static Pageable toSortedPageable(Pageable pageable, SortBy sortBy, SortType sortType) {
        final var resolvedSortBy = resolveSortBy(sortBy);
        final var resolvedSortType = resolveSortType(sortType);
        final var resolvedSort = resolveSort(resolvedSortBy, resolvedSortType);
        return PageRequest
                .of(pageable
                        .getPageNumber(),
                        pageable
                                .getPageSize(),
                        resolvedSort);
    }

    private static Specification<Folder> isActive() {
        return (root, query, builder) -> builder
                .isNull(root
                        .get(ATTRIBUTE_DELETED_AT));
    }

    private static Specification<Folder> hasParent(Long parentId) {
        return (root, query, builder) -> {
            // Null parent id means query at root level.
            if (parentId == null) {
                return builder
                        .isNull(root
                                .get(ATTRIBUTE_PARENT));
            }
            return builder
                    .equal(root
                            .get(ATTRIBUTE_PARENT)
                            .get(ATTRIBUTE_ID), parentId);
        };
    }

    private static Specification<Folder> nameContains(String searchQuery) {
        return (root, query, builder) -> {
            // Skip keyword filter when searchQuery is blank.
            if (StringUtils
                    .isBlank(searchQuery)) {
                return builder
                        .conjunction();
            }
            final var normalizedKeyword = StringUtils
                    .lowerCase(StringUtils
                            .trim(searchQuery));
            final var likePattern = String
                    .format(LIKE_PATTERN_TEMPLATE, normalizedKeyword);
            return builder
                    .like(builder
                            .lower(root
                                    .get(ATTRIBUTE_NAME)),
                            likePattern);
        };
    }

    private static SortBy resolveSortBy(SortBy sortBy) {
        // Default sort field is name when client omits sortBy.
        if (sortBy == null) {
            return SortBy.NAME;
        }
        return sortBy;
    }

    private static SortType resolveSortType(SortType sortType) {
        // Default sort direction is ascending when client omits sortType.
        if (sortType == null) {
            return SortType.ASC;
        }
        return sortType;
    }

    private static Sort resolveSort(SortBy sortBy, SortType sortType) {
        // CREATED_AT field uses timestamp order with id as stable tie-breaker.
        if (sortBy == SortBy.CREATED_AT) {
            return resolveCreatedAtSort(sortType);
        }
        return resolveNameSort(sortType);
    }

    private static Sort resolveNameSort(SortType sortType) {
        // Descending token maps to case-insensitive name descending.
        if (sortType == SortType.DESC) {
            return Sort
                    .by(Sort.Order
                            .desc(ATTRIBUTE_NAME)
                            .ignoreCase(),
                            Sort.Order
                                    .asc(ATTRIBUTE_ID));
        }
        return Sort
                .by(Sort.Order
                        .asc(ATTRIBUTE_NAME)
                        .ignoreCase(),
                        Sort.Order
                                .asc(ATTRIBUTE_ID));
    }

    private static Sort resolveCreatedAtSort(SortType sortType) {
        // Descending token maps to newest folder first.
        if (sortType == SortType.DESC) {
            return Sort
                    .by(Sort.Order
                            .desc(ATTRIBUTE_CREATED_AT),
                            Sort.Order
                                    .asc(ATTRIBUTE_ID));
        }
        return Sort
                .by(Sort.Order
                        .asc(ATTRIBUTE_CREATED_AT),
                        Sort.Order
                                .asc(ATTRIBUTE_ID));
    }
}
