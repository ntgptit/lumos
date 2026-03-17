# Study Recall Backend API Contract

## Response shape khi `activeMode=RECALL`
- `choices`: mảng rỗng.
- `matchPairs`: mảng rỗng.
- `prompt`: front text.
- `answer`: back text.
- `allowedActions` trước reveal:
  - `REVEAL_ANSWER`
  - `RESET_CURRENT_MODE`
- `allowedActions` sau reveal, trước khi chấm:
  - `MARK_REMEMBERED`
  - `RETRY_ITEM`
  - `GO_NEXT`
  - `RESET_CURRENT_MODE`
- `allowedActions` sau khi đã chấm:
  - `GO_NEXT`
  - `RESET_CURRENT_MODE`

## Command contract
- Reveal: `POST /reveal-answer`
- Remembered: `POST /mark-remembered`
- Retry: `POST /retry-item`
- Next: `POST /next`
