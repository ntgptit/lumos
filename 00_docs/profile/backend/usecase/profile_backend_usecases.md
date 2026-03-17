# Profile Backend Use Cases

## Mục tiêu nghiệp vụ
Feature `profile` ở backend tập trung vào hồ sơ tài khoản và các tùy chọn học tập cá nhân, giúp mỗi người dùng có trải nghiệm học phù hợp với nhu cầu của mình.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-PROFILE-001 | Xem hồ sơ tổng hợp | Cung cấp một ảnh chụp đầy đủ về tài khoản và tùy chọn cá nhân |
| BE-PROFILE-002 | Xem tùy chọn học tập | Cho người dùng biết giới hạn nội dung mới của mình |
| BE-PROFILE-003 | Cập nhật tùy chọn học tập | Cho người dùng thay đổi nhịp học mới mỗi phiên |
| BE-PROFILE-004 | Xem tùy chọn giọng đọc | Cho người dùng biết cấu hình hỗ trợ phát âm hiện tại |
| BE-PROFILE-005 | Cập nhật tùy chọn giọng đọc | Cho người dùng cá nhân hóa trải nghiệm phát âm |

## BE-PROFILE-001 - Xem hồ sơ tổng hợp
### Mục tiêu
Giúp frontend lấy được thông tin tài khoản và tùy chọn chính chỉ trong một lần truy vấn.

### Luồng chính
1. Hệ thống lấy thông tin người dùng hiện tại.
2. Hệ thống lấy tùy chọn học tập.
3. Hệ thống lấy tùy chọn giọng đọc.
4. Hệ thống ghép lại thành một hồ sơ tổng hợp.

## BE-PROFILE-002 - Xem tùy chọn học tập
### Mục tiêu
Cho người dùng biết mình đang học bài mới theo giới hạn nào.

### Luồng chính
1. Hệ thống tìm tùy chọn học tập hiện tại của người dùng.
2. Nếu chưa có, hệ thống tạo giá trị mặc định.
3. Hệ thống trả về cấu hình hiện tại.

## BE-PROFILE-003 - Cập nhật tùy chọn học tập
### Mục tiêu
Cho người dùng tự điều chỉnh khối lượng nội dung mới trong mỗi phiên học.

### Luồng chính
1. Hệ thống nhận giá trị giới hạn mới.
2. Hệ thống cập nhật hồ sơ tùy chọn học tập.
3. Hệ thống trả cấu hình sau cập nhật.

## BE-PROFILE-004 - Xem tùy chọn giọng đọc
### Mục tiêu
Cho người dùng thấy hệ thống đang hỗ trợ phát âm theo cấu hình nào.

### Luồng chính
1. Hệ thống tìm cấu hình giọng đọc hiện tại.
2. Nếu chưa có, hệ thống tạo cấu hình mặc định.
3. Hệ thống trả thông tin cấu hình.

## BE-PROFILE-005 - Cập nhật tùy chọn giọng đọc
### Mục tiêu
Cho phép người dùng cá nhân hóa việc nghe phát âm khi học.

### Luồng chính
1. Hệ thống nhận các lựa chọn như bật tắt, tự phát, loại adapter, voice, tốc độ và cao độ.
2. Hệ thống cập nhật cấu hình tương ứng.
3. Hệ thống trả cấu hình đã lưu.
