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



    FileManager {
        id: fileManager
    }


    EncryptManager {
        id: aes
    }

}
