# Authentication Principles

## Mục tiêu

Authentication là lớp xác thực danh tính người dùng và cấp quyền truy cập vào API của ứng dụng.

Hệ thống phải cho phép:

- tạo tài khoản mới
- xác thực người dùng bằng `username` hoặc `email` kết hợp `password`
- cấp token truy cập ngắn hạn
- duy trì phiên đăng nhập bằng refresh token
- thu hồi quyền truy cập khi người dùng đăng xuất hoặc token bị vô hiệu hóa

## Phạm vi

Mỗi auth flow cần bao phủ:

- `register`
- `login`
- `refresh token`
- `logout`
- `get current user`

## Nguyên tắc phân chia trách nhiệm

### Backend

Backend sở hữu:

- định danh người dùng chuẩn
- kiểm tra tính hợp lệ của `username`, `email`, `password`
- kiểm tra thông tin đăng nhập
- phát hành `JWT access token`
- phát hành và xoay vòng `refresh token`
- trạng thái hiệu lực của refresh token
- canonical auth state của người dùng

### Frontend

Frontend chỉ nên giữ:

- form state tạm thời
- loading state
- hiển thị lỗi xác thực
- lưu token theo policy sản phẩm
- tự động gọi `refresh token` khi access token hết hạn nếu session còn hợp lệ

Frontend không quyết định:

- user có được xác thực hay không
- token có còn hiệu lực hay không
- refresh token có còn hợp lệ hay đã bị thu hồi

## UI behavior và business behavior

### UI behavior

Do frontend quản lý:

- nhập `username`, `email`, `password`
- ẩn hoặc hiện mật khẩu
- disable nút trong lúc submit
- hiển thị loading, success, error
- điều hướng sau khi đăng nhập thành công

### Business behavior

Do backend quản lý:

- tài khoản có tồn tại hay không
- identifier map tới user nào
- mật khẩu đúng hay sai
- access token được cấp khi nào
- refresh token được chấp nhận hay bị từ chối
- phiên đăng nhập còn hiệu lực hay không

## Nguyên tắc bảo mật

- password không được lưu dạng raw text
- password phải được hash trước khi lưu
- refresh token phải có vòng đời và trạng thái rõ ràng
- access token có TTL ngắn
- refresh token có TTL dài hơn và có thể bị thu hồi
- logout phải làm mất hiệu lực refresh token tương ứng
