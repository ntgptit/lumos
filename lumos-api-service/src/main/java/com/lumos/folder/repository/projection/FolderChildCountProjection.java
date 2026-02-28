package com.lumos.folder.repository.projection;

public interface FolderChildCountProjection {

    Long getParentId();

    Long getChildFolderCount();
}
