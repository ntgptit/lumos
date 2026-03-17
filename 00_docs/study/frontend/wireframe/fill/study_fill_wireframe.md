# Study Fill Frontend Wireframe

## Mục tiêu màn hình
Màn hình `fill` cần buộc người dùng tự nhập đáp án, qua đó phản ánh chính xác hơn mức độ ghi nhớ. Màn hình phải làm nổi bật vùng nhập liệu nhưng vẫn hỗ trợ người dùng học từ đáp án đúng khi cần.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Tiêu đề phiên học | Đầu màn hình | Xác định người dùng đang ở mode fill | Tên deck, tên mode | Cố định trong chặng fill |
| Thanh tiến độ | Dưới tiêu đề | Thể hiện mức độ hoàn thành hiện tại | Tiến độ của mode hoặc phiên | Cập nhật sau mỗi nội dung |
| Khối câu hỏi hoặc gợi ý | Trung tâm trên | Nêu rõ người dùng cần trả lời điều gì | Câu hỏi, từ gợi ý hoặc ngữ cảnh | Là điểm nhìn đầu tiên trước vùng nhập |
| Vùng nhập đáp án | Trung tâm giữa | Cho người dùng tự gõ câu trả lời | Ô nhập, chỉ dẫn ngắn | Luôn sẵn sàng cho thao tác chính |
| Vùng hỗ trợ và phản hồi | Nửa dưới màn hình | Hỗ trợ xem đáp án, biết kết quả và quyết định bước tiếp theo | Nút kiểm tra, xem đáp án, phản hồi, tiếp tục | Thay đổi theo kết quả người dùng vừa nhận |

## Luồng tương tác chính
1. Người dùng đọc câu hỏi hoặc gợi ý.
2. Người dùng nhập câu trả lời vào vùng nhập.
3. Người dùng chọn kiểm tra kết quả.
4. Màn hình phản hồi đạt hoặc chưa đạt.
5. Nếu cần, người dùng xem đáp án mẫu rồi thử lại hoặc chuyển tiếp.

## Trạng thái hiển thị
- Trước khi gửi câu trả lời, vùng nhập phải là điểm nổi bật nhất trên màn hình.
- Sau khi kiểm tra, phản hồi cần đủ rõ để người dùng biết mình nên thử lại hay có thể đi tiếp.
- Khi người dùng chọn xem đáp án, đáp án đúng phải được trình bày nổi bật nhưng không lấn át hoàn toàn vùng luyện tập.

## Nguyên tắc nghiệp vụ trên giao diện
- Hành động chính của mode fill là nhập và kiểm tra đáp án, nên các thành phần khác phải phục vụ cho mục tiêu đó.
- Không biến màn hình fill thành một màn xem đáp án đơn thuần.
- Khi phản hồi chưa đạt, giao diện phải khuyến khích học tiếp thay vì tạo cảm giác thất bại.
