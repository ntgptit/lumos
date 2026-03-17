# Home Backend Use Cases

## Mục tiêu nghiệp vụ
Feature `home` hiện chưa có dịch vụ backend riêng cho phần dashboard. Vai trò nghiệp vụ ở phía backend chủ yếu là hỗ trợ gián tiếp thông qua dữ liệu của các feature con.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-HOME-001 | Không phát sinh xử lý backend riêng cho dashboard home | Ghi nhận đúng hiện trạng phân tách nghiệp vụ của hệ thống |

## BE-HOME-001 - Không phát sinh xử lý backend riêng cho dashboard home
### Mô tả nghiệp vụ
- `home` hiện là điểm vào của người dùng sau khi đăng nhập.
- Dashboard trên màn hình `home` đang đóng vai trò dẫn dắt trải nghiệm và điều hướng, chưa phải một báo cáo nghiệp vụ lấy dữ liệu thật từ backend.
- Dữ liệu mà người dùng tiếp cận từ `home` thực tế đến từ các module khác như `folder`, `progress` và `profile`.

### Kết luận BA
- Chưa có yêu cầu backend độc lập cho `home` ở thời điểm hiện tại.
- Nếu dashboard về sau cần hiển thị số liệu thật, nên bổ sung một use case backend riêng thay vì tiếp tục dùng dữ liệu trình bày tĩnh.
