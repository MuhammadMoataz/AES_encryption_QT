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

    Text {
        id: fileStatusText
        text: "Please upload your file"
        topPadding: 10
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Body"
        font.weight: Font.Medium
    }

    ColumnLayout {
        id: buttons_progressbar_layout
        width: parent.width - 40
        anchors.margins: 20
        anchors.top: fileStatusText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8


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
                    if(password.validPassword) {
                        encryptFlag = true
                        openFileDialog.nameFilters = ["Plain files (*.*)"]
                        openFileDialog.open()
                    } else {
                        helperText.text = "Please enter your Password!"
                        helperText.color = "red"
                    }
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
                    if (password.validPassword) {
                        encryptFlag = false
                        openFileDialog.nameFilters = ["Enc files (*.enc)"]
                        openFileDialog.open()
                    } else {
                        helperText.text = "Please enter your Password!"
                        helperText.color = "red"
                    }
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



                onAccepted: {
                    var fullPath = openFileDialog.selectedFile.toString()
                    var file = fullPath.replace(/^(file:\/{3})/,"")
                    console.log("selected file " + file)

                    //Update: show file info
                    fileManager.getFileInfo(file)
                    var ext = fileManager.getExt()
                    var path = fileManager.getPath()
                    var size = fileManager.getSize()


                    /* validate file extension in the encryption operation */
                    var validFileExt = true
                    if (encryptFlag)
                        validFileExt = validateFileExt(ext)

                    if (!validFileExt) {
                        fileStatusText.text = "Cannot encrypt already encrypted file"
                        return
                    }


                    console.log("file ext " + ext)
                    console.log("file path " + path)
                    console.log("file size " + size)

                    fileStatusText.text = "File : " + path +
                            " File size: " + size/1024 +" KB " + "File Type: " + fileManager.mimeType(file)




                    // call the encryption / decryption method according to the flag
                    if (encryptFlag) {
                        startEnc(file, password.text, size)
                        save.enabled = true
                    }
                    else {
                        if (encryptManager.decryptAES(file, password.text, size))
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
                    // TODO
                    encryptManager.saveTempFile(path)
                    save.enabled = false
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
            anchors.top: buttonsLayout.bottom
            anchors.left: buttonsLayout.left
            anchors.margins: 8
            anchors.leftMargin: 0

        }
    }

    ColumnLayout {
        id: passwordLayout
        width: parent.width - 40
        anchors.margins: 30
        anchors.top: buttons_progressbar_layout.bottom
        anchors.horizontalCenter: buttons_progressbar_layout.horizontalCenter
        spacing: 8

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


    function validateFileExt(ext) {
        return ext !== "enc"
    }

    function updateProgress(progress) {
        progressBar.value = progress
    }


}
