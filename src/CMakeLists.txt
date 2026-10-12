# =============================================================================
# qt_qml_simple_hello — the Qt/QML application
# =============================================================================
# C++ entry point only; the UI lives in the App QML module under qml/.
# =============================================================================

# ---- Executable -------------------------------------------------------------
qt_add_executable(qt_qml_simple_hello)

# ---- Sources ----------------------------------------------------------------
target_sources(qt_qml_simple_hello
    PRIVATE
        main.cpp
)

# ---- Properties -------------------------------------------------------------
set_target_properties(qt_qml_simple_hello PROPERTIES
    WIN32_EXECUTABLE FALSE       # keep the console so qDebug / QML warnings are visible
    CXX_EXTENSIONS OFF
)

# ---- Compile Definitions ----------------------------------------------------
# Shown in the window title via Qt.application.version
target_compile_definitions(qt_qml_simple_hello
    PRIVATE
        APP_VERSION="${PROJECT_VERSION}"
)

# ---- Dependencies -----------------------------------------------------------
target_link_libraries(qt_qml_simple_hello
    PRIVATE
        app_qmlplugin            # static App QML module (qml/), imported in main.cpp
        Qt6::Quick
        Qt6::QuickControls2
)

# ---- Cross-Cutting Configuration --------------------------------------------
# PCH, unity build, profiler links, clang-tidy, ASan deploy — see cmake/configure_target.cmake
configure_target(qt_qml_simple_hello)
deploy_qt_runtime(qt_qml_simple_hello)

message(STATUS "qt_qml_simple_hello configured (Qt ${Qt6_VERSION})")
