# cmake/qt_deploy.cmake
# Makes a Qt/QML executable runnable outside a Qt-aware environment (Windows only, no-op elsewhere):
#   deploy_qt_runtime(<target>)                      — dev time: next to the exe in bin/<preset>/
#   install_qt_runtime(<target> DESTINATION <dir>)   — install time: `cmake --install` / cpack
#
# Both run windeployqt (Qt DLLs, platform plugin, QML imports such as QtQuick.Controls) and drop a
# qt.conf next to the exe. Without qt.conf, vcpkg's Qt derives its plugin/QML paths from the vcpkg
# tree layout, not the layout windeployqt creates, so QtQuick.Controls fails with
# "plugin qtquickcontrols2plugin not found".
#
# Call both AFTER the target is created (install_qt_runtime after its install(TARGETS)).

# Sets _windeployqt (a $<CONFIG>-aware genex) and _qt_conf in the caller's scope; returns FALSE if
# windeployqt is missing.
function(_qt_deploy_setup out_ok)
  set(${out_ok} FALSE PARENT_SCOPE)
  if(NOT WIN32)
    return()
  endif()
  # vcpkg puts Qt host tools in <installed>/<triplet>/tools/Qt6/bin; Qt6_DIR is <installed>/<triplet>/share/Qt6.
  # The .debug.bat wrapper points windeployqt at the debug Qt DLLs and plugins.
  find_program(WINDEPLOYQT_EXE windeployqt HINTS "${Qt6_DIR}/../../tools/Qt6/bin" NO_DEFAULT_PATH)
  if(NOT WINDEPLOYQT_EXE)
    message(WARNING "[qt] windeployqt not found — the app may not start outside a Qt-aware environment")
    return()
  endif()
  get_filename_component(_qt_bin "${WINDEPLOYQT_EXE}" DIRECTORY)
  set(_windeployqt "$<IF:$<CONFIG:Debug>,${_qt_bin}/windeployqt.debug.bat,${WINDEPLOYQT_EXE}>" PARENT_SCOPE)

  set(_conf "${CMAKE_BINARY_DIR}/qt.conf")
  file(WRITE "${_conf}" "[Paths]\nPrefix = .\nPlugins = .\nQmlImports = qml\n")
  set(_qt_conf "${_conf}" PARENT_SCOPE)
  set(${out_ok} TRUE PARENT_SCOPE)
endfunction()

set(_WINDEPLOYQT_ARGS --qmldir "${PROJECT_SOURCE_DIR}/qml" --no-translations --no-compiler-runtime --verbose 0)

function(deploy_qt_runtime target)
  _qt_deploy_setup(_ok)
  if(NOT _ok)
    return()
  endif()
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND "${_windeployqt}" ${_WINDEPLOYQT_ARGS} "$<TARGET_FILE:${target}>"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_qt_conf}" "$<TARGET_FILE_DIR:${target}>/qt.conf"
    COMMENT "windeployqt: deploying Qt runtime next to ${target}"
    VERBATIM)
endfunction()

function(install_qt_runtime target)
  cmake_parse_arguments(PARSE_ARGV 1 arg "" "DESTINATION" "")
  _qt_deploy_setup(_ok)
  if(NOT _ok)
    return()
  endif()

  # Non-Qt runtime DLLs from vcpkg (freetype, harfbuzz, pcre2, zlib, fmt, ...). At build time the vcpkg
  # toolchain copies these next to the exe; at install time it only does so when asked.
  if(COMMAND x_vcpkg_install_local_dependencies)
    x_vcpkg_install_local_dependencies(TARGETS ${target} DESTINATION "${arg_DESTINATION}")
  endif()

  # \${CMAKE_INSTALL_PREFIX} is resolved at install time, so cpack's staging prefix works too.
  # cmd /c so the Debug .bat wrapper runs as well as the Release .exe.
  list(JOIN _WINDEPLOYQT_ARGS "\" \"" _args)
  install(
    CODE "
    set(_exe \"\${CMAKE_INSTALL_PREFIX}/${arg_DESTINATION}/$<TARGET_FILE_NAME:${target}>\")
    message(STATUS \"windeployqt: deploying Qt runtime next to \${_exe}\")
    execute_process(COMMAND cmd /c \"${_windeployqt}\" \"${_args}\" \"\${_exe}\" RESULT_VARIABLE _rc)
    if(NOT _rc EQUAL 0)
      message(FATAL_ERROR \"windeployqt failed (\${_rc})\")
    endif()
    file(COPY \"${_qt_conf}\" DESTINATION \"\${CMAKE_INSTALL_PREFIX}/${arg_DESTINATION}\")")
endfunction()
