# Study Frontend Shared Use Cases

## Mục tiêu nghiệp vụ
Khối `study` ở frontend chịu trách nhiệm dẫn dắt người dùng đi qua phiên học một cách tập trung, dễ hiểu và nhất quán giữa các mode khác nhau.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-STUDY-SHARED-001 | Bắt đầu học từ một deck | Đưa người dùng vào đúng phiên học phù hợp với nhu cầu hiện tại |
| FE-STUDY-SHARED-002 | Tiếp tục phiên học đang dang dở | Giúp người dùng quay lại đúng điểm học trước đó |
| FE-STUDY-SHARED-003 | Theo dõi tiến độ phiên học | Cho người dùng biết mình đang ở đâu trong hành trình học |
| FE-STUDY-SHARED-004 | Thực hiện thao tác học theo từng mode | Đảm bảo mỗi mode có cách tương tác rõ ràng và dễ hiểu |
| FE-STUDY-SHARED-005 | Nghe phát âm hỗ trợ trong lúc học | Tăng cường ghi nhớ bằng kênh âm thanh khi cần |
| FE-STUDY-SHARED-006 | Làm lại mode hiện tại | Cho người dùng tự chủ quyết định luyện lại một chặng học |
| FE-STUDY-SHARED-007 | Kết thúc phiên học và xem kết quả | Đóng phiên học với cảm nhận rõ ràng về mức độ hoàn thành |

## FE-STUDY-SHARED-001 - Bắt đầu học từ một deck
### Mục tiêu
Giúp người dùng vào phiên học nhanh từ một deck mà không phải suy nghĩ về luồng bên trong.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Tiền điều kiện
- Người dùng đang đứng tại deck có thể học.

### Hậu điều kiện
- Người dùng được đưa vào màn hình học với nội dung đầu tiên sẵn sàng.

### Luồng chính
1. Người dùng chọn bắt đầu học.
2. Ứng dụng điều hướng sang màn hình học của deck.
3. Ứng dụng hiển thị thông tin phiên học và nội dung đầu tiên.
4. Người dùng có thể bắt đầu thao tác ngay.

### Luồng ngoại lệ
1. Nếu hiện không có nội dung phù hợp để học, ứng dụng phải thông báo rõ lý do thay vì đưa vào màn hình trống.

## FE-STUDY-SHARED-002 - Tiếp tục phiên học đang dang dở
### Mục tiêu
Cho phép người dùng quay lại phiên cũ mà không cảm thấy mất mạch học tập.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Tiền điều kiện
- Người dùng có phiên học chưa hoàn tất.

### Hậu điều kiện
- Màn hình học hiển thị lại đúng mode, đúng nội dung và đúng tiến độ trước đó.

### Luồng chính
1. Người dùng chọn tiếp tục học.
2. Ứng dụng mở lại phiên học đang dang dở.
3. Ứng dụng hiển thị đúng trạng thái mà người dùng đã rời đi.
4. Người dùng tiếp tục thao tác mà không cần khởi động lại từ đầu.

## FE-STUDY-SHARED-003 - Theo dõi tiến độ phiên học
### Mục tiêu
Giúp người dùng luôn biết mình đã đi được bao xa và còn bao nhiêu nội dung phía trước.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Trong suốt phiên học, ứng dụng hiển thị số lượng nội dung hoặc chặng đã hoàn thành.
2. Mỗi khi người dùng xử lý xong một nội dung, tiến độ được cập nhật ngay.
3. Người dùng nhìn thấy trạng thái hoàn thành thay đổi một cách nhất quán.

### Quy tắc nghiệp vụ
- Tiến độ phải dễ hiểu và ổn định giữa các mode.
- Thông tin tiến độ không được làm người dùng hiểu sai rằng phiên học đã kết thúc khi vẫn còn chặng phía sau.

## FE-STUDY-SHARED-004 - Thực hiện thao tác học theo từng mode
### Mục tiêu
Giúp người dùng chỉ nhìn thấy những hành động phù hợp với mode hiện tại để tránh bối rối.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Ứng dụng hiển thị nội dung học theo mode hiện tại.
2. Ứng dụng đưa ra các hành động phù hợp với mode đó.
3. Người dùng thực hiện thao tác mong muốn.
4. Ứng dụng phản hồi kết quả và đưa người dùng sang bước tiếp theo khi phù hợp.

### Quy tắc nghiệp vụ
- Mỗi mode cần có cách trình bày khác nhau nhưng phải giữ cùng một tinh thần học tập xuyên suốt.
- Không hiển thị các hành động khiến người dùng hiểu sai bước hiện tại.

## FE-STUDY-SHARED-005 - Nghe phát âm hỗ trợ trong lúc học
### Mục tiêu
Hỗ trợ người dùng kết hợp nghe và nhìn trong quá trình học để tăng khả năng ghi nhớ.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Người dùng chọn nghe phát âm tại nội dung đang học.
2. Ứng dụng phát âm thanh tương ứng nếu nội dung có hỗ trợ.
3. Người dùng có thể tiếp tục học sau khi nghe.

## FE-STUDY-SHARED-006 - Làm lại mode hiện tại
### Mục tiêu
Cho người dùng cảm giác chủ động khi muốn luyện lại một chặng chưa chắc chắn.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Tiền điều kiện
- Phiên học đang đứng tại một mode xác định.

### Hậu điều kiện
- Người dùng quay lại từ đầu của mode hiện tại.

### Luồng chính
1. Người dùng chọn làm lại mode đang học.
2. Ứng dụng yêu cầu xác nhận nếu thao tác có thể làm mất kết quả tạm thời.
3. Sau khi xác nhận, ứng dụng đưa người dùng quay lại nội dung đầu tiên của mode.

## FE-STUDY-SHARED-007 - Kết thúc phiên học và xem kết quả
### Mục tiêu
Tạo một điểm kết rõ ràng để người dùng biết phiên học đã hoàn tất và cảm nhận được thành quả của mình.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Tiền điều kiện
- Người dùng đã hoàn thành toàn bộ chặng học trong phiên.

### Hậu điều kiện
- Người dùng thấy trạng thái phiên học đã hoàn tất.
- Người dùng có thể rời màn hình học hoặc bắt đầu lại theo nhu cầu.

### Luồng chính
1. Ứng dụng nhận biết phiên học đã hoàn tất.
2. Ứng dụng hiển thị trạng thái hoàn thành và kết quả tổng quan.
3. Người dùng quyết định quay lại deck, tiếp tục học nội dung khác hoặc bắt đầu phiên mới nếu có.
