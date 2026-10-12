find_package(fmt CONFIG REQUIRED)

# Qt comes from vcpkg (qtbase + qtdeclarative in vcpkg.json). Quick/Qml/QuickControls2 are all in qtdeclarative.
if(BUILD_APP)
  set(_qt_components Core Gui Qml Quick QuickControls2)
  if(BUILD_TESTING)
    list(APPEND _qt_components Test) # QtTest for the viewmodel tests (test/)
  endif()
  find_package(Qt6 6.8 REQUIRED COMPONENTS ${_qt_components})
  qt_standard_project_setup(REQUIRES 6.8)
  set(QT_QML_GENERATE_QMLLS_INI ON) # writes .qmlls.ini so qmlls resolves the App module
endif()
