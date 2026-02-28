package com.lumos.common.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;

public record SearchRequest(
        @Size(max = SearchRequestConst.SEARCH_QUERY_MAX_LENGTH)
        @Schema(description = "Search keyword") String searchQuery,
        @Size(max = SearchRequestConst.SORT_TYPE_MAX_LENGTH)
        @Schema(description = "Sort type token") String sortType
) {
}

final class SearchRequestConst {

    private SearchRequestConst() {
    }

    static final int SEARCH_QUERY_MAX_LENGTH = 255;
    static final int SORT_TYPE_MAX_LENGTH = 64;
}
