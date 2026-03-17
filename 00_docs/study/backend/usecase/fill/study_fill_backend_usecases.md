# Study Backend Fill Use Cases

## Mục tiêu nghiệp vụ
Mode `fill` ở backend hỗ trợ chặng gõ lại đáp án, giúp kiểm tra khả năng nhớ chính xác thay vì chỉ nhận biết hoặc tự đánh giá cảm tính.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-STUDY-FILL-001 | Chuẩn bị câu hỏi điền đáp án | Tạo tình huống buộc người dùng tự nhập câu trả lời |
| BE-STUDY-FILL-002 | Chấm mức độ chính xác của câu trả lời | Đánh giá nội dung người dùng nhập so với đáp án chuẩn |
| BE-STUDY-FILL-003 | Hỗ trợ xem đáp án và làm lại | Giúp người dùng sửa sai và tiếp tục luyện ngay trong phiên |

## BE-STUDY-FILL-001 - Chuẩn bị câu hỏi điền đáp án
### Mục tiêu
Đưa ra câu hỏi mà người dùng phải tự nhập câu trả lời thay vì chọn sẵn phương án.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Phiên học có mode fill.

### Hậu điều kiện
- Một nội dung điền đáp án được chuẩn bị cho người dùng.

### Luồng chính
1. Hệ thống chọn nội dung cần kiểm tra ở mode fill.
2. Hệ thống xác định câu gợi ý và đáp án chuẩn.
3. Hệ thống đưa nội dung vào trạng thái chờ người dùng nhập câu trả lời.

### Quy tắc nghiệp vụ
- Mục tiêu của mode fill là đánh giá khả năng nhớ chính xác bằng cách tự gõ lại.
- Câu hỏi phải đủ rõ để người dùng hiểu mình cần nhập điều gì.

## BE-STUDY-FILL-002 - Chấm mức độ chính xác của câu trả lời
### Mục tiêu
Xác định câu trả lời người dùng nhập có đạt yêu cầu hay không.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Người dùng đã nhập câu trả lời cho nội dung hiện tại.

### Hậu điều kiện
- Kết quả đúng hoặc chưa đúng của lần nhập được ghi nhận.

### Luồng chính
1. Người dùng gửi câu trả lời đã nhập.
2. Hệ thống chuẩn hóa dữ liệu cần thiết trước khi so sánh.
3. Hệ thống đối chiếu câu trả lời với đáp án chuẩn theo quy tắc đã đặt ra.
4. Hệ thống xác định kết quả đạt hoặc chưa đạt.
5. Hệ thống cập nhật tiến độ của nội dung trong phiên học.

### Quy tắc nghiệp vụ
- Tiêu chí chấm phải nhất quán giữa các lần thử của cùng một nội dung.
- Kết quả đúng chỉ được ghi nhận khi mức độ chính xác đạt ngưỡng yêu cầu.

## BE-STUDY-FILL-003 - Hỗ trợ xem đáp án và làm lại
### Mục tiêu
Cho phép người dùng học từ lỗi sai ngay trong lúc làm bài và thử lại sau khi đã xem đáp án đúng.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Nội dung fill hiện tại đang chờ trả lời hoặc vừa trả lời chưa đạt.

### Hậu điều kiện
- Người dùng có thể nhìn thấy đáp án chuẩn và tiếp tục luyện lại nếu cần.

### Luồng chính
1. Người dùng yêu cầu xem đáp án khi chưa chắc chắn hoặc sau khi làm sai.
2. Hệ thống mở đáp án chuẩn cho nội dung hiện tại.
3. Hệ thống ghi nhận rằng nội dung này cần được luyện thêm.
4. Hệ thống cho phép người dùng nhập lại hoặc gặp lại nội dung này ở lượt sau.

### Quy tắc nghiệp vụ
- Việc xem đáp án không đồng nghĩa với việc đã hoàn thành tốt nội dung.
- Nội dung cần xem đáp án phải được xem là chưa đạt về chất lượng ghi nhớ.
