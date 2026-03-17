# Study Backend Match Use Cases

## Mục tiêu nghiệp vụ
Mode `match` ở backend hỗ trợ việc học bằng liên kết cặp thông tin, giúp người dùng củng cố khả năng nhận diện nhanh giữa hai vế kiến thức.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-STUDY-MATCH-001 | Chuẩn bị bài ghép cặp | Tạo ra một lượt ghép cặp rõ ràng, cân bằng và dễ hiểu |
| BE-STUDY-MATCH-002 | Chấm kết quả ghép cặp | Xác định người dùng ghép đúng hay sai trên từng cặp |
| BE-STUDY-MATCH-003 | Xử lý các cặp ghép sai | Giữ lại nội dung người dùng chưa nắm chắc để luyện thêm |

## BE-STUDY-MATCH-001 - Chuẩn bị bài ghép cặp
### Mục tiêu
Tập hợp các cặp thông tin phù hợp để người dùng có thể ghép nối trong một lượt học.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Phiên học có mode match.
- Có đủ dữ liệu để tạo hai vế ghép cặp.

### Hậu điều kiện
- Một bài ghép cặp được chuẩn bị cho người dùng.

### Luồng chính
1. Hệ thống chọn nhóm nội dung cần đưa vào lượt ghép cặp.
2. Hệ thống chia dữ liệu thành hai vế tương ứng để người dùng ghép.
3. Hệ thống kiểm tra số lượng và mức độ phù hợp giữa các cặp.
4. Hệ thống trình bài ghép cặp cho người dùng.

### Quy tắc nghiệp vụ
- Mỗi vế bên trái phải có đúng một vế bên phải tương ứng.
- Không đưa vào một lượt ghép cặp các mục dễ gây nhầm lẫn quá mức nếu làm giảm khả năng đánh giá.

## BE-STUDY-MATCH-002 - Chấm kết quả ghép cặp
### Mục tiêu
Xác định mức độ chính xác của toàn bộ lượt ghép cặp mà người dùng vừa hoàn thành.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Người dùng đã hoàn tất việc ghép các cặp cần thiết.

### Hậu điều kiện
- Từng cặp được xác định là đúng hoặc sai.
- Kết quả của lượt ghép được ghi nhận vào tiến độ phiên học.

### Luồng chính
1. Người dùng gửi kết quả ghép cặp.
2. Hệ thống đối chiếu từng cặp với đáp án đúng.
3. Hệ thống xác định số cặp đúng và số cặp sai.
4. Hệ thống cập nhật kết quả của lượt match trong phiên học.
5. Hệ thống trả lại phản hồi để người dùng biết mình đã làm đúng đến đâu.

## BE-STUDY-MATCH-003 - Xử lý các cặp ghép sai
### Mục tiêu
Bảo đảm những cặp người dùng ghép sai không bị bỏ qua sau một lần thử.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Đã có kết quả ghép cặp và tồn tại cặp sai.

### Hậu điều kiện
- Các cặp sai được đưa vào luồng học lại nếu cần.

### Luồng chính
1. Hệ thống xác định các cặp ghép sai sau khi chấm.
2. Hệ thống đánh dấu các nội dung liên quan là chưa đạt trong mode hiện tại.
3. Hệ thống đưa các nội dung đó vào lượt luyện tiếp theo theo quy tắc của phiên.

### Quy tắc nghiệp vụ
- Một lượt ghép cặp chỉ được xem là đạt khi đáp ứng tiêu chuẩn đúng đã đặt ra.
- Các cặp sai cần có cơ hội xuất hiện lại trong cùng phiên hoặc ở phiên sau.
