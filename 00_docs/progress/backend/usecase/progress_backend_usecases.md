# Progress Backend Use Cases

## Mục tiêu nghiệp vụ
Feature `progress` ở backend tổng hợp các tín hiệu học tập dài hạn để người dùng biết mình đang có bao nhiêu nội dung đến hạn, bao nhiêu nội dung quá hạn và mức phân bố tiến độ theo SRS.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-PROGRESS-001 | Tính tổng quan nhắc học | Cho người dùng biết mức độ cấp bách của backlog học |
| BE-PROGRESS-002 | Tính tổng quan tiến độ SRS | Cho người dùng biết trạng thái học tập dài hạn |

## BE-PROGRESS-001 - Tính tổng quan nhắc học
### Mục tiêu
Tạo ra một bản tóm tắt dễ hiểu về khối lượng nội dung cần học lại.

### Luồng chính
1. Hệ thống đọc các trạng thái học tập của người dùng.
2. Hệ thống xác định số nội dung đã đến hạn.
3. Hệ thống xác định số nội dung quá hạn.
4. Hệ thống suy ra mức độ nhắc học tương ứng.
5. Hệ thống xác định deck nên được ưu tiên học tiếp.
6. Hệ thống trả về bản tóm tắt nhắc học.

## BE-PROGRESS-002 - Tính tổng quan tiến độ SRS
### Mục tiêu
Cho người dùng thấy bức tranh dài hạn về tiến độ ghi nhớ.

### Luồng chính
1. Hệ thống tổng hợp số nội dung đã đi vào chu trình học lặp lại.
2. Hệ thống thống kê phân bố theo từng mức hộp SRS.
3. Hệ thống thống kê số lượt học đúng và sai.
4. Hệ thống trả về bản tóm tắt tiến độ học.
