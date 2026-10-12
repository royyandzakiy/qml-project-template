find_package(fmt CONFIG REQUIRED)
find_package(scn CONFIG REQUIRED)

# Qt comes from vcpkg (qtbase + qtdeclarative in vcpkg.json). Quick/Qml/QuickControls2 are all in qtdeclarative.
if(BUILD_APP)
  find_package(Qt6 6.8 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)
  qt_standard_project_setup(REQUIRES 6.8)
  set(QT_QML_GENERATE_QMLLS_INI ON) # writes .qmlls.ini so qmlls resolves the App module
endif()
