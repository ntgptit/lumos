# Study Modes

## Mục tiêu

Phần này mô tả cách vận hành 5 mode học theo UI wireframe và product flow chuẩn.

Mode plan chuẩn:

- `first-learning session`: `review -> match -> guess -> recall -> fill`
- `review session`: chỉ dùng `fill`

Quy ước outcome:

- `passed`: user nhớ được
- `failed`: user cần học lại

Không dùng outcome trung gian như `revealed_without_pass`.
Các action như `revealAnswer`, `show`, `help` hoặc nghe audio chỉ là hành vi hỗ trợ UI hoặc hỗ trợ học, không tự tạo review outcome.

## 1. Review / Xem lại

### Mục tiêu

Giúp user nhìn lại đầy đủ term và meaning để làm quen nội dung trước khi chuyển sang các mode chủ động hơn.

### UI

- một card hiển thị mặt nghĩa hoặc giải thích
- một card hiển thị term chính
- có thể có icon text to speech ở từng card nếu policy cho phép

### Cách thực hiện

- user xem cả hai mặt của item
- user có thể nghe lại nội dung để làm quen phát âm
- sau khi xem xong, user phải tự đánh giá:
- nhớ được -> `passed`
- cần học lại -> `failed`

Review là mode nhận biết và làm quen, chưa buộc user phải tự gõ đáp án.

## 2. Match / Ghép đôi

### Mục tiêu

Giúp user liên kết đúng giữa term và meaning qua thao tác ghép cặp.

### UI

- màn hình hiển thị nhiều ô theo dạng lưới 2 cột
- một phía là term
- một phía là meaning hoặc prompt tương ứng

### Cách thực hiện

- user chọn một ô ở cột này và một ô ở cột còn lại để tạo thành cặp
- cặp đúng được đánh dấu là đã ghép
- cặp sai được xem là lỗi học của item hiện tại
- kết quả chuẩn hóa:
- ghép đúng -> `passed`
- ghép sai -> `failed`

Match là mode liên kết nhận diện nhanh, giúp tạo kết nối ban đầu giữa hai mặt thông tin.

## 3. Guess / Đoán

### Mục tiêu

Cho user nhìn một prompt và chọn ra đáp án đúng trong nhiều lựa chọn.

### UI

- một card lớn hiển thị prompt chính
- một danh sách các lựa chọn bên dưới
- có thể có text to speech cho prompt hoặc choice nếu policy cho phép

### Cách thực hiện

- user đọc hoặc nghe prompt
- user chọn một đáp án trong danh sách
- chọn đúng -> `passed`
- chọn sai -> `failed`

Guess tăng mức chủ động hơn match vì user phải nhận diện đáp án đúng từ nhiều khả năng.

## 4. Recall / Nhớ lại

### Mục tiêu

Buộc user tự nhớ đáp án trước khi được xem lời giải.

### UI

Mode này có 2 trạng thái:

- trước khi hiện đáp án: chỉ thấy prompt và vùng đáp án đang bị ẩn
- sau khi hiện đáp án: thấy lời giải và các nút tự đánh giá

### Cách thực hiện

- user nhìn prompt và tự nhớ đáp án trong đầu
- nếu cần, user bấm `Hiển thị` để xem đáp án
- sau khi xem, user bắt buộc chọn một trong hai kết quả:
- `Nhớ được` -> `passed`
- `Cần học lại` hoặc `Đã quên` -> `failed`

Action `Hiển thị` chỉ giúp lộ đáp án để user tự đánh giá, không phải là một outcome riêng.

## 5. Fill / Điền

### Mục tiêu

Kiểm tra active recall mạnh nhất bằng cách buộc user tự nhập đáp án.

### UI

- một card hiển thị prompt hoặc meaning
- một vùng nhập đáp án
- nút `Trợ giúp`
- nút `Kiểm tra`

### Cách thực hiện

- user đọc prompt
- user tự điền đáp án
- bấm `Kiểm tra` để submit
- điền đúng -> `passed`
- điền sai -> `failed`

`Trợ giúp` là hành vi hỗ trợ học:

- có thể gợi ý hoặc hỗ trợ nhìn lại đáp án theo policy sản phẩm
- không tự chốt outcome
- item chỉ có outcome khi user thực sự hoàn tất bước kiểm tra

Fill có hai vai trò:

- mode cuối của `first-learning session`
- mode duy nhất của `review session`
