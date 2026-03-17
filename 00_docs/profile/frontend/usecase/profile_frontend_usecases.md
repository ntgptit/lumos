# Profile Frontend Use Cases

## Mục tiêu nghiệp vụ
Feature `profile` ở frontend là nơi người dùng quản lý tài khoản và cá nhân hóa trải nghiệm học, từ giao diện ứng dụng đến giới hạn học mới và thiết lập giọng đọc.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-PROFILE-001 | Xem hồ sơ cá nhân | Cho người dùng thấy đầy đủ thông tin tài khoản và thiết lập hiện tại |
| FE-PROFILE-002 | Thay đổi giao diện hiển thị | Cho người dùng chọn cách ứng dụng hiển thị theo sở thích |
| FE-PROFILE-003 | Điều chỉnh nhịp học bài mới | Cho người dùng kiểm soát khối lượng học mới |
| FE-PROFILE-004 | Điều chỉnh giọng đọc hỗ trợ học tập | Cho người dùng cá nhân hóa trải nghiệm nghe |
| FE-PROFILE-005 | Đăng xuất từ hồ sơ cá nhân | Cho người dùng chủ động kết thúc phiên sử dụng |

## FE-PROFILE-001 - Xem hồ sơ cá nhân
### Mục tiêu
Cho người dùng một nơi tập trung để xem thông tin tài khoản và toàn bộ thiết lập cá nhân.

### Luồng chính
1. Người dùng mở tab hồ sơ.
2. Ứng dụng tải hồ sơ tổng hợp.
3. Ứng dụng hiển thị thông tin tài khoản, thiết lập giao diện, nhịp học và giọng đọc.

## FE-PROFILE-002 - Thay đổi giao diện hiển thị
### Mục tiêu
Cho phép người dùng chọn cách ứng dụng hiển thị phù hợp với thói quen sử dụng.

### Luồng chính
1. Người dùng chọn một tùy chọn giao diện.
2. Ứng dụng áp dụng thay đổi ngay lập tức.
3. Người dùng có thể dùng nút chuyển nhanh để đổi giữa sáng và tối.

## FE-PROFILE-003 - Điều chỉnh nhịp học bài mới
### Mục tiêu
Cho phép người dùng tự quyết định mỗi phiên nên tiếp nhận bao nhiêu nội dung mới.

### Luồng chính
1. Người dùng chọn giới hạn số thẻ học mới.
2. Ứng dụng gửi cập nhật lên hệ thống.
3. Giao diện phản ánh giá trị mới sau khi lưu thành công.

## FE-PROFILE-004 - Điều chỉnh giọng đọc hỗ trợ học tập
### Mục tiêu
Cho người dùng chủ động lựa chọn cách nghe phát âm trong quá trình học.

### Luồng chính
1. Người dùng bật hoặc tắt giọng đọc.
2. Người dùng chọn tự phát, loại giọng, voice, tốc độ và cao độ.
3. Ứng dụng lưu thay đổi sau mỗi lựa chọn.
4. Người dùng có thể dùng khu vực preview để kiểm tra cảm giác nghe.

## FE-PROFILE-005 - Đăng xuất từ hồ sơ cá nhân
### Mục tiêu
Cho phép người dùng kết thúc phiên sử dụng từ khu vực quản lý cá nhân.

### Luồng chính
1. Người dùng chọn đăng xuất.
2. Ứng dụng kết thúc phiên hiện tại.
3. Người dùng được đưa về màn hình xác thực.
