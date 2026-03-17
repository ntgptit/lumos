# Study Backend Guess Use Cases

## Mục tiêu nghiệp vụ
Mode `guess` ở backend hỗ trợ chặng lựa chọn đáp án đúng, giúp người dùng kiểm tra khả năng nhận biết nhanh giữa các phương án gần giống nhau.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-STUDY-GUESS-001 | Chuẩn bị câu hỏi lựa chọn đáp án | Tạo câu hỏi có đáp án đúng rõ ràng và các phương án đủ sức phân loại |
| BE-STUDY-GUESS-002 | Chấm kết quả chọn đáp án | Xác định người dùng có nhận biết đúng nội dung hay không |
| BE-STUDY-GUESS-003 | Xử lý nội dung trả lời sai | Giữ lại những mục chưa nắm chắc để tiếp tục luyện |

## BE-STUDY-GUESS-001 - Chuẩn bị câu hỏi lựa chọn đáp án
### Mục tiêu
Xây dựng câu hỏi trắc nghiệm giúp đánh giá khả năng nhận biết nhanh của người dùng.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Phiên học có mode guess.
- Nội dung hiện tại có thể tạo ra phương án đúng và phương án nhiễu.

### Hậu điều kiện
- Một câu hỏi nhiều lựa chọn được chuẩn bị cho người dùng.

### Luồng chính
1. Hệ thống chọn nội dung cần kiểm tra ở mode guess.
2. Hệ thống xác định đáp án đúng.
3. Hệ thống chọn thêm các phương án nhiễu phù hợp.
4. Hệ thống sắp xếp các phương án trước khi đưa cho người dùng.

### Quy tắc nghiệp vụ
- Trong mỗi câu hỏi chỉ có một đáp án đúng.
- Các phương án nhiễu phải đủ gần để kiểm tra nhận biết, nhưng không được gây hiểu nhầm vì sai ngữ cảnh.

## BE-STUDY-GUESS-002 - Chấm kết quả chọn đáp án
### Mục tiêu
Đánh giá việc lựa chọn của người dùng và phản hồi kết quả ngay trong phiên.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Câu hỏi guess hiện tại đang được hiển thị.

### Hậu điều kiện
- Kết quả đúng hoặc sai của câu hỏi được ghi nhận.
- Phiên học được cập nhật tiến độ tương ứng.

### Luồng chính
1. Người dùng chọn một phương án.
2. Hệ thống đối chiếu phương án được chọn với đáp án đúng.
3. Hệ thống xác định kết quả đúng hoặc sai.
4. Hệ thống lưu kết quả của câu hỏi vào phiên học.
5. Hệ thống trả lại phản hồi để người dùng biết tình trạng của mình.

## BE-STUDY-GUESS-003 - Xử lý nội dung trả lời sai
### Mục tiêu
Không để các mục người dùng chọn sai bị bỏ qua sau lần trả lời đầu tiên.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Câu hỏi vừa được chấm là sai.

### Hậu điều kiện
- Nội dung sai được gắn trạng thái cần luyện thêm.

### Luồng chính
1. Hệ thống đánh dấu nội dung hiện tại là chưa đạt.
2. Hệ thống đưa nội dung đó vào nhóm cần học lại nếu phiên học yêu cầu.
3. Hệ thống điều chỉnh tiến trình để người dùng có cơ hội gặp lại nội dung này.

### Quy tắc nghiệp vụ
- Nội dung trả lời sai không được ghi nhận là đã nắm chắc.
- Một nội dung có thể xuất hiện lại trong cùng phiên để củng cố trí nhớ ngắn hạn.
