# AGENTS.md

## Intent

This repo contains:

- a Flutter application at the repository root
- a Spring Boot API service under `lumos-api-service/`

Use the existing Codex skills as the primary implementation guidance. Use repo-local guards and CI-style gates as the final source of truth when there is any conflict.

## Priority

Within this repository, use this order:

1. this `AGENTS.md`
2. the relevant skill
3. repo-local guard scripts and checklists

If a skill and a repo-local guard disagree, prefer the repo-local guard for this repository.

## Routing

### Flutter app

Use Flutter guidance when the task touches:

- `lib/**`
- `test/**`
- `tool/**`
- Flutter project files at the repo root

Load these in order:

1. `C:\Users\ntgpt\.codex\skills\flutter-app-development\SKILL.md`
2. if the task is implementing or reviewing Flutter UI from provided wireframe or mockup images, also load:
   - `C:\Users\ntgpt\.codex\skills\flutter-wireframe-to-ui\SKILL.md`
3. the mode-specific Flutter skill if the task clearly fits one:
   - `C:\Users\ntgpt\.codex\skills\flutter-full-app\SKILL.md`
   - `C:\Users\ntgpt\.codex\skills\flutter-frontend-client\SKILL.md`
4. `C:\Users\ntgpt\.codex\flutter_architecture_checklist.md`
5. `D:\workspace\lumos\00_docs\architecture\flutter\memora_flutter_architecture_contract.md`

Repo-specific rules for Flutter:

- `D:\workspace\lumos\00_docs\architecture\flutter\memora_flutter_architecture_contract.md` is the authoritative repo-local contract for Flutter folder placement, shared UI boundaries, feature sequencing, and study-mode structure.
- `Riverpod Annotation + DI` is required.
- `go_router` is required.
- `retrofit + dio` is required for remote HTTP integration.
- `pretty_dio_logger` is preferred for debug or personal-app development only.
- `lib/common/widgets` must stay render-only.
- For wireframe-driven UI work, AI must analyze the wireframe first and write a UI Contract before any code.
- For wireframe-driven UI work, AI must convert the wireframe into a UI Section Table before writing hierarchy or code.
- For wireframe-driven UI work, the UI Section Table must start with these columns: `Section`, `Position`, `Responsibility`, `Data Source`.
- For wireframe-driven UI work, AI must analyze all interactions first, split Frontend versus Backend responsibility, explain why each interaction belongs to FE or BE, and identify logic that must not be placed in Flutter UI.
- For wireframe-driven UI work, AI must write an Interaction Contract table with: `Interaction`, `FE Responsibility`, `BE Responsibility`, `Reason`.
- For wireframe-driven UI work, AI must classify responsibilities into `Presentation`, `Application`, `Domain`, and `Infrastructure` before code generation.
- For wireframe-driven UI work, AI must define API contracts before code generation.
- For wireframe-driven UI work, AI must describe frontend ViewModel state binding before code generation.
- For wireframe-driven UI work, AI must write an implementation plan for backend (`Controller`, `Service`, `Repository`) and frontend (`Screen`, `Widgets`, `ViewModel`) before code generation.
- For wireframe-driven UI work, AI must preserve the architecture flow `Flutter UI -> ViewModel -> Repository -> API -> Backend service`.
- For wireframe-driven UI work, AI must write the Widget Tree first before implementing code.
- For wireframe-driven UI work, the Widget Tree order must match the wireframe exactly.
- For wireframe-driven UI work, after generating the Widget Tree AI must validate it against the wireframe: compare it, confirm all sections exist, confirm order is identical, and confirm no section is missing.
- For wireframe-driven UI work, AI must separate UI behavior by section and identify how sections react to each other before implementation.
- For wireframe-driven UI work, AI must not redesign the layout, must not merge UI sections, must not reorder components, and must follow the wireframe layout exactly.
- For wireframe-driven UI work, AI must use this UI validation checklist: `[ ] All wireframe sections implemented`, `[ ] Section order preserved`, `[ ] No layout redesign`, `[ ] No missing components`.
- For wireframe-driven UI work, mapping to existing Shared Widget(s) is mandatory before creating any new widget.
- Do not create a new Flutter widget by default if an existing Shared Widget can be adapted.
- Shared widget prefixes may differ, but AI must explicitly look for existing equivalents of `AppScaffold`, `SectionContainer`, `PrimaryButton`, `SecondaryButton`, `AppTextField`, `AppDropdown`, `DataTableView`, `AppCard`, and `AppSpacing` before building custom UI pieces.
- For wireframe-driven UI work, spacing must follow centralized design-common tokens and existing spacing helpers from the Flutter app architecture, not ad hoc `SizedBox` or `EdgeInsets` literals.
- For wireframe-driven UI work, AI must prevent layout shift across loading, empty, error, validation, and interaction states by keeping the page shell and major regions structurally stable.
- For wireframe-driven UI work, AI must follow the app's existing Flutter file structure strictly and place files only in the correct layer and feature folders.
- Do not use `setState` as the main architecture.
- Do not use `else`.
- Use Material 3 theme, density, and component behavior.
- Use centralized theme tokens under `lib/core/theme/**`.

Flutter verification strategy:

- Do not run the full Flutter suite by default.
- Choose the smallest verification level that matches the affected files.
- Escalate one level when a selected check fails unexpectedly or when the change radius is unclear.
- Always report which verification level was used.

Verification triggers:

- Run `flutter pub get` only when `pubspec.yaml`, `pubspec.lock`, dependency declarations, or Flutter tooling setup change.
- Run `flutter gen-l10n` only when files under `lib/l10n/*.arb` change.
- Run `flutter pub run build_runner build --delete-conflicting-outputs` only when touching generated-code inputs:
  - files using `@riverpod`
  - files using `@freezed`
  - files using `@JsonSerializable`
  - files using `@RestApi`
  - files declaring `part '*.g.dart'` or `part '*.freezed.dart'`

Verification level 1: Fast path

- Use for leaf UI or copy changes limited to feature files under `lib/presentation/features/**`
- Do not use when touching `lib/presentation/shared/**`, `lib/core/**`, `lib/app/**`, `lib/l10n/**`, or `tool/**`
- Do not use when touching providers, routing, DI, generated-code inputs, or shared design system primitives

Run:

```bash
flutter analyze <changed_files_or_changed_feature_dirs>
flutter test <affected_test_files_or_feature_test_dirs_if_they_exist>
```

Verification level 2: Standard feature path

- Use for feature-level state, repository, navigation, DTO, or multi-file feature changes
- Use when the change is bigger than a leaf widget patch but still not app-wide
- Prefer targeted `flutter analyze` and targeted `flutter test` after the guard pass

Run regeneration commands only if their trigger applies, then run:

```bash
dart run tool/verify_frontend_checklists.dart
flutter analyze <changed_files_or_changed_feature_dirs>
flutter test <affected_test_files_or_feature_test_dirs_if_they_exist>
```

Verification level 3: Full gate

- Use for changes in `lib/presentation/shared/**`
- Use for changes in `lib/core/**`
- Use for changes in `lib/app/**`
- Use for changes in `lib/l10n/**`
- Use for changes in `tool/**`
- Use for theme, auth, network, routing, DI, generated-code architecture, and cross-feature refactors
- Use before commit or push unless the user explicitly asks for a narrower local verification only

Run regeneration commands only if their trigger applies, then run:

```bash
dart run tool/verify_frontend_checklists.dart
dart run custom_lint
flutter analyze
flutter test
```

Default Flutter rule:

- For inner-loop implementation, prefer verification level 1 or level 2.
- Use the consolidated verifier `dart run tool/verify_frontend_checklists.dart` for level 2 and level 3, not for every leaf widget edit.
- Do not run `flutter pub get`, `flutter gen-l10n`, `build_runner`, or `custom_lint` unless their trigger or verification level requires them.
- Do not run individual guard scripts unless debugging a specific failure.

### Spring Boot API

Use backend guidance when the task touches:

- `lumos-api-service/**`

Load:

1. `C:\Users\ntgpt\.codex\skills\spring-boot-rest-api\SKILL.md`

Repo-specific rules for Spring Boot:

- This backend uses Spring Boot + JPA guard rules.
- Apply the repo backend guard as the final authority for generated or patched code.
- Prefer `JpaSpecificationExecutor` for JPA dynamic search.
- Prefer `Flyway` for migrations.
- Follow constant-first, fail-fast, no-else, and no-hardcode structure.

Backend verification after code changes inside `lumos-api-service/`:

```bash
cd lumos-api-service
python tool/verify_backend_checklists.py
```

Use strict mode when the task is explicitly a review or quality-hardening pass:

```bash
cd lumos-api-service
python tool/verify_backend_checklists.py --strict
```

## Mixed tasks

If a task touches both Flutter and Spring Boot:

- load both relevant skills
- keep each side inside its own boundaries
- do not leak backend rules into Flutter or Flutter rules into backend

## Code generation rules

These rules apply to both app areas unless a stronger repo-local guard overrides them:

- one public type per file
- constants first
- no magic numbers or magic values
- no `else`
- fail fast
- early return
- early throw
- no business logic in controllers or widgets
- use semantic naming
- keep architecture boundaries explicit

## Review rules

When asked to review:

- focus first on bugs, regressions, boundary violations, contract drift, and missing tests
- prefer findings over summary
- cite exact files and lines where possible

For Flutter reviews, verify:

- guard compliance
- shared widget boundaries
- Riverpod Annotation + DI usage
- M3 theming and token usage

For backend reviews, verify:

- backend guard compliance
- JPA branch correctness
- DTO, exception, logging, and message-key conventions

## Output rules

- Prefer patch, diff, or concise snippets over full-file dumps unless the user asks for full files.
- Keep responses short and concrete.
- If a required verification step cannot run, state exactly which step failed and why.
