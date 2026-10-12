import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// Reusable piece of UI: shows a label and two buttons, knows nothing about where the data comes from.
Frame {
    id: card

    required property string label
    signal incrementClicked
    signal resetClicked

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: card.label
            font.pixelSize: 18
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8

            Button {
                text: "Click me"
                onClicked: card.incrementClicked()
            }
            Button {
                text: "Reset"
                onClicked: card.resetClicked()
            }
        }
    }
}
