# Study Documentation

Tài liệu `study` được tách theo domain để dễ quản lý và mở rộng.

## Cấu trúc

- [Session Overview](/D:/workspace/learnwise/docs/study/session/README.md)
- [Session Principles](/D:/workspace/learnwise/docs/study/session/principles.md)
- [Session Domain Model](/D:/workspace/learnwise/docs/study/session/domain-model.md)
- [Session Lifecycle](/D:/workspace/learnwise/docs/study/session/session-lifecycle.md)
- [Text To Speech](/D:/workspace/learnwise/docs/study/session/text-to-speech.md)
- [Spaced Repetition Overview](/D:/workspace/learnwise/docs/study/spaced-repetition/README.md)
- [7-Box Model](/D:/workspace/learnwise/docs/study/spaced-repetition/7-box-model.md)
- [Review Policy](/D:/workspace/learnwise/docs/study/spaced-repetition/review-policy.md)
- [Reminder](/D:/workspace/learnwise/docs/study/spaced-repetition/reminder.md)
- [Reminder Strategies](/D:/workspace/learnwise/docs/study/spaced-repetition/reminder-strategies.md)
- [Resume And Analytics](/D:/workspace/learnwise/docs/study/spaced-repetition/resume-and-analytics.md)

## Nguyên tắc chung

- Backend là nơi sở hữu canonical state của session học.
- Frontend chỉ giữ UI behavior và local temporary interaction.
- Study session và spaced repetition là hai lớp nghiệp vụ riêng nhưng nối với nhau.
