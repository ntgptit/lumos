# Frontend Guard Rule Inventory

## Mục tiêu tài liệu

Tài liệu này mô tả các quy tắc kiểm soát chất lượng mà thư mục `tool/` đang áp dụng cho frontend Flutter của repo `lumos`.

Mục tiêu của bộ guard không phải để mô tả cách viết code chi tiết, mà để làm rõ:

- Hệ thống đang bảo vệ những chuẩn nghiệp vụ và chuẩn chất lượng nào.
- Mỗi guard đang ngăn loại rủi ro nào đối với sản phẩm.
- Guard nào đang được chạy mặc định trong luồng kiểm tra frontend.
- Guard nào là guard bổ sung, chỉ chạy khi được gọi riêng hoặc được CI cấu hình riêng.

## Phạm vi áp dụng

- Phạm vi chính: frontend Flutter trong `lib/**`, `test/**`, `integration_test/**`, `coverage/**`, `tool/guards/**`.
- Bộ guard mặc định đang được gọi qua `tool/verify_frontend_checklists.dart`.
- Ngoài bộ mặc định, trong `tool/guards/` còn có các guard bổ sung cho kiểm thử, coverage, cấu trúc feature, accessibility và tính đồng bộ CI.

## Nguyên tắc đọc tài liệu này

- Góc nhìn của tài liệu là góc nhìn BA và quản trị chất lượng.
- Mỗi guard được mô tả theo 4 ý:
  - Phạm vi kiểm soát.
  - Mục tiêu nghiệp vụ hoặc mục tiêu chất lượng.
  - Điều guard đang ngăn chặn.
  - Rủi ro nếu không kiểm soát.

## Nhóm A. Guard mặc định đang chạy qua `tool/verify_frontend_checklists.dart`

### A01. `riverpod-annotation`

**Công cụ**
- `tool/guards/verify_riverpod_annotation.dart`

**Phạm vi kiểm soát**
- Kiểm soát cách khai báo provider và cách quản lý lifecycle trong các file Riverpod.

**Mục tiêu nghiệp vụ**
- Bảo đảm toàn bộ phần quản lý trạng thái của ứng dụng đi theo một chuẩn duy nhất, dễ bảo trì, dễ mở rộng và dễ kiểm soát lỗi.

**Điều đang bị ngăn chặn**
- Không cho khai báo provider thủ công theo nhiều kiểu cũ.
- Không cho dùng `StateNotifier` hoặc `ChangeNotifier` trong vùng logic đã chuẩn hóa theo Riverpod Annotation.
- Không cho dùng `mounted` sai ngữ cảnh trong notifier.
- Ở chế độ strict, file có generated notifier phải có annotation chuẩn.

**Rủi ro nếu không kiểm soát**
- Cùng một nghiệp vụ có thể bị triển khai theo nhiều kiểu state management khác nhau.
- Tăng rủi ro lỗi lifecycle và lỗi bất đồng bộ.
- Khó onboarding và khó review do không còn một quy ước chung.

### A02. `state-management`

**Công cụ**
- `tool/guards/verify_state_management_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát cách màn hình và widget xử lý trạng thái, đặc biệt là `AsyncValue`.

**Mục tiêu nghiệp vụ**
- Bảo đảm các màn hình luôn biểu diễn đủ trạng thái dữ liệu: đang tải, thành công, lỗi.

**Điều đang bị ngăn chặn**
- Không cho dùng `setState()` làm kiến trúc chính.
- Không cho dùng `else` và `else if` theo triết lý fail-fast.
- Không cho đọc `AsyncValue` bằng các nhánh dễ bỏ sót trạng thái như `hasValue`, `requireValue`, `maybeWhen`, `maybeMap`.
- Bắt buộc các file state chuẩn phải có annotation Riverpod.
- Bắt buộc có `whenWithLoading` ở extension chuẩn.

**Rủi ro nếu không kiểm soát**
- Màn hình có thể thiếu trạng thái loading hoặc error.
- Logic UI dễ rẽ nhánh phức tạp và khó theo dõi.
- Dữ liệu bất đồng bộ bị xử lý không nhất quán giữa các màn hình.

### A03. `ui-logic-separation`

**Công cụ**
- `tool/guards/verify_ui_logic_separation_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát ranh giới giữa layer giao diện và layer dữ liệu hoặc nghiệp vụ.

**Mục tiêu nghiệp vụ**
- Bảo đảm UI chỉ làm nhiệm vụ hiển thị và điều hướng tương tác, không mang logic xử lý dữ liệu.

**Điều đang bị ngăn chặn**
- UI không được import trực tiếp data layer, repository, service, datasource, usecase, network client, `dart:io`, `dart:convert`.
- UI không được tự tạo provider, notifier, network client hay gọi HTTP trực tiếp.
- UI không được tự parse JSON.
- UI không được đọc trực tiếp provider cấp repository hoặc service.
- Mỗi file UI bị giới hạn cấu trúc để tránh nhồi nhiều widget và nhiều trách nhiệm vào một file.

**Rủi ro nếu không kiểm soát**
- Boundary kiến trúc bị vỡ.
- Widget trở thành nơi gánh cả logic hiển thị lẫn logic dữ liệu.
- Tăng chi phí sửa lỗi và tăng rủi ro side effect khi thay đổi UI.

### A04. `l10n-usage`

**Công cụ**
- `tool/guards/verify_l10n_usage_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát text hiển thị cho người dùng trong UI.

**Mục tiêu nghiệp vụ**
- Bảo đảm ứng dụng có thể hỗ trợ đa ngôn ngữ và thống nhất cách quản lý nội dung hiển thị.

**Điều đang bị ngăn chặn**
- Không cho hardcode text trong `Text`, `SelectableText`, `LumosText` và các property hiển thị phổ biến như label, hint, helper, tooltip, title, subtitle, message.

**Rủi ro nếu không kiểm soát**
- Khó dịch đa ngôn ngữ.
- Copywriting bị phân tán, không đồng bộ.
- Tăng rủi ro bỏ sót text khi thay đổi ngôn ngữ hoặc thay đổi wording.

### A05. `navigation`

**Công cụ**
- `tool/guards/verify_navigation_go_router_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát cách khai báo và sử dụng điều hướng trong ứng dụng.

**Mục tiêu nghiệp vụ**
- Bảo đảm điều hướng nhất quán, an toàn và dễ quản trị khi số lượng màn hình tăng lên.

**Điều đang bị ngăn chặn**
- Bắt buộc có `go_router`.
- Không cho dùng `Navigator`, `MaterialPageRoute`, `onGenerateRoute`.
- Không cho điều hướng bằng string path trực tiếp.
- Không cho truy cập `GoRouter.of(context)` trong luồng feature nếu làm lệch chuẩn typed routing.
- Không cho khai báo `GoRoute` ngoài vùng router chuẩn.

**Rủi ro nếu không kiểm soát**
- Route bị drift tên hoặc drift tham số.
- Tăng lỗi runtime do path sai.
- Khó kiểm soát sơ đồ điều hướng toàn hệ thống.

### A06. `opacity-contract`

**Công cụ**
- `tool/guards/verify_opacity_constants_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát token opacity dùng trong theme và UI.

**Mục tiêu nghiệp vụ**
- Bảo đảm trạng thái giao diện như disabled, hover, scrim, divider có độ nhất quán trên toàn hệ thống.

**Điều đang bị ngăn chặn**
- `AppOpacity` phải chứa đúng bộ token và đúng giá trị chuẩn.
- Không cho sinh thêm opacity constant ngoài danh sách chuẩn.
- Không cho khai báo opacity constant ở nơi khác.
- Không cho dùng opacity token ngoài phạm vi được quản lý.

**Rủi ro nếu không kiểm soát**
- Trạng thái UI bị lệch nhau giữa các màn hình.
- Overlay, disabled state, scrim và divider mất tính đồng nhất.
- Khó hiệu chỉnh visual system khi có thay đổi thiết kế.

### A07. `common-widget-boundaries`

**Công cụ**
- `tool/guards/verify_common_widget_boundaries.dart`

**Phạm vi kiểm soát**
- Kiểm soát ranh giới của widget dùng chung.

**Mục tiêu nghiệp vụ**
- Bảo đảm widget dùng chung thực sự là tài sản dùng chung của sản phẩm, không bị pha lẫn logic của từng feature.

**Điều đang bị ngăn chặn**
- Không cho đưa widget đặc thù feature vào thư mục common/shared widgets.
- Không cho common widget tự điều hướng.
- Không cho common widget tự `throw`.
- Chỉ cho phép `StatefulWidget` ở một số trường hợp UI-only đã được whitelist.
- Không cho common widget phụ thuộc repository, service, viewmodel hoặc feature.

**Rủi ro nếu không kiểm soát**
- Widget dùng chung trở thành widget nửa chung nửa riêng.
- Tái sử dụng kém.
- Shared layer bị ô nhiễm bởi logic feature, làm tăng chi phí thay đổi sau này.

### A08. `common-widget-usage`

**Công cụ**
- `tool/guards/verify_common_widget_usage_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát việc feature có dùng shared widget chuẩn hay dùng raw Material widget.

**Mục tiêu nghiệp vụ**
- Bảo đảm ứng dụng sử dụng cùng một hệ component về giao diện, hành vi và theme.

**Điều đang bị ngăn chặn**
- Ở ngoài shared widget folders và core themes, không được dùng trực tiếp nhiều raw Material widgets quan trọng như app bar, dialog, text field, button, icon button, FAB, popup menu, dropdown, radio list tile.
- Ở feature UI còn bị kiểm soát thêm `Icon`, `Text`, `ListTile`.
- Guard có baseline để chỉ chặn phát sinh mới nếu hệ thống đang còn debt cũ.

**Rủi ro nếu không kiểm soát**
- Mỗi feature tự dựng component riêng.
- Thiết kế và hành vi component bị phân mảnh.
- Rất khó chuẩn hóa UI khi số lượng màn hình tăng.

### A09. `ui-constants`

**Công cụ**
- `tool/guards/verify_ui_constants_centralization.dart`

**Phạm vi kiểm soát**
- Kiểm soát việc sử dụng số đo giao diện trong view layer.

**Mục tiêu nghiệp vụ**
- Bảo đảm spacing, radius, duration, opacity, font size được quản lý như design token dùng chung.

**Điều đang bị ngăn chặn**
- Không cho tạo file `_ui_const.dart` ở từng feature.
- Không cho hardcode nhiều loại số UI phổ biến như spacing, size, radius, duration, elevation, opacity, font size.

**Rủi ro nếu không kiểm soát**
- Mỗi feature tự đặt quy chuẩn hiển thị riêng.
- Mất tính nhất quán giữa màn hình.
- Tăng chi phí thay đổi khi bộ thiết kế thay đổi.

### A10. `spacing-ownership`

**Công cụ**
- `tool/guards/verify_spacing_ownership_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát ai là nơi sở hữu outer spacing của layout.

**Mục tiêu nghiệp vụ**
- Bảo đảm khoảng cách ngoài của màn hình được đặt ở đúng tầng, tránh padding lồng nhau và bố cục lệch nhịp.

**Điều đang bị ngăn chặn**
- Widget không mang vai trò owner về layout không được tự ôm root `Padding` hoặc `Container(margin)`.
- Không cho padding và margin bị chồng lặp giữa parent và child.

**Rủi ro nếu không kiểm soát**
- Double spacing.
- Layout drift giữa loading, error, empty, success.
- Khó xác định nơi nào thật sự đang quyết định khoảng cách hiển thị.

### A11. `theme-architecture`

**Công cụ**
- `tool/guards/verify_theme_architecture_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát cấu trúc thư mục, file và token của theme system.

**Mục tiêu nghiệp vụ**
- Bảo đảm hệ thống theme có cấu trúc rõ ràng, có thể mở rộng và có thể truy vết nguồn gốc của từng token thiết kế.

**Điều đang bị ngăn chặn**
- Bắt buộc có đủ các nhóm `foundation`, `semantic`, `component`, `builders`, `extensions`.
- Bắt buộc có bộ file theme chuẩn của repo.
- Không cho tồn tại file hoặc thư mục theme legacy ngoài kiến trúc mới.
- Bắt buộc có một số token nền tảng và token component theo naming chuẩn.

**Rủi ro nếu không kiểm soát**
- Theme bị dồn thành các file constants khó quản trị.
- Không rõ token nào phục vụ mục đích nào.
- Mất khả năng scale theme khi số lượng component tăng.

### A12. `string-utils`

**Công cụ**
- `tool/guards/verify_string_utils_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát cách chuẩn hóa và biến đổi chuỗi.

**Mục tiêu nghiệp vụ**
- Bảo đảm các xử lý chuỗi quan trọng đi qua cùng một chuẩn, tránh cách hiểu khác nhau giữa các feature.

**Điều đang bị ngăn chặn**
- Ngoài `string_utils.dart`, không được tự dùng trực tiếp các thao tác trim, lower/upper, replace, split, substring.

**Rủi ro nếu không kiểm soát**
- Cùng một business rule nhưng mỗi nơi normalize khác nhau.
- Phát sinh lỗi dữ liệu đầu vào khó truy vết.
- Tăng chi phí sửa lỗi khi thay đổi quy tắc xử lý chuỗi.

### A13. `ui-design`

**Công cụ**
- `tool/guards/verify_ui_design_guard.dart`

**Phạm vi kiểm soát**
- Kiểm soát các thông số giao diện nền tảng như breakpoint, spacing, size, touch target, màu sắc và component legacy.

**Mục tiêu nghiệp vụ**
- Bảo đảm chất lượng visual và khả năng dùng của sản phẩm đạt một chuẩn tối thiểu, không bị lệch do từng feature tự quyết định.

**Điều đang bị ngăn chặn**
- Không cho dùng một số legacy widgets.
- Khống chế breakpoint mobile, spacing grid, horizontal padding, button height, icon size, AppBar height, typography scale, touch target tối thiểu.
- Cấm hardcoded color, hex color, `Colors.*`, alpha literal và hardcoded size quá lớn.

**Rủi ro nếu không kiểm soát**
- UI mất nhịp thiết kế.
- Tương tác chạm không đạt chuẩn.
- Màu sắc và alpha bị phân mảnh.
- Trải nghiệm sản phẩm kém ổn định giữa các màn hình.

### A14. `code-quality`

**Công cụ**
- `tool/guards/verify_code_quality_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát độ phình to của file, class, function, độ sâu lồng nhau, startup budget, disposal, cache policy, JSON parsing và file chết.

**Mục tiêu nghiệp vụ**
- Bảo đảm mã nguồn đủ bền để sản phẩm có thể tiếp tục mở rộng mà không tăng nhanh nợ kỹ thuật.

**Điều đang bị ngăn chặn**
- Không cho dùng marker bypass `quality-guard:`.
- Bắt buộc model class có annotation bất biến.
- Presentation và viewmodel không được import network client trực tiếp.
- Cảnh báo file quá dài, class quá dài, function quá dài, nesting quá sâu, constructor quá nhiều tham số, widget children inline quá nhiều, viewmodel có quá nhiều public methods.
- Bắt buộc dispose hoặc cancel đúng với resource trong `State`.
- Cảnh báo list/grid dùng `children:`.
- Cảnh báo cache không có dấu hiệu chính sách TTL hoặc invalidation.
- Cảnh báo await quá nhiều trước `runApp`.
- Cảnh báo JSON parsing nặng mà không offload.
- Đánh dấu file có khả năng không còn được dùng.

**Ngưỡng mặc định đang áp dụng**
- File hiệu dụng: tối đa `500` dòng.
- Class: tối đa `300` dòng.
- Function: tối đa `80` dòng.
- Nesting depth: tối đa `3`.
- Constructor params: tối đa `4`.
- Inline children: tối đa `5`.
- Public methods trong state/controller/viewmodel: tối đa `10`.
- Số tác vụ await trước `runApp`: tối đa `1`.
- Cảnh báo JSON nặng khi `jsonDecode >= 3` hoặc có trong loop từ `1`.

**Rủi ro nếu không kiểm soát**
- Mã nguồn nhanh chóng khó sửa, khó review, khó test.
- Startup chậm.
- Rò rỉ resource.
- Cache không có vòng đời rõ ràng.
- UI giật do parse dữ liệu nặng trên main isolate.

### A15. `component-theme`

**Công cụ**
- `tool/guards/verify_component_theme_usage_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát việc feature tự override style của Material component.

**Mục tiêu nghiệp vụ**
- Bảo đảm các component chính của ứng dụng nhận style từ hệ theme tập trung thay vì từ từng màn hình riêng lẻ.

**Điều đang bị ngăn chặn**
- UI file dùng theme phải import từ `lib/core/themes/**` hoặc `app_foundation.dart`.
- Không cho feature tự override một loạt màu và style quan trọng của scaffold, app bar, card, button, chip, divider, list tile, switch, checkbox, radio, slider, progress indicator, dialog, snackbar.
- Trong feature UI, loading indicator trực tiếp bị hạn chế để ưu tiên shared loading widget.

**Rủi ro nếu không kiểm soát**
- Mỗi màn hình có thể tạo biến thể style riêng.
- Mất tính đồng bộ visual.
- Rất tốn chi phí khi redesign hoặc đổi theme system.

### A16. `feature-surface`

**Công cụ**
- `tool/guards/verify_feature_surface_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát nền chính của màn hình feature.

**Mục tiêu nghiệp vụ**
- Bảo đảm surface cấp màn hình bám theo color scheme của hệ thống.

**Điều đang bị ngăn chặn**
- `Scaffold.backgroundColor` chỉ được dùng theme surface/background tokens hoặc một số biểu thức ngoại lệ đã định nghĩa.

**Rủi ro nếu không kiểm soát**
- Mỗi màn hình có một nền khác nhau không theo hệ thống.
- Khó đạt sự nhất quán giữa light/dark theme.

### A17. `shared-widget-override`

**Công cụ**
- `tool/guards/verify_shared_widget_override_contract.dart`

**Phạm vi kiểm soát**
- Kiểm soát việc feature layer cố tình đổi màu của shared widget.

**Mục tiêu nghiệp vụ**
- Bảo đảm shared widget là điểm thực thi cuối cùng của design system, không bị feature làm sai lệch.

**Điều đang bị ngăn chặn**
- Feature không được truyền các named argument override màu hoặc màu trạng thái khi dùng shared widget.

**Rủi ro nếu không kiểm soát**
- Shared widget chỉ còn là vỏ bọc hình thức.
- Cùng một component nhưng mỗi feature có thể hiển thị khác nhau.

### A18. `shared-widgets-m3-coverage`

**Công cụ**
- `tool/guards/verify_shared_widgets_m3_coverage.dart`

**Phạm vi kiểm soát**
- Kiểm soát chất lượng nội tại của shared widget layer.

**Mục tiêu nghiệp vụ**
- Bảo đảm shared widget thực sự tuân thủ Material 3 và thực sự dùng token tập trung.

**Điều đang bị ngăn chặn**
- Manifest shared widget phải khớp file thật.
- Không cho dùng legacy widgets.
- Không cho hardcode style token, hardcode size, hardcode duration, hardcode color.
- Không cho tự dựng style bằng `styleFrom`, `ButtonStyle`, `Theme.of(...).copyWith`, `InputDecorationTheme`, `.copyWith`, `.withOpacity`, `Theme.of(context)`.

**Rủi ro nếu không kiểm soát**
- Shared widget layer mất chuẩn M3.
- Thiết kế bị phân mảnh ngay tại tầng dùng chung.
- CI không còn nhìn thấy đầy đủ phạm vi component phải kiểm soát.

## Nhóm B. Guard bổ sung trong `tool/guards`

### B01. `verify_accessibility_contract.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm sản phẩm đáp ứng các yêu cầu accessibility cơ bản.

**Điều đang bị ngăn chặn**
- Touch target nhỏ hơn `44dp`.
- Không có `Semantics(...)` trong toàn dự án.
- App shell không hỗ trợ reduce motion hoặc text scaling.
- Shared/core widget tương tác không có tooltip hoặc semantic affordance.
- Tự override `textScaleFactor` không có kiểm soát.

**Rủi ro nếu không kiểm soát**
- Người dùng có nhu cầu accessibility gặp khó khăn khi dùng sản phẩm.
- Chất lượng trải nghiệm thấp trên các thiết bị và cấu hình trợ năng khác nhau.

### B02. `verify_ci_guard_parity.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm rule đã viết ra phải thật sự được thực thi trong CI.

**Điều đang bị ngăn chặn**
- Guard tồn tại ở local nhưng không được gọi trong workflow.
- Workflow gọi nhầm guard không còn tồn tại.

**Rủi ro nếu không kiểm soát**
- Môi trường local và CI đánh giá chất lượng khác nhau.
- Quy định chất lượng bị vô hiệu hóa trên pipeline thật.

### B03. `verify_color_scheme_usage_contract.dart`

**Mục tiêu nghiệp vụ**
- Gom nhóm các kiểm soát về color scheme thành một điểm gọi chung.

**Điều đang bị ngăn chặn**
- Guard này không tạo thêm rule mới.
- Nó tái sử dụng kiểm soát từ `component-theme`, `feature-surface` và `shared-widget-override`.

**Rủi ro nếu không kiểm soát**
- Nhóm kiểm soát màu sắc khó được gọi đầy đủ và nhất quán.

### B04. `verify_coverage_budget.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm frontend giữ được mức bao phủ kiểm thử tối thiểu theo toàn hệ thống và theo từng layer.

**Điều đang bị ngăn chặn**
- Coverage toàn cục thấp hơn `20%`.
- Coverage theo layer thấp hơn ngưỡng mặc định:
  - `core >= 25%`
  - `data >= 25%`
  - `domain >= 20%`
  - `presentation >= 25%`
  - `other >= 15%`

**Rủi ro nếu không kiểm soát**
- Chất lượng regression testing suy giảm theo thời gian.
- Một số layer tăng rất nhanh nhưng không có mức test tương ứng.

### B05. `verify_feature_architecture_contract.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm mọi feature mới đều đi theo cùng một cấu trúc tài liệu hóa và triển khai.

**Điều đang bị ngăn chặn**
- Thiếu thư mục chuẩn của feature.
- Thiếu file provider, state, screen, content chuẩn.
- Provider không dùng Riverpod annotation hoặc không có part file.
- State không theo Freezed.
- Screen không orchestrate state đúng vai trò.
- Content file ôm luôn trách nhiệm orchestration.
- UI file import thẳng data layer.
- Tự tạo lớp `ScreenText` thay cho l10n.

**Rủi ro nếu không kiểm soát**
- Mỗi feature có một hình dạng khác nhau.
- BA, dev và reviewer khó đối chiếu giữa các feature.
- Tăng mạnh chi phí bảo trì khi số feature tăng lên.

### B06. `verify_public_api_test_contract.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm các API công khai ở layer logic có mức test tối thiểu.

**Điều đang bị ngăn chặn**
- Public methods trong repository, service, provider, controller, datasource, usecase, engine không có bằng chứng test.
- Coverage public API thấp hơn `40%`.
- Cho phép baseline để đóng băng nợ cũ, nhưng không cho phát sinh nợ mới.

**Rủi ro nếu không kiểm soát**
- API công khai thay đổi mà không có cảnh báo từ test.
- Boundary logic trở nên mong manh và dễ regression.

### B07. `verify_riverpod_layout_state_contract.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm flow Riverpod trong UI và state layer ổn định, dễ dự đoán và tương thích với code generator.

**Điều đang bị ngăn chặn**
- Dùng `mounted` hoặc `context.mounted` sai ngữ cảnh.
- Dùng `ref.read(...)` trực tiếp trong `build`.
- Lưu `WidgetRef` hoặc `Ref` làm field.
- File Riverpod bị thiếu annotation, thiếu `part '*.g.dart'`, part name sai, hoặc generated part chưa tồn tại.

**Rủi ro nếu không kiểm soát**
- Sinh lỗi lifecycle khó tái hiện.
- Flow state bị phụ thuộc vào implementation chi tiết của widget.
- Gặp lỗi build/generate không ổn định giữa các môi trường.

### B08. `verify_test_pyramid_contract.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm cấu trúc kiểm thử cân bằng giữa viewmodel, domain, view và integration.

**Điều đang bị ngăn chặn**
- Feature có viewmodel nhưng không có viewmodel test tối thiểu.
- Feature có domain logic nhưng không có domain test tối thiểu.
- Feature có view nhưng không có view/flow test tối thiểu.
- Toàn hệ thống thiếu integration test.
- Có baseline để tránh fail debt cũ nhưng vẫn chặn debt mới.

**Ngưỡng mặc định đang áp dụng**
- Mỗi feature có viewmodel: tối thiểu `1` viewmodel test.
- Mỗi feature có domain logic: tối thiểu `1` domain test.
- Mỗi feature có view: tối thiểu `1` view hoặc flow test.
- Integration test toàn hệ thống: tối thiểu `1`.

**Rủi ro nếu không kiểm soát**
- Test tập trung lệch vào một tầng.
- Hệ thống thiếu các bài test chứng minh luồng người dùng chạy xuyên tầng.

### B09. `verify_theme_contract.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm hệ thống theme ở cấp ứng dụng đáp ứng chuẩn tối thiểu về M3, light/dark và contrast.

**Điều đang bị ngăn chặn**
- Thiếu `dynamic_color` nếu không có marker cho phép.
- Thiếu factory theme light/dark.
- Theme không bật `useMaterial3: true`.
- Thiếu color scheme light/dark, thiếu `ColorScheme.fromSeed`, thiếu validation contrast.
- `main.dart` không khai báo `themeMode:`.

**Rủi ro nếu không kiểm soát**
- Theme system thiếu nền tảng cho dark mode.
- Color scheme phát sinh lệch chuẩn.
- Contrast không được kiểm soát có thể làm giảm khả năng đọc.

### B10. `verify_ui_state_scalability_contract.dart`

**Mục tiêu nghiệp vụ**
- Bảo đảm màn hình dữ liệu lớn có khả năng mở rộng và trải nghiệm tải trạng thái hợp lý.

**Điều đang bị ngăn chặn**
- `.when(...)` thiếu `loading:` hoặc `error:`.
- List/grid chỉ dùng spinner mà không có skeleton hoặc shimmer.
- `ListView(children:)` và `GridView(children:)` trong các màn hình feature khi không có lý do ngoại lệ.

**Rủi ro nếu không kiểm soát**
- Màn hình lớn dễ lag.
- Trải nghiệm loading nghèo nàn.
- UI thiếu trạng thái lỗi hoặc trạng thái tải dẫn tới hành vi không đầy đủ.

## Script hỗ trợ

### `tool/verify_frontend_checklists.dart`

- Vai trò: điểm chạy chung cho 18 guard mặc định trong Nhóm A.
- Giá trị với BA và reviewer: chỉ cần một lệnh là có thể xác nhận phần lớn contract frontend cốt lõi đã được kiểm tra.

### `tool/generate_public_methods_inventory.dart`

- Vai trò: sinh inventory phục vụ audit public API.
- Đây là script hỗ trợ, không phải guard contract độc lập.

### `tool/guards/guard_project_profile.dart`

- Vai trò: đọc profile của repo để các guard biết prefix widget, package name và naming convention đặc thù của dự án.
- Giá trị với BA và reviewer: giúp rule bám đúng vocabulary của dự án thay vì dùng giả định chung.

## Kết luận nghiệp vụ

- Bộ guard hiện tại đang tập trung vào 5 nhóm mục tiêu chất lượng chính:
  - Kiến trúc rõ ràng.
  - Trải nghiệm giao diện nhất quán.
  - State flow ổn định.
  - Khả năng kiểm thử và kiểm soát regression.
  - Khả năng mở rộng lâu dài của codebase.

- Nếu chạy `dart run tool/verify_frontend_checklists.dart`, nhóm dự án đang xác nhận phần lớn contract frontend cốt lõi.
- Nếu muốn audit đầy đủ toàn bộ cơ chế kiểm soát của thư mục `tool/guards`, cần gọi thêm các guard bổ sung trong Nhóm B.
- Một số guard có baseline để chấp nhận nợ cũ nhưng không cho phát sinh nợ mới. Hiện tại nhóm này gồm:
  - `common-widget-usage`
  - `public-api-test`
  - `test-pyramid`
