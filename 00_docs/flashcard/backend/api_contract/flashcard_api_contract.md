# Flashcard Backend API Contract

## Base path

- `/api/v1/decks/{deckId}/flashcards`

## `POST /api/v1/decks/{deckId}/flashcards`

- Mục đích: Tạo flashcard mới.
- Request body:
  - `frontText: string`
  - `backText: string`
  - `frontLangCode: string | null`
  - `backLangCode: string | null`
- Response:
  - HTTP `201 Created`
  - `id`, `deckId`, `frontText`, `backText`, `frontLangCode`, `backLangCode`, `pronunciation`, `note`, `isBookmarked`, `audit`

## `GET /api/v1/decks/{deckId}/flashcards`

- Mục đích: Lấy flashcard theo page.
- Query:
  - `searchQuery`
  - `sortBy` = `CREATED_AT | UPDATED_AT | FRONT_TEXT`
  - `sortType` = `ASC | DESC`
  - `page`
  - `size`
- Response:
  - HTTP `200 OK`
  - `items`
  - `page`
  - `size`
  - `totalElements`
  - `totalPages`
  - `hasNext`
  - `hasPrevious`

## `PUT /api/v1/decks/{deckId}/flashcards/{flashcardId}`

- Mục đích: Cập nhật flashcard.
- Request body:
  - Cùng shape với create.
- Response:
  - HTTP `200 OK`
  - `FlashcardResponse`

## `DELETE /api/v1/decks/{deckId}/flashcards/{flashcardId}`

- Mục đích: Xóa mềm flashcard.
- Response:
  - HTTP `204 No Content`

## Validation chính

- `frontText`: bắt buộc, max 300.
- `backText`: bắt buộc, max 2000.
- `frontLangCode`, `backLangCode`: max độ dài theo constant backend.

## Lỗi nghiệp vụ

- `404`: deck hoặc flashcard không tồn tại.
- `400/422`: validation field.
