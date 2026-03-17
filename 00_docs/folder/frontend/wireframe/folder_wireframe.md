# Folder Frontend Wireframe

## Mục tiêu màn hình
Màn hình `folder` phải giúp người dùng vừa hiểu mình đang đứng ở đâu trong cây thư viện, vừa thao tác nhanh trên nhánh hiện tại.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Header thư mục | Đầu màn hình | Cho người dùng biết cấp hiện tại và ngữ cảnh đang quản lý | Tên ngữ cảnh, mô tả ngắn, trạng thái thư mục hoặc deck | Luôn hiển thị |
| Thanh điều hướng nội bộ | Dưới header | Hỗ trợ quay lên cấp cha hoặc về gốc | Nút điều hướng, ô tìm kiếm, công cụ sắp xếp | Thay đổi theo ngữ cảnh hiện tại |
| Vùng cảnh báo | Dưới thanh điều hướng | Thông báo lỗi nghiệp vụ hoặc lỗi thao tác | Thông báo ngắn gọn | Chỉ hiện khi có lỗi |
| Danh sách chính | Khu vực nội dung | Hiển thị thư mục con hoặc danh sách deck | Row danh sách, empty state, loading thêm | Chiếm phần lớn màn hình |
| Nút tạo nhanh | Góc dưới màn hình | Cho phép tạo thư mục hoặc deck | Nút nổi hoặc action sheet | Luôn sẵn sàng khi có quyền thao tác |
| Lớp phủ đang xử lý | Phủ toàn màn hình khi cần | Ngăn thao tác trùng lặp khi hệ thống đang xử lý | Loading overlay | Chỉ bật khi đang lưu hoặc xóa |

## Quy tắc hiển thị
- Khi đang ở thư mục còn nhánh con, vùng danh sách ưu tiên hiển thị thư mục.
- Khi đang ở thư mục lá, vùng danh sách chuyển sang hiển thị deck.
- Khu vực tìm kiếm và sắp xếp vẫn nằm cùng vị trí để người dùng không phải học lại giao diện.

## Trạng thái cần hỗ trợ
- Danh sách thư mục có dữ liệu.
- Danh sách thư mục rỗng.
- Danh sách deck trong thư mục lá.
- Đang tải thêm dữ liệu.
- Đang lưu hoặc xóa.
- Có lỗi cần hiển thị ngay trên màn hình.
