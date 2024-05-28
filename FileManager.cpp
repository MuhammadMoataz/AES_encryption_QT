#include "FileManager.h"

FileManager::FileManager(QObject *parent)
    : QObject{parent}
{}

QByteArray FileManager::readFile(QString filePath)
{
    filePath = filePath.last(filePath.size() - 8);
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
