#include "FileManager.h"

FileManager::FileManager(QObject *parent)
    : QObject{parent}
{}

QByteArray FileManager::readFile()
{
    QString filePath = "C:/Users/moham/OneDrive/Desktop/new.txt"; // Replace with your file path
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "Error opening file:" << filePath;
        return nullptr;
    }

    QByteArray fileContent = file.readAll();
    file.close();

    qDebug() << "File size:" << fileContent.size() << "bytes";
    qDebug() << "File Contents " << fileContent;
    return fileContent;
}
