# Study Shared Backend API Contract

## Session endpoints

### `POST /api/v1/study/sessions`
- Mục đích: Tạo study session mới.
- Request body:
  - `deckId: number`
  - `preferredSessionType: FIRST_LEARNING | REVIEW | null`
- Response:
  - HTTP `201 Created`
  - `sessionId`
  - `deckId`
  - `deckName`
  - `sessionType`
  - `activeMode`
  - `modeState`
  - `modePlan[]`
  - `allowedActions[]`
  - `progress`
  - `currentItem`
  - `sessionCompleted`

### `GET /api/v1/study/sessions/{sessionId}`
- Mục đích: Resume session đã có.
- Response:
  - HTTP `200 OK`
  - Cùng shape `StudySessionResponse`

### `POST /api/v1/study/sessions/{sessionId}/submit-answer`
- Mục đích: Submit answer text hoặc matched pairs.
- Request body:
  - `answer: string | null`
  - `matchedPairs: [{ leftId, rightId }]`
- Quy tắc:
  - Mode `MATCH` cần `matchedPairs`.
  - Mode khác cần `answer`.

### Các command endpoint khác
- `POST /reveal-answer`
- `POST /mark-remembered`
- `POST /retry-item`
- `POST /next`
- `POST /reset-current-mode`
- `POST /complete-mode`
- `POST /api/v1/study/decks/{deckId}/reset-progress`

## Response `StudySessionResponse`
- `progress`
  - `completedItems`
  - `totalItems`
  - `completedModes`
  - `totalModes`
  - `itemProgress`
  - `modeProgress`
  - `sessionProgress`
- `currentItem`
  - `flashcardId`
  - `prompt`
  - `answer`
  - `note`
  - `pronunciation`
  - `instruction`
  - `inputPlaceholder`
  - `choices[]`
  - `matchPairs[]`
  - `speech`

## Trạng thái lifecycle
- `INITIALIZED`
- `IN_PROGRESS`
- `WAITING_FEEDBACK`
- `RETRY_PENDING`
- `COMPLETED`
