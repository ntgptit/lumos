# Study Session Principles

## Mục tiêu

Study là hệ thống học theo session, trong đó backend là nơi sở hữu trạng thái nghiệp vụ chuẩn của toàn bộ quá trình học.

## Phạm vi

Mỗi `StudySession`:

- gắn với một bộ nội dung học
- có thể bắt đầu, tiếp tục và resume
- gồm nhiều mode học
- có progress tổng
- có lịch sử thao tác
- có completion rule rõ ràng

Study hỗ trợ hai ngữ cảnh:

- `first-learning session`
- `review session`

## Quy tắc mode

Hệ thống hỗ trợ 5 mode:

1. `review`
2. `match`
3. `guess`
4. `recall`
5. `fill`

Policy sử dụng mode:

- `first-learning session`: đi qua đủ 5 mode
- `review session`: chỉ dùng `fill`

## Phân chia trách nhiệm

### Backend

Backend sở hữu:

- current state
- answer result
- retry queue
- progress
- completion rule
- resume snapshot
- history / event log

### Frontend

Frontend chỉ nên giữ:

- render UI
- animation
- local temporary interaction
- optimistic UI nếu cần

Frontend không giữ business truth của session học.

## UI behavior và business behavior

### UI behavior

Do frontend quản lý:

- animation
- loading
- disable nút tạm thời
- hiệu ứng phản hồi giao diện
- ô nhập liệu đang gõ dở
- đếm ngược hiển thị
- audio indicator

### Business behavior

Do backend quản lý:

- user trả lời đúng hay sai
- item nào cần học lại
- mode đã hoàn thành hay chưa
- có được chuyển bước tiếp theo hay không
- progress được tính như thế nào
- session resume từ đâu
- action nào được phép tiếp theo
