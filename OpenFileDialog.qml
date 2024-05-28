import QtQuick
import QtQuick.Dialogs
import untitled




FileDialog {
    id: openFileDialog

    property string path
    property string size
    property string name

    acceptLabel: "Select"
    nameFilters: ["Text files (*.txt)"]
    title: "Select File"

    onAccepted: {
        save.enabled = true
        console.log("selected file " + openFileDialog.selectedFile)
        // call the encryption / decryption method according to the flag
        fileManager.readFile()
    }

    FileManager {
        id: fileManager
    }

}
