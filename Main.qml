import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import untitled


ApplicationWindow {
    id: root
    visible: true
    title: qsTr("Ur Encryptor")
    width: 500
    height: 300

    property bool encryptFlag: true

    RowLayout {
        id: buttonsLayout
        width: parent.width - 40
        anchors.margins: 20
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Button {
            id: encBut
            width: 80
            height: 20
            Layout.fillWidth: true
            Layout.minimumWidth: 80
            Layout.preferredWidth: 100
            Layout.maximumWidth: root.width
            topPadding: 20
            bottomPadding: 20
            leftPadding: 16
            rightPadding: 16
            // enabled: false
            Text {
                anchors.centerIn: parent
                text: "Encrypt"
                font.family: "Body"
                font.weight: Font.Medium
            }

            onClicked: {
                encryptFlag = true
                openFileDialog.nameFilters = ["Text files (*.txt)"]
                openFileDialog.open()
            }

        }
        Button {
            id: decBut
            width: 80
            height: 20
            Layout.fillWidth: true
            Layout.minimumWidth: 80
            Layout.preferredWidth: 100
            Layout.maximumWidth: root.width
            topPadding: 20
            bottomPadding: 20
            leftPadding: 16
            rightPadding: 16
            // enabled: false
            Text {
                anchors.centerIn: parent
                text: "Decrypt"
                font.family: "Body"
                font.weight: Font.Medium
            }
            onClicked: {
                encryptFlag = false
                openFileDialog.nameFilters = ["Enc files (*.enc)"]
                openFileDialog.open()

            }

        }

        Button {
            id: save
            width: 80
            height: 20
            Layout.fillWidth: true
            Layout.minimumWidth: 80
            Layout.preferredWidth: 100
            Layout.maximumWidth: 300
            enabled: false
            topPadding: 20
            bottomPadding: 20
            leftPadding: 16
            rightPadding: 16
            Text {
                anchors.centerIn: parent
                text: "Save"
                font.family: "Body"
                font.weight: Font.Medium
            }
            onClicked:{
                saveFileDialog.open()
            }

        }

        OpenFileDialog {
            id: openFileDialog
            nameFilters: {

                ["Text files (*.txt)"]
            }
            onAccepted: {
                console.log("selected file " + openFileDialog.selectedFile)
                // call the encryption / decryption method according to the flag
                var file = fileManager.readFile(openFileDialog.selectedFile)
                if (encryptFlag) {
                    encryptManager.encryptAES(file, password.text)
                    save.enabled = true
                }
                else {
                    if (encryptManager.decryptAES(file, password.text))
                        save.enabled = true
                    else {
                        helperText.text = "Wrong Password!"
                        helperText.color = "red"
                    }
                }
            }
        }


        FileDialog {
            id: saveFileDialog
            acceptLabel: "Save"
            fileMode: FileDialog.SaveFile
            title: "Save Output file"
            onAccepted: {
                var fullPath = selectedFile.toString()
                var path = fullPath.replace(/^(file:\/{3})/,"")
                encryptManager.saveTempFile(path)
                save.enabled = false
            }
        }


        FileManager {
            id: fileManager
        }

    }


    ColumnLayout {
        id: passwordLayout
        width: parent.width - 40
        anchors.margins: 20
        anchors.top: buttonsLayout.bottom
        anchors.horizontalCenter: buttonsLayout.horizontalCenter
        spacing: 8

        PasswordField {
            id: password
            width: parent.width
            // Lay
            // Layout.alignment: parent.alignment
            // anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillWidth: true
            onTextEdited: {

                passwordValidation(text)

                // if (passwordValidation(text)) {
                //     encBut.enabled = true
                //     decBut.enabled = true
                // }

            }
        }


        RowLayout {
            id: passwordIndicator
            spacing: 8
            // anchors.left: password.left
            Rectangle {
                id: firstIndicator
                height: 2
                Layout.fillWidth: true
                color: "light grey"
            }
            Rectangle {
                id: secondIndicator
                height: 2
                Layout.fillWidth: true
                color: "light grey"
            }
            Rectangle {
                id: thirdIndicator
                height: 2
                Layout.fillWidth: true
                color: "light grey"
            }
        }

        Rectangle {
            id: helperRect
            // anchors.left: passwordInputField.left
            // anchors.leftMargin: 20
            color: "red"
            Text {
                id: helperText
                text: qsTr("At least 8 characters long, 1 upper and lower case letter, 1 number and 1 special character")
                color: "grey"
            }

        }

    }





}
