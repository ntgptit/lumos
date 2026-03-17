# TTS Backend API Contract

## Kết luận hiện trạng

- Không có endpoint TTS standalone.
- Contract TTS nằm rải trong 2 chỗ:
  - `GET/PUT /api/v1/profile/speech-preference`
  - `StudySessionResponse.currentItem.speech`

## Speech Preference Contract

- `enabled`
- `autoPlay`
- `adapter`
- `voice`
- `speed`
- `pitch`
- `locale`

## Speech Capability Contract trong study item

- `enabled`
- `autoPlay`
- `available`
- `adapter`
- `locale`
- `voice`
- `speed`
- `pitch`
- `fieldName`
- `sourceType`
- `audioUrl`
- `allowedActions`
- `speechText`
