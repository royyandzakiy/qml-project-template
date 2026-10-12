import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    visible: true
    width: 480
    height: 320
    title: "Qt QML Hello (v" + Qt.application.version + ")"

    property int clicks: 0

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "Hello, QML"
            font.pixelSize: 24
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: root.clicks === 0 ? "Click me" : "Clicked " + root.clicks + "x"
            onClicked: root.clicks++
        }
    }
}
