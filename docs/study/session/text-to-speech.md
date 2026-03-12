# Text To Speech In Study

## Mục tiêu

Text to speech là một capability hỗ trợ việc học trong study session.

Capability này cho phép hệ thống:

- đọc nội dung học bằng giọng nói
- hỗ trợ luyện nghe và ghi nhớ phát âm
- hỗ trợ accessibility cho người dùng không thuận tiện đọc chữ trên màn hình
- tạo trải nghiệm học liền mạch trong từng mode

Text to speech không thay thế flow học chính. Đây là một lớp hỗ trợ được gắn vào session và item hiện tại.

## Phạm vi sản phẩm hiện tại

Ở giai đoạn hiện tại, text to speech chỉ hỗ trợ:

- tiếng Hàn

Người dùng có thể chỉnh cấu hình text to speech tại:

- màn hình `Profile`
- thuộc luồng `bottom navigation`

Profile là nơi người dùng bật, tắt hoặc điều chỉnh các thiết lập text to speech ở cấp tài khoản. Study session chỉ đọc và áp dụng cấu hình đó trong lúc học.

## Phạm vi áp dụng

Text to speech có thể được dùng trong cả 5 mode:

1. `review`
2. `match`
3. `guess`
4. `recall`
5. `fill`

Vai trò của text to speech trong từng mode:

- `review`: đọc mặt trước, mặt sau hoặc ví dụ để user làm quen nội dung
- `match`: đọc prompt hoặc item được focus để hỗ trợ ghép đúng cặp
- `guess`: đọc câu hỏi hoặc lựa chọn cần nghe
- `recall`: đọc prompt để user tự nhớ lại đáp án
- `fill`: đọc câu hỏi, cụm từ hoặc đáp án mẫu để user kiểm tra trí nhớ và phát âm

## Nguyên tắc sản phẩm

Text to speech là một capability cấp session nhưng được kích hoạt trên từng item.

Hệ thống cần hỗ trợ:

- phát audio cho item hiện tại
- phát lại audio nhiều lần
- tự động phát nếu session policy cho phép
- ghi nhận user đã nghe hay chưa nếu dữ liệu đó có giá trị nghiệp vụ

Text to speech phải hoạt động nhất quán giữa:

- `first-learning session`
- `review session`

Trong `review session`, text to speech hỗ trợ trực tiếp cho phiên `fill`.

## Domain model

### SpeechContent

Nội dung text được phép đem đi phát audio trong một item học.

SpeechContent có thể gồm:

- term
- definition
- example sentence
- hint
- answer explanation

### SpeechAsset

Đại diện cho audio có thể được phát trong study session.

SpeechAsset có thể đến từ:

- file audio đã tồn tại sẵn
- audio được generate trước
- audio được generate theo yêu cầu

SpeechAsset cần mô tả được:

- `asset_id`
- `item_id`
- `locale`
- `voice`
- `source_type`
- `audio_url` hoặc reference tương đương
- `duration_ms`

Ở giai đoạn hiện tại, `locale` được chốt là `ko-KR`.

### SpeechPolicy

Policy quyết định item nào được phép phát audio và phát theo cách nào.

SpeechPolicy cần mô tả được:

- field nào được đọc
- có auto-play hay không
- có cho phép replay hay không
- có giới hạn số lần phát trong một session hay không
- mode nào được phép dùng text to speech

### SpeechPreference

Cấu hình text to speech ở cấp người dùng.

SpeechPreference được quản lý từ màn hình `Profile` và cần mô tả được:

- text to speech đang bật hay tắt
- voice hiện hành cho tiếng Hàn
- có auto-play hay không
- tốc độ phát nếu sản phẩm hỗ trợ

Study session không sở hữu preference này, mà chỉ tiêu thụ preference đã được backend trả về.

### SpeechEvent

Log các hành vi nghe có giá trị nghiệp vụ.

Ví dụ:

- `speech_requested`
- `speech_started`
- `speech_completed`
- `speech_replayed`
- `speech_failed`

SpeechEvent chỉ nên được lưu nếu team muốn dùng cho analytics, accessibility insight hoặc learning insight.

## Phân chia trách nhiệm

### Backend

Backend sở hữu:

- metadata của `SpeechAsset`
- `SpeechPolicy` theo ngôn ngữ, deck, mode hoặc item type
- `SpeechPreference` ở cấp người dùng
- quyền được phát audio cho item hiện tại
- trạng thái canonical về việc item hiện tại có speech capability hay không
- event log nếu hành vi nghe cần được lưu

Backend trả về cùng canonical session state:

- item hiện tại có audio hay không
- field nào được phép phát
- URL hoặc reference của audio nếu đã sẵn sàng
- action nào được phép như `play_speech` hoặc `replay_speech`
- preference hiện hành cần áp dụng trong session nếu cần cho render

### Frontend

Frontend sở hữu:

- player state cục bộ
- loading audio
- buffering
- play / pause / replay interaction
- animation, waveform, progress bar, caption highlight
- xử lý audio focus và interruption từ thiết bị
- màn hình `Profile` trong `bottom navigation` để user chỉnh text to speech setting

Frontend không quyết định:

- item nào được phép có text to speech
- field nào được phép đọc
- playback nào có giá trị nghiệp vụ cần lưu
- locale hỗ trợ ở giai đoạn hiện tại

## Luồng nghiệp vụ

### 1. Session được tạo

Khi backend tạo `StudySession`, hệ thống đồng thời xác định speech capability cho từng item hoặc cho item hiện tại.

Canonical state cần cho biết:

- item hiện tại có speech hay không
- audio đã sẵn sàng hay chưa
- policy phát audio của item hiện tại
- user preference cần áp dụng cho playback tiếng Hàn

### 2. Frontend render item hiện tại

Frontend đọc canonical state và hiển thị nút nghe tương ứng.

Nếu policy cho phép auto-play, frontend có thể tự phát sau khi item đã render ổn định.

Nếu user đã tắt text to speech từ `Profile`, frontend không tự phát và có thể ẩn hoặc disable các hành vi liên quan theo policy sản phẩm.

### 3. User yêu cầu phát audio

Khi user bấm nghe:

- frontend bắt đầu luồng playback
- nếu cần ghi nhận nghiệp vụ, frontend gửi command hoặc event về backend
- backend cập nhật event log nếu policy yêu cầu

### 4. Audio hoàn thành

Khi audio phát xong:

- frontend cập nhật local player state
- nếu completion của audio có giá trị nghiệp vụ, backend nhận `speech_completed`

### 5. User tiếp tục học

Playback không được làm thay đổi progress học tập nếu completion policy không yêu cầu.

Progress của session vẫn phải được quyết định bởi các command học chính như:

- `submitAnswer`
- `revealAnswer`
- `markRemembered`
- `goNext`

## Quan hệ với progress và completion

Mặc định, text to speech là capability hỗ trợ chứ không phải điều kiện hoàn thành item.

Hệ thống có thể cấu hình:

- audio chỉ là hỗ trợ giao diện
- hoặc audio là một phần của learning evidence trong một số loại nội dung đặc biệt

Nếu audio được tính là learning evidence, policy đó phải do backend chốt rõ và trả về trong canonical state.

## Resume

Khi user quay lại session, hệ thống cần khôi phục được:

- item hiện tại có speech capability hay không
- audio nào gắn với item hiện tại
- policy hiện hành của audio
- user preference hiện hành cho tiếng Hàn

Frontend chỉ cần khôi phục UI player state ở mức cần thiết.

Hệ thống không cần resume lại chính xác vị trí đang phát dở trừ khi sản phẩm muốn hỗ trợ media resume như một capability riêng.

## Analytics

Nếu speech event được lưu, analytics có thể trả lời được:

- item nào được nghe nhiều nhất
- mode nào dùng text to speech nhiều nhất
- user có dùng replay thường xuyên hay không
- completion rate có thay đổi khi item có audio hay không

Analytics của text to speech không được thay thế analytics học tập cốt lõi. Đây là lớp dữ liệu bổ sung.

## Nguyên tắc thiết kế

- text to speech là capability của study session, không phải một mode học riêng
- phạm vi hiện tại chỉ hỗ trợ tiếng Hàn
- cấu hình text to speech được chỉnh tại `Profile` trong `bottom navigation`
- backend quyết định canonical speech capability
- frontend quyết định trải nghiệm playback
- speech event chỉ lưu khi thật sự có giá trị nghiệp vụ hoặc phân tích
- playback không được làm rối flow học chính
