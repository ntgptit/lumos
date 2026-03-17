# Lumos Use Case Documentation

Tài liệu trong `00_docs` được viết lại theo góc nhìn BA, tập trung vào:
- mục tiêu nghiệp vụ
- tác nhân sử dụng
- điều kiện bắt đầu và kết thúc
- luồng nghiệp vụ chính
- luồng ngoại lệ
- quy tắc nghiệp vụ
- cấu trúc màn hình và hành vi người dùng

## Phạm vi
- `auth`
- `home`
- `folder`
- `deck`
- `flashcard`
- `progress`
- `profile`
- `reminder`
- `study`
- `tts`

## Quy ước Use Case ID
- Frontend: `FE-<FEATURE>-NNN`
- Backend: `BE-<FEATURE>-NNN`
- Study mode:
  - Frontend: `FE-STUDY-<MODE>-NNN`
  - Backend: `BE-STUDY-<MODE>-NNN`
  - Shared: `FE-STUDY-SHARED-NNN`, `BE-STUDY-SHARED-NNN`

## Cấu trúc thư mục
- `feature_name/backend/usecase`
- `feature_name/backend/api_contract`
- `feature_name/frontend/usecase`
- `feature_name/frontend/wireframe`

## Lưu ý khi đọc tài liệu
- `usecase` và `wireframe` được trình bày theo ngôn ngữ nghiệp vụ và trải nghiệm người dùng.
- `api_contract` vẫn giữ tính kỹ thuật để thuận tiện cho phân tích tích hợp FE/BE.
- `home` hiện chưa có dữ liệu dashboard thật từ backend, nên use case của `home` chủ yếu là điều hướng và hiển thị.
- `tts` hiện là năng lực hỗ trợ, được nhúng trong `study` và `profile`, chưa phải một màn hình độc lập.
- `study` là chức năng lớn nên được tách theo từng mode: `shared`, `review`, `match`, `guess`, `recall`, `fill`.
