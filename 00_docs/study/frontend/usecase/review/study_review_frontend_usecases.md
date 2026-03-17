# Study Frontend Review Use Cases

## Mục tiêu nghiệp vụ
Mode `review` ở frontend giúp người dùng lướt nhanh qua từng nội dung và tự đánh giá ngay mình đã nhớ hay chưa nhớ.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-STUDY-REVIEW-001 | Xem nhanh nội dung review | Giúp người dùng tiếp cận từng mục trong thời gian rất ngắn |
| FE-STUDY-REVIEW-002 | Đánh dấu đã nhớ | Cho phép người dùng xác nhận nhanh nội dung mình nắm chắc |
| FE-STUDY-REVIEW-003 | Đánh dấu cần học lại | Giữ lại những mục chưa chắc để tiếp tục luyện |
| FE-STUDY-REVIEW-004 | Chuyển sang mục tiếp theo | Duy trì nhịp lướt nhanh, không đứt mạch học |

## FE-STUDY-REVIEW-001 - Xem nhanh nội dung review
### Mục tiêu
Trình bày nội dung sao cho người dùng chỉ cần nhìn ngắn gọn là có thể ra quyết định.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Ứng dụng hiển thị một nội dung review tại một thời điểm.
2. Người dùng quan sát nội dung chính.
3. Ứng dụng giữ vùng quyết định luôn sẵn sàng để người dùng phản hồi.

### Quy tắc nghiệp vụ
- Màn hình review phải ưu tiên tốc độ hơn độ chi tiết.
- Người dùng không phải nhập liệu trong mode này.

## FE-STUDY-REVIEW-002 - Đánh dấu đã nhớ
### Mục tiêu
Cho phép người dùng xác nhận nhanh rằng nội dung hiện tại đã được ghi nhớ.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Người dùng chọn hành động thể hiện đã nhớ.
2. Ứng dụng phản hồi rằng kết quả đã được ghi nhận.
3. Ứng dụng chuẩn bị chuyển sang mục tiếp theo.

## FE-STUDY-REVIEW-003 - Đánh dấu cần học lại
### Mục tiêu
Cho phép người dùng chủ động báo rằng nội dung hiện tại chưa vững và cần được gặp lại.

### Tác nhân
- Người dùng.
- Ứng dụng.

### Luồng chính
1. Người dùng chọn hành động thể hiện chưa nhớ.
2. Ứng dụng ghi nhận nội dung này cần học lại.
3. Ứng dụng thông báo trạng thái phản hồi rõ ràng để người dùng yên tâm rằng quyết định đã được lưu.

## FE-STUDY-REVIEW-004 - Chuyển sang mục tiếp theo
### Mục tiêu
Giữ nhịp thao tác ngắn, liên tục và không làm người dùng dừng lại quá lâu ở một mục review.

### Tác nhân
- Ứng dụng.

### Luồng chính
1. Sau khi người dùng đưa ra quyết định, ứng dụng hiển thị phản hồi ngắn gọn.
2. Ứng dụng chuyển sang mục review tiếp theo.
3. Tiến độ trên màn hình được cập nhật đồng thời.
