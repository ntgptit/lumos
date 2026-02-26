# lumos

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Code Quality

- Analyzer config is defined in `analysis_options.yaml` and inherits `flutter_lints`.
- Additional local rules are enabled for stricter consistency.

## Auto Format

- Run formatter manually:

```bash
dart format lib test tool
```

- VS Code project settings already enable `formatOnSave` for Dart in `.vscode/settings.json`.

## Pre-commit Hook

Install repository hooks once:

```powershell
powershell -ExecutionPolicy Bypass -File tool/install_git_hooks.ps1
```

Pre-commit will run:

- `dart format --set-exit-if-changed lib test tool`
- `flutter analyze`
- `flutter test`

If you prefer Node workflow, you can replace this with Husky + lint-staged.

## Run Frontend (FE)

Run commands from project root `D:/workspace/lumos`:

```bash
flutter pub get
flutter run -d chrome
```

Optional targets:

```bash
flutter devices
flutter run -d android
flutter run -d ios
```

Build FE (web release):

```bash
flutter build web --release
```
