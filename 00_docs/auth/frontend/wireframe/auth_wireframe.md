# Auth Frontend Wireframe

## Mục tiêu màn hình
Màn hình xác thực phải giúp người dùng hiểu rõ hai lựa chọn: đăng nhập nếu đã có tài khoản và đăng ký nếu là người dùng mới, đồng thời hiển thị trạng thái xử lý một cách rõ ràng.

## Màn hình liên quan
- Màn hình khởi động kiểm tra phiên
- Màn hình xác thực

## Cấu trúc màn hình khởi động
| Khu vực | Vị trí | Mục đích nghiệp vụ | Thông tin hiển thị | Hành vi |
| --- | --- | --- | --- | --- |
| Vùng chờ toàn màn hình | Trung tâm | Báo ứng dụng đang kiểm tra phiên | Loading | Không cho người dùng thao tác |
| Vùng báo lỗi khởi động | Trung tâm | Thông báo nếu kiểm tra phiên gặp lỗi hiếm | Nội dung lỗi ngắn gọn | Cho phép thử lại hoặc quay lại luồng xác thực |

## Cấu trúc màn hình xác thực
| Khu vực | Vị trí | Mục đích nghiệp vụ | Thông tin hiển thị | Hành vi |
| --- | --- | --- | --- | --- |
| Khối thẻ xác thực | Trung tâm màn hình | Tập trung toàn bộ thao tác đăng nhập hoặc đăng ký | Tiêu đề, mô tả, form | Luôn là khu vực tương tác chính |
| Bộ chuyển chế độ | Dưới tiêu đề | Cho người dùng chọn giữa đăng nhập và đăng ký | Hai lựa chọn rõ ràng | Chuyển nội dung form ngay tại chỗ |
| Khu vực nhập liệu | Trung tâm thẻ | Thu thập thông tin xác thực | Field thay đổi theo chế độ | Cho phép nhập và sửa dữ liệu |
| Vùng thông báo lỗi | Dưới form | Giải thích vì sao thao tác chưa thành công | Thông điệp lỗi ngắn gọn | Chỉ hiển thị khi có lỗi |
| Nút xác nhận chính | Cuối thẻ | Hoàn tất thao tác đăng nhập hoặc đăng ký | Nhãn CTA theo chế độ | Bị khóa khi đang xử lý |

## Quy tắc hiển thị
- Chế độ đăng nhập hiển thị định danh và mật khẩu.
- Chế độ đăng ký hiển thị username, email và mật khẩu.
- Thông báo lỗi phải nằm gần khu vực nhập liệu để người dùng dễ nhận biết.
- Khi đang xử lý, người dùng vẫn nhìn thấy nguyên form nhưng không thể bấm gửi lặp lại.

## Trạng thái cần hỗ trợ
- Đang kiểm tra phiên.
- Đăng nhập thành công.
- Đăng ký thành công.
- Sai thông tin đăng nhập.
- Dữ liệu đăng ký không hợp lệ.
- Mạng hoặc máy chủ gặp sự cố.
