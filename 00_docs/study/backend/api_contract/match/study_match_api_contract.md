# Study Match Backend API Contract

## Response shape khi `activeMode=MATCH`
- `choices`: mảng rỗng.
- `matchPairs`: chứa toàn bộ grid ghép cặp của session hiện tại.
- `prompt` và `answer`: vẫn có trong payload current item, nhưng UI chính dùng `matchPairs`.
- `allowedActions` trước feedback:
  - `SUBMIT_ANSWER`
  - `RESET_CURRENT_MODE`
- `allowedActions` sau feedback:
  - `GO_NEXT`
  - `RESET_CURRENT_MODE`

## Submit contract
- Endpoint: `POST /api/v1/study/sessions/{sessionId}/submit-answer`
- Body:
  - `answer: "match"` hoặc chuỗi placeholder từ FE
  - `matchedPairs`
    - `leftId`
    - `rightId`
