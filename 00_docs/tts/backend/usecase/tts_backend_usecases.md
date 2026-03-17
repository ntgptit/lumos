# TTS Backend Use Cases

## Mục tiêu nghiệp vụ
`tts` ở backend hiện không phải một chức năng phát âm độc lập, mà là năng lực hỗ trợ cho học tập và hồ sơ người dùng thông qua cấu hình giọng đọc và khả năng phát âm của nội dung đang học.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-TTS-001 | Lưu cấu hình giọng đọc cá nhân | Cho mỗi người dùng có trải nghiệm nghe phù hợp |
| BE-TTS-002 | Xác định nội dung có thể phát âm trong phiên học | Cho frontend biết lúc nào nên bật tính năng nghe |

## BE-TTS-001 - Lưu cấu hình giọng đọc cá nhân
### Mục tiêu
Giúp người dùng duy trì một cấu hình giọng đọc nhất quán giữa các lần sử dụng.

### Luồng chính
1. Hệ thống tạo cấu hình mặc định nếu người dùng chưa có.
2. Hệ thống lưu lựa chọn bật tắt, tự phát, giọng, tốc độ và cao độ.
3. Hệ thống trả lại cấu hình đang áp dụng.

## BE-TTS-002 - Xác định nội dung có thể phát âm trong phiên học
### Mục tiêu
Cho frontend biết tại thời điểm nào có thể hỗ trợ nghe phát âm.

### Luồng chính
1. Hệ thống đọc cấu hình giọng đọc của người dùng.
2. Hệ thống kiểm tra nội dung học hiện tại có văn bản phù hợp để phát âm hay không.
3. Hệ thống trả về thông tin khả dụng phát âm cùng các hành động được phép.

### Ghi chú BA
- Backend hiện không chịu trách nhiệm sinh file âm thanh hoàn chỉnh.
- Trách nhiệm chính là quản lý quy tắc và cấu hình cho việc phát âm.
