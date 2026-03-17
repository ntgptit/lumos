# Study Frontend Shared Wireframe

## Mục tiêu màn hình
Khung màn hình `study` cần giữ người dùng tập trung vào một nội dung tại một thời điểm, đồng thời cho họ cảm nhận rõ tiến độ, mode hiện tại và các hành động phù hợp ở từng bước.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Thông tin phiên học | Đầu màn hình | Giúp người dùng biết mình đang học deck nào và đang ở chặng nào | Tên deck, tên mode, chỉ báo trạng thái phiên | Luôn hiển thị xuyên suốt phiên học |
| Thanh tiến độ | Ngay dưới phần đầu | Cho người dùng biết mức độ hoàn thành hiện tại | Số nội dung đã làm, mức độ hoàn tất của phiên | Cập nhật sau mỗi nội dung |
| Vùng nội dung chính | Trung tâm màn hình | Là nơi người dùng tập trung xử lý nội dung học | Câu hỏi, gợi ý, thẻ nội dung hoặc bài tập theo mode | Thay đổi theo mode nhưng giữ vai trò trung tâm |
| Vùng hành động chính | Nửa dưới màn hình | Cho người dùng thực hiện bước học kế tiếp | Nút chọn đáp án, đánh dấu nhớ, xem đáp án, tiếp tục | Chỉ hiển thị các hành động phù hợp với bước hiện tại |
| Vùng hỗ trợ | Cuối màn hình hoặc gắn gần nội dung | Hỗ trợ học nhưng không làm loãng trọng tâm chính | Nghe phát âm, làm lại mode, trợ giúp ngắn | Chỉ xuất hiện khi ngữ cảnh cho phép |

## Luồng tương tác chính
1. Người dùng vào màn hình học từ một deck hoặc tiếp tục phiên đang dở.
2. Màn hình cho thấy ngay deck hiện tại, mode hiện tại và tiến độ chung.
3. Người dùng xử lý nội dung tại vùng trung tâm.
4. Người dùng dùng các hành động ở vùng dưới để phản hồi hoặc chuyển bước.
5. Màn hình cập nhật tiến độ và thay nội dung tiếp theo mà vẫn giữ bố cục tổng thể ổn định.

## Trạng thái hiển thị
- Khi mới vào phiên học, màn hình cần ưu tiên cho người dùng thấy rõ họ đang bắt đầu ở mode nào.
- Trong lúc đang học, bố cục chính không thay đổi đột ngột giữa các nội dung liên tiếp.
- Khi hoàn tất một mode, màn hình phải cho thấy đã chuyển chặng thành công.
- Khi hoàn tất toàn bộ phiên, màn hình phải hiển thị kết quả kết thúc rõ ràng.

## Nguyên tắc nghiệp vụ trên giao diện
- Mỗi thời điểm chỉ nên có một nội dung trọng tâm để người dùng xử lý.
- Tiến độ phải đủ nổi bật để tạo động lực nhưng không được lấn át nội dung học.
- Các hành động phụ như nghe phát âm hoặc làm lại mode phải đứng sau hành động chính.
- Dù mode thay đổi, người dùng vẫn phải cảm nhận được mình đang ở trong cùng một hành trình học.
