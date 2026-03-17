# Reminder Backend API Contract

## `GET /api/v1/study/reminders/summary`

- Mục đích: Trả contract nhắc học cho user hiện tại.
- Response:
  - `dueCount: number`
  - `overdueCount: number`
  - `escalationLevel: string`
  - `reminderTypes: string[]`
  - `recommendation: object | null`
    - `deckId`
    - `deckName`
    - `dueCount`
    - `overdueCount`
    - `estimatedSessionMinutes`
    - `recommendedSessionType`

## Ghi chú

- Đây là contract backend riêng của module `reminder`, nhưng hiện FE tiêu thụ contract này thông qua feature `progress`.
