# Reminder Strategies

## Vai trò

Tài liệu này chốt các loại reminder mà hệ thống hỗ trợ và rule kích hoạt của từng loại.

Mỗi reminder là một output nghiệp vụ của backend, được sinh ra từ:

- `DueQueue`
- `ReminderPlan`
- `SchedulePolicy`
- trạng thái overdue hiện tại
- nhịp học gần đây của người dùng

Frontend chỉ render đúng reminder đã được backend quyết định.

## Danh sách reminder

Hệ thống hỗ trợ 5 nhóm reminder chính:

1. `In-app badge + due list`
2. `Daily push reminder`
3. `Due-based session recommendation`
4. `Overdue escalation`
5. `Weekly digest`

## 1. In-app badge + due list

Đây là lớp reminder mặc định trong ứng dụng.

### Mục tiêu

- cho người dùng biết có item cần ôn ngay lúc mở app
- hiển thị danh sách item hoặc deck cần học trong ngày
- tạo điểm vào tự nhiên cho phiên `fill review`

### Rule kích hoạt

Reminder này được kích hoạt khi:

- có ít nhất một item `due`
- hoặc có ít nhất một item `overdue`

### Dữ liệu cần có

- tổng số item `due`
- tổng số item `overdue`
- deck hoặc nhóm nội dung ưu tiên
- CTA mở session ôn tập phù hợp

### Kênh hiển thị

- badge trên home
- khu vực `due list`
- indicator ở deck hoặc nhóm nội dung

## 2. Daily push reminder

Đây là reminder chủ động ngoài ứng dụng theo nhịp hằng ngày.

### Mục tiêu

- tạo thói quen học đều
- kéo người dùng quay lại app khi chưa mở app trong ngày

### Rule kích hoạt

Reminder này được kích hoạt khi đồng thời thỏa các điều kiện:

- đang ở trong khung giờ nhắc học của người dùng
- trong ngày có item `due` hoặc `overdue`
- người dùng chưa hoàn thành target học trong ngày
- chưa vượt `frequency cap` của push trong ngày

### Dữ liệu cần có

- số item cần ôn trong ngày
- số item quá hạn nếu có
- session được đề xuất khi bấm vào push

### Kênh hiển thị

- push notification

## 3. Due-based session recommendation

Đây là reminder mang tính đề xuất hành động cụ thể.

### Mục tiêu

- không chỉ báo là có due item
- mà còn chỉ ra session nào nên được bắt đầu ngay

### Rule kích hoạt

Reminder này được kích hoạt khi:

- có `DueQueue` khả dụng
- backend chọn được session phù hợp theo số item hiện có
- người dùng đang ở trạng thái có thể bắt đầu một phiên ôn tập mới

### Dữ liệu cần có

- session type được đề xuất
- số item dự kiến trong session
- deck hoặc nhóm nội dung ưu tiên
- thời lượng ước tính của session

### Kênh hiển thị

- card đề xuất trong app
- CTA trong push hoặc banner

## 4. Overdue escalation

Đây là reminder tăng dần mức độ khi backlog quá hạn tích tụ.

### Mục tiêu

- ngăn backlog phình to
- tăng lực kéo quay lại học theo mức độ cần thiết

### Rule kích hoạt

Reminder này được kích hoạt khi số item `overdue`, số ngày quá hạn hoặc tổng backlog vượt ngưỡng do backend định nghĩa.

Escalation nên có các mức:

1. `level_1`: chỉ hiển thị badge và due list khi mới xuất hiện overdue
2. `level_2`: hiển thị banner nổi bật trong app khi overdue vượt ngưỡng nhẹ
3. `level_3`: gửi push khi overdue kéo dài nhiều ngày hoặc backlog tăng rõ rệt
4. `level_4`: đề xuất session ngắn ưu tiên xử lý backlog trước

### Dữ liệu cần có

- mức escalation hiện tại
- số item overdue
- số ngày overdue cao nhất hoặc trung bình
- session được đề xuất để giảm backlog

### Kênh hiển thị

- badge
- banner
- push
- session recommendation

## 5. Weekly digest

Đây là reminder tổng hợp theo tuần.

### Mục tiêu

- cho người dùng thấy tiến độ học dài hạn
- tạo cảm giác kiểm soát và duy trì nhịp học

### Rule kích hoạt

Reminder này được kích hoạt theo lịch cố định hằng tuần khi có dữ liệu học tập đủ để tổng hợp.

Có thể bỏ qua digest trong tuần nếu:

- người dùng không có hoạt động học nào
- không có item due, overdue hoặc thay đổi box đáng kể

### Dữ liệu cần có

- số item đã ôn trong tuần
- số item được tăng box
- số item bị lùi box
- số item còn overdue
- khuyến nghị mức độ học cho tuần kế tiếp

### Kênh hiển thị

- inbox trong app
- push summary
- email summary nếu sản phẩm hỗ trợ

## Nguyên tắc quyết định reminder

Backend phải quyết định:

- có sinh reminder hay không
- sinh reminder loại nào
- reminder nào được ưu tiên nếu có nhiều loại cùng lúc
- session nào sẽ được mở khi người dùng tương tác
- reminder nào chỉ hiển thị trong app và reminder nào được phép đẩy ra ngoài app

Frontend chỉ nên:

- render đúng loại reminder đã được backend chuẩn hóa
- hiển thị badge, banner, push hoặc digest
- điều hướng vào session đúng theo recommendation
