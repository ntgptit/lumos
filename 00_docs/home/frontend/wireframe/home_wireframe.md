# Home Frontend Wireframe

## Mục tiêu màn hình
Màn hình `home` phải đóng vai trò trung tâm điều hướng, đồng thời tạo cảm giác ứng dụng có cấu trúc rõ ràng ngay từ lần nhìn đầu tiên.

## Cấu trúc shell tổng thể
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| App bar | Trên cùng | Xác định người dùng đang ở đâu trong hệ thống | Tên tab, mô tả ngắn, biểu tượng thông báo, hồ sơ nhanh | Thay đổi theo tab đang chọn |
| Điều hướng chính | Dưới cùng trên mobile hoặc cạnh trái trên màn hình lớn | Cho phép chuyển giữa các nhóm chức năng chính | Home, Library, Folders, Progress, Profile | Đổi nội dung vùng thân màn hình |
| Vùng nội dung tab | Chính giữa | Hiển thị nội dung của tab đang chọn | Dashboard hoặc màn hình con của từng tab | Giữ ổn định khi người dùng chuyển tab |
| Dải báo đang chuyển tab | Phía trên vùng nội dung | Báo hiệu chuyển đổi nội dung trong thời gian ngắn | Loading mask ngắn | Chỉ hiển thị khi cần |

## Cấu trúc tab Home
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Hero card | Đầu trang | Truyền thông điệp chính của sản phẩm | Tiêu đề, mô tả, CTA | Thu hút người dùng ngay khi vào ứng dụng |
| Nhóm chỉ số nhanh | Giữa trang | Tạo cảm giác có tiến độ và thành quả | 3 chỉ số nổi bật | Chủ yếu mang tính định hướng |
| Khu vực chia đôi | Cuối trang | Nhấn mạnh vùng tập trung và hoạt động gần đây | Focus area, recent activity | Thích ứng theo thiết bị |

## Quy tắc hiển thị theo thiết bị
- Mobile: điều hướng nằm dưới cùng, các khối nội dung xếp dọc.
- Tablet: điều hướng dạt sang trái, các khối có thể chia 2 cột.
- Desktop: điều hướng mở rộng hơn, vùng nội dung rộng hơn và cân đối hơn.

## Trạng thái cần hỗ trợ
- Đang vào màn hình chính sau đăng nhập.
- Đang chuyển tab.
- Đang nhấn lại tab thư mục để cuộn về đầu.
