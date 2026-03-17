# Deck Backend API Contract

## Base path

- `/api/v1/folders/{folderId}/decks`

## `POST /api/v1/folders/{folderId}/decks`

- Mục đích: Tạo deck mới.
- Request body:
  - `name: string`
  - `description: string | null`
- Response:
  - HTTP `201 Created`
  - `id`, `folderId`, `name`, `description`, `flashcardCount`, `audit`

## `GET /api/v1/folders/{folderId}/decks`

- Mục đích: Lấy danh sách deck trong folder.
- Query:
  - `searchQuery`
  - `sortBy`
  - `sortType`
  - `page`
  - `size`
- Response:
  - HTTP `200 OK`
  - Mảng `DeckResponse`

## `PUT /api/v1/folders/{folderId}/decks/{deckId}`

- Mục đích: Cập nhật deck.
- Request body:
  - `name: string`
  - `description: string | null`
- Response:
  - HTTP `200 OK`
  - `DeckResponse`

## `DELETE /api/v1/folders/{folderId}/decks/{deckId}`

- Mục đích: Xóa mềm deck.
- Response:
  - HTTP `204 No Content`

## `POST /api/v1/folders/{folderId}/decks/import`

- Mục đích: Import deck và flashcard từ Excel.
- Content type:
  - `multipart/form-data`
- Form field:
  - `file`
- Response:
  - HTTP `200 OK`
  - `folderId`
  - `processedDeckCount`
  - `createdDeckCount`
  - `importedFlashcardCount`

## Lỗi nghiệp vụ thường gặp

- `404`: folder hoặc deck không tồn tại.
- `409`: trùng tên deck hoặc folder cha không được phép chứa deck.
- `400/422`: file import sai hoặc validation field lỗi.
