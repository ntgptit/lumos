# Feature Architecture Checklist (Flutter + Riverpod)

Checklist này là chuẩn bắt buộc cho tất cả feature mới trong `lib/presentation/features/*`.

## 1. Folder Structure (Bắt buộc)

Mỗi feature phải theo template:

```text
lib/
  presentation/
    features/
      <feature_name>/
        providers/
          <feature>_provider.dart
          <feature>_provider.g.dart
          states/
            <feature>_state.dart
            <feature>_state.freezed.dart
        screens/
          <feature>_screen.dart
          <feature>_content.dart
          widgets/
            blocks/
            dialogs/
            states/
```

## 2. Responsibility Split (Bắt buộc)

- `providers/`: chứa toàn bộ điều phối state, nghiệp vụ màn hình, gọi repository/use case qua DI.
- `providers/states/`: chứa model state bằng Freezed, immutable, có computed getter cho dữ liệu hiển thị.
- `screens/<feature>_screen.dart`: chỉ quản lý `AsyncValue` flow (`loading/data/error`) và wiring cấp màn hình.
- `screens/<feature>_content.dart`: chỉ layout/composition UI, không xử lý nghiệp vụ.
- `screens/widgets/blocks`: widget khối UI tái sử dụng trong feature.
- `screens/widgets/dialogs`: dialog/prompt của feature.
- `screens/widgets/states`: empty/failure/error/skeleton/overlay UI state.

## 3. Riverpod + DI Contract (Bắt buộc)

- Dùng `@Riverpod` annotation, không khai báo provider thủ công khi không cần.
- Provider layer inject dependency qua `ref.read(...)`, không tạo dependency trực tiếp bằng `new`.
- Không dùng `setState` cho business state.
- UI chỉ gọi action của provider (`create`, `update`, `delete`, `refresh`...), không chứa luồng nghiệp vụ.
- Bắt buộc dùng DI cho tab/page mapping nếu feature có nhiều tab hoặc nhiều sub-page:
  - Không hardcode `if/switch` dựng page trực tiếp trong `Screen`.
  - Tạo provider chuyên trách (ví dụ `featureTabPageProvider(index)`), `Screen` chỉ watch và render.
- Điều hướng theo trạng thái phải được điều phối từ provider (hoặc derived provider), không để `Screen` nắm business mapping.

## 3.1 Fine-grained Subscriptions (Bắt buộc)

- Không watch toàn bộ state ở widget gốc nếu chỉ cần 1 phần dữ liệu.
- Chỉ watch đúng thuộc tính cần dùng bằng derived provider.
- Tách các vùng UI theo trách nhiệm để giảm rebuild:
  - `AppBar` watch title.
  - `BottomNavigation` watch selected index.
  - `Body` watch page/current transition data.
- Mọi derived state cho UI (`selectedIndex`, `title`, `visibleItems`, `currentPage`) phải có provider riêng, không tính toán ad-hoc trong widget lớn.

## 4. UI/Logic Boundary (Bắt buộc)

- Không để logic nghiệp vụ trong widget:
  - không call repository trực tiếp trong screen/content/widget.
  - không xử lý state transition trong widget.
- Logic dẫn xuất dữ liệu (filter/sort/group/map cho hiển thị) phải đặt trong state/provider.
- Widget chỉ render dữ liệu đã chuẩn bị sẵn từ state.

## 5. State Rules (Bắt buộc)

- State dùng Freezed (`@freezed`) và immutable.
- State phải có đầy đủ status cho UI:
  - async status qua `AsyncValue` ở screen/provider.
  - mutation status (ví dụ `none/creating/updating/deleting`) trong state để overlay/banner tự lắng nghe.
- Tránh constructor state quá nhiều tham số:
  - gom nhóm bằng sub-state (ví dụ `TreeState`, `FilterState`) khi cần.

## 6. Widget Rules (Bắt buộc)

- Ưu tiên shared widget trong `lib/presentation/shared/widgets`.
- Không dùng raw Material widget nếu đã có wrapper tương ứng.
- `common/widgets` chỉ render-only: không điều hướng, không throw exception, không chứa feature widget.

## 7. Self-check Trước Khi Tạo PR

- [ ] Cấu trúc thư mục đúng template mục 1.
- [ ] `screen` chỉ xử lý async flow.
- [ ] `content` chỉ layout/render.
- [ ] Toàn bộ nghiệp vụ nằm ở `providers/`.
- [ ] State Freezed và có mutation status nếu feature có thao tác ghi.
- [ ] Không có repository call trong UI layer.
- [ ] Không hardcode tab/page mapping trong `Screen`; đã DI qua provider.
- [ ] Đã tách fine-grained subscriptions (không watch toàn bộ state ở root widget).
- [ ] Đã dùng shared widgets thay vì raw Material widgets.
- [ ] Pass các guard bắt buộc:
  - `dart run tool/verify_riverpod_annotation.dart`
  - `dart run tool/verify_state_management_contract.dart`
  - `dart run tool/verify_common_widget_boundaries.dart`
  - `dart run tool/verify_common_widget_usage_contract.dart`
  - `flutter analyze`
  - `flutter test`

## 8. Non-compliance Policy

- Vi phạm bất kỳ mục bắt buộc nào ở trên: không merge.
- Nếu cần ngoại lệ kiến trúc: phải được review và thống nhất trước khi implement.
