# cmake/qt_deploy.cmake
# Copies the Qt runtime (platform plugin, QML imports like QtQuick/Controls) next to an executable
# so it runs in place from bin/. vcpkg's applocal step only copies the DLLs the exe links directly,
# not the plugins Qt loads at runtime.
#
# Call deploy_qt_runtime(<target>) AFTER the target is created. No-op off Windows.

function(deploy_qt_runtime target)
  if(NOT WIN32)
    return()
  endif()

  # vcpkg puts Qt host tools in <installed>/<triplet>/tools/Qt6/bin; Qt6_DIR is <installed>/<triplet>/share/Qt6.
  # The .debug.bat wrapper points windeployqt at the debug Qt DLLs and plugins.
  find_program(WINDEPLOYQT_EXE windeployqt HINTS "${Qt6_DIR}/../../tools/Qt6/bin" NO_DEFAULT_PATH)
  if(NOT WINDEPLOYQT_EXE)
    message(WARNING "[qt] windeployqt not found — ${target} may not start outside a Qt-aware environment")
    return()
  endif()
  get_filename_component(_qt_bin "${WINDEPLOYQT_EXE}" DIRECTORY)
  set(_deploy "$<IF:$<CONFIG:Debug>,${_qt_bin}/windeployqt.debug.bat,${WINDEPLOYQT_EXE}>")

  # Without qt.conf, vcpkg's Qt derives its plugin/QML paths from the vcpkg tree layout, not the
  # layout windeployqt creates, so QtQuick.Controls fails with "plugin qtquickcontrols2plugin not found".
  set(_qt_conf "${CMAKE_CURRENT_BINARY_DIR}/qt.conf")
  file(WRITE "${_qt_conf}" "[Paths]\nPrefix = .\nPlugins = .\nQmlImports = qml\n")

  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND "${_deploy}" --qmldir "${PROJECT_SOURCE_DIR}/qml" --no-translations --no-compiler-runtime
            --verbose 0 "$<TARGET_FILE:${target}>"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_qt_conf}" "$<TARGET_FILE_DIR:${target}>/qt.conf"
    COMMENT "windeployqt: deploying Qt runtime next to ${target}"
    VERBATIM)
endfunction()
