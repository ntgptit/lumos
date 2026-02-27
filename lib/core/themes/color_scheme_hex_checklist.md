# Color Scheme Hex Checklist (Material Design 3)

Mục tiêu: chọn seed color và các màu override trong `color_schemes.dart` một cách nhất quán, để theme đẹp và đảm bảo khả năng tiếp cận (accessibility).

## 1. Nguyên tắc cơ bản về màu sắc trong Material Design 3

- Màu chủ đạo (seed color): là màu trung tâm, hệ thống tự động sinh bảng màu `primary`, `secondary`, `tertiary`, `error`, `neutral`, `neutral variant` theo tonal palette.
- Tương phản (contrast): mỗi cặp màu cần đạt ngưỡng WCAG tối thiểu.
  - `4.5:1` cho text nhỏ (dưới 18pt hoặc 14pt đậm).
  - `3:1` cho text lớn và thành phần giao diện (icon, button border...).
- Khả năng tiếp cận (accessibility): màu sắc phải dễ đọc với nhiều nhóm người dùng, bao gồm người khiếm thị màu.
- Ưu tiên để Material 3 tự sinh `secondary`, `tertiary`, `neutral`, `error`.
- Chỉ `copyWith` khi cần nhận diện thương hiệu rõ hơn.

## 2. Quy trình chọn seed color (mã hex)

- [ ] Xác định màu thương hiệu:
  - Nếu app có logo/brand, bắt đầu từ màu chính của logo.
- [ ] Kiểm tra seed color bằng Material Theme Builder:
  - Truy cập: <https://m3.material.io/theme-builder> (hoặc Figma plugin).
  - Nhập mã hex của seed color.
  - Xem bảng màu được sinh ra: primary, secondary, tertiary, neutral...
  - Kiểm tra các cặp contrast warning được gợi ý trong công cụ.
- [ ] Điều chỉnh seed color nếu cần:
  - Nếu primary quá tối/quá sáng dẫn đến `onPrimary` không đủ contrast:
    - Dịch hue (ví dụ: xanh sang xanh lá) trong cùng nhóm nhận diện.
    - Điều chỉnh lightness để đạt contrast nhưng vẫn giữ tone.
  - Dùng Contrast Checker để check nhanh cặp màu cụ thể:
    - <https://coolors.co/contrast-checker>
- [ ] Xem xét ý nghĩa văn hóa:
  - Nếu app hướng thị trường quốc tế, tránh các màu dễ gây hiểu sai ý nghĩa.

## 3. Tùy chỉnh các màu phụ (secondary, tertiary, error)

- [ ] Để hệ thống tự sinh:
  - Thông thường chỉ cần seed color; secondary/tertiary/error được Material 3 sinh tự động và hài hòa.
- [ ] Nếu cần tùy chỉnh thủ công:
  - Dùng `ColorScheme.fromSeed(...).copyWith(secondary: ..., tertiary: ...)`.
  - Kiểm tra contrast của `secondary/onSecondary`.
  - Kiểm tra contrast của `secondary` trên các nền hay dùng như `surface` và `background`.
  - Đảm bảo màu vẫn nằm trong tonal palette phù hợp, không quá chói hoặc lạc tông.
- [ ] Màu error:
  - Ưu tiên giữ mặc định Material để bảo toàn tính nhận diện lỗi.
  - Nếu tùy chỉnh, vẫn phải đảm bảo độ nổi bật và contrast.
  - Màu tham khảo thường thấy: `#FFB4A9` (light/dark), nhưng nên xem là thông số đối chiếu, không phải ràng buộc.

## 4. Contrast tối thiểu (WCAG)

- Text nhỏ: tỷ lệ tối thiểu `4.5:1`.
- Text lớn và UI controls: tỷ lệ tối thiểu `3:1`.
- Cặp màu cần ưu tiên check:
  - `onPrimary` / `primary`
  - `onSurface` / `surface`
  - `onSecondaryContainer` / `secondaryContainer`
  - `outline` / `surface`

## 5. Quy tắc dark mode

- [ ] Không đảo ngược màu đơn giản:
  - Dark mode không phải light mode với nền đen.
  - Material 3 sinh dark mode từ cùng seed color, với tone tối hơn và giảm độ bão hòa.
- [ ] Kiểm tra tương phản trong dark mode:
  - Đảm bảo text trên nền tối vẫn đủ contrast (`onPrimary`, `onSurface` thường sáng hơn).
  - Dùng Theme Builder để xem trước đồng thời light và dark.
- [ ] Điều chỉnh riêng cho dark nếu cần:
  - Định nghĩa `darkColorScheme` bằng `ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark)`.
  - Nếu cần, `copyWith` một số màu cho phù hợp ngữ cảnh sử dụng thực tế.

## 6. Quy tắc code

- Không hard-code màu hex trong widget.
- Tất cả màu UI phải đi qua `Theme.of(context).colorScheme`.
- `color_schemes.dart` là nơi duy nhất chứa quyết định seed/override màu.

## 7. Các công cụ hỗ trợ chọn mã hex

- [ ] Material Theme Builder (web):
  - Trực quan, cho phép xem palette Material 3 và tải về theme Flutter.
  - <https://m3.material.io/theme-builder>
- [ ] Figma plugin "Material Theme Builder":
  - Tạo và đối chiếu theme ngay trong file design.
- [ ] Contrast Checker:
  - WebAIM: <https://webaim.org/resources/contrastchecker/>
  - Coolors: <https://coolors.co/contrast-checker>
- [ ] Adobe Color:
  - Tham khảo bộ màu hài hòa và kiểm tra contrast.
  - <https://color.adobe.com/>
- [ ] Color Hunt:
  - Tham khảo các palette màu phổ biến.
  - <https://colorhunt.co/>

## 8. Kiểm tra và xác nhận cuối cùng

- [ ] Chạy thử với seed color đã chọn trên thiết bị thật:
  - Kiểm tra cả light mode và dark mode.
- [ ] Kiểm tra các màn hình chính:
  - Text có dễ đọc hay không.
  - Nút bấm có nổi bật và đủ contrast hay không.
  - Trạng thái hover/press có hiệu ứng rõ ràng hay không.
- [ ] Điều chỉnh nếu phát hiện vấn đề contrast:
  - Ví dụ text xám trên nền xám nhạt.
  - Ưu tiên điều chỉnh qua `ColorScheme` và `copyWith` trong `color_schemes.dart`.

## 9. Lưu ý quan trọng

- Không hard-code màu hex trong widget:
  - Luôn sử dụng `Theme.of(context).colorScheme`.
- Tránh dùng quá nhiều màu:
  - Material 3 khuyến khích 5 vai trò chính: `primary`, `secondary`, `tertiary`, `error`, `neutral`.
  - Các biến thể còn lại nên để hệ thống sinh tự động từ seed color.
- Không bỏ qua neutral colors:
  - `surface`, `background`, `onSurface` rất quan trọng cho khả năng đọc và bố cục thị giác.
  - Các màu neutral cũng được sinh từ seed, cần được kiểm tra như nhóm màu chính.
