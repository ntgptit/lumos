package com.lumos.folder.repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.lumos.folder.entity.Folder;
import com.lumos.folder.repository.projection.FolderChildCountProjection;

public interface FolderRepository extends JpaRepository<Folder, Long>, JpaSpecificationExecutor<Folder> {

    Optional<Folder> findByIdAndDeletedAtIsNull(Long id);

    List<Folder> findAllByParentIdAndDeletedAtIsNull(Long parentId);

    @Query(nativeQuery = true, value = """
            SELECT f.parent_id AS parentId, COUNT(f.id) AS childFolderCount
            FROM folders f
            WHERE f.deleted_at IS NULL
              AND f.parent_id IN (:parentIds)
            GROUP BY f.parent_id
            """)
    List<FolderChildCountProjection> findChildCountByParentIds(@Param("parentIds") List<Long> parentIds);

    @Modifying
    @Query(value = """
            WITH RECURSIVE folder_tree AS (
                SELECT f.id
                FROM folders f
                WHERE f.id = :folderId AND f.deleted_at IS NULL
                UNION ALL
                SELECT c.id
                FROM folders c
                JOIN folder_tree ft ON c.parent_id = ft.id
                WHERE c.deleted_at IS NULL
            )
            UPDATE folders
            SET deleted_at = :deletedAt,
                updated_at = :deletedAt
            WHERE id IN (SELECT id FROM folder_tree)
            """, nativeQuery = true)
    int softDeleteFolderTree(@Param("folderId") Long folderId, @Param("deletedAt") Instant deletedAt);

    @Query(value = """
            SELECT COUNT(1) > 0
            FROM folders f
            WHERE f.deleted_at IS NULL
              AND (:excludeId IS NULL OR f.id <> :excludeId)
              AND LOWER(f.name) = LOWER(:name)
              AND (
                    (:parentId IS NULL AND f.parent_id IS NULL)
                    OR f.parent_id = :parentId
                  )
            """, nativeQuery = true)
    boolean existsActiveSiblingName(@Param("parentId") Long parentId, @Param("name") String name,
            @Param("excludeId") Long excludeId);
}
