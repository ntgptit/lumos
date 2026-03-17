# Study Review Frontend Wireframe

## Mục tiêu màn hình
Màn hình `review` cần phục vụ việc xem nhanh và ra quyết định nhanh. Người dùng phải chỉ mất ít thời gian để nhìn một nội dung và chọn đã nhớ hoặc cần học lại.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Tiêu đề phiên học | Đầu màn hình | Xác nhận người dùng đang ở mode review | Tên deck, tên mode | Cố định trong suốt chặng review |
| Thanh tiến độ | Dưới tiêu đề | Tạo cảm giác đang tiến về đích | Tiến độ của mode hoặc phiên | Cập nhật sau mỗi quyết định |
| Thẻ nội dung review | Trung tâm màn hình | Làm nổi bật nội dung cần xem nhanh | Từ, nghĩa, ghi chú ngắn hoặc thông tin chính | Mỗi lần chỉ hiển thị một nội dung |
| Nhóm quyết định nhanh | Nửa dưới màn hình | Cho phép người dùng phản hồi ngay mức độ ghi nhớ | Nút đã nhớ, nút cần học lại | Luôn đặt ở vị trí dễ thao tác |
| Phản hồi ngắn | Gần nhóm quyết định hoặc chuyển tiếp ngay | Xác nhận lựa chọn đã được ghi nhận | Trạng thái ngắn gọn sau thao tác | Biến mất khi sang mục kế tiếp |

## Luồng tương tác chính
1. Người dùng nhìn thẻ nội dung review.
2. Người dùng quyết định mình đã nhớ hay chưa nhớ.
3. Người dùng chọn hành động tương ứng.
4. Màn hình phản hồi ngắn gọn rồi chuyển sang nội dung tiếp theo.

## Trạng thái hiển thị
- Không có trạng thái nhập liệu ở mode review.
- Trạng thái sau thao tác phải ngắn, rõ và không chặn nhịp lướt nhanh.
- Khi không còn nội dung review, màn hình phải chuyển sang chặng kế tiếp hoặc kết thúc phiên.

## Nguyên tắc nghiệp vụ trên giao diện
- Ưu tiên tốc độ hơn chi tiết.
- Vùng quyết định phải nổi bật hơn các thông tin phụ.
- Không để người dùng phải suy nghĩ về bước tiếp theo sau khi đã chọn xong.
