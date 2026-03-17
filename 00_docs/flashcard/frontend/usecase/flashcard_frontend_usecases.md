# Flashcard Frontend Use Cases

## Mục tiêu nghiệp vụ
Feature `flashcard` ở frontend là không gian làm việc chi tiết của một deck, nơi người dùng có thể xem, tìm kiếm, sắp xếp, chỉnh sửa nội dung học và đi vào các chế độ học tập từ chính deck đó.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-FLASHCARD-001 | Xem nội dung của deck | Cho người dùng quan sát và kiểm tra toàn bộ flashcard trong deck |
| FE-FLASHCARD-002 | Tìm kiếm, sắp xếp và tải thêm flashcard | Giúp người dùng tìm đúng nội dung cần thao tác |
| FE-FLASHCARD-003 | Tạo, sửa, xóa flashcard | Hỗ trợ quản lý nội dung học chi tiết |
| FE-FLASHCARD-004 | Bắt đầu học từ deck | Cho người dùng đi thẳng vào các hoạt động học tập |
| FE-FLASHCARD-005 | Theo dõi tiến độ học của deck | Gợi ý mức độ sẵn sàng học ngay trên màn hình deck |
| FE-FLASHCARD-006 | Học lại từ đầu một deck | Xóa tiến độ cũ để bắt đầu lại |

## FE-FLASHCARD-001 - Xem nội dung của deck
### Mục tiêu
Cho phép người dùng nhìn thấy toàn bộ flashcard của một deck trong một màn hình duy nhất.

### Luồng chính
1. Người dùng mở một deck từ danh sách.
2. Ứng dụng tải dữ liệu flashcard của deck đó.
3. Ứng dụng hiển thị preview, thông tin deck và danh sách flashcard.
4. Nếu deck chưa có dữ liệu, ứng dụng hiển thị trạng thái rỗng.

## FE-FLASHCARD-002 - Tìm kiếm, sắp xếp và tải thêm flashcard
### Mục tiêu
Giúp người dùng thao tác nhanh trên deck có nhiều dữ liệu.

### Luồng chính
1. Người dùng bật tìm kiếm và nhập từ khóa.
2. Ứng dụng làm mới danh sách theo kết quả lọc.
3. Người dùng đổi tiêu chí sắp xếp.
4. Ứng dụng áp dụng thứ tự hiển thị mới.
5. Khi cuộn gần cuối, ứng dụng tải thêm dữ liệu nếu còn.

## FE-FLASHCARD-003 - Tạo, sửa, xóa flashcard
### Mục tiêu
Cho phép người dùng cập nhật nội dung học ngay trên màn hình của deck.

### Luồng chính
1. Người dùng chọn tạo mới hoặc thao tác trên một flashcard cụ thể.
2. Ứng dụng mở hộp thoại phù hợp.
3. Người dùng xác nhận thao tác.
4. Ứng dụng gửi yêu cầu lên hệ thống.
5. Danh sách được cập nhật lại sau khi xử lý xong.
6. Nếu lỗi, ứng dụng hiển thị thông báo ngay trên màn hình.

## FE-FLASHCARD-004 - Bắt đầu học từ deck
### Mục tiêu
Cho phép người dùng đi thẳng từ nội dung học sang hoạt động học tập.

### Luồng chính
1. Người dùng chọn một hành động học như review, learn, quiz hoặc match.
2. Ứng dụng điều hướng sang phiên học tương ứng.
3. Với chế độ `Learn`, người dùng có thể chọn học bài mới, ôn tập hoặc đặt lại tiến độ trước khi bắt đầu.

## FE-FLASHCARD-005 - Theo dõi tiến độ học của deck
### Mục tiêu
Giúp người dùng biết nhanh deck đang ở mức nào trước khi vào học.

### Luồng chính
1. Ứng dụng hiển thị các chỉ dấu tiến độ như số nội dung chưa bắt đầu và đã thành thạo.
2. Người dùng có thể dùng khu vực này như điểm vào để bắt đầu học.

## FE-FLASHCARD-006 - Học lại từ đầu một deck
### Mục tiêu
Cho phép người dùng xóa tiến độ cũ và bắt đầu lại khi cần.

### Luồng chính
1. Người dùng chọn hành động đặt lại tiến độ học.
2. Ứng dụng hỏi xác nhận.
3. Sau khi xác nhận, hệ thống xóa tiến độ học của deck.
4. Màn hình deck được làm mới để phản ánh trạng thái mới.
