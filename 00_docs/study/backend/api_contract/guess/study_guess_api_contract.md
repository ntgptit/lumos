# Study Guess Backend API Contract

## Response shape khi `activeMode=GUESS`

- `choices`: danh sách multiple choice, tối đa 5 phần tử.
- `matchPairs`: mảng rỗng.
- `prompt`: front text.
- `answer`: back text.
- `allowedActions` trước feedback:
  - `SUBMIT_ANSWER`
  - `RESET_CURRENT_MODE`
- `allowedActions` sau feedback:
  - `GO_NEXT`
  - `RESET_CURRENT_MODE`

## Submit contract

- Endpoint: `POST /submit-answer`
- Body:
  - `answer: string`
  - `matchedPairs: []`
