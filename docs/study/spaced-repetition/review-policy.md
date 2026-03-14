# Review Policy

## Giai đoạn học

Study được chia thành hai giai đoạn:

- `initial learning`
- `spaced review`

Trong đó:

- `initial learning` dùng đủ 5 mode để hình thành trí nhớ ban đầu
- `spaced review` chỉ dùng `fill` để kiểm tra recall chủ động

Quy ước outcome chung:

- `passed`: user nhớ được
- `failed`: user cần học lại

Không dùng outcome phụ như `revealed_without_pass` hoặc `skipped`.
Các action hỗ trợ như reveal, help hoặc nghe audio không tự tạo review outcome.

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

## Chuẩn hóa outcome từ các mode

### Review

- nhớ -> `passed`
- cần học lại -> `failed`

Review mode thuộc `initial learning`.

### Guess

- chọn đúng -> `passed`
- chọn sai -> `failed`

Guess mode thuộc `initial learning`.

### Recall

- sau khi user tự đánh giá là nhớ được -> `passed`
- sau khi user tự đánh giá là cần học lại -> `failed`

Recall mode thuộc `initial learning`.

### Fill

- điền đúng -> `passed`
- điền sai -> `failed`

Fill mode có hai vai trò:

- mode cuối của `initial learning`
- mode duy nhất của `spaced review`

### Match

- cặp đúng -> `passed`
- cặp sai -> `failed`

Match mode thuộc `initial learning`.
