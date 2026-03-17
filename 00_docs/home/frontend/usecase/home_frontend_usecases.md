# Home Frontend Use Cases

## Mục tiêu nghiệp vụ
Feature `home` là lớp vỏ điều hướng chính sau khi người dùng đăng nhập, giúp người dùng di chuyển nhanh giữa các khu vực chức năng và nhận được một màn hình chào mang tính định hướng.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-HOME-001 | Vào màn hình chính sau đăng nhập | Đưa người dùng đến không gian làm việc trung tâm |
| FE-HOME-002 | Chuyển tab trong màn hình chính | Cho người dùng di chuyển giữa các nhóm chức năng lớn |
| FE-HOME-003 | Nhấn lại tab thư mục | Hỗ trợ người dùng quay nhanh về đầu danh sách |
| FE-HOME-004 | Xem dashboard chào mừng | Cung cấp điểm bắt đầu mang tính định hướng |

## FE-HOME-001 - Vào màn hình chính sau đăng nhập
### Mục tiêu
Cho người dùng một điểm vào thống nhất ngay sau khi xác thực thành công.

### Luồng chính
1. Người dùng đăng nhập thành công.
2. Ứng dụng chuyển người dùng sang màn hình chính.
3. Màn hình chính hiển thị app bar, khu vực nội dung và thanh điều hướng phù hợp với thiết bị.

## FE-HOME-002 - Chuyển tab trong màn hình chính
### Mục tiêu
Giúp người dùng chuyển nhanh giữa các nhóm chức năng mà không mất ngữ cảnh.

### Luồng chính
1. Người dùng chọn một tab chức năng.
2. Ứng dụng chuyển vùng nội dung sang tab được chọn.
3. Ứng dụng giữ lại các tab đã đi qua để trải nghiệm chuyển đổi mượt hơn.
4. Ứng dụng hiển thị tín hiệu tải ngắn khi cần.

### Kết quả mong đợi
- Người dùng cảm thấy việc chuyển tab nhanh và ổn định.
- Không bị mất vị trí hoặc ngữ cảnh một cách bất ngờ.

## FE-HOME-003 - Nhấn lại tab thư mục
### Mục tiêu
Hỗ trợ thao tác quay nhanh về đầu danh sách khi người dùng đang ở sâu trong thư viện.

### Luồng chính
1. Người dùng đang ở tab thư mục.
2. Người dùng nhấn lại đúng tab đó.
3. Ứng dụng cuộn danh sách thư mục về đầu.

## FE-HOME-004 - Xem dashboard chào mừng
### Mục tiêu
Tạo cảm giác có định hướng ngay khi người dùng bước vào ứng dụng.

### Luồng chính
1. Ứng dụng hiển thị khối giới thiệu nổi bật.
2. Ứng dụng hiển thị nhóm chỉ số nhanh.
3. Ứng dụng hiển thị khu vực gợi ý hoạt động và vùng tập trung học tập.

### Ghi chú BA
- Nội dung dashboard hiện mang tính trình bày và khuyến khích sử dụng.
- Chưa phải dashboard số liệu nghiệp vụ chính thức.
