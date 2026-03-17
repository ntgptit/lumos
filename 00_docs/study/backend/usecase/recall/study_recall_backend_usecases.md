# Study Backend Recall Use Cases

## Mục tiêu nghiệp vụ
Mode `recall` ở backend hỗ trợ chặng nhớ lại chủ động, nơi người dùng phải tự gọi lại đáp án trước khi được phép đối chiếu với kết quả đúng.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-STUDY-RECALL-001 | Giữ đáp án ở trạng thái ẩn trước khi tự nhớ lại | Tạo điều kiện để người dùng thực sự cố gắng nhớ trước khi xem đáp án |
| BE-STUDY-RECALL-002 | Mở đáp án để người dùng tự đối chiếu | Cho phép người dùng tự kiểm tra sau giai đoạn nhớ lại |
| BE-STUDY-RECALL-003 | Ghi nhận kết quả tự đánh giá | Xác định nội dung đã nhớ hay cần học lại sau khi đối chiếu |

## BE-STUDY-RECALL-001 - Giữ đáp án ở trạng thái ẩn trước khi tự nhớ lại
### Mục tiêu
Buộc người dùng tập trung nhớ lại từ gợi ý ban đầu thay vì nhìn ngay đáp án.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Phiên học đã chuyển đến mode recall.

### Hậu điều kiện
- Nội dung được hiển thị ở trạng thái chưa lộ đáp án.

### Luồng chính
1. Hệ thống đưa ra gợi ý hoặc câu hỏi của nội dung hiện tại.
2. Hệ thống giữ đáp án ở trạng thái ẩn.
3. Hệ thống chờ người dùng hoàn tất giai đoạn tự nhớ lại.

### Quy tắc nghiệp vụ
- Trước khi mở đáp án, người dùng chưa thể tự xác nhận đã nhớ hay chưa nhớ.
- Mục tiêu của mode recall là kích hoạt trí nhớ chủ động, không phải nhận biết thụ động.

## BE-STUDY-RECALL-002 - Mở đáp án để người dùng tự đối chiếu
### Mục tiêu
Cho phép người dùng so sánh điều mình nhớ với đáp án chuẩn sau khi đã chủ động nhớ lại.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Nội dung recall hiện tại đang ở trạng thái ẩn đáp án.

### Hậu điều kiện
- Đáp án chuẩn được hiển thị cho người dùng.

### Luồng chính
1. Người dùng yêu cầu xem đáp án.
2. Hệ thống xác nhận nội dung hiện tại đủ điều kiện để mở đáp án.
3. Hệ thống chuyển nội dung sang trạng thái đã lộ đáp án.
4. Hệ thống cho phép người dùng tự đánh giá sau khi đối chiếu.

## BE-STUDY-RECALL-003 - Ghi nhận kết quả tự đánh giá
### Mục tiêu
Chuyển nhận định của người dùng sau khi xem đáp án thành kết quả cụ thể cho phiên học.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Đáp án của nội dung recall hiện tại đã được mở.

### Hậu điều kiện
- Nội dung được ghi nhận là đã nhớ hoặc cần học lại.

### Luồng chính
1. Sau khi xem đáp án, người dùng tự đánh giá mình đã nhớ hay chưa.
2. Hệ thống ghi nhận kết quả tự đánh giá.
3. Hệ thống cập nhật tiến độ tạm thời của mode recall.
4. Nếu nội dung chưa đạt, hệ thống đưa vào nhóm cần gặp lại theo quy tắc của phiên.

### Quy tắc nghiệp vụ
- Tự đánh giá chỉ hợp lệ sau khi đáp án đã được mở.
- Nội dung được đánh dấu chưa nhớ phải có cơ hội được luyện lại.
