# Study Review Backend API Contract

## Response shape khi `activeMode=REVIEW`
- `choices`: mảng rỗng.
- `matchPairs`: mảng rỗng.
- `prompt`: front text.
- `answer`: back text.
- `allowedActions` trước feedback:
  - `MARK_REMEMBERED`
  - `RETRY_ITEM`
  - `RESET_CURRENT_MODE`
- `allowedActions` sau feedback:
  - `GO_NEXT`
  - `RESET_CURRENT_MODE`

## Cách submit
- Review mode không dùng `submit-answer`.
- FE gọi trực tiếp:
  - `POST /mark-remembered`
  - `POST /retry-item`
  - sau đó `POST /next`
