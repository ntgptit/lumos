# Flashcard Frontend Wireframe

## Mục tiêu màn hình
Màn hình `flashcard` cần giúp người dùng vừa quản lý nội dung chi tiết của một deck, vừa nhìn thấy các điểm vào học tập ngay trong cùng bối cảnh.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Thanh công cụ trên cùng | Trên cùng | Cung cấp thao tác nhanh trên deck | Tìm kiếm, sắp xếp, tạo mới | Luôn sẵn sàng |
| Vùng cảnh báo | Đầu nội dung, khi cần | Thông báo lỗi thao tác hoặc tải dữ liệu | Thông điệp ngắn gọn | Chỉ hiện khi có lỗi |
| Vùng preview | Phía trên danh sách | Cho người dùng xem nhanh một số flashcard tiêu biểu | Carousel thẻ xem trước | Có thể dùng để mở học nhanh |
| Vùng thông tin deck | Dưới preview | Tóm tắt deck đang xem | Tên deck, tổng số thẻ | Tạo ngữ cảnh rõ ràng |
| Vùng hành động học | Dưới thông tin deck | Mời người dùng bắt đầu các hoạt động học | Các nút review, learn, quiz, match | Điều hướng sang study |
| Vùng tiến độ deck | Dưới hành động học | Tóm tắt trạng thái học hiện tại của deck | Số chưa bắt đầu, đang học, thành thạo | Có thể nhấn để tiếp tục học |
| Danh sách flashcard | Nội dung chính | Hiển thị toàn bộ flashcard trong deck | Card list với action | Cho phép mở thao tác từng thẻ |
| Trạng thái rỗng | Thay cho danh sách | Hướng dẫn tạo flashcard đầu tiên | Thông điệp và CTA | Hiện khi deck chưa có dữ liệu |
| Lớp phủ đang tải hoặc đang xử lý | Phủ một phần hoặc toàn màn hình | Báo trạng thái làm mới hoặc lưu dữ liệu | Loading mask, overlay | Ngăn thao tác trùng lặp khi cần |

## Quy tắc hiển thị
- Khi deck có dữ liệu, preview và các khu vực học phải được ưu tiên hiển thị ở nửa trên màn hình.
- Khi deck chưa có dữ liệu, giao diện cần tập trung vào việc hướng dẫn tạo flashcard đầu tiên.
- Các thao tác học phải nhìn thấy được mà không buộc người dùng rời khỏi màn hình deck.

## Trạng thái cần hỗ trợ
- Loading ban đầu.
- Có dữ liệu.
- Không có dữ liệu.
- Đang tìm kiếm.
- Đang tải thêm.
- Đang xử lý tạo, sửa hoặc xóa.
- Có lỗi sau thao tác.
