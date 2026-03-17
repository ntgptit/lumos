# Folder Frontend Use Cases

## Mục tiêu nghiệp vụ
Feature `folder` ở frontend giúp người dùng duyệt cây thư viện, tạo cấu trúc tổ chức mới và chuyển sang quản lý bộ thẻ học khi đi tới một thư mục lá.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-FOLDER-001 | Duyệt thư viện theo cây | Cho người dùng mở sâu từng cấp thư mục |
| FE-FOLDER-002 | Tìm kiếm và sắp xếp thư mục | Giúp người dùng tìm nhanh nhánh cần thao tác |
| FE-FOLDER-003 | Tạo, sửa, xóa thư mục | Hỗ trợ người dùng quản lý cấu trúc thư viện |
| FE-FOLDER-004 | Quản lý deck trong thư mục lá | Chuyển ngữ cảnh từ quản lý thư mục sang quản lý bộ thẻ |
| FE-FOLDER-005 | Làm mới danh sách | Giữ dữ liệu hiển thị luôn cập nhật |

## FE-FOLDER-001 - Duyệt thư viện theo cây
### Mục tiêu
Giúp người dùng đi từ thư mục gốc xuống từng nhánh cụ thể.

### Luồng chính
1. Người dùng mở màn hình thư viện.
2. Ứng dụng hiển thị danh sách thư mục ở cấp hiện tại.
3. Người dùng chọn một thư mục để đi sâu hơn.
4. Ứng dụng tải và hiển thị cấp kế tiếp.
5. Người dùng có thể quay về cấp cha hoặc về gốc.

## FE-FOLDER-002 - Tìm kiếm và sắp xếp thư mục
### Mục tiêu
Giảm thời gian tìm đúng nhánh thư viện cần thao tác.

### Luồng chính
1. Người dùng nhập từ khóa tìm kiếm.
2. Ứng dụng cập nhật lại danh sách theo điều kiện tìm kiếm.
3. Người dùng đổi cách sắp xếp.
4. Ứng dụng hiển thị kết quả mới trong cùng ngữ cảnh.

## FE-FOLDER-003 - Tạo, sửa, xóa thư mục
### Mục tiêu
Cho người dùng thay đổi cấu trúc thư viện mà không cần rời khỏi màn hình đang duyệt.

### Luồng chính
1. Người dùng mở hộp thoại tạo hoặc chỉnh sửa.
2. Người dùng xác nhận thao tác.
3. Ứng dụng gửi yêu cầu lên hệ thống.
4. Khi thành công, danh sách hiện tại được cập nhật lại.
5. Khi thất bại, ứng dụng hiển thị lỗi gần khu vực thao tác.

## FE-FOLDER-004 - Quản lý deck trong thư mục lá
### Mục tiêu
Khi người dùng đi tới thư mục không còn thư mục con, ứng dụng chuyển trọng tâm sang nội dung học bên trong.

### Luồng chính
1. Người dùng mở một thư mục lá.
2. Ứng dụng đổi vùng danh sách từ thư mục sang bộ thẻ học.
3. Người dùng có thể tạo bộ thẻ mới hoặc mở bộ thẻ hiện có.

### Quy tắc nghiệp vụ
- Một thư mục lá là nơi thích hợp để quản lý deck.
- Khi còn thư mục con, ưu tiên hiển thị cấu trúc cây thay vì danh sách deck.

## FE-FOLDER-005 - Làm mới danh sách
### Mục tiêu
Giúp người dùng luôn nhìn thấy dữ liệu mới nhất trong phạm vi đang làm việc.

### Luồng chính
1. Người dùng kéo để làm mới.
2. Ứng dụng tải lại dữ liệu của cấp hiện tại.
3. Nếu đang ở thư mục lá, ứng dụng đồng thời tải lại danh sách deck.
