# 7-Box Spaced Repetition Model

## Vai trò trong hệ thống

Lớp 7 ô không thay thế study session.

Nó quyết định:

- item nào cần học
- item đang ở mức ghi nhớ nào
- thời điểm ôn tiếp theo
- due item, overdue item
- loại review session cần mở

Study session vẫn là nơi thực hiện việc học.

## Domain model

### LearningCardState

Trạng thái học tập của một item đối với một user.

Nó cần chứa tối thiểu:

- `user_id`
- `content_id` hoặc `flashcard_id`
- `box_index`
- `last_reviewed_at`
- `next_review_at`
- `last_result`
- `consecutive_success_count`
- `lapse_count`
- `is_due`

### SrsBox

Hệ thống dùng 7 box:

1. `box_1`
2. `box_2`
3. `box_3`
4. `box_4`
5. `box_5`
6. `box_6`
7. `box_7`

Một cấu hình mặc định đề xuất:

| Ô | Ý nghĩa | Khoảng ôn mặc định |
|---|---|---|
| 1 | mới học hoặc vừa quên | ngay trong ngày |
| 2 | nhớ bước đầu | 1 ngày |
| 3 | nhớ ngắn hạn ổn | 3 ngày |
| 4 | nhớ tương đối chắc | 7 ngày |
| 5 | nhớ tốt | 14 ngày |
| 6 | nhớ rất tốt | 30 ngày |
| 7 | ghi nhớ duy trì | 60 ngày |

### ReviewOutcome

Kết quả chuẩn hóa mà study session trả về cho lớp spaced repetition.

Tối thiểu gồm:

- `passed`
- `failed`

### DueQueue

Tập item đã đến hạn hoặc quá hạn.

Dùng để:

- tạo reminder
- tạo study session
- ưu tiên item cần ôn

### ReminderPlan

Kế hoạch nhắc học cho user trong một mốc thời gian nhất định.

### ReviewHistory

Event log của hành vi ôn tập.

### SchedulePolicy

Policy tính:

- box tăng hay giảm thế nào
- khoảng cách giữa các box
- lúc nào item được coi là due
- cách ưu tiên item trong queue
- loại review session nào sẽ được tạo

## Quan hệ với study session

Backend quyết định:

- item mới hoặc nội dung chưa qua giai đoạn học đầu -> tạo `first-learning session`
- item đã có learning state và đến hạn ôn -> tạo `fill review session`

Mode plan chuẩn:

- `first-learning session`: `review -> match -> guess -> recall -> fill`
- `review session`: `fill`
