# TTS Frontend Use Cases

## Mục tiêu nghiệp vụ
`tts` ở frontend hỗ trợ người dùng nghe phát âm trong lúc học và kiểm tra lại cấu hình nghe trong phần hồ sơ cá nhân.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-TTS-001 | Nghe phát âm trong phiên học | Hỗ trợ ghi nhớ qua kênh âm thanh |
| FE-TTS-002 | Tự động phát âm khi vào nội dung mới | Tạo trải nghiệm học liền mạch hơn |
| FE-TTS-003 | Dừng phát âm khi đổi nội dung | Tránh gây rối trải nghiệm nghe |
| FE-TTS-004 | Nghe thử cấu hình giọng đọc trong hồ sơ | Giúp người dùng kiểm tra lựa chọn của mình |

## FE-TTS-001 - Nghe phát âm trong phiên học
### Mục tiêu
Cho người dùng chủ động nghe cách đọc của nội dung đang học.

### Luồng chính
1. Người dùng chọn phát âm trên màn hình học.
2. Ứng dụng dùng cấu hình giọng đọc hiện tại để phát nội dung.
3. Ứng dụng phản ánh trạng thái đang phát hoặc đã dừng.

## FE-TTS-002 - Tự động phát âm khi vào nội dung mới
### Mục tiêu
Giảm thao tác lặp lại khi người dùng muốn nghe phát âm liên tục trong lúc học.

### Luồng chính
1. Người dùng bật chế độ tự phát.
2. Mỗi khi nội dung học thay đổi, ứng dụng tự phát âm nếu nội dung đó có thể nghe.

## FE-TTS-003 - Dừng phát âm khi đổi nội dung
### Mục tiêu
Tránh việc âm thanh của nội dung cũ chồng lên nội dung mới.

### Luồng chính
1. Khi người dùng chuyển sang một nội dung học khác, ứng dụng dừng phần âm thanh đang chạy.
2. Ứng dụng đồng bộ lại trạng thái phát âm theo nội dung mới.

## FE-TTS-004 - Nghe thử cấu hình giọng đọc trong hồ sơ
### Mục tiêu
Giúp người dùng đánh giá trước xem cấu hình giọng đọc hiện tại có phù hợp hay không.

### Luồng chính
1. Người dùng thay đổi một hoặc nhiều thuộc tính giọng đọc.
2. Người dùng chọn nghe thử.
3. Ứng dụng phát đoạn preview tương ứng.
