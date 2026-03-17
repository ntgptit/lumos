# Study Backend Review Use Cases

## Mục tiêu nghiệp vụ
Mode `review` ở backend hỗ trợ chặng xem lại nhanh, nơi người dùng tự đánh giá mình đã nhớ hay cần học lại đối với từng nội dung.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-STUDY-REVIEW-001 | Chuẩn bị danh sách nội dung cần xem lại nhanh | Đảm bảo người dùng gặp đúng các mục cần lướt qua trong chặng review |
| BE-STUDY-REVIEW-002 | Ghi nhận nội dung đã nhớ | Củng cố tiến độ cho các mục người dùng tự tin |
| BE-STUDY-REVIEW-003 | Ghi nhận nội dung cần học lại | Giữ lại các mục chưa chắc để xử lý thêm trong phiên |

## BE-STUDY-REVIEW-001 - Chuẩn bị danh sách nội dung cần xem lại nhanh
### Mục tiêu
Sắp xếp các nội dung review theo thứ tự rõ ràng để người dùng có thể ra quyết định nhanh trên từng mục.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Phiên học có bao gồm mode review.

### Hậu điều kiện
- Danh sách nội dung review được chuẩn bị sẵn cho phiên.

### Luồng chính
1. Hệ thống nhận biết phiên học đang chuyển sang mode review.
2. Hệ thống lấy danh sách nội dung thuộc chặng review của phiên.
3. Hệ thống sắp xếp danh sách theo thứ tự đã định cho phiên đó.
4. Hệ thống cung cấp từng nội dung một để người dùng đánh giá.

### Quy tắc nghiệp vụ
- Review chỉ tập trung vào việc xem nhanh và tự đánh giá.
- Mỗi thời điểm chỉ đưa ra một nội dung để tránh quá tải.

## BE-STUDY-REVIEW-002 - Ghi nhận nội dung đã nhớ
### Mục tiêu
Xác nhận rằng người dùng đã nhớ nội dung hiện tại và có thể chuyển tiếp.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Nội dung review hiện tại đang được hiển thị.

### Hậu điều kiện
- Nội dung được ghi nhận là đã nhớ trong phiên.
- Phiên sẵn sàng chuyển sang mục tiếp theo.

### Luồng chính
1. Người dùng xác nhận đã nhớ nội dung hiện tại.
2. Hệ thống ghi nhận kết quả tích cực cho nội dung đó.
3. Hệ thống cập nhật tiến độ tạm thời của mode review.
4. Hệ thống chuẩn bị chuyển sang nội dung tiếp theo.

## BE-STUDY-REVIEW-003 - Ghi nhận nội dung cần học lại
### Mục tiêu
Giữ lại những nội dung người dùng chưa chắc để được xử lý thêm trong cùng phiên.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Nội dung review hiện tại đang được hiển thị.

### Hậu điều kiện
- Nội dung được đánh dấu là cần học lại.
- Nội dung có thể được đưa vào lượt xử lý bổ sung của mode.

### Luồng chính
1. Người dùng xác nhận chưa nhớ nội dung hiện tại.
2. Hệ thống ghi nhận kết quả chưa đạt cho nội dung đó.
3. Hệ thống cập nhật tiến độ mode review.
4. Hệ thống đưa nội dung vào nhóm cần học lại nếu phù hợp với quy tắc phiên học.
5. Hệ thống chuyển người dùng sang nội dung tiếp theo.

### Quy tắc nghiệp vụ
- Nội dung bị đánh dấu chưa nhớ không được xem là hoàn tất về mặt chất lượng.
- Hệ thống ưu tiên cho người dùng gặp lại các nội dung chưa nhớ ngay trong phiên hiện tại khi cần.
