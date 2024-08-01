import QtQuick
import QtQuick.Controls
Button {
    id: button
    enabled: true
    topPadding: 20
    bottomPadding: 20
    leftPadding: 16
    rightPadding: 16
    anchors.fill: butRect
    flat: true

    background: Rectangle {
        id: butRect
        radius: 8
        height: 58
        color: button.enabled ? "#0073E6" : "lightgrey"
        border.width: button.enabled? (button.hovered? 2:0) : 0
        border.color: "orange"
        opacity: button.enabled ? 1.0 : 0.5

    }

    Text {
        anchors.centerIn: butRect
        font.family: "Body"
        font.weight: Font.Medium
    }

    MouseArea {
        id: mouseArea
        anchors.fill: butRect
        cursorShape: Qt.PointingHandCursor

        onEntered: button.hovered = true
        onExited: button.hovered = false

        onClicked: {
           if (button.enabled) {
               button.clicked()
           }
        }
    }
}
