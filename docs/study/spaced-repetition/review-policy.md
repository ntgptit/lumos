# Review Policy

## Giai đoạn học

Study được chia thành hai giai đoạn:

- `initial learning`
- `spaced review`

Trong đó:

- `initial learning` dùng đủ 5 mode để hình thành trí nhớ ban đầu
- `spaced review` chỉ dùng `fill` để kiểm tra recall chủ động

## Luật di chuyển giữa các box

### Item mới

Một item mới được đưa vào:

- `box_1`

với:

- `last_reviewed_at = null`
- `next_review_at = now`

### Outcome là passed

- item tăng lên box tiếp theo
- nếu đang ở `box_7` thì giữ ở `box_7`
- `next_review_at` được tính theo policy của box mới

### Outcome là failed

- item lùi về 1 box
- nếu đang ở `box_1` thì giữ ở `box_1`
- `lapse_count` tăng
- `next_review_at = now` hoặc một khoảng ngắn theo policy

Ví dụ:

- `box_7 -> box_6`
- `box_6 -> box_5`
- `box_3 -> box_2`
- `box_1 -> box_1`

### Outcome là revealed_without_pass

- item không tăng box
- item giữ nguyên box hiện tại
- `next_review_at` có thể ngắn hơn tùy policy

### Outcome là skipped

- không thay đổi box
- không thay đổi progress học thuật chính

## Chuẩn hóa outcome từ các mode

### Review

- nhớ -> `passed`
- cần học lại -> `failed`
- chỉ xem mà không đánh giá -> `revealed_without_pass`

Review mode thuộc `initial learning`.

### Guess

- chọn đúng -> `passed`
- chọn sai -> `failed`

Guess mode thuộc `initial learning`.

### Recall

- `markRemembered` -> `passed`
- `markForgotten` -> `failed`
- reveal nhưng chưa xác nhận -> `revealed_without_pass`

Recall mode thuộc `initial learning`.

### Fill

- điền đúng -> `passed`
- điền sai -> `failed`
- chỉ hiện đáp án gợi ý nhưng chưa đạt -> `revealed_without_pass`

Fill mode có hai vai trò:

- mode cuối của `initial learning`
- mode duy nhất của `spaced review`

### Match

- cặp đúng -> `passed`
- cặp sai -> `failed`

Match mode thuộc `initial learning`.
