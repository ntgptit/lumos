# Study Session Overview

Phần này mô tả lớp `study session`.

Study session là lớp thực thi phiên học:

- quản lý mode hiện tại
- quản lý state của session
- trả canonical state cho frontend
- thực thi flow học trong từng phiên

## Tài liệu con

- [Principles](/D:/workspace/lumos/docs/study/session/principles.md)
- [Study Modes](/D:/workspace/lumos/docs/study/session/study-modes.md)
- [Domain Model](/D:/workspace/lumos/docs/study/session/domain-model.md)
- [Session Lifecycle](/D:/workspace/lumos/docs/study/session/session-lifecycle.md)
- [Text To Speech](/D:/workspace/lumos/docs/study/session/text-to-speech.md)

## Quy tắc sản phẩm

- lần đầu user học nội dung qua đủ 5 mode
- các lần ôn tập tiếp theo chỉ học bằng `fill`
- mọi item học chỉ chốt bằng 2 outcome: `passed` hoặc `failed`
