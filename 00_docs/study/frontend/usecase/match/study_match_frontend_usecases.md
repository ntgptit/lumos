# Study Frontend Match Use Cases

## Mục tiêu nghiệp vụ
Mode `match` ở frontend giúp người dùng ghép đúng hai vế thông tin để củng cố khả năng liên kết khái niệm một cách nhanh và trực quan.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-STUDY-MATCH-001 | Quan sát bài ghép cặp | Giúp người dùng hiểu ngay mình cần ghép những nhóm thông tin nào |
| FE-STUDY-MATCH-002 | Tạo các cặp ghép | Cho phép người dùng thao tác trực quan để nối hai vế kiến thức |
| FE-STUDY-MATCH-003 | Xác nhận lượt ghép cặp | Chốt câu trả lời sau khi người dùng hoàn tất ghép |
| FE-STUDY-MATCH-004 | Xem phản hồi và tiếp tục | Giúp người dùng biết kết quả của lượt ghép trước khi sang bước kế tiếp |

## FE-STUDY-MATCH-001 - Quan sát bài ghép cặp
### Mục tiêu
Làm rõ cho người dùng đâu là hai nhóm thông tin cần liên kết với nhau.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Ứng dụng hiển thị hai nhóm thông tin ở hai vùng riêng biệt.
2. Người dùng quan sát toàn bộ các mục trước khi ghép.
3. Ứng dụng giữ bố cục ổn định để người dùng dễ theo dõi.

## FE-STUDY-MATCH-002 - Tạo các cặp ghép
### Mục tiêu
Cho phép người dùng ghép từng cặp theo cách trực quan, giảm nhầm lẫn thao tác.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Người dùng chọn hai mục tương ứng để tạo thành một cặp.
2. Ứng dụng phản ánh ngay rằng cặp ghép đã được hình thành.
3. Người dùng tiếp tục cho đến khi hoàn tất toàn bộ các cặp cần ghép.

### Quy tắc nghiệp vụ
- Một mục chỉ nên thuộc về một cặp tại một thời điểm.
- Người dùng phải dễ dàng nhận ra những mục đã ghép và chưa ghép.

## FE-STUDY-MATCH-003 - Xác nhận lượt ghép cặp
### Mục tiêu
Giúp người dùng chủ động chốt kết quả sau khi đã kiểm tra lại các cặp của mình.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Sau khi ghép xong, người dùng chọn xác nhận.
2. Ứng dụng kiểm tra lượt ghép đã đủ điều kiện gửi kết quả hay chưa.
3. Ứng dụng ghi nhận câu trả lời và chờ phản hồi cho lượt ghép.

## FE-STUDY-MATCH-004 - Xem phản hồi và tiếp tục
### Mục tiêu
Cho người dùng biết lượt ghép vừa rồi đạt hay chưa đạt trước khi chuyển sang nội dung tiếp theo.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Ứng dụng hiển thị phản hồi của lượt ghép.
2. Người dùng nhận biết những cặp đã đúng hoặc cần cải thiện.
3. Ứng dụng cho phép chuyển tiếp khi đã hoàn tất phản hồi cần thiết.
