# Authentication Domain Model

## Mục tiêu

Phần này chốt các khái niệm domain của lớp `authentication`.

## Các thực thể cốt lõi

### UserAccount

Aggregate gốc của danh tính người dùng.

Nó giữ:

- `user_id`
- `username`
- `email`
- `password_hash`
- `account_status`
- `created_at`
- `updated_at`

### LoginIdentifier

Định danh được dùng cho flow đăng nhập.

Hệ thống hỗ trợ hai loại:

- `username`
- `email`

Ở thời điểm đăng nhập, backend nhận một `identifier` và tự quyết định đó là `username` hay `email`.

### Credential

Tập thông tin dùng để xác thực người dùng trong flow cơ bản.

Bao gồm:

- `identifier`
- `password`

### AccessToken

Token truy cập ngắn hạn ở dạng `JWT`.

AccessToken cần mô tả được:

- `subject`
- `issued_at`
- `expires_at`
- `token_type`
- claim tối thiểu để xác định người dùng và quyền truy cập

### RefreshToken

Token làm mới phiên đăng nhập.

RefreshToken cần mô tả được:

- `refresh_token_id`
- `user_id`
- `token_hash` hoặc reference tương đương
- `issued_at`
- `expires_at`
- `revoked_at`
- `device_label` hoặc `client_context` nếu sản phẩm cần quản lý theo thiết bị

### AuthSession

Đại diện cho một phiên đăng nhập có thể được làm mới bằng refresh token.

AuthSession cần mô tả được:

- user nào đang đăng nhập
- refresh token nào đang active
- session được tạo khi nào
- session còn hiệu lực hay không

### AuthResult

Kết quả chuẩn backend trả về sau các command auth chính.

AuthResult có thể gồm:

- thông tin user tối thiểu
- `access_token`
- `refresh_token`
- `expires_in`
- trạng thái xác thực hiện tại

## Trạng thái cốt lõi

### AccountStatus

Trạng thái vòng đời của tài khoản.

Ví dụ:

- `active`
- `disabled`
- `locked`

### RefreshTokenStatus

Trạng thái vòng đời của refresh token.

Ví dụ:

- `active`
- `rotated`
- `revoked`
- `expired`

## Ba lớp dữ liệu cần tách riêng

### Master account data

Dữ liệu gốc của tài khoản:

- username
- email
- password hash
- trạng thái tài khoản

### Session and token state

Dữ liệu runtime của phiên đăng nhập:

- refresh token đang active
- token đã rotate
- token đã revoke
- thời điểm hết hạn

### Auth event log

Dữ liệu ghi nhận hành vi xác thực có giá trị nghiệp vụ.

Ví dụ:

- `register_succeeded`
- `login_succeeded`
- `login_failed`
- `refresh_succeeded`
- `refresh_failed`
- `logout_succeeded`
