# Auth Frontend Use Cases

## Mục tiêu nghiệp vụ
Khối frontend `auth` bảo đảm người dùng luôn được đưa tới đúng màn hình theo trạng thái phiên, đồng thời hỗ trợ đăng nhập, đăng ký và đăng xuất một cách rõ ràng.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-AUTH-001 | Khởi động ứng dụng và kiểm tra phiên | Xác định người dùng có thể vào thẳng hệ thống hay phải đăng nhập |
| FE-AUTH-002 | Đăng nhập từ màn hình xác thực | Cho người dùng truy cập vào ứng dụng |
| FE-AUTH-003 | Đăng ký tài khoản từ màn hình xác thực | Cho người dùng mới bắt đầu sử dụng ứng dụng |
| FE-AUTH-004 | Đăng xuất khỏi ứng dụng | Đưa người dùng về trạng thái chưa xác thực |
| FE-AUTH-005 | Điều hướng theo trạng thái xác thực | Giữ cho toàn bộ luồng màn hình nhất quán |

## FE-AUTH-001 - Khởi động ứng dụng và kiểm tra phiên
### Mục tiêu
Xác định nhanh người dùng có phiên hợp lệ hay không ngay khi mở ứng dụng.

### Tác nhân
- Người dùng mở ứng dụng.

### Luồng chính
1. Ứng dụng đọc thông tin phiên đã lưu trên thiết bị.
2. Nếu có dữ liệu phiên, ứng dụng kiểm tra tính hợp lệ của phiên đó.
3. Nếu phiên còn dùng được, người dùng được đưa vào màn hình chính.
4. Nếu phiên không còn hợp lệ, ứng dụng xóa dữ liệu phiên cũ.
5. Người dùng được đưa tới màn hình xác thực.

### Kết quả mong đợi
- Người dùng không phải thao tác dư thừa khi phiên còn hợp lệ.
- Không giữ lại phiên lỗi hoặc đã hết hiệu lực.

## FE-AUTH-002 - Đăng nhập từ màn hình xác thực
### Mục tiêu
Cho phép người dùng truy cập hệ thống bằng thông tin đăng nhập của mình.

### Tác nhân
- Người dùng đã có tài khoản.

### Luồng chính
1. Người dùng nhập định danh và mật khẩu.
2. Ứng dụng gửi yêu cầu đăng nhập.
3. Nếu thành công, ứng dụng lưu phiên trên thiết bị.
4. Người dùng được chuyển tới màn hình chính.

### Luồng ngoại lệ
1. Sai tài khoản hoặc mật khẩu.
2. Mạng lỗi hoặc máy chủ không phản hồi.
3. Hệ thống hiển thị thông báo lỗi ngay trên màn hình xác thực.

## FE-AUTH-003 - Đăng ký tài khoản từ màn hình xác thực
### Mục tiêu
Cho phép người dùng mới tạo tài khoản và bắt đầu sử dụng ngay.

### Tác nhân
- Người dùng chưa có tài khoản.

### Luồng chính
1. Người dùng chuyển sang chế độ đăng ký.
2. Người dùng nhập username, email và password.
3. Ứng dụng gửi yêu cầu đăng ký.
4. Nếu thành công, ứng dụng lưu phiên mới.
5. Người dùng được chuyển tới màn hình chính.

### Luồng ngoại lệ
1. Email hoặc username đã tồn tại.
2. Dữ liệu nhập không hợp lệ.
3. Hệ thống hiển thị lỗi tại cùng màn hình.

## FE-AUTH-004 - Đăng xuất khỏi ứng dụng
### Mục tiêu
Cho phép người dùng chủ động kết thúc phiên làm việc.

### Tác nhân
- Người dùng đang đăng nhập.

### Luồng chính
1. Người dùng chọn thao tác đăng xuất.
2. Ứng dụng gửi yêu cầu kết thúc phiên.
3. Ứng dụng xóa dữ liệu phiên trên thiết bị.
4. Người dùng được đưa về màn hình xác thực.

## FE-AUTH-005 - Điều hướng theo trạng thái xác thực
### Mục tiêu
Đảm bảo người dùng luôn ở đúng màn hình theo tình trạng đăng nhập.

### Quy tắc nghiệp vụ
- Khi chưa xác thực, người dùng chỉ nên thấy luồng xác thực.
- Khi đã xác thực, người dùng không nên quay lại màn hình đăng nhập trừ khi đăng xuất.
- Trong thời gian kiểm tra phiên, ứng dụng hiển thị màn hình chờ thay vì nhảy màn hình liên tục.
