# Progress Backend API Contract

## `GET /api/v1/study/reminders/summary`

- Mục đích: Trả snapshot nhắc học.
- Response:
  - `dueCount`
  - `overdueCount`
  - `escalationLevel`
  - `reminderTypes[]`
  - `recommendation`
    - `deckId`
    - `deckName`
    - `dueCount`
    - `overdueCount`
    - `estimatedSessionMinutes`
    - `recommendedSessionType`

## `GET /api/v1/study/analytics/overview`

- Mục đích: Trả snapshot analytics SRS.
- Response:
  - `totalLearnedItems`
  - `dueCount`
  - `overdueCount`
  - `passedAttempts`
  - `failedAttempts`
  - `boxDistribution`

## Ghi chú

- Hai endpoint này là contract backend chính cho màn hình `progress`.
- Cả hai đều yêu cầu user đã xác thực.
