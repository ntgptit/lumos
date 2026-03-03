package com.lumos.testkit;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;

public final class SearchRequestFixtures {

    private SearchRequestFixtures() {
    }

    public static SearchRequest byNameAsc(String keyword) {
        return new SearchRequest(keyword, SortBy.NAME, SortType.ASC);
    }

    public static SearchRequest byFrontTextAsc(String keyword) {
        return new SearchRequest(keyword, SortBy.FRONT_TEXT, SortType.ASC);
    }

    public static SearchRequest empty() {
        return new SearchRequest(null, null, null);
    }
}
