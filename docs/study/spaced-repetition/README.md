# Spaced Repetition Overview

Phần này mô tả lớp `spaced repetition` của study theo mô hình 7 ô.

Lớp này chịu trách nhiệm:

- quyết định item nào cần ôn
- xếp item vào box phù hợp
- tính lịch ôn tiếp theo
- sinh due queue và reminder
- nối review outcome từ study session vào trạng thái học dài hạn

## Tài liệu con

- [7-Box Model](/D:/workspace/lumos/docs/study/spaced-repetition/7-box-model.md)
- [Review Policy](/D:/workspace/lumos/docs/study/spaced-repetition/review-policy.md)
- [Reminder](/D:/workspace/lumos/docs/study/spaced-repetition/reminder.md)
- [Reminder Strategies](/D:/workspace/lumos/docs/study/spaced-repetition/reminder-strategies.md)
- [Resume And Analytics](/D:/workspace/lumos/docs/study/spaced-repetition/resume-and-analytics.md)

## Quy tắc sản phẩm

- lần đầu user học nội dung qua đầy đủ 5 mode
- từ các lần ôn tập tiếp theo, item đến hạn chỉ được ôn bằng `fill`
- review outcome chuẩn chỉ còn `passed` và `failed`
