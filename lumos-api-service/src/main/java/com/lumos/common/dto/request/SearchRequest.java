package com.lumos.common.dto.request;

import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;

public record SearchRequest(
        @Size(max = SearchRequestConst.SEARCH_QUERY_MAX_LENGTH)
        @Schema(description = "Search keyword") String searchQuery,
        @Schema(description = "Sort by token") SortBy sortBy,
        @Schema(description = "Sort type token") SortType sortType) {
}

final class SearchRequestConst {

    private SearchRequestConst() {
    }

    static final int SEARCH_QUERY_MAX_LENGTH = 255;
}
