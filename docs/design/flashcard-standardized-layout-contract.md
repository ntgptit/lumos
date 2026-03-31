# Flashcard Screen Standardized Layout Contract

## Metadata

- Status: Ready for implementation
- Scope: `lib/presentation/features/flashcard/**`
- Source of truth: standardized reference image attached in task
- Constraint: keep existing architecture, providers, routes, and color system
- Allowed change: layout and visual composition only

## 1. Screen Intent

Màn hình flashcard là màn `deck detail for study entry`.

Mục tiêu chính:

- cho người dùng xem nhanh thẻ đại diện của bộ
- nhận diện bộ thẻ và metadata liên quan
- bắt đầu một chế độ học từ ngay màn này
- xem nhanh tiến độ trước khi cuộn xuống danh sách thẻ

Màn này không phải:

- một màn dashboard analytics tổng quát
- một màn CRUD table thuần
- một màn study session thực thụ

## 2. Foundation And Adaptive Theme Mapping

- Giữ toàn bộ màu từ `Theme.of(context).colorScheme` và `context.appColors`
- Giữ typography từ shared theme hiện có
- Giữ spacing và radius qua `ResponsiveDimensions`, `context.spacing`, `context.shapes`, `context.component`
- Không thêm palette cục bộ trong feature
- Không thêm breakpoint cục bộ ngoài những layout-only decisions trong section widget

## 3. UI Section Table

| Section | Position | Responsibility | Data Source | Existing Mapping |
| --- | --- | --- | --- | --- |
| App bar | Top | Hiển thị tên deck và action utility | `FlashcardState.deckName`, local UI actions | `FlashcardContent` + `LumosAppBar` |
| Preview card | Top hero | Xem nhanh 1 flashcard, lật mặt trước/sau, vào chế độ học từ preview | `FlashcardState.items`, `previewIndex`, `isStudyCardFlipped` | `FlashcardPreviewCarousel` |
| Preview pagination | Under preview card | Cho biết vị trí thẻ đang xem | `FlashcardState.safePreviewIndex`, items | `FlashcardPreviewCarousel` |
| Deck summary | Under preview | Hiển thị title và metadata của bộ thẻ | `deckName`, `totalElements` | `FlashcardSetMetadataSection` |
| Study section label | Under deck summary | Tách rõ khu vực hành động học | local static section header | new layout wrapper in content |
| Study action grid | Under study label | Mở các mode học từ bộ thẻ | local action list + existing handlers | `FlashcardStudyActionSection` |
| Progress section header | Under actions | Hiển thị title, description ngắn, CTA đi tới progress detail | local strings + route | `FlashcardStudyProgressSection` |
| Progress bar + stat cards | Under progress header | Tóm tắt mức tiến độ và phân nhóm trạng thái học | `totalElements`, computed counts | `FlashcardStudyProgressSection` |
| Search bar | Below progress when visible | Lọc danh sách thẻ | `searchQuery`, local debounce | existing search section |
| Card list header | Below progress/search | Báo section list và sort action | `totalElements`, sort state | `FlashcardListHeader` |
| Card list | Below list header | Hiển thị các flashcard để quản lý | `FlashcardState.items` | `FlashcardListCard` list |

## 4. Wireframe Section Analysis

- Ảnh chuẩn hóa là `high fidelity` về hierarchy và composition.
- App bar là hàng utility gọn, không dùng hero banner trong header.
- Preview card là vùng nổi bật nhất màn, lớn hơn các action card.
- Metadata nằm tách riêng ngay dưới preview, không trộn vào action section.
- Khu “Học” là một section riêng với grid 2 cột và một card full width ở cuối.
- Progress section có:
  - header trái
  - CTA nhỏ bên phải
  - linear progress bar
  - 3 stat cards cùng hàng
- Danh sách thẻ là phần sau fold, không được chen lên trước progress block.

## 5. Interaction Contract

| Interaction | FE Responsibility | BE Responsibility | Reason |
| --- | --- | --- | --- |
| Toggle search | hiện/ẩn ô tìm kiếm | none | purely local UI behavior |
| Sort cards | mở sheet và gửi lựa chọn sort | cung cấp dữ liệu đã sort sau query mới | UI chọn sort, data source vẫn do controller/repository |
| Swipe preview page | đổi preview index và reset flipped state | none | preview is local presentation state |
| Tap preview card | flip front/back on current preview card | none | card flip is local view state already present in feature state |
| Tap preview expand button | mở flow học từ index hiện tại | session truth ở backend/study flow | screen chỉ điều hướng |
| Tap study action card | khởi động mode học hoặc open learn sheet | study session availability và session launch handled outside widget | UI chỉ dispatch existing handlers |
| Tap progress detail CTA | navigate to deck progress route | progress data remains owned by progress feature | this screen only links out |
| Tap progress stat cards | open study from current deck | actual study logic not in UI | reuse existing action callbacks |
| Pull to refresh | trigger refresh | controller/repository fetch newest data | standard FE refresh |
| Search input | debounce và cập nhật query | query execution and data fetching | FE owns input UX only |
| Audio/star/edit/delete in list | dispatch existing actions | repo/session persistence and business logic | unchanged architecture |

## 6. Responsibility Analysis

### Frontend responsibility

- cấu trúc section theo ảnh chuẩn hóa
- preview page index
- local flip state của preview card
- toggle search
- debounce search input
- rendering progress summary
- navigation tới route hoặc modal đã có
- loading/refresh/mutating overlays

### Backend or non-UI responsibility

- danh sách flashcard thật
- sort/query result
- persistence của bookmark, create, edit, delete
- study session launch outcome
- progress business truth

### Logic that must not move into Flutter UI

- tính toán business progress ngoài các count hiển thị đơn giản
- quyết định loại study session được phép
- CRUD persistence
- session availability rules

## 7. Domain Responsibility Analysis

| Layer | Responsibility |
| --- | --- |
| Presentation | render section, handle local flip, local search visibility, dispatch existing actions |
| Application | `FlashcardAsyncController` orchestration for refresh, sort, search, toggle star, preview index |
| Domain | flashcard entities, sort enums, study launch rules, progress meaning |
| Infrastructure | repositories, datasource, API/local persistence |

## 8. API Contract Design

Không có API contract mới.

Không thay đổi:

- request or response shape
- provider interface
- repository calls
- route parameter shape

## 9. Screen-Class And Adaptive Layout Plan

- Mobile-first, single column
- Preview card constrained by existing page width and screen frame
- Action cards:
  - 2 columns on normal phone width
  - last item spans full width
  - compact width still keeps 2-column intention where possible
- Progress stat cards:
  - 3 columns on standard width
  - stacked or wrapped only when width is too narrow
- Reading-heavy content remains constrained by existing page shell

## 10. Major Sections In Visual Order

1. App bar
2. Preview card
3. Preview dots
4. Deck summary metadata
5. Study section label
6. Study action grid
7. Progress section
8. Search bar when visible
9. Card list header
10. Card list

## 11. Widget Tree

```text
FlashcardContent
└─ Theme
   └─ Scaffold
      ├─ LumosAppBar
      └─ Stack
         ├─ RefreshIndicator
         │  └─ LumosScreenFrame
         │     └─ LumosPagedSliverList
         │        ├─ Sliver: inline error banner (optional)
         │        ├─ Sliver: FlashcardPreviewCarousel
         │        ├─ Sliver: FlashcardSetMetadataSection
         │        ├─ Sliver: Study section heading
         │        ├─ Sliver: FlashcardStudyActionSection
         │        ├─ Sliver: FlashcardStudyProgressSection
         │        ├─ Sliver: Search bar (optional)
         │        ├─ Sliver: FlashcardListHeader
         │        ├─ Sliver list: FlashcardListCard
         │        └─ Sliver trailing spacing/loading
         ├─ FlashcardLoadingMask
         └─ FlashcardMutatingOverlay
```

## 12. Layout Validation

- [x] All visible wireframe sections are present
- [x] Section order matches the standardized image
- [x] Preview stays above metadata
- [x] Metadata stays above study actions
- [x] Progress stays above searchable card list
- [x] No section from the standardized image is merged into another unrelated section

## 13. Frontend State Binding

| UI Element | Bound State | Update Path |
| --- | --- | --- |
| App bar title | `state.deckName` | read-only from `FlashcardState` |
| Preview current item | `state.items[state.safePreviewIndex]` | page change -> controller `setPreviewIndex` |
| Preview front/back side | `state.isStudyCardFlipped` | tap card -> controller `toggleStudyCardFlipped` |
| Preview dots | `state.safePreviewIndex`, items length | derived render state |
| Metadata total count | `state.totalElements` | derived render state |
| Search visibility | `state.isSearchVisible` | controller `toggleSearchVisibility` |
| Search query | `state.searchQuery` | debounce -> controller `updateSearchQuery` |
| Progress counts | `notStartedCount`, `masteredCount`, learning derived local | derived from `FlashcardState` |
| Mutating overlay | `state.isMutating` | existing feature state |
| Loading mask | `state.isRefreshing` | existing feature state |

## 14. Section UI Logic

### Preview card

- shows current flashcard side
- tap toggles front/back
- page change resets to front side
- expand button enters study flow from the current preview item

### Deck summary

- always visible when items exist
- title and metadata stay compact and readable

### Study actions

- primary study mode remains visually emphasized
- other actions remain scan-friendly
- last action spans full width per standardized image

### Progress

- presents summary before detailed list
- CTA navigates away, not inline expand
- stat cards are tappable shortcuts into current deck study flow

### Search and list

- search remains optional and app bar controlled
- list management stays below the summary blocks

## 15. Shared-Widget Mapping

| Needed role | Reuse decision |
| --- | --- |
| Page shell | keep existing `Scaffold` + `LumosScreenFrame` |
| App bar | reuse `LumosAppBar` |
| Preview container | keep feature widget `FlashcardPreviewCarousel` |
| Cards | reuse `LumosCard` and shared button/icon primitives |
| Progress bar | reuse `LumosProgressBar` |
| Stat cards | reuse `LumosStatCard` if it fits; otherwise keep feature-local progress composition |
| Empty/error states | keep shared `LumosEmptyState`, `LumosErrorState` |

No new shared widget is required for this task unless a repeated pattern emerges beyond this screen.

## 16. Spacing Mapping

- section gaps use existing compact responsive spacing
- hero preview remains the visually largest block
- action grid and progress cards use token-based gaps only
- no ad hoc raw pixel spacing outside existing responsive helpers

## 17. State And Layout-Stability Plan

- Loading shell must preserve app bar + top content rhythm
- Empty state remains below list header area only when there are no items
- Search visibility should not reorder core summary sections
- Refresh and mutating overlays must not collapse existing content regions

## 18. Implementation Plan

### Frontend

1. update `FlashcardPreviewCarousel` to support front/back flip layout
2. update `FlashcardSetMetadataSection` for standardized stacked summary layout
3. update `FlashcardStudyActionSection` to 2-column card grid with subtitle and full-width last card
4. update `FlashcardStudyProgressSection` from ring layout to header + linear progress + 3 stat cards
5. reorder `FlashcardListContent` to insert explicit study section header and keep progress above list
6. adjust `FlashcardContent` app bar composition and wire preview flip callback
7. update `FlashcardLoadingShell` to better mirror the new top layout
8. add only the minimum localization strings required by the standardized layout

### Backend

- no backend work

## 19. Assumptions And Ambiguities

- standardized image is for mobile layout first
- colors must stay on current theme roles, not pixel-match the screenshot
- list section exists below the fold even though the screenshot crops it
- progress CTA may route to existing deck progress screen even if that screen is still simple
