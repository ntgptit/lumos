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
2. the mode-specific Flutter skill if the task clearly fits one:
   - `C:\Users\ntgpt\.codex\skills\flutter-full-app\SKILL.md`
   - `C:\Users\ntgpt\.codex\skills\flutter-frontend-client\SKILL.md`
3. `C:\Users\ntgpt\.codex\flutter_architecture_checklist.md`

Repo-specific rules for Flutter:

- `Riverpod Annotation + DI` is required.
- `go_router` is required.
- `retrofit + dio` is required for remote HTTP integration.
- `pretty_dio_logger` is preferred for debug or personal-app development only.
- `lib/common/widgets` must stay render-only.
- Do not use `setState` as the main architecture.
- Do not use `else`.
- Use Material 3 theme, density, and component behavior.
- Use centralized theme tokens under `lib/core/themes/**`.

Flutter verification after code changes:

```bash
flutter pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
dart run tool/verify_frontend_checklists.dart
dart run custom_lint
flutter analyze
flutter test
```

Default Flutter rule:

- run the consolidated verifier `dart run tool/verify_frontend_checklists.dart`
- do not run individual guard scripts unless debugging a specific failure

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
