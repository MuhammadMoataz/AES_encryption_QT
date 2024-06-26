import QtQuick
import QtQuick.Dialogs
import untitled



FileDialog {
    id: openFileDialog
    objectName: "openFileDialog"

    signal startEnc(string file,string password,int size)

    property string path
    property string size
    property string name

    acceptLabel: "Select"
    title: "Select File"



    FileManager {
        id: fileManager
    }


    EncryptManager {
        id: aes
    }

}
