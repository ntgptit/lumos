# Progress Frontend Wireframe

## Mục tiêu màn hình
Màn hình `progress` phải đóng vai trò như một bảng điều khiển tiến độ đơn giản, giúp người dùng trả lời nhanh ba câu hỏi: còn bao nhiêu nội dung cần học, nên học gì trước và mức độ tiến bộ đang ở đâu.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Thẻ tổng quan động lực | Đầu màn hình | Tóm tắt số nội dung đến hạn, quá hạn và mức cảnh báo | Due, overdue, mức nhắc học | Luôn hiển thị khi có dữ liệu |
| Thẻ gợi ý học tiếp | Giữa màn hình, có điều kiện | Khuyến nghị deck nên học ngay | Tên deck, số nội dung cần học, CTA | Chỉ hiện khi có đề xuất |
| Thẻ phân bố tiến độ | Cuối màn hình | Giải thích trạng thái học dài hạn theo SRS | Phân bố theo box | Luôn hiển thị khi có dữ liệu |

## Trạng thái cần hỗ trợ
- Đang tải dữ liệu.
- Tải lỗi và cần thử lại.
- Có dữ liệu đầy đủ.
- Có hoặc không có thẻ gợi ý học tiếp.

## Quy tắc hiển thị
- Thẻ động lực phải đứng đầu vì đây là thông tin có tính hành động cao nhất.
- Thẻ gợi ý học tiếp phải được đặt giữa để dẫn sang phiên học.
- Thẻ phân bố tiến độ đóng vai trò giải thích sâu hơn, nên đặt phía sau.
