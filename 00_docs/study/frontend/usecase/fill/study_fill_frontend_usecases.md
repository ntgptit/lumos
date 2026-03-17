# Study Frontend Fill Use Cases

## Mục tiêu nghiệp vụ
Mode `fill` ở frontend giúp người dùng tự gõ lại đáp án, qua đó kiểm tra khả năng nhớ chính xác thay vì chỉ nhận biết sơ bộ.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-STUDY-FILL-001 | Đọc câu hỏi và nhập đáp án | Khuyến khích người dùng tự gọi lại và tự viết ra câu trả lời |
| FE-STUDY-FILL-002 | Gửi câu trả lời để kiểm tra | Xác nhận kết quả nhập của người dùng trên nội dung hiện tại |
| FE-STUDY-FILL-003 | Xem đáp án mẫu khi cần | Hỗ trợ người dùng học từ lỗi sai ngay tại chỗ |
| FE-STUDY-FILL-004 | Thử lại hoặc chuyển tiếp | Duy trì nhịp luyện tập sau khi đã có phản hồi |

## FE-STUDY-FILL-001 - Đọc câu hỏi và nhập đáp án
### Mục tiêu
Đưa người dùng vào tình huống phải tự viết ra câu trả lời thay vì lựa chọn sẵn.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Ứng dụng hiển thị câu hỏi hoặc gợi ý của nội dung hiện tại.
2. Ứng dụng cung cấp vùng nhập đáp án rõ ràng.
3. Người dùng tự nhập câu trả lời của mình.

## FE-STUDY-FILL-002 - Gửi câu trả lời để kiểm tra
### Mục tiêu
Cho phép người dùng chốt câu trả lời hiện tại để nhận phản hồi.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Sau khi nhập xong, người dùng chọn kiểm tra đáp án.
2. Ứng dụng ghi nhận câu trả lời đã nhập.
3. Ứng dụng hiển thị phản hồi đạt hoặc chưa đạt.

## FE-STUDY-FILL-003 - Xem đáp án mẫu khi cần
### Mục tiêu
Giúp người dùng học từ đáp án đúng trong trường hợp bí hoặc vừa trả lời chưa đạt.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Người dùng chọn xem đáp án khi chưa chắc chắn.
2. Ứng dụng hiển thị đáp án chuẩn.
3. Người dùng dùng thông tin đó để hiểu lại nội dung và chuẩn bị cho lần thử tiếp theo.

## FE-STUDY-FILL-004 - Thử lại hoặc chuyển tiếp
### Mục tiêu
Cho người dùng tiếp tục luyện nếu chưa đạt hoặc đi tiếp nếu đã nắm được nội dung.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Sau khi nhận phản hồi, người dùng quyết định thử lại hoặc sang nội dung tiếp theo.
2. Nếu cần luyện thêm, ứng dụng giữ người dùng trong cùng nhịp học của mode fill.
3. Nếu đã đạt, ứng dụng chuyển sang nội dung tiếp theo và cập nhật tiến độ.
