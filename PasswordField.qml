import QtQuick
import QtQuick.Controls
import QtQuick.Layouts




TextField {
    id: passwordField
    topPadding: 17
    bottomPadding: 17
    rightPadding: 20
    leftPadding: 20
    height: 55

    background: Rectangle {
        id: borderRect
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: "white"
        border.color: "light grey"
        border.width: 0.5
        radius: 8
        anchors.centerIn: parent
        anchors.top: passwordField.top
        Label {
            id: floatingLabel
            text: "Password"
            font.pixelSize: 18
            color: "grey"
            anchors.bottom: borderRect.top
            anchors.bottomMargin: -10
            anchors.left: borderRect.left
            anchors.leftMargin: 20

        }
    }

    placeholderText: "Enter Password"
    echoMode: TextInput.Password
    inputMethodHints: Qt.ImhHiddenText
    passwordMaskDelay: 500



    states: State {
        name: "focused"
        when: passwordField.focus || passwordField.text.length > 0
        PropertyChanges {
            target: floatingLabel
            anchors.verticalCenter: undefined
            anchors.bottom: parent.top
            anchors.bottomMargin: -10
            font.pixelSize: 12
            color: "black"
            opacity: 1.0
        }
    }

    transitions: Transition {
        from: ""
        to: "focused"
        reversible: true
        NumberAnimation {
            properties: "anchors.bottomMargin, font.pixelSize, opacity"
            duration: 200
        }
    }

    onTextEdited: {
        console.log("text changed")
    }
}





