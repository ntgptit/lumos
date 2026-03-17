# Auth Backend API Contract

## Tổng quan

- Base path: `/api/v1/auth`
- Kiểu xác thực:
  - `register`, `login`, `refresh`, `logout`: public hoặc dùng refresh token trong body.
  - `me`: yêu cầu access token hợp lệ.

## `POST /api/v1/auth/register`

- Mục đích: Tạo account mới và trả session ngay.
- Request body:
  - `username: string`
  - `email: string`
  - `password: string`
- Validation:
  - `username`: bắt buộc, max length, đúng regex username.
  - `email`: bắt buộc, đúng email format.
  - `password`: bắt buộc, có min/max length.
- Response thành công:
  - HTTP `201 Created`
  - `user`
  - `accessToken`
  - `refreshToken`
  - `expiresIn`
  - `authenticated`

## `POST /api/v1/auth/login`

- Mục đích: Đăng nhập bằng username hoặc email.
- Request body:
  - `identifier: string`
  - `password: string`
- Response thành công:
  - HTTP `200 OK`
  - Cùng shape với `AuthResponse`

## `POST /api/v1/auth/refresh`

- Mục đích: Xoay refresh token và cấp access token mới.
- Request body:
  - `refreshToken: string`
- Response thành công:
  - HTTP `200 OK`
  - Cùng shape với `AuthResponse`
- Ghi chú:
  - Refresh token cũ bị đánh dấu `ROTATED`.
  - Token hết hạn hoặc không hợp lệ trả lỗi xác thực.

## `POST /api/v1/auth/logout`

- Mục đích: Thu hồi refresh token.
- Request body:
  - `refreshToken: string`
- Response thành công:
  - HTTP `204 No Content`
- Ghi chú:
  - Gọi lặp lại trên token đã revoke vẫn được coi là thành công.

## `GET /api/v1/auth/me`

- Mục đích: Lấy hồ sơ người dùng hiện tại.
- Header:
  - `Authorization: Bearer <accessToken>`
- Response thành công:
  - HTTP `200 OK`
  - `id`
  - `username`
  - `email`
  - `accountStatus`

## Lỗi tiêu biểu

- `400/422`: lỗi validation đầu vào.
- `401`: sai thông tin đăng nhập, token sai, refresh token không dùng được.
- `403`: access bị chặn bởi security layer.
- `409`: trùng username hoặc email.
