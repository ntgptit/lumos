package com.lumos.folder.dto.response;

import java.util.List;

public record BreadcrumbResponse(
        Long folderId,
        List<BreadcrumbItemResponse> items
) {
}
