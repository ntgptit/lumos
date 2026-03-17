# Study Guess Frontend Wireframe

## Mục tiêu màn hình
Màn hình `guess` cần giúp người dùng đọc nhanh câu hỏi, so sánh các phương án và chọn đáp án trong thời gian ngắn, đồng thời vẫn hiểu rõ kết quả sau mỗi lần chọn.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Tiêu đề phiên học | Đầu màn hình | Xác định người dùng đang ở mode guess | Tên deck, tên mode | Giữ ổn định trong suốt chặng |
| Thanh tiến độ | Dưới tiêu đề | Tạo cảm giác hoàn thành dần từng câu | Thông tin tiến độ | Cập nhật theo từng câu hỏi |
| Khối câu hỏi | Trung tâm màn hình | Nêu rõ nội dung cần chọn đáp án | Câu hỏi hoặc gợi ý chính | Luôn là điểm tập trung đầu tiên |
| Danh sách phương án | Bên dưới câu hỏi | Cho người dùng lựa chọn giữa nhiều đáp án | Các phương án lựa chọn | Mỗi phương án là một điểm chạm rõ ràng |
| Vùng phản hồi và chuyển tiếp | Cuối màn hình | Cho biết kết quả và hỗ trợ sang câu tiếp theo | Đúng hoặc sai, đáp án đúng, nút tiếp tục | Chỉ hiển thị sau khi người dùng đã chọn |

## Luồng tương tác chính
1. Người dùng đọc câu hỏi ở vùng trung tâm.
2. Người dùng xem các phương án ở bên dưới.
3. Người dùng chọn một đáp án.
4. Màn hình hiển thị phản hồi đúng hoặc sai.
5. Người dùng chuyển sang câu tiếp theo.

## Trạng thái hiển thị
- Trước khi chọn, tất cả phương án ở trạng thái sẵn sàng.
- Sau khi chọn, đáp án đã chọn và đáp án đúng phải được thể hiện đủ rõ để người dùng đối chiếu.
- Tiến độ phải thay đổi đồng thời với việc chuyển câu.

## Nguyên tắc nghiệp vụ trên giao diện
- Câu hỏi phải nổi bật hơn các phương án.
- Các phương án cần có trọng số thị giác tương đương để tránh dẫn hướng sai.
- Phản hồi phải giúp người dùng học được từ lựa chọn vừa rồi, không chỉ báo đúng hoặc sai đơn thuần.
