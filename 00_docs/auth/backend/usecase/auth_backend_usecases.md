# Auth Backend Use Cases

## Định hướng tài liệu
Tài liệu này mô tả use case của backend `auth` theo góc nhìn nghiệp vụ.

- Tập trung vào mục tiêu người dùng, điều kiện nghiệp vụ, kết quả mong đợi và các quy tắc cần được bảo đảm.
- Không đi sâu vào cấu trúc field request/response, mã lỗi kỹ thuật, hay cách triển khai token.
- Chi tiết giao tiếp kỹ thuật được tách riêng tại `00_docs/auth/backend/api_contract/auth_api_contract.md`.

## Mục tiêu nghiệp vụ
Feature `auth` bảo đảm người dùng có thể bắt đầu sử dụng hệ thống, truy cập lại tài khoản của mình và duy trì trạng thái đăng nhập một cách an toàn, liên tục.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-AUTH-001 | Đăng ký tài khoản | Cho phép người dùng mới bắt đầu sử dụng hệ thống ngay sau khi tạo tài khoản thành công |
| BE-AUTH-002 | Đăng nhập | Cho phép người dùng quay lại hệ thống bằng thông tin định danh hợp lệ |
| BE-AUTH-003 | Duy trì phiên đăng nhập | Giúp người dùng tiếp tục làm việc mà không bị gián đoạn bởi việc hết hạn đăng nhập ngắn hạn |
| BE-AUTH-004 | Đăng xuất | Cho phép người dùng chủ động kết thúc phiên làm việc hiện tại một cách an toàn |
| BE-AUTH-005 | Xem thông tin tài khoản hiện tại | Cung cấp hồ sơ chuẩn của người dùng đang đăng nhập để các màn hình khác sử dụng thống nhất |

## BE-AUTH-001 - Đăng ký tài khoản
### Mục tiêu
Cho phép người dùng mới tạo tài khoản hợp lệ và bắt đầu sử dụng hệ thống ngay sau khi đăng ký thành công.

### Tác nhân
- Người dùng chưa có tài khoản.

### Tiền điều kiện
- Người dùng cung cấp đủ thông tin đăng ký theo quy định của hệ thống.
- Thông tin định danh dự kiến sử dụng chưa thuộc về một tài khoản khác.

### Hậu điều kiện
- Một tài khoản mới được ghi nhận ở trạng thái có thể sử dụng.
- Người dùng có thể đi tiếp vào hệ thống mà không cần thực hiện thêm một bước đăng nhập riêng.

### Luồng chính
1. Người dùng gửi thông tin đăng ký.
2. Hệ thống kiểm tra tính hợp lệ của thông tin đã nhận.
3. Hệ thống kiểm tra khả năng sử dụng của thông tin định danh.
4. Hệ thống tạo tài khoản mới.
5. Hệ thống thiết lập trạng thái đăng nhập ban đầu cho người dùng.
6. Hệ thống trả thông tin cần thiết để người dùng bắt đầu sử dụng hệ thống.

### Luồng ngoại lệ
1. Thông tin đăng ký không hợp lệ, hệ thống từ chối tiếp nhận.
2. Username đã được sử dụng, hệ thống từ chối đăng ký.
3. Email đã được sử dụng, hệ thống từ chối đăng ký.

### Quy tắc nghiệp vụ
- Username phải là duy nhất trong hệ thống.
- Email phải là duy nhất trong hệ thống.
- Sau khi đăng ký thành công, người dùng không cần lặp lại thao tác đăng nhập để vào hệ thống.

## BE-AUTH-002 - Đăng nhập
### Mục tiêu
Cho phép người dùng đã có tài khoản truy cập lại hệ thống bằng thông tin xác thực hợp lệ.

### Tác nhân
- Người dùng đã có tài khoản.

### Tiền điều kiện
- Tài khoản đã tồn tại trong hệ thống.
- Tài khoản đang ở trạng thái được phép sử dụng.

### Hậu điều kiện
- Người dùng được ghi nhận là đã đăng nhập hợp lệ.
- Hệ thống cấp lại thông tin phiên để người dùng tiếp tục sử dụng các chức năng cần xác thực.

### Luồng chính
1. Người dùng cung cấp thông tin đăng nhập.
2. Hệ thống xác định tài khoản tương ứng.
3. Hệ thống kiểm tra trạng thái tài khoản.
4. Hệ thống xác thực thông tin bí mật đi kèm.
5. Hệ thống mở phiên làm việc mới cho người dùng.
6. Hệ thống trả thông tin tài khoản cơ bản và thông tin phiên hiện tại.

### Luồng ngoại lệ
1. Không tìm thấy tài khoản phù hợp với thông tin định danh được cung cấp.
2. Thông tin bí mật không chính xác.
3. Tài khoản không còn ở trạng thái được phép sử dụng.

### Quy tắc nghiệp vụ
- Người dùng có thể đăng nhập bằng username hoặc email.
- Tài khoản không hoạt động không được phép tạo phiên làm việc mới.

## BE-AUTH-003 - Duy trì phiên đăng nhập
### Mục tiêu
Giúp người dùng tiếp tục sử dụng hệ thống liên tục khi phiên đăng nhập ngắn hạn không còn hiệu lực nhưng quyền truy cập vẫn hợp lệ.

### Tác nhân
- Người dùng đã đăng nhập và đang có thông tin duy trì phiên hợp lệ.

### Tiền điều kiện
- Phiên hiện tại trước đó đã được tạo hợp lệ.
- Thông tin dùng để duy trì phiên vẫn còn hiệu lực và chưa bị thu hồi.

### Hậu điều kiện
- Một phiên làm việc mới được thiết lập để thay thế phiên cũ.
- Quyền truy cập của người dùng được tiếp nối mà không cần nhập lại thông tin đăng nhập ban đầu.

### Luồng chính
1. Ứng dụng gửi yêu cầu duy trì phiên thay cho người dùng.
2. Hệ thống xác định phiên đang được yêu cầu gia hạn.
3. Hệ thống kiểm tra phiên còn đủ điều kiện để tiếp tục sử dụng.
4. Hệ thống thay thế thông tin phiên cũ bằng thông tin phiên mới.
5. Hệ thống trả thông tin phiên mới cho ứng dụng.

### Luồng ngoại lệ
1. Không xác định được phiên hợp lệ tương ứng với yêu cầu duy trì phiên.
2. Phiên đã hết hiệu lực hoặc đã bị thu hồi.
3. Tài khoản gắn với phiên không còn đủ điều kiện sử dụng hệ thống.

### Quy tắc nghiệp vụ
- Thông tin duy trì phiên cũ không được tiếp tục sử dụng sau khi đã được thay thế.
- Chỉ tài khoản đang hoạt động mới được duy trì phiên.

## BE-AUTH-004 - Đăng xuất
### Mục tiêu
Cho phép người dùng chủ động chấm dứt phiên làm việc ở thiết bị hiện tại để bảo đảm an toàn truy cập.

### Tác nhân
- Người dùng đang đăng nhập.

### Hậu điều kiện
- Phiên làm việc hiện tại không còn được phép sử dụng cho các lần truy cập tiếp theo.

### Luồng chính
1. Người dùng hoặc ứng dụng gửi yêu cầu đăng xuất phiên hiện tại.
2. Hệ thống xác định phiên cần kết thúc.
3. Hệ thống vô hiệu hóa quyền tiếp tục sử dụng phiên đó.
4. Hệ thống xác nhận thao tác đăng xuất thành công.

### Luồng ngoại lệ
1. Thông tin phiên gửi kèm không hợp lệ hoặc không còn sử dụng được.

### Quy tắc nghiệp vụ
- Đăng xuất được xử lý theo hướng an toàn và không làm phát sinh thêm phiên mới.
- Nếu yêu cầu đăng xuất lặp lại trên cùng một phiên đã bị vô hiệu hóa, hệ thống vẫn coi thao tác là hoàn tất.

## BE-AUTH-005 - Xem thông tin tài khoản hiện tại
### Mục tiêu
Cung cấp một hồ sơ tài khoản chuẩn của người dùng đang đăng nhập để các màn hình và nghiệp vụ phía sau sử dụng thống nhất.

### Tác nhân
- Người dùng đang có quyền truy cập hợp lệ.

### Tiền điều kiện
- Yêu cầu được gửi trong bối cảnh đã xác thực thành công.

### Hậu điều kiện
- Ứng dụng nhận được thông tin tài khoản hiện tại ở một cấu trúc thống nhất.

### Luồng chính
1. Hệ thống xác định người dùng hiện tại từ ngữ cảnh xác thực.
2. Hệ thống kiểm tra tài khoản còn hợp lệ.
3. Hệ thống trả về hồ sơ người dùng hiện tại.

### Luồng ngoại lệ
1. Yêu cầu không mang theo thông tin xác thực hợp lệ.
2. Tài khoản tương ứng không còn tồn tại hoặc không còn được phép sử dụng.

### Kết quả nghiệp vụ
- Các chức năng cần hiển thị hoặc kiểm tra thông tin người dùng hiện tại có cùng một nguồn dữ liệu chuẩn.
