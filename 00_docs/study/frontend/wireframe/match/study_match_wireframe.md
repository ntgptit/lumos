# Study Match Frontend Wireframe

## Mục tiêu màn hình
Màn hình `match` cần giúp người dùng nhìn thấy hai nhóm thông tin và ghép chúng thành từng cặp chính xác trong một không gian trực quan, dễ theo dõi.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Tiêu đề phiên học | Đầu màn hình | Cho biết người dùng đang ở chặng ghép cặp | Tên deck, tên mode | Cố định trong chặng match |
| Thanh tiến độ | Dưới tiêu đề | Thể hiện mức độ hoàn tất của chặng | Tiến độ hiện tại | Cập nhật sau mỗi lượt ghép hoàn tất |
| Cột thông tin bên trái | Nửa trái vùng chính | Hiển thị nhóm mục thứ nhất cần ghép | Danh sách từ, khái niệm hoặc nhãn | Cho phép chọn từng mục |
| Cột thông tin bên phải | Nửa phải vùng chính | Hiển thị nhóm mục thứ hai cần ghép | Danh sách nghĩa, mô tả hoặc giá trị tương ứng | Cho phép chọn từng mục |
| Vùng xác nhận lượt ghép | Cuối vùng chính hoặc cuối màn hình | Chốt bài làm sau khi ghép đủ cặp | Nút xác nhận, phản hồi kết quả | Chỉ sẵn sàng khi đủ điều kiện ghép |

## Luồng tương tác chính
1. Người dùng quan sát hai cột thông tin.
2. Người dùng lần lượt ghép các mục tương ứng.
3. Sau khi ghép đủ, người dùng xác nhận lượt ghép.
4. Màn hình hiển thị phản hồi và cho phép đi tiếp.

## Trạng thái hiển thị
- Các mục đã ghép phải dễ phân biệt với các mục chưa ghép.
- Trạng thái phản hồi sau khi xác nhận cần chỉ ra rõ người dùng đã làm tốt tới đâu.
- Nếu còn lỗi, màn hình phải giúp người dùng hiểu rằng nội dung đó cần luyện thêm.

## Nguyên tắc nghiệp vụ trên giao diện
- Hai nhóm thông tin phải được tách bạch rõ để giảm nhầm lẫn.
- Số lượng mục trên màn hình phải vừa đủ để người dùng vẫn quan sát được toàn cảnh.
- Hành động xác nhận chỉ nên nổi bật khi người dùng đã hoàn tất việc ghép.
