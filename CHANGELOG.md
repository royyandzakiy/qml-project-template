# Changelog

Notable changes to this template (condensed — not every commit). Newest first.

## 2026-10-12 — Cleanup for QML development
- Removed: Conan (`conanfile.py`, `config_conan.cmake`, profiles), `.devcontainer/`, `.run/` (CLion),
  `examples/`, Perfetto, ClangBuildAnalyzer, MSan, MinGW and `clang-cl-asan` presets, CI badge
  scripts, the version header, `VCPKG_MANIFEST_MODE`; `.codebase-memory/` untracked (local only).
- `PKG_MANAGER` is now `vcpkg | none` (`none` = bring your own Qt from an installer/SDK).
- Fixed: coverage flags now reach `app_core` (were applied after the targets); coverage is skipped
  with a warning on MSVC/clang-cl instead of breaking the link.
- Linux/macOS test presets run headless (`QT_QPA_PLATFORM=offscreen`); `setup-ubuntu.sh` installs
  vcpkg + Qt build deps instead of Conan.
- Added `.qmlformat.ini` + `[*.qml]` in `.editorconfig`, Qt VS Code extensions, QML/Qt Creator
  notes in `EDITOR_SETUP.md`; C++ formatting now also covers `test/`.

## 2026-10-12 — Qt/QML starter (forked from cpp-project-template)
- Single Qt 6.8 / QML app from vcpkg (clang-cl, `x64-windows`); `MyApp`, `MyLib` and the
  lib-only presets removed.
- Layout: `src/core/` (pure C++, no Qt), `src/viewmodels/` (`QML_ELEMENT` classes), `qml/`
  (static `App` QML module incl. `components/`), `resources/` (exe icon).
- `deploy_qt_runtime()` runs windeployqt + writes `qt.conf` so the app runs from `bin/<preset>/`;
  `cmake --install` / cpack ZIP produce a self-contained release folder.
- Tests: GTest on `core`, QtTest on the viewmodels. `format` / `format-check` also cover `.qml`.
- qtbase trimmed to the features QML needs; Tracy is an opt-in vcpkg feature; one output dir per preset.
- CI reduced to Windows clang-cl (debug + release) with a vcpkg binary cache.
- Qt Quick Test (`test/qml/tst_*.qml`): CounterCard component test + Main.qml smoke test.
- Spix E2E (`ENABLE_SPIX`, `clang-cl-e2e` preset): Python drives the real app over XML-RPC
  (`test/e2e/`). AnyRPC via vcpkg feature, Spix v0.14 via FetchContent. Test builds only.

## Before 2026-10-12
Inherited from [cpp-project-template](https://github.com/royyandzakiy/cpp-project-template) (presets,
vcpkg/clangd/clang-tidy setup, sanitizers, coverage, profilers, CI) — see its changelog for that history.
