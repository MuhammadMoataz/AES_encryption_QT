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
    width: 400
    height: 300
    // color: "black"

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
            Text {
                anchors.centerIn: parent
                text: "Encrypt"
                font.family: "Body"
                font.weight: Font.Medium
            }

            onClicked: {
                encryptFlag = true
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
                save.enabled = true
                console.log("selected file " + openFileDialog.selectedFile)
                // call the encryption / decryption method according to the flag
                var file = fileManager.readFile(openFileDialog.selectedFile)
                if (encryptFlag)
                    encryptManager.encryptAES(file, "password")
                else
                    encryptManager.decryptAES(file, "password")
            }
        }


        FileDialog {
            id: saveFileDialog
            acceptLabel: "Save"
            fileMode: FileDialog.SaveFile
            title: "Save Output file"
        }


        FileManager {
            id: fileManager
        }

    }


    RowLayout {
        id: passwordLayout
        width: parent.width - 40
        anchors.margins: 50
        anchors.top: buttonsLayout.bottom
        anchors.horizontalCenter: buttonsLayout.horizontalCenter
        spacing: 10

        PasswordField {
            id: password
            Layout.fillWidth: true
        }

    }





}
