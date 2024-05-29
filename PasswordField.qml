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

    function passwordValidation(password) {

        // check whether the password is cleared
        if (password.length === 0) {
            firstIndicator.color = "grey"
            secondIndicator.color = "grey"
            thirdIndicator.color = "grey"
            helperText.text = "At least 8 characters long, 1 upper and lower case letter, 1 number and 1 special character"
            helperText.color = "grey"
            return
        }

        /* Using a regExp to validate the password input to match */
        /* At least 8 Characters long, 1 upper and lower case letter, 1 number and 1 special character */


        var regExp = /^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{8,}$/
        if (regExp.test(password)) {
            // valid Password, Check for length 2nd Requirement

            // Strong Password
            if (password.length >= 15) {
                firstIndicator.color = "green"
                secondIndicator.color = "green"
                thirdIndicator.color = "green"
                helperText.text = "Strong"
                helperText.color = "green"
            } else if (password.length >= 10) {
                firstIndicator.color = "orange"
                secondIndicator.color = "orange"
                thirdIndicator.color = "light grey"
                helperText.text = "Okay"
                helperText.color = "orange"
            }


        } else {
            firstIndicator.color = "red"
            secondIndicator.color = "light grey"
            thirdIndicator.color = "light grey"
            helperText.text = "Weak"
            helperText.color = "red"
        }
    }

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
        when: passwordField.focus || passwordField.length > 0
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

        passwordValidation(text)

    }
}





