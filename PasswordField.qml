import QtQuick
import QtQuick.Controls

Item {
    id: root




    TextField {
        id: passwordField
        width: parent.width
        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        topPadding: 17
        bottomPadding: 17
        rightPadding: 20
        leftPadding: 20

        background: Rectangle {
            id: borderRect
            width: parent.width
            height: 55
            color: "white"
            border.color: "black"
            border.width: 0.5
            radius: 8
            anchors.centerIn: parent
            Label {
                id: floatingLabel
                text: "Password"
                font.pixelSize: 18
                color: "lightgreen"
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
                color: "blue"
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






}
