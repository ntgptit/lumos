package com.lumos.folder.dto.request;

import com.lumos.folder.constant.FolderConstants;
import com.lumos.folder.constant.ValidationMessageKeys;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RenameFolderRequest(
        @NotBlank(message = ValidationMessageKeys.FOLDER_NAME_REQUIRED)
        @Size(max = FolderConstants.NAME_MAX_LENGTH, message = ValidationMessageKeys.FOLDER_NAME_MAX_LENGTH)
        String name
) {
}
