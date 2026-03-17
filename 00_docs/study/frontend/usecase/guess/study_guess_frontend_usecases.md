# Study Frontend Guess Use Cases

## Mục tiêu nghiệp vụ
Mode `guess` ở frontend giúp người dùng chọn đáp án đúng trong số nhiều phương án, từ đó kiểm tra khả năng nhận biết nhanh kiến thức.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-STUDY-GUESS-001 | Xem câu hỏi và các phương án | Giúp người dùng nhanh chóng hiểu nội dung cần chọn |
| FE-STUDY-GUESS-002 | Chọn đáp án | Ghi nhận quyết định của người dùng trên từng câu hỏi |
| FE-STUDY-GUESS-003 | Xem phản hồi đúng sai | Cho người dùng biết ngay kết quả của lựa chọn |
| FE-STUDY-GUESS-004 | Chuyển sang câu tiếp theo | Duy trì nhịp làm bài liên tục |

## FE-STUDY-GUESS-001 - Xem câu hỏi và các phương án
### Mục tiêu
Trình bày câu hỏi và các đáp án theo cách rõ ràng để người dùng có thể đọc nhanh và đưa ra lựa chọn.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Ứng dụng hiển thị câu hỏi ở vị trí trung tâm.
2. Ứng dụng liệt kê các phương án bên dưới theo bố cục dễ chọn.
3. Người dùng xem câu hỏi và cân nhắc đáp án.

## FE-STUDY-GUESS-002 - Chọn đáp án
### Mục tiêu
Cho phép người dùng xác nhận phương án mình tin là đúng.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Người dùng chạm chọn một phương án.
2. Ứng dụng phản ánh ngay trạng thái đã chọn.
3. Ứng dụng ghi nhận quyết định đó cho câu hỏi hiện tại.

## FE-STUDY-GUESS-003 - Xem phản hồi đúng sai
### Mục tiêu
Giúp người dùng hiểu ngay lựa chọn vừa rồi có chính xác hay không.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Sau khi ghi nhận đáp án, ứng dụng hiển thị phản hồi đúng hoặc sai.
2. Nếu cần, ứng dụng làm nổi bật đáp án đúng để người dùng đối chiếu.
3. Người dùng nhận biết kết quả trước khi sang câu tiếp theo.

## FE-STUDY-GUESS-004 - Chuyển sang câu tiếp theo
### Mục tiêu
Giữ trải nghiệm trắc nghiệm ngắn gọn và không ngắt quãng.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Sau khi xem phản hồi, người dùng chọn sang câu tiếp theo.
2. Ứng dụng tải câu hỏi kế tiếp trong cùng mode.
3. Tiến độ học được cập nhật đồng thời trên màn hình.
