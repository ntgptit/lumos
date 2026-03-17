# Profile Backend API Contract

## `GET /api/v1/profile`

- Mục đích: Trả snapshot profile tổng hợp.
- Response:
  - `user`
    - `id`
    - `username`
    - `email`
    - `accountStatus`
  - `studyPreference`
    - `firstLearningCardLimit`
  - `speechPreference`
    - `enabled`
    - `autoPlay`
    - `adapter`
    - `voice`
    - `speed`
    - `pitch`
    - `locale`

## `GET /api/v1/profile/study-preference`

- Response:
  - `firstLearningCardLimit`

## `PUT /api/v1/profile/study-preference`

- Request body:
  - `firstLearningCardLimit: number`
- Validation:
  - min `1`
  - max `100`
- Response:
  - `StudyPreferenceResponse`

## `GET /api/v1/profile/speech-preference`

- Response:
  - `enabled`
  - `autoPlay`
  - `adapter`
  - `voice`
  - `speed`
  - `pitch`
  - `locale`

## `PUT /api/v1/profile/speech-preference`

- Request body:
  - `enabled: boolean`
  - `autoPlay: boolean`
  - `adapter: enum`
  - `voice: string`
  - `speed: number`
  - `pitch: number`
- Validation:
  - `speed` và `pitch` trong khoảng `0.5` đến `2.0`
- Response:
  - `SpeechPreferenceResponse`
