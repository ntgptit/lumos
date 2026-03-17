# Folder Backend API Contract

## `POST /api/v1/folders`

- Mục đích: Tạo folder.
- Request body:
  - `name: string`
  - `description: string | null`
  - `parentId: number | null`
- Response:
  - HTTP `201 Created`
  - `id`, `name`, `description`, `colorHex`, `parentId`, `depth`, `childFolderCount`, `audit`
- Validation chính:
  - `name` bắt buộc, max 120.
  - `description` max 400.

## `GET /api/v1/folders`

- Mục đích: Lấy folder theo scope.
- Query:
  - `parentId`
  - `searchQuery`
  - `sortBy` = `NAME | CREATED_AT | UPDATED_AT`
  - `sortType` = `ASC | DESC`
  - `page`
  - `size`
- Response:
  - HTTP `200 OK`
  - Mảng `FolderResponse`

## `PATCH /api/v1/folders/{folderId}/rename`

- Mục đích: Đổi tên nhanh.
- Request body:
  - `name: string`
- Response:
  - HTTP `200 OK`
  - `FolderResponse`

## `PUT /api/v1/folders/{folderId}`

- Mục đích: Cập nhật metadata folder.
- Request body:
  - `name: string`
  - `description: string | null`
  - `parentId: number | null`
- Response:
  - HTTP `200 OK`
  - `FolderResponse`
- Ghi chú:
  - Service hiện không dùng `parentId` để move folder; payload chủ yếu giữ shape đồng nhất với create.

## `DELETE /api/v1/folders/{folderId}`

- Mục đích: Soft delete folder tree.
- Response:
  - HTTP `204 No Content`

## Lỗi nghiệp vụ thường gặp

- `404`: folder không tồn tại hoặc đã bị xóa.
- `409`: trùng tên sibling, hoặc parent hiện có deck nên không được tạo subfolder.
- `400/422`: lỗi validation field.
