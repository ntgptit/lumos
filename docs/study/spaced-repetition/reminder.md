# Reminder

## Vai trò

Reminder là đầu ra của trạng thái spaced repetition.

Reminder không phải là một tính năng độc lập theo màn hình, mà là kết quả của:

- `DueQueue`
- `ReminderPlan`
- `SchedulePolicy`

## Điều kiện tạo reminder

Một reminder được sinh khi:

- có item `due`
- có item `overdue`
- có target học trong ngày chưa hoàn thành

Reminder dựa trên:

- `DueQueue`
- `ReminderPlan`

Khi reminder mở phiên ôn tập, session được tạo theo mode `fill`.

## Nội dung reminder

Reminder nên trả lời được:

- hôm nay có bao nhiêu item cần học
- có bao nhiêu item quá hạn
- session được đề xuất là gì
- ưu tiên học deck nào hoặc nhóm nội dung nào

## Quy tắc ưu tiên

Khi tạo queue ôn tập, backend nên ưu tiên:

1. item overdue
2. item ở box thấp hơn
3. item due hôm nay
4. item mới

Nguyên tắc:

- học lại những thứ dễ quên trước
- giải quyết backlog trước

## Chiến lược reminder

Hệ thống hỗ trợ 5 nhóm reminder chính:

1. `In-app badge + due list`
2. `Daily push reminder`
3. `Due-based session recommendation`
4. `Overdue escalation`
5. `Weekly digest`

Chi tiết loại reminder và rule kích hoạt của từng loại được mô tả tại [reminder-strategies.md](/D:/workspace/learnwise/docs/study/spaced-repetition/reminder-strategies.md).

## Nguyên tắc thực thi

Backend là nơi quyết định:

- có cần tạo reminder hay không
- reminder thuộc loại nào
- thời điểm reminder được kích hoạt
- session nào được đề xuất
- deck hoặc nhóm nội dung nào cần ưu tiên

Frontend chỉ nên:

- render badge, banner, danh sách hoặc thông điệp nhắc học
- hiển thị push theo dữ liệu đã được backend chuẩn hóa
- mở đúng session khi người dùng tương tác với reminder
