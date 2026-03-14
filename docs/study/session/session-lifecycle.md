# Study Session Lifecycle

## State machine chung

Mọi mode học phải map được về một khung lifecycle chung:

- `initialized`
- `in_progress`
- `waiting_feedback`
- `retry_pending`
- `completed`

Ý nghĩa:

- `initialized`: mode đã được tạo nhưng chưa bắt đầu tương tác thực sự
- `in_progress`: mode đang ở trạng thái học bình thường
- `waiting_feedback`: mode đang chờ phản hồi nghiệp vụ sau một action
- `retry_pending`: mode có item đang chờ học lại hoặc xử lý lại
- `completed`: mode đã thỏa mãn completion policy

## Command model

Study session dùng command-based API.

Các command chuẩn:

- `startSession`
- `resumeSession`
- `submitAnswer`
- `revealAnswer`
- `markRemembered`
- `retryItem`
- `goNext`
- `completeMode`

Mỗi command trả về:

- canonical updated state
- progress summary
- next allowed actions

Lưu ý:

- canonical learning outcome chỉ có `passed` hoặc `failed`
- các command hỗ trợ như `revealAnswer` không tự sinh ra outcome riêng
- outcome chỉ được chốt khi user hoàn tất bước đánh giá hoặc kiểm tra của mode hiện tại

## Tạo session

Backend quyết định loại session cần mở:

- `first-learning session`
- `review session`

Từ đó backend quyết định mode plan:

- học mới: đủ 5 mode
- ôn tập: `fill`

## Progress và completion

Progress cần được backend tính và trả về nhất quán ở ba mức:

- item-level
- mode-level
- session-level

Completion cũng phải được backend quyết định ở ba mức:

- item completed
- mode completed
- session completed

## Resume

Khi user quay lại session, hệ thống phải khôi phục được:

- mode đang active
- state hiện tại của mode
- item hiện tại
- progress hiện tại
- retry queue hiện tại
- action tiếp theo được phép
- mode plan tương ứng với loại session hiện tại

Resume dựa trên snapshot state do backend sở hữu.

## Đặc tính mở rộng

Thiết kế session phải cho phép:

- thêm mode mới mà không phải copy logic cũ
- thay đổi completion policy mà không làm vỡ flow chung
- làm code review dễ hiểu vì flow đã được chuẩn hóa
