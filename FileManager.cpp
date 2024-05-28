#include "FileManager.h"

FileManager::FileManager(QObject *parent)
    : QObject{parent}, ext{""}
{}

QByteArray FileManager::readFile(QString filePath)
{
    filePath = filePath.last(filePath.size() - 8);
    QFileInfo fileInfo(filePath);
    ext = fileInfo.suffix();
    size = fileInfo.size();
    path = fileInfo.absoluteFilePath();


    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "Error opening file:" << filePath;
        return nullptr;
    }

    QByteArray fileContent = file.readAll();
    file.close();

    qDebug() << "File size: " << size << "File path " << path << "File ext " << ext;
    return fileContent;
}
