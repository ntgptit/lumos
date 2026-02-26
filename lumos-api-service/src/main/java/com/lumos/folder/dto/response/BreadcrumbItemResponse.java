package com.lumos.folder.dto.response;

public record BreadcrumbItemResponse(
        Long id,
        String name,
        Integer depth
) {
}
