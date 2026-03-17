# Reminder Backend Use Cases

## Mục tiêu nghiệp vụ
Feature `reminder` giúp hệ thống nhận diện người dùng đang có nội dung nào đến hạn hoặc quá hạn, từ đó đưa ra mức nhắc học và gợi ý hành động ưu tiên.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-REMINDER-001 | Xác định mức nhắc học | Phản ánh mức độ cấp bách của backlog học tập |
| BE-REMINDER-002 | Gợi ý deck nên học tiếp | Đưa ra điểm bắt đầu hợp lý cho lần học kế tiếp |

## BE-REMINDER-001 - Xác định mức nhắc học
### Mục tiêu
Cho người dùng một tín hiệu rõ ràng về việc có cần quay lại học ngay hay không.

### Luồng chính
1. Hệ thống đọc toàn bộ trạng thái học của người dùng.
2. Hệ thống xác định số nội dung đã đến hạn.
3. Hệ thống xác định số nội dung quá hạn.
4. Hệ thống phân loại mức nhắc học phù hợp.
5. Hệ thống trả lại kết quả tổng hợp.

## BE-REMINDER-002 - Gợi ý deck nên học tiếp
### Mục tiêu
Giảm thời gian người dùng phải tự quyết định nên ôn deck nào trước.

### Luồng chính
1. Hệ thống nhóm các nội dung đến hạn theo từng deck.
2. Hệ thống chọn deck có khối lượng cần xử lý lớn nhất.
3. Hệ thống ước tính thời lượng phiên học.
4. Hệ thống trả gợi ý deck ưu tiên.
