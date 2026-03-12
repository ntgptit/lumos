# Token Lifecycle

## Mục tiêu

Phần này mô tả vòng đời của `JWT access token` và `refresh token`.

## Access token

### Vai trò

`Access token` dùng để gọi các API cần xác thực.

### Đặc tính

- thời gian sống ngắn
- ở dạng `JWT`
- được gửi kèm theo request đến backend
- hết hạn thì không được dùng tiếp

### Hành vi hệ thống

Khi access token còn hiệu lực:

- request được xử lý bình thường nếu token hợp lệ

Khi access token hết hạn:

- frontend không tự suy luận user đã bị logout
- frontend thử gọi `refreshToken` nếu còn refresh token hợp lệ

## Refresh token

### Vai trò

`Refresh token` dùng để xin cấp lại access token mới mà không cần người dùng đăng nhập lại.

### Đặc tính

- thời gian sống dài hơn access token
- không dùng để gọi API nghiệp vụ thông thường
- có trạng thái hiệu lực rõ ràng
- có thể bị `rotated`, `revoked` hoặc `expired`

## Refresh flow

### Đầu vào

- `refresh_token`

### Xử lý nghiệp vụ

Backend phải:

- kiểm tra refresh token có tồn tại hay không
- kiểm tra refresh token có đúng định dạng và đúng nguồn không
- kiểm tra token còn hiệu lực hay đã `revoked` hoặc `expired`
- xác định token thuộc về user nào
- tạo access token mới
- có thể tạo refresh token mới theo policy rotation

### Kết quả

Khi refresh thành công, backend trả về:

- `access_token` mới
- `refresh_token` mới nếu hệ thống dùng rotation
- `expires_in` mới

Khi refresh thất bại:

- frontend phải đưa user về trạng thái chưa authenticated
- yêu cầu user đăng nhập lại

## Refresh token rotation

Hệ thống nên hỗ trợ `refresh token rotation`.

Nguyên tắc:

- mỗi lần refresh thành công, token cũ bị chuyển khỏi trạng thái `active`
- token mới trở thành token duy nhất được phép dùng cho lần refresh tiếp theo
- token cũ nếu bị dùng lại thì backend có thể xem đó là tín hiệu bất thường

## Storage policy

Backend là nơi quyết định refresh token nào còn hợp lệ.

Frontend chỉ lưu token theo policy sản phẩm.

Frontend không được coi dữ liệu đang lưu là nguồn sự thật cuối cùng về auth state.

## Resume khi app mở lại

Khi app khởi động lại:

1. frontend đọc token đã lưu
2. nếu access token còn dùng được thì hydrate user state
3. nếu access token không còn dùng được nhưng refresh token còn có thể thử, frontend gọi `refreshToken`
4. nếu refresh thành công, frontend cập nhật token và tiếp tục session
5. nếu refresh thất bại, frontend điều hướng user về màn hình login

## Analytics và audit

Nếu cần theo dõi auth behavior, hệ thống nên ghi nhận:

- số lần login thành công
- số lần login thất bại
- số lần refresh thành công
- số lần refresh thất bại
- số lần logout

Auth analytics là lớp theo dõi bảo mật và vận hành, không thay thế canonical auth state.
