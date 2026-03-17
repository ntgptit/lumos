# Home Backend API Contract

## Kết luận hiện trạng

- Không có endpoint backend chuyên biệt cho `home`.
- Không có request/response contract riêng cho dashboard home.

## Dữ liệu mà home shell phụ thuộc gián tiếp

- Trạng thái xác thực:
  - `GET /api/v1/auth/me`
- Dữ liệu của tab con:
  - `folder` tab dùng `/api/v1/folders`
  - `progress` tab dùng `/api/v1/study/reminders/summary` và `/api/v1/study/analytics/overview`
  - `profile` tab dùng `/api/v1/profile`

## Ghi chú

- Nếu sau này dashboard home được nối dữ liệu thật, nên tạo contract riêng thay vì tiếp tục hardcode ở FE.
