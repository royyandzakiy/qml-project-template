# =============================================================================
# App QML module — every .qml file the app loads lives here
# =============================================================================
# A STATIC module linked into the executable through its plugin target (app_qmlplugin), so the
# QML files stay in qml/ (same layout as nexus-test-tool-qml) instead of next to main.cpp.
# Add new .qml files to QML_FILES; C++ QML_ELEMENT types can go in SOURCES later.
# =============================================================================

qt_add_qml_module(app_qml
    URI App
    VERSION 1.0
    STATIC
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/App # must end in the URI path, or qmllint/qmlls can't resolve it
    QML_FILES
        Main.qml
)
