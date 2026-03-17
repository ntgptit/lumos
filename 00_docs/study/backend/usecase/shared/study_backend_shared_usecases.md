# Study Backend Shared Use Cases

## Mục tiêu nghiệp vụ
Khối `study` ở backend chịu trách nhiệm lựa chọn đúng nội dung cần học, tổ chức phiên học theo đúng nhịp độ và cập nhật kết quả của phiên thành tiến độ ghi nhớ dài hạn.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-STUDY-SHARED-001 | Bắt đầu phiên học phù hợp | Chọn đúng loại phiên và tập nội dung cần học tại thời điểm hiện tại |
| BE-STUDY-SHARED-002 | Tiếp tục phiên học đang dang dở | Giúp người dùng quay lại đúng điểm dừng trước đó |
| BE-STUDY-SHARED-003 | Kiểm soát thao tác học hợp lệ | Đảm bảo người dùng chỉ đi theo đúng tiến trình học |
| BE-STUDY-SHARED-004 | Điều phối chuyển bước và chuyển mode | Đưa phiên học tiến lên tuần tự, không bỏ sót nội dung cần học lại |
| BE-STUDY-SHARED-005 | Làm lại mode hiện tại | Cho phép người dùng học lại một chặng khi chưa tự tin |
| BE-STUDY-SHARED-006 | Đặt lại tiến độ của deck | Hỗ trợ bắt đầu lại việc học của cả deck từ đầu |
| BE-STUDY-SHARED-007 | Cập nhật tiến độ ghi nhớ dài hạn | Biến kết quả của phiên học thành lịch ôn tập có ý nghĩa lâu dài |

## BE-STUDY-SHARED-001 - Bắt đầu phiên học phù hợp
### Mục tiêu
Xác định người dùng nên học bài mới hay ôn tập và đưa ra đúng nhóm nội dung cần xử lý trong phiên.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Người dùng đã đăng nhập.
- Deck còn hiệu lực và có thể học.

### Hậu điều kiện
- Một phiên học được tạo cho đúng deck.
- Phiên học có loại phiên và lộ trình mode rõ ràng.

### Luồng chính
1. Người dùng bắt đầu học từ một deck.
2. Hệ thống kiểm tra trong deck còn nội dung mới chưa học hay không.
3. Hệ thống kiểm tra trong deck có nội dung đã đến hạn ôn tập hay không.
4. Hệ thống xác định loại phiên học phù hợp theo ưu tiên nghiệp vụ.
5. Hệ thống chọn tập nội dung cần đưa vào phiên học.
6. Hệ thống xác định các mode cần đi qua trong phiên này.
7. Hệ thống tạo phiên học và trả về trạng thái đầu tiên để người dùng bắt đầu.

### Luồng ngoại lệ
1. Nếu deck không còn nội dung phù hợp để học, hệ thống thông báo không thể tạo phiên mới.

### Quy tắc nghiệp vụ
- Khi còn bài mới, hệ thống ưu tiên người dùng xử lý bài mới trước.
- Số lượng bài mới trong một phiên phụ thuộc vào thiết lập học tập của người dùng.
- Phiên học chỉ được tạo cho một deck tại một thời điểm.

## BE-STUDY-SHARED-002 - Tiếp tục phiên học đang dang dở
### Mục tiêu
Cho phép người dùng quay lại phiên học cũ mà không mất tiến độ giữa chừng.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Người dùng đã có phiên học chưa hoàn tất.

### Hậu điều kiện
- Người dùng nhận lại đúng nội dung, đúng mode và đúng bước đang dừng.

### Luồng chính
1. Người dùng mở lại phiên học trước đó.
2. Hệ thống kiểm tra phiên học thuộc về đúng người dùng.
3. Hệ thống lấy lại mode hiện tại, nội dung hiện tại và tiến độ đã hoàn thành.
4. Hệ thống trả về trạng thái phiên học tại điểm dừng gần nhất.

### Luồng ngoại lệ
1. Nếu phiên học không tồn tại hoặc không thuộc về người dùng hiện tại, hệ thống từ chối truy cập.

## BE-STUDY-SHARED-003 - Kiểm soát thao tác học hợp lệ
### Mục tiêu
Bảo đảm mỗi thao tác của người dùng phù hợp với giai đoạn học hiện tại.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Phiên học đang ở trạng thái hoạt động.

### Hậu điều kiện
- Chỉ những thao tác hợp lệ mới được ghi nhận.

### Luồng chính
1. Người dùng thực hiện một thao tác trong phiên học.
2. Hệ thống kiểm tra thao tác đó có phù hợp với mode và bước hiện tại hay không.
3. Nếu phù hợp, hệ thống tiếp tục xử lý kết quả của thao tác.
4. Nếu không phù hợp, hệ thống từ chối thao tác và giữ nguyên trạng thái phiên học.

### Quy tắc nghiệp vụ
- Quyền quyết định thao tác hợp lệ luôn thuộc về backend.
- Một thao tác không được làm thay đổi tiến trình học nếu chưa đúng thời điểm.

## BE-STUDY-SHARED-004 - Điều phối chuyển bước và chuyển mode
### Mục tiêu
Đảm bảo phiên học tiến lên mạch lạc, không bỏ sót nội dung chưa đạt và không kết thúc quá sớm.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Người dùng vừa hoàn thành một nội dung học hoặc một bước trong mode hiện tại.

### Hậu điều kiện
- Phiên học được chuyển sang nội dung tiếp theo, lượt học lại hoặc mode tiếp theo tùy kết quả.

### Luồng chính
1. Hệ thống ghi nhận kết quả của nội dung vừa xử lý.
2. Hệ thống kiểm tra trong mode hiện tại còn nội dung chưa làm hay không.
3. Nếu còn, hệ thống chuyển sang nội dung kế tiếp.
4. Nếu không còn nội dung mới nhưng vẫn còn nội dung cần học lại, hệ thống chuyển sang lượt học lại trong cùng mode.
5. Nếu mode hiện tại đã hoàn tất, hệ thống chuyển sang mode kế tiếp trong lộ trình.
6. Nếu không còn mode nào phía sau, hệ thống kết thúc phiên học.

### Quy tắc nghiệp vụ
- Nội dung trả lời sai hoặc đánh dấu chưa nhớ có thể được đưa vào lượt học lại.
- Phiên học chỉ kết thúc khi toàn bộ mode dự kiến đã hoàn thành.

## BE-STUDY-SHARED-005 - Làm lại mode hiện tại
### Mục tiêu
Cho người dùng được bắt đầu lại một chặng học khi muốn củng cố thêm.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Phiên học đang đứng ở một mode xác định.

### Hậu điều kiện
- Tiến độ tạm thời của mode hiện tại được làm mới.
- Người dùng quay lại từ nội dung đầu tiên của mode.

### Luồng chính
1. Người dùng chọn làm lại mode hiện tại.
2. Hệ thống xác nhận mode đó có thể làm lại.
3. Hệ thống xóa kết quả tạm thời của mode hiện tại.
4. Hệ thống đưa người dùng quay về nội dung đầu tiên của mode.

## BE-STUDY-SHARED-006 - Đặt lại tiến độ của deck
### Mục tiêu
Cho phép người dùng xóa lịch sử ghi nhớ của một deck để học lại như mới.

### Tác nhân
- Người dùng.
- Hệ thống.

### Tiền điều kiện
- Deck tồn tại và thuộc phạm vi người dùng được phép thao tác.

### Hậu điều kiện
- Tiến độ ghi nhớ dài hạn của deck được đưa về trạng thái ban đầu.

### Luồng chính
1. Người dùng xác nhận muốn đặt lại tiến độ của deck.
2. Hệ thống xác định toàn bộ nội dung học thuộc deck đó.
3. Hệ thống xóa trạng thái ghi nhớ dài hạn gắn với các nội dung này.
4. Hệ thống thông báo thao tác đã hoàn tất.

### Luồng ngoại lệ
1. Nếu deck không tồn tại hoặc không thuộc quyền của người dùng, hệ thống từ chối thao tác.

## BE-STUDY-SHARED-007 - Cập nhật tiến độ ghi nhớ dài hạn
### Mục tiêu
Chuyển kết quả của một phiên học thành dữ liệu phục vụ việc ôn tập về sau.

### Tác nhân
- Hệ thống.

### Tiền điều kiện
- Phiên học đã hoàn tất hoặc đủ điều kiện chốt kết quả.

### Hậu điều kiện
- Trạng thái ghi nhớ của từng nội dung trong phiên được cập nhật.
- Thời điểm ôn tập tiếp theo được tính lại.

### Luồng chính
1. Hệ thống tổng hợp kết quả của toàn bộ nội dung trong phiên học.
2. Với nội dung mới, hệ thống tạo trạng thái ghi nhớ ban đầu.
3. Với nội dung đã có lịch sử, hệ thống điều chỉnh mức độ ghi nhớ theo kết quả của phiên.
4. Hệ thống tính lại thời điểm cần ôn tập kế tiếp cho từng nội dung.
5. Hệ thống lưu tiến độ mới để dùng cho các phiên sau.

### Quy tắc nghiệp vụ
- Nội dung được làm tốt nhiều lần sẽ có khoảng cách ôn tập dài hơn.
- Nội dung làm sai hoặc cần học lại sẽ được đưa về lịch ôn gần hơn.
- Hệ thống chỉ cập nhật tiến độ khi kết quả của phiên đủ tin cậy để ghi nhận.
