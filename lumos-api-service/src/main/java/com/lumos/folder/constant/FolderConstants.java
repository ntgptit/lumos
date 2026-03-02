package com.lumos.folder.constant;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FolderConstants {

    public static final int ROOT_FOLDER_DEPTH = 1;
    public static final int DEFAULT_CHILD_FOLDER_COUNT = 0;
    public static final int NAME_MAX_LENGTH = 120;
    public static final int DESCRIPTION_MAX_LENGTH = 400;
    public static final int COLOR_HEX_MAX_LENGTH = 9;
    public static final String COLOR_HEX_REGEX = "^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$";
    public static final String DEFAULT_COLOR_HEX = "#4F46E5";
    public static final String EMPTY_DESCRIPTION = "";
}
