# Study Recall Frontend Wireframe

## Mục tiêu màn hình
Màn hình `recall` cần tạo khoảng dừng cho việc tự nhớ lại trước khi người dùng nhìn thấy đáp án. Đây là màn hình mang tính suy nghĩ hơn các mode khác nên phải làm rõ hai giai đoạn: nhớ lại và đối chiếu.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Tiêu đề phiên học | Đầu màn hình | Xác định người dùng đang ở mode recall | Tên deck, tên mode | Cố định trong suốt chặng |
| Thanh tiến độ | Dưới tiêu đề | Giúp người dùng biết mình còn bao nhiêu nội dung cần nhớ lại | Tiến độ hiện tại | Cập nhật sau mỗi nội dung |
| Khối gợi nhớ | Trung tâm trên | Hiển thị câu hỏi hoặc gợi ý để kích hoạt trí nhớ | Nội dung cần nhớ lại | Luôn xuất hiện trước đáp án |
| Vùng đáp án ẩn hoặc hiện | Trung tâm dưới | Cho người dùng đối chiếu với đáp án khi đã sẵn sàng | Khu vực chờ hoặc đáp án chuẩn | Ban đầu ẩn, chỉ hiển thị khi người dùng yêu cầu |
| Nhóm hành động tự đánh giá | Cuối màn hình | Hỗ trợ lần lượt xem đáp án, đánh giá đã nhớ hoặc cần học lại, và đi tiếp | Nút xem đáp án, đã nhớ, cần học lại, tiếp tục | Thay đổi theo giai đoạn của nội dung |

## Luồng tương tác chính
1. Người dùng nhìn gợi ý và tự nhớ lại câu trả lời.
2. Khi sẵn sàng, người dùng chọn xem đáp án.
3. Màn hình hiển thị đáp án để người dùng đối chiếu.
4. Người dùng tự đánh giá mình đã nhớ hay chưa.
5. Người dùng chuyển sang nội dung tiếp theo.

## Trạng thái hiển thị
- Trước khi mở đáp án, vùng đáp án chỉ nên là khu vực chờ để giữ tập trung cho giai đoạn nhớ lại.
- Sau khi mở đáp án, các hành động tự đánh giá mới được làm nổi bật.
- Nếu người dùng chọn cần học lại, màn hình phải phản hồi rõ rằng nội dung này sẽ được xử lý thêm.

## Nguyên tắc nghiệp vụ trên giao diện
- Không để đáp án lộ sớm trước khi người dùng quyết định xem.
- Hai giai đoạn nhớ lại và tự đánh giá phải được tách biệt rõ ràng về mặt thị giác.
- Vùng hành động phải giúp người dùng hiểu ngay bước tiếp theo cần làm là gì.
