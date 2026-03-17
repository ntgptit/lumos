# Study Frontend Recall Use Cases

## Mục tiêu nghiệp vụ
Mode `recall` ở frontend giúp người dùng chủ động nhớ lại nội dung trước khi được phép xem đáp án, từ đó tăng chiều sâu ghi nhớ.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-STUDY-RECALL-001 | Tự nhớ lại trước khi xem đáp án | Khuyến khích người dùng thực sự cố gắng gọi lại kiến thức |
| FE-STUDY-RECALL-002 | Mở đáp án để đối chiếu | Cho phép kiểm tra lại điều vừa nhớ với kết quả chuẩn |
| FE-STUDY-RECALL-003 | Tự đánh giá đã nhớ hay chưa | Biến kết quả đối chiếu thành hành động học cụ thể |
| FE-STUDY-RECALL-004 | Chuyển sang nội dung tiếp theo | Giữ nhịp độ học mạch lạc sau khi tự đánh giá |

## FE-STUDY-RECALL-001 - Tự nhớ lại trước khi xem đáp án
### Mục tiêu
Tạo khoảng dừng đủ rõ để người dùng suy nghĩ và gọi lại kiến thức từ trí nhớ của mình.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Ứng dụng hiển thị gợi ý hoặc câu hỏi của nội dung hiện tại.
2. Đáp án được giữ ở trạng thái chưa hiển thị.
3. Người dùng dành thời gian tự nhớ lại trước khi quyết định xem đáp án.

## FE-STUDY-RECALL-002 - Mở đáp án để đối chiếu
### Mục tiêu
Cho phép người dùng so sánh điều mình vừa nhớ với đáp án chuẩn.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Khi sẵn sàng, người dùng chọn xem đáp án.
2. Ứng dụng hiển thị đáp án của nội dung hiện tại.
3. Người dùng đối chiếu kết quả của bản thân với đáp án chuẩn.

## FE-STUDY-RECALL-003 - Tự đánh giá đã nhớ hay chưa
### Mục tiêu
Giúp người dùng phản ánh trung thực mức độ ghi nhớ của mình sau khi đối chiếu.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Sau khi xem đáp án, ứng dụng hiển thị các lựa chọn tự đánh giá.
2. Người dùng xác nhận mình đã nhớ hoặc cần học lại.
3. Ứng dụng ghi nhận kết quả đó và phản hồi ngắn gọn.

## FE-STUDY-RECALL-004 - Chuyển sang nội dung tiếp theo
### Mục tiêu
Tiếp tục hành trình học sau khi người dùng đã hoàn tất việc nhớ lại và tự đánh giá.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Sau khi tự đánh giá, người dùng chọn sang nội dung tiếp theo.
2. Ứng dụng hiển thị nội dung mới trong cùng mode hoặc chuyển sang chặng tiếp theo khi cần.
3. Thanh tiến độ được cập nhật tương ứng.
