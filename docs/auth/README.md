# Authentication Overview

Phần này mô tả lớp `authentication` và `authorization entry` của ứng dụng.

Hệ thống hỗ trợ:

- đăng ký tài khoản
- đăng nhập bằng `username` hoặc `email` kết hợp `password`
- cấp `JWT access token`
- cấp `refresh token`
- làm mới access token khi hết hạn
- đăng xuất và thu hồi refresh token

## Tài liệu con

- [Principles](/D:/workspace/lumos/docs/auth/principles.md)
- [Domain Model](/D:/workspace/lumos/docs/auth/domain-model.md)
- [Auth Lifecycle](/D:/workspace/lumos/docs/auth/auth-lifecycle.md)
- [Token Lifecycle](/D:/workspace/lumos/docs/auth/token-lifecycle.md)

## Quy tắc sản phẩm

- người dùng có thể đăng nhập bằng `username` hoặc `email`
- mật khẩu luôn là yếu tố xác thực bắt buộc trong flow cơ bản
- backend là nơi sở hữu canonical auth state
- `access token` dùng để gọi API
- `refresh token` dùng để cấp lại `access token` mà không bắt người dùng đăng nhập lại
