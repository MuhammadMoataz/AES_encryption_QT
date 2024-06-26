#include "FileManager.h"

FileManager::FileManager(QObject *parent)
    : QObject{parent}
{}

QString FileManager::mimeType(const QString &filePath)
{
    return QMimeDatabase().mimeTypeForFile( filePath ).name();
}

void FileManager::getFileInfo(QString filePath)
{
    QFileInfo fileInfo(filePath);

    setExt(fileInfo.suffix());
    setSize(fileInfo.size());
    setPath(fileInfo.absoluteFilePath());

}

QString FileManager::getPath() const
{
    return m_path;
}

void FileManager::setPath(const QString &newPath)
{
    m_path = newPath;
}

QString FileManager::getExt() const
{
    return m_ext;
}

void FileManager::setExt(const QString &newExt)
{
    m_ext = newExt;
}

qint64 FileManager::getSize() const
{
    return m_size;
}

void FileManager::setSize(qint64 newSize)
{
    m_size = newSize;
}
