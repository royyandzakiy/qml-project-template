import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    objectName: "mainWindow" // root of Spix item paths, e.g. "mainWindow/incrementButton"
    visible: true
    width: 480
    height: 320
    title: Qt.application.name + " (v" + Qt.application.version + ")"

    // C++ viewmodel, registered with QML_ELEMENT (src/viewmodels/counter_view_model.hpp)
    CounterViewModel {
        id: counter
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "Hello, QML"
            font.pixelSize: 24
        }

        CounterCard {
            objectName: "counterCard"
            Layout.alignment: Qt.AlignHCenter
            label: counter.label
            onIncrementClicked: counter.increment()
            onResetClicked: counter.reset()
        }
    }
}
