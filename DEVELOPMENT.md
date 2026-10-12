# DEVELOPMENT

## Backlog

- write README.md (from README.md.template)
- add license

- linux
  - add Ubuntu CI job (scripts/setup-ubuntu.sh, offscreen tests, vcpkg binary cache)
  - verify Linux/macOS presets end to end (only Windows clang-cl is verified so far)
  - coverage target on Linux (setup_coverage_target is wired to unit_tests only)

- nexus-test-tool-qml migration
  - vcpkg: qtbase `widgets` feature (nexus uses QApplication + file dialogs), `qtserialport` port — each triggers a Qt rebuild
  - move nexus `core/` into src/core, viewmodels into src/viewmodels as QML_ELEMENT (drop setContextProperty)
  - add nexus qml/ files to QML_FILES in qml/CMakeLists.txt, fix `import "panels"`-style relative imports
  - Spix E2E for the USB flow

- other targets (build infra only, code layout carries over) — via PKG_MANAGER=none + a preset/toolchain
  - embedded linux (Yocto / Boot2Qt SDK, eglfs)
  - wasm (Qt for WebAssembly + emscripten)
  - android / ios (Qt installer kits, androiddeployqt)

- docs generator (doxygen with a modern theme)

## Known issues

- Quick 3D needs a GPU (RHI) backend: headless Linux tests (`QT_QPA_PLATFORM=offscreen`) may not render the 3D tab — use xvfb + Mesa (llvmpipe) on a Linux CI runner
- msvc-asan / clang-linux-asan / clang-linux-tsan not yet run with Qt in this template
- clang-cl ASan needs a release-CRT (/MD) build of every dependency incl. Qt — no preset for it
- QML tests find QtQuick.Controls through the app's deployed bin/<preset>/ — build the whole preset before ctest

## Skip

- MinGW: vcpkg Qt (x64-mingw-* triplets + static QML plugins) is too fragile
- Conan: no usable Qt
- MemorySanitizer: needs Qt itself built with MSan
- Qt for MCUs: different product, separate template
