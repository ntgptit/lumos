# Authentication Lifecycle

## Command model

Authentication dùng command-based API.

Các command chuẩn:

- `register`
- `login`
- `refreshToken`
- `logout`
- `getCurrentUser`

Mỗi command phải trả về kết quả đủ để frontend không phải tự suy luận nghiệp vụ.

## Register

### Đầu vào

- `username`
- `email`
- `password`

### Xử lý nghiệp vụ

Backend phải:

- kiểm tra định dạng `username`
- kiểm tra định dạng `email`
- kiểm tra policy của `password`
- kiểm tra `username` đã tồn tại hay chưa
- kiểm tra `email` đã tồn tại hay chưa
- tạo `UserAccount`
- hash password trước khi lưu

### Kết quả

Hệ thống có thể:

- chỉ tạo tài khoản và yêu cầu người dùng đăng nhập sau
- hoặc tạo tài khoản rồi đăng nhập ngay

Trong thiết kế này, backend nên trả về kết quả rõ ràng để frontend biết:

- tài khoản đã được tạo chưa
- người dùng đã ở trạng thái authenticated chưa
- có token đi kèm hay không

## Login

### Đầu vào

- `identifier`
- `password`

`identifier` có thể là:

- `username`
- `email`

### Xử lý nghiệp vụ

Backend phải:

- xác định `identifier` map tới user nào
- kiểm tra tài khoản có tồn tại hay không
- kiểm tra trạng thái tài khoản có cho phép đăng nhập hay không
- so khớp password với `password_hash`
- tạo `JWT access token`
- tạo `refresh token`
- tạo `AuthSession`

### Kết quả

Khi đăng nhập thành công, backend trả về:

- `access_token`
- `refresh_token`
- `expires_in`
- thông tin user tối thiểu

Khi đăng nhập thất bại, backend trả về lỗi chuẩn hóa để frontend chỉ cần hiển thị đúng thông điệp tương ứng.

## Get current user

Command này dùng `access token` hiện hành để trả về user đã đăng nhập.

Mục tiêu:

- kiểm tra session ở FE còn hợp lệ ở mức API hay không
- hydrate lại trạng thái user sau khi app khởi động

## Logout

### Đầu vào

- `refresh_token` hiện hành hoặc session hiện hành

### Xử lý nghiệp vụ

Backend phải:

- xác định refresh token hoặc auth session cần đóng
- đánh dấu refresh token là `revoked`
- làm session không còn khả năng `refresh`

### Kết quả

Sau logout:

- access token cũ có thể tự hết hạn theo TTL ngắn
- refresh token đã logout không được dùng để cấp access token mới

## Luồng FE

Frontend nên triển khai auth flow theo thứ tự:

1. user mở màn hình `login` hoặc `register`
2. user nhập dữ liệu và submit
3. frontend gọi command tương ứng
4. backend trả về `AuthResult` hoặc lỗi
5. frontend lưu token theo policy sản phẩm
6. frontend hydrate user state và điều hướng vào app
