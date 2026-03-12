# Resume And Analytics

## Progress dài hạn

Backend cần theo dõi tối thiểu:

- tổng số item đã học
- tổng số item đang due
- tổng số item overdue
- phân bố item theo 7 box
- tỉ lệ pass / fail theo thời gian

Ngoài ra nên tách rõ:

- progress của giai đoạn học đầu
- progress của giai đoạn ôn tập bằng `fill`

## Resume

Khi user quay lại, hệ thống phải khôi phục được:

- item đang due
- item nào đã được học trong session trước
- state box hiện tại
- `next_review_at`
- kế hoạch nhắc học hiện hành
- loại session cần mở: full learning hay fill review

Resume ở đây không chỉ là resume session, mà còn là resume trạng thái học tập dài hạn của user.

## Audit và analytics

Event log của lớp 7 ô cần đủ để trả lời:

- item nào vừa tăng box
- item nào vừa bị lùi box
- item nào thất bại lặp lại nhiều lần
- mode nào tạo ra nhiều fail nhất
- khoảng cách ôn nào đang hiệu quả

Điều này giúp hệ thống:

- tối ưu reminder
- điều chỉnh schedule policy
- đánh giá hiệu quả từng mode học
