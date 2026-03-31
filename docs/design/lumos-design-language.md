# Lumos Design Language Specification

## Metadata

- Status: Draft for pre-implementation alignment
- Scope: Flutter app visual language, interaction language, and screen-family rules
- Applies to: `lib/core/theme/**`, `lib/presentation/shared/**`, `lib/presentation/features/**`
- Non-goal: This document does not redefine backend behavior, legacy BA wireframes, or API contracts

## Intent

Tài liệu này là nguồn sự thật riêng cho phần design của Lumos trước khi triển khai tiếp.

Tài liệu cũ trong `00_docs/**` có thể tham khảo về mặt nghiệp vụ, nhưng **không được coi là nguồn sự thật cho visual design** nếu có mâu thuẫn với tài liệu này.

Mục tiêu của tài liệu:

- chốt một ngôn ngữ thiết kế thống nhất cho toàn app
- tránh mỗi feature tự phát triển một giọng giao diện riêng
- tạo hợp đồng rõ ràng giữa `theme`, `shared widgets`, `feature screens`
- giúp phase triển khai sau đó có tiêu chuẩn review cụ thể

## Product Framing

Lumos là ứng dụng học tập xoay quanh:

- thư viện học liệu: folder, deck, flashcard
- phiên học tập trung: study session theo mode
- động lực học: progress, streak, reminder, completion
- tiện ích cá nhân: profile, theme, speech, settings

Đây không phải:

- một SaaS dashboard thuần quản trị
- một social app giàu feed
- một game hóa nặng tính giải trí

Vì vậy ngôn ngữ thiết kế phải đi theo hướng:

- tập trung
- dễ đọc
- có cảm giác tiến bộ
- đáng tin cậy
- hơi premium nhưng không phô trương

## North Star

### Design direction

Lumos phải được cảm nhận như một `calm-focus learning system`.

Nền tảng thị giác nên là:

- `minimal utility` cho thao tác hàng ngày
- `editorial warmth` cho các điểm nhấn cảm xúc
- `study-first focus` cho phiên học

### What Lumos should feel like

- gọn
- sáng rõ
- có nhịp thở
- thông minh
- bình tĩnh
- có tiến độ

### What Lumos must not feel like

- dashboard template chung chung
- neon hoặc sci-fi quá mạnh
- glassmorphism nặng
- enterprise quá khô cứng
- gamified quá trẻ con
- mỗi màn một phong cách khác nhau

## Design Principles

### 1. Focus before decoration

Trang trí chỉ được dùng để hỗ trợ hierarchy hoặc cảm xúc. Nội dung học và hành động chính luôn là trung tâm.

### 2. One primary action at a time

Mỗi màn cần có một trọng tâm thao tác rõ ràng. Không để nhiều CTA cạnh tranh nhau.

### 3. Stable shells, changing content

Khi nội dung thay đổi, shell và bố cục chính vẫn phải ổn định để giảm tải nhận thức.

### 4. Calm progress, not noisy gamification

Progress phải tạo động lực nhưng không biến app thành game UI.

### 5. Same product, same voice

Light mode và dark mode là hai biến thể của cùng một thương hiệu, không phải hai app khác nhau.

### 6. Shared first

Feature chỉ được tạo visual mới khi shared layer không đáp ứng đúng vai trò.

## Brand Personality

| Thuộc tính | Mức độ | Cách thể hiện |
| --- | --- | --- |
| Trustworthy | Cao | Màu nền sạch, contrast rõ, typography chắc |
| Focused | Cao | Layout ít nhiễu, CTA rõ, study shell ổn định |
| Warm | Trung bình | Accent ấm ở progress, completion, reminder |
| Intelligent | Cao | Typography tốt, hierarchy tinh gọn, số liệu rõ |
| Playful | Thấp | Chỉ dùng ở empty state hoặc completion moment |
| Luxurious | Thấp đến trung bình | Chỉ ở hero/editorial accents, không dùng đại trà |

## Visual Language

## Color System

### Core decision

Lumos dùng một trục màu thống nhất:

- `primary`: teal học tập và tập trung
- `secondary`: amber ấm cho động lực và reward
- `info accent`: blue cho thông tin và secondary emphasis
- `neutral`: slate hoặc ink cho text, surface, border

Không dùng dark mode tím neon nếu light mode lại đi theo xanh dashboard. Hai mode phải cùng hue family.

### Target palette

| Role | Light target | Dark target | Usage |
| --- | --- | --- | --- |
| Brand primary | `#0E6D68` | `#5FB8AF` | CTA chính, highlight học tập, progress focus |
| Brand primary strong | `#0A5753` | `#7CD0C8` | Pressed, emphasis mạnh |
| Brand primary container | `#D8F1ED` | `#143231` | Hero nhẹ, selected state, soft highlight |
| Reward amber | `#C06B2C` | `#E9A35D` | streak, progress reward, reminder emphasis |
| Reward container | `#FFE7D1` | `#392615` | badge, positive milestone |
| Info blue | `#296C93` | `#67B2D9` | informational banners, audio, tips |
| Success | `#2F8F4E` | `#65C27F` | correct answer, done state |
| Warning | `#B86A07` | `#E7A23D` | pending, caution |
| Error | `#B3261E` | `#FF7B72` | destructive, wrong answer critical |
| Canvas | `#F7FAF9` | `#0C1515` | app background |
| Surface | `#FFFFFF` | `#12201F` | cards, panels |
| Surface muted | `#EFF5F4` | `#172726` | secondary sections |
| Outline | `#D6E2DF` | `#294240` | card border, dividers |
| Text primary | `#1B2B2A` | `#E3ECEB` | main text |
| Text secondary | `#5A6A69` | `#A9B8B7` | helper text |

### Color rules

- Một màn chỉ nên có `1 màu chủ đạo` và `1 màu phụ` nổi bật.
- Không dùng quá `3 accent hues` trong cùng một viewport.
- Gradient chỉ dùng cho:
  - home hero
  - onboarding hero
  - completion or celebration state
- Không dùng gradient trong:
  - form
  - settings
  - dense list
  - study interaction core card

### State color rules

| State | Color role | Usage rule |
| --- | --- | --- |
| Correct | Success | rõ ràng nhưng không chói |
| Incorrect | Error | chỉ dùng cho outcome quan trọng |
| Retry | Warning | dùng khi user cần làm lại hoặc còn dang dở |
| Info | Info blue | dùng cho hint, speech, guidance |
| Disabled | Neutral muted | không trộn disabled với semantic state |

## Typography

### Typography strategy

Giữ tinh thần typography hiện có:

- `DM Serif Display` cho high-emotion or high-attention moments
- `Inter Tight` cho heading và title
- `Noto Sans` cho body, form, helper, dense reading

### Typography roles

| Role | Font | Usage |
| --- | --- | --- |
| Display | DM Serif Display | home hero, onboarding hero, completion heading |
| Headline | Inter Tight | screen title, section title lớn |
| Title | Inter Tight | card title, dialog title, list section title |
| Body | Noto Sans | mô tả, nội dung tiêu chuẩn |
| Label | Noto Sans | field label, chip label, metadata |

### Typography rules

- Serif chỉ dùng cho các moment nhấn mạnh, không dùng cho flow thao tác dày.
- Không dùng display font trong:
  - form auth
  - dense analytics
  - settings
  - list items
- Headline phải đủ chắc, nhưng không lạm dụng toàn bộ chữ in đậm.
- Body copy ưu tiên dễ đọc hơn là cá tính.
- Tránh viết toàn bộ text UI bằng sentence quá dài; ưu tiên label ngắn, động từ rõ.

## Shape, Spacing, and Elevation

### Shape language

Lumos dùng shape mềm nhưng có cấu trúc:

- button and input: bo vừa, rõ ràng, không quá tròn
- standard card: bo trung bình
- hero or focus card: bo lớn hơn để tạo cảm giác vùng trọng tâm
- pill/chip: dùng cho metadata và micro actions

### Radius guidance

| Element | Radius direction |
| --- | --- |
| Button | 12 đến 16 |
| Input | 14 đến 16 |
| Standard card | 16 đến 20 |
| Hero or focus card | 24 đến 28 |
| Pill/chip | full or near-pill |

### Spacing guidance

App phải có nhịp spacing nhất quán:

- khoảng cách trong cùng một card: chặt hơn
- khoảng cách giữa section: thoáng hơn
- khoảng cách của study mode: rộng hơn list mode

### Elevation guidance

- Ưu tiên `outline + soft shadow` hơn là shadow nặng.
- Không dùng nhiều tầng elevation cùng lúc trong một màn.
- Standard surfaces phần lớn nên là:
  - outline nhẹ
  - shadow rất nhỏ
  - contrast dựa nhiều vào surface role

## Motion

### Motion tone

Motion của Lumos phải:

- ngắn
- có chủ đích
- bình tĩnh
- không “bouncy” kiểu social app

### Motion rules

| Motion type | Direction |
| --- | --- |
| Screen transition | nhẹ, rõ, không gây chóng mặt |
| Card reveal | fade + slight translate |
| Study answer feedback | tức thời, rõ kết quả |
| Loading | yên, ổn định, không giật |
| Repeated motion | hạn chế tối đa |

### Duration guidance

- micro feedback: `120ms` đến `180ms`
- standard reveal: `180ms` đến `240ms`
- screen or shell transition: `240ms` đến `320ms`

## Iconography and Illustration

### Icons

- Dùng một phong cách icon thống nhất theo Material rounded direction.
- Kích thước icon phải bám token.
- Icon chỉ là hỗ trợ, không tranh vai trò với text.

### Illustration and decorative graphics

- Chỉ dùng ở:
  - onboarding
  - empty state
  - success/completion
  - selected hero moments
- Không dùng minh họa lớn ở các màn library dense hoặc study focus core.

## Screen Family Grammar

### Overview

Lumos không nên có một layout style cho mọi màn. Thay vào đó, toàn app dùng một language thống nhất nhưng có `screen families` khác nhau.

| Family | Primary goal | Mood | Density | Decorative allowance |
| --- | --- | --- | --- | --- |
| Auth / Onboarding | chào đón và tạo tin cậy | warm, calm | thấp | trung bình |
| Home / Dashboard | định hướng và thúc đẩy | optimistic, structured | trung bình | trung bình |
| Library | quét, tìm, quản lý | efficient, clear | trung bình đến cao | thấp |
| Study | tập trung và phản hồi tức thời | focused, immersive | thấp đến trung bình | rất thấp |
| Progress | đọc tiến độ và xu hướng | analytical, encouraging | trung bình đến cao | thấp |
| Settings / Profile | chỉnh cấu hình, thông tin cá nhân | neutral, stable | trung bình | rất thấp |

### Current feature mapping

| Feature | Screen family | Preferred shared shell | Notes |
| --- | --- | --- | --- |
| `auth` | Auth / Onboarding | centered scaffold or form layout | trust-first, low density |
| `onboarding` | Auth / Onboarding | onboarding shell | editorial accent allowed |
| `home` | Home / Dashboard | `LumosDashboardLayout` | hero + next action + summary |
| `folder` | Library | list or detail layout | scan and manage |
| `deck` | Library | list or detail layout | scan, organize, enter study |
| `flashcard` | Library | detail layout | content-heavy but still utility-first |
| `study` | Study | `LumosStudyLayout` | most critical flow in app |
| `progress` | Progress | `LumosDashboardLayout` | denser analytics allowed |
| `profile` | Settings / Profile | grouped detail layout | neutral shell |
| `settings` | Settings / Profile | form or grouped detail layout | least decorative area |
| `reminder` | Settings / Profile with reward accents | form or grouped detail layout | reminder time and motivation UI |

## Family 1: Auth and Onboarding

### Goal

Làm người dùng thấy app đáng tin, dễ bắt đầu, không quá nặng nề.

### Structure

- một vùng hero ngắn hoặc message zone
- một form card chính
- tối đa một CTA chính và một secondary path rõ ràng

### Design rules

- Dùng accent mềm của brand, không dùng quá nhiều semantic colors.
- Form phải rất rõ và sạch.
- Serif chỉ nên dùng ở hero title hoặc welcome statement.
- Không tạo cảm giác enterprise admin login.

## Family 2: Home and Dashboard

### Goal

Đưa người dùng về đúng việc cần làm tiếp theo trong hôm nay.

### Structure

- top summary hoặc hero
- một cụm quick stats nhỏ
- một vùng “next action” hoặc “focus today”
- một vùng activity hoặc recent context

### Design rules

- Home không phải nơi hiển thị toàn bộ analytics.
- Hero có thể có gradient nhẹ hoặc editorial typography.
- Stat card phải ngắn, quét nhanh, không quá nhiều text.
- CTA chính nên dẫn về study hoặc library action quan trọng nhất.

## Family 3: Library

### Goal

Cho phép quét, tìm, sắp xếp, quản lý folder, deck, flashcard hiệu quả.

### Structure

- page header
- search and sort bar
- list or grouped cards
- floating or footer create action nếu cần

### Design rules

- Ưu tiên readability và scan speed.
- Giảm trang trí.
- Card list phải giữ chiều cao và metadata ổn định.
- Search, sort, filter phải dùng cùng grammar trên các màn library.
- Một item library phải luôn có hierarchy rõ:
  - title
  - subtitle or metadata
  - progress or count
  - contextual action

## Family 4: Study

### Goal

Giữ user xử lý đúng một nội dung tại một thời điểm, với phản hồi rất rõ và không phân tâm.

### Structure

- study header hoặc compact session meta
- progress header
- central content card
- primary action row
- secondary help utilities

### Design rules

- Study shell phải ổn định giữa các mode.
- Nội dung trung tâm luôn là phần lớn nhất.
- CTA phải nhất quán vị trí.
- Feedback đúng sai phải rõ ràng, tức thời, nhưng không gây sốc thị giác.
- Không dùng quá nhiều decorative surfaces trong core study step.

### Study-specific rules

- reveal answer, mark remembered, retry, go next phải có visual priority rõ.
- audio, help, reset mode là secondary actions.
- progress luôn hiện diện nhưng không lấn át card học.
- mode thay đổi nhưng người dùng vẫn phải thấy mình đang ở chung một hành trình.

## Family 5: Progress

### Goal

Cho người dùng thấy họ đang đi lên thế nào, ở đâu mạnh, ở đâu cần quay lại.

### Structure

- summary header
- metric cards
- trend or momentum cards
- recommendation cards

### Design rules

- Data density được phép cao hơn home.
- Màu semantic chỉ dùng để làm rõ ý nghĩa, không dùng để trang trí tràn lan.
- Biểu đồ hoặc distribution view phải ưu tiên readability.
- Recommendation card phải chuyển được sang action cụ thể.

## Family 6: Settings and Profile

### Goal

Cho phép cấu hình, xem thông tin, và thử các tiện ích cá nhân mà không tạo cảm giác rối.

### Structure

- page header
- grouped sections
- neutral cards hoặc grouped list items

### Design rules

- Trạng thái phải rõ nhưng giao diện trung tính.
- Đây là nơi ít trang trí nhất app.
- Danger actions phải rất tách biệt.

## Component Language

### Forbidden visual patterns

- không trộn nhiều hơn một style card nổi bật trong cùng một vùng
- không tạo card trong card trong card nếu không có hierarchy thật sự
- không cho mỗi feature tự chọn radius, shadow, hay gradient riêng
- không dùng semantic color như một màu brand phụ
- không để dark mode đổi hẳn sang một cá tính thị giác khác
- không biến progress screen thành dashboard generic không liên quan tới học tập

## Buttons

| Type | Role | Rule |
| --- | --- | --- |
| Primary | hành động chính của màn | tối đa 1 visual primary per region |
| Secondary | hành động phụ nhưng quan trọng | outline hoặc soft fill |
| Text | hành động nhẹ | không dùng cho CTA chính |
| Icon button | utility | chỉ dùng khi meaning rõ |
| Danger | destructive | chỉ dùng cho remove, logout, destructive confirm |

### Button rules

- Primary button phải luôn là hành động mạnh nhất trong vùng.
- Không để hai primary button cạnh nhau trong cùng một card.
- Trong study mode, action sequence phải nhất quán qua các bước.

## Cards

| Type | Role | Rule |
| --- | --- | --- |
| Hero card | thông điệp và CTA | chỉ vài nơi chiến lược |
| Stat card | số liệu ngắn | luôn quét nhanh được |
| Info card | guidance hoặc message | dùng icon và tone nhẹ |
| Focus card | central study content | lớn, ổn định, contrast tốt |
| Section card | gom nhóm nội dung | background nhẹ, ít trang trí |

### Card rules

- Không biến toàn app thành lưới card đồng dạng.
- Card phải có vai trò rõ, không chỉ là container mặc định.
- Hero card và focus card là hai ngoại lệ được phép nổi bật hơn standard card.

## Inputs and Forms

### Rules

- Form field spacing và helper text phải thống nhất.
- Error message đặt sát field, không rải rác toàn màn.
- Input shape và button shape phải cùng family.
- Placeholder không thay thế label.

## Lists

### Rules

- Một list family phải có grammar nhất quán về:
  - leading
  - title
  - subtitle
  - metadata
  - trailing action
- Swipe, reorder, selection chỉ dùng khi thật sự có giá trị thao tác.

## Feedback and States

### State hierarchy

| State | Rule |
| --- | --- |
| Loading | giữ shell ổn định, ưu tiên skeleton thay vì layout jump |
| Empty | cho biết thiếu gì và action tiếp theo là gì |
| Error | giải thích ngắn, có recovery path |
| Success | ngắn gọn, không làm gián đoạn flow |
| Mutating overlay | chỉ dùng khi cần khóa tác vụ ngắn |

### State rules

- Loading không được làm layout biến mất hoàn toàn nếu screen đã có shell.
- Empty state của library, progress, study phải khác nhau về tone nhưng cùng component grammar.
- Snackbar, banner, dialog phải thống nhất severity language.

## Layout Contract

### Shared shells

Thiết kế sau này phải bám 3 shell chính:

- `LumosScaffold` cho shell chuẩn
- `LumosDashboardLayout` cho home, progress, profile-like grouped screens
- `LumosStudyLayout` cho study focus flow

### Width and composition

- Mobile ưu tiên single-column.
- Tablet cho phép split hợp lý nhưng không ép chia đôi mọi màn.
- Desktop mở rộng chiều ngang nhưng phải giữ max content width cho vùng học và form.

### Stable region contract

Các vùng sau phải có vị trí ổn định nếu màn hỗ trợ:

- page header
- primary content
- action area
- feedback area

## Accessibility Contract

- Contrast phải đạt mức đọc tốt ở cả light và dark.
- Không dùng màu làm tín hiệu duy nhất cho đúng sai hoặc trạng thái.
- Touch target phải đủ lớn theo token.
- Progress và answer feedback phải có semantic label rõ.
- Typography scale phải ưu tiên readability trước compactness.

## Copy Tone

### Tone of voice

- ngắn
- rõ
- bình tĩnh
- hướng hành động

### Copy rules

- Ưu tiên động từ cụ thể: `Bắt đầu học`, `Tiếp tục`, `Làm lại`, `Xem tiến độ`
- Tránh label mơ hồ kiểu `Thực hiện`, `Tiếp tục nữa`, `Xử lý`
- Empty state cần nói:
  - hiện thiếu gì
  - user nên làm gì tiếp

## Implementation Contract

## Existing foundations to preserve

Các phần sau là nền móng đúng hướng và nên được giữ:

- `lib/core/theme/**`
- `lib/presentation/shared/primitives/**`
- `lib/presentation/shared/composites/**`
- `lib/presentation/shared/layouts/**`

## Existing issues to correct during implementation

### 1. Palette drift between modes

Light mode và dark mode hiện có nguy cơ mang hai cá tính khác nhau. Khi triển khai, phải gom về cùng một brand axis.

### 2. Dashboard influence is too strong

Một số surface và palette đang gần với dashboard template hơn là learning product. Khi triển khai, home có thể giữ chút dashboard grammar, nhưng study và library phải đi về learning-first.

### 3. Need explicit screen-family rules

Shared components có sẵn khá nhiều, nhưng chưa có hợp đồng đủ rõ về việc màn nào được “nổi”, màn nào phải “lùi”.

## Shared widget mapping direction

| Design role | Preferred implementation area |
| --- | --- |
| Base tokens | `lib/core/theme/tokens/**` |
| Theme assembly | `lib/core/theme/app_theme.dart` |
| Typography mapping | `lib/core/theme/app_text_theme.dart` |
| Button primitives | `lib/presentation/shared/primitives/buttons/**` |
| Card primitives | `lib/presentation/shared/primitives/displays/**` |
| Layout shells | `lib/presentation/shared/layouts/**` |
| Form composites | `lib/presentation/shared/composites/forms/**` |
| State composites | `lib/presentation/shared/composites/states/**` |
| Study composites | `lib/presentation/shared/composites/study/**` |

## Rollout Plan

### Phase 1. Brand and token consolidation

- unify light and dark palette
- define semantic color roles
- preserve typography stack but tighten usage rules
- normalize shape and elevation roles

### Phase 2. Shared component alignment

- buttons
- cards
- inputs
- banners
- empty/error/loading states

### Phase 3. Screen family shells

- auth/onboarding
- dashboard/home
- library
- study
- progress
- settings/profile

### Phase 4. Study-first polish

- progress header
- answer feedback language
- mode transition consistency
- action priority consistency

### Phase 5. QA and review

- verify light and dark parity
- verify mobile/tablet/desktop parity
- verify accessibility and state stability
- verify no feature has drifted off the shared language

## Acceptance Checklist

- [ ] Light mode và dark mode giữ cùng một brand identity
- [ ] Home, library, study, progress, settings có cùng voice nhưng khác density đúng chủ đích
- [ ] Typography dùng đúng role, không lạm dụng display serif
- [ ] Mỗi vùng chỉ có một primary action rõ ràng
- [ ] Study flow giữ shell ổn định giữa các mode
- [ ] Shared widget được ưu tiên trước custom widget
- [ ] Loading, empty, error, success có grammar thống nhất
- [ ] Không có màn nào dùng gradient hoặc decorative styling quá mức
- [ ] Các semantic state color được dùng nhất quán
- [ ] Tài liệu này đủ chi tiết để bắt đầu implementation plan

## Decision Summary

Lumos sẽ theo hướng:

- `calm-focus learning system`
- `minimal utility` làm nền
- `editorial warmth` làm accent
- `study-first` cho flow quan trọng nhất

Ba quyết định thiết kế quan trọng nhất:

1. Một brand axis thống nhất giữa light và dark
2. Screen-family rules rõ ràng thay vì một kiểu card hóa cho toàn app
3. Shared theme và shared widgets là nơi giữ design language, không phải từng feature riêng lẻ
