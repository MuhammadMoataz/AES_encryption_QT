import QtQuick
import QtQuick.Dialogs

Item {
    id: root

    property string path
    property string size
    property string name

    FileDialog {
        id: openFileDialog
        acceptLabel: "Select"
        nameFilters: ["Text files (*.txt)"]
        title: "Select File"

        onAccepted: {
            save.enabled = true
            console.log("selected file " + openFileDialog.selectedFile)
            // call the encryption / decryption method according to the flag
        }

    }
}
