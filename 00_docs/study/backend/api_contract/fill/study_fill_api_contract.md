# Study Fill Backend API Contract

## Response shape khi `activeMode=FILL`

- `choices`: mảng rỗng.
- `matchPairs`: mảng rỗng.
- Payload backend giữ:
  - `prompt`: front text
  - `answer`: back text
- FE hiện đang đảo cách hiển thị để bắt user gõ lại `frontText`.
- `allowedActions` trước feedback:
  - `SUBMIT_ANSWER`
  - `REVEAL_ANSWER`
  - `RESET_CURRENT_MODE`
- `allowedActions` khi đang retry sau reveal hoặc trả lời sai:
  - `REVEAL_ANSWER`
  - `SUBMIT_ANSWER`
  - `RESET_CURRENT_MODE`
- `allowedActions` khi đã đúng:
  - `GO_NEXT`
  - `RESET_CURRENT_MODE`

## Submit contract

- Endpoint: `POST /submit-answer`
- Body:
  - `answer: string`
- Ghi chú:
  - `REVEAL_ANSWER` trong fill mode được backend tính là `FAILED`.
