# Study Session Domain Model

## Mục tiêu

Phần này chốt các khái niệm domain của lớp `study session`.

## Các thực thể cốt lõi

### StudySession

Aggregate gốc của vòng học.

Nó giữ:

- session identity
- mode đang active
- progress tổng
- trạng thái tổng của session
- snapshot dùng để resume

### StudyMode

Là loại hình học trong session.

Mỗi mode phải có:

- identity rõ ràng
- state machine rõ ràng
- danh sách action được phép
- completion rule rõ ràng

Mode plan theo session:

- `first-learning session`: full mode cycle
- `review session`: `fill`

### SessionItem

Đơn vị học của session.

Nó là bản chụp nghiệp vụ của nội dung tại thời điểm session được tạo và dùng để:

- render nội dung học
- theo dõi trạng thái học của từng item
- tính progress
- gắn với attempt và event

### ModeState

Trạng thái runtime chuẩn của một mode trong session.

ModeState cần mô tả được:

- mode đang ở trạng thái nào
- item hiện tại là gì
- progress hiện tại ra sao
- action nào được phép tiếp theo
- mode đã hoàn thành hay chưa

### Attempt / Event

Log chuẩn của các hành động học tập có giá trị nghiệp vụ.

Dùng cho:

- audit
- analytics
- trace hành vi thực tế

### ProgressSnapshot

Ảnh chụp tiến độ hiện tại, tối ưu cho:

- resume nhanh
- render nhanh
- đồng bộ trạng thái hiện hành

### CompletionPolicy

Policy định nghĩa:

- khi nào item completed
- khi nào mode completed
- khi nào session completed
- item nào cần retry
- progress được tính như thế nào

## Ba lớp dữ liệu cần tách riêng

### Master content

Dữ liệu gốc của nội dung học:

- deck
- flashcard
- câu hỏi
- đáp án

### Snapshot state

Dữ liệu của session cụ thể, dùng để:

- khóa bộ nội dung học của session
- khôi phục session chính xác
- render current state nhanh

### Event log / attempts

Dữ liệu ghi lại hành vi học tập có ý nghĩa nghiệp vụ.

Phục vụ:

- analytics
- audit
- trace hành vi thật
