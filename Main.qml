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
    width: 900
    height: 300

    property bool encryptFlag: true


    Text {
        id: fileStatusText
        text: "Please select your file"
        topPadding: 10
        elide: Text.ElideRight
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Body"
        font.weight: Font.Medium
        wrapMode: Text.WordWrap
    }

    ColumnLayout {
        id: buttons_progressbar_layout
        width: parent.width - 40
        anchors.margins: 20
        anchors.top: fileStatusText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15
        RowLayout {
            id: buttonsLayout
            width: parent.width - 40
            // anchors.margins: 20
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            property string filePath: ""
            property int size: 0

            CustomButton {
                id: selectBut
                Layout.fillWidth: true
                Layout.minimumWidth: 100
                Layout.preferredWidth: 150
                Layout.maximumWidth: 300
                text: "Select File"

                onClicked:{
                    encBut.enabled = false
                    decBut.enabled = false
                    progressBar.value = 0
                    helperText.text = "Please enter your Password!"
                    helperText.color = "red"
                    openFileDialog.open()
                }


            }

            CustomButton {
                id: encBut
                enabled: false
                Layout.fillWidth: true
                Layout.minimumWidth: 100
                Layout.preferredWidth: 150
                Layout.maximumWidth: 300
                text: "Encrypt"

                onClicked: {
                    if (password.validPassword) {
                        password.text = ""
                        encryptManager.encryptSlot(buttonsLayout.filePath, password, buttonsLayout.size)
                    } else {
                        helperText.text = "Please enter your Password!"
                        helperText.color = "red"
                    }
                }

            }
            CustomButton {
                id: decBut
                Layout.fillWidth: true
                Layout.minimumWidth: 100
                Layout.preferredWidth: 150
                Layout.maximumWidth: 300
                enabled: false
                text: "Decrypt"

                onClicked: {
                    if (password.validPassword) {
                        password.text = ""
                        encryptManager.decryptSlot(buttonsLayout.filePath, password, buttonsLayout.size)
                    } else {
                        helperText.text = "Please enter your Password!"
                        helperText.color = "red"
                    }
                }

            }



            OpenFileDialog {
                id: openFileDialog
                property bool validPassword: false

                Connections {
                    target: encryptManager
                    onOperationFinished: function(valid) {
                        openFileDialog.validPassword = valid
                        if (valid) {
                            helperText.text = "Success!!"
                            helperText.color = "green"
                            encBut.enabled = false
                            decBut.enabled = false
                            password.changePwIndicatorColor("green")
                        } else {
                            helperText.text = "Wrong Password!"
                            helperText.color = "red"
                            encBut.enabled = false
                            decBut.enabled = false
                            password.changePwIndicatorColor("red")
                        }
                    }

                    onDecryptionAborted: {
                        helperText.text = "Decryption Error!!"
                        helperText.color = "red"
                        decBut.enabled = false
                        progressBar.value = 0
                        password.changePwIndicatorColor("red")
                    }

                    onEncryptionAborted: {
                        helperText.text = "Encryption Error!!"
                        helperText.color = "red"
                        encBut.enabled = false
                        progressBar.value = 0
                        password.changePwIndicatorColor("red")
                    }

                    onEncryptionChecked: function(isEncrypted) {
                        if (isEncrypted === true) {
                            encBut.enabled = false
                            decBut.enabled = true
                            saveFileDialog.nameFilters = ["All files (*.*)"]

                        }
                        else if(isEncrypted === false) {
                            encBut.enabled = true
                            decBut.enabled = false
                            saveFileDialog.nameFilters = ["Enc files (*.enc)"]
                        }
                    }
                }

                onAccepted: {
                    var fullPath = openFileDialog.selectedFile.toString()
                    var file = fullPath.replace(/^(file:\/{3})/,"")
                    console.log("selected file " + file)

                    //Update: show file info
                    fileManager.getFileInfo(file)
                    var ext = fileManager.getExt()
                    var path = fileManager.getPath()
                    var size = fileManager.getSize()


                    console.log("file ext " + ext)
                    console.log("file path " + path)
                    console.log("file size " + size)

                    fileStatusText.text = "File : " + path +
                            ", File size: " + formatFileSize(size) +", " + "File Type: " + fileManager.mimeType(file)
                    buttonsLayout.filePath = path
                    buttonsLayout.size = size
                    encryptManager.isEncryptedFile(path)
                    saveFileDialog.open()
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
                    // TODO
                    encryptManager.setFilePath(path)
                }
            }


            FileManager {
                id: fileManager
            }

        }

        ProgressBar {
            id: progressBar
            from: 0
            to: 100
            value: 0
            Layout.fillWidth: true

            // anchors.top: buttonsLayout.bottom
            // anchors.left: buttonsLayout.left
            // anchors.margins: 8
            // anchors.leftMargin: 0
        }




        Item {
            width: parent.width
            Layout.fillWidth: true
            ColumnLayout {
                width: parent.width
                spacing: 4

                PasswordField {
                    id: password
                    width: parent.width
                    Layout.fillWidth: true
                    onTextEdited: {

                        if (passwordValidation(text)) {
                            encBut.enabled = true
                            decBut.enabled = true
                        }

                    }
                }


                RowLayout {
                    id: passwordIndicator
                    spacing: 8
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
                    color: "red"
                    Text {
                        id: helperText
                        text: qsTr("At least 8 characters long, 1 upper and lower case letter, 1 number and 1 special character")
                        color: "grey"
                    }

                }
            }


        }


    }

    ColumnLayout {
        id: passwordLayout
        width: parent.width - 40
        anchors.margins: 30
        anchors.top: buttons_progressbar_layout.bottom
        anchors.horizontalCenter: buttons_progressbar_layout.horizontalCenter
        spacing: 8



    }


    function validateFileExt(ext) {
        return ext !== "enc"
    }

    function updateProgress(progress) {
        progressBar.value = progress
    }

    function formatFileSize(size) {
        const units = ['B', 'KB', 'MB', 'GB', 'TB'];
        let unitIndex = 0;

        while (size >= 1024 && unitIndex < units.length - 1) {
            size /= 1024;
            unitIndex++;
        }

        return `${size.toFixed(2)} ${units[unitIndex]}`;
    }


}
