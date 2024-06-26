#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include <QFile>
#include <QDebug>
#include <qqml.h>
#include <QFileInfo>
#include <QMimeDatabase>

class FileManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(qint64 size READ getSize WRITE setSize)
    Q_PROPERTY(QString ext READ getExt WRITE setExt)
    Q_PROPERTY(QString path READ getPath WRITE setPath)
public:
    explicit FileManager(QObject *parent = nullptr);
    Q_INVOKABLE QString mimeType(const QString &filePath);
    Q_INVOKABLE void getFileInfo(QString filePath);
    Q_INVOKABLE QString getPath() const;
    void setPath(const QString &newPath);

    Q_INVOKABLE QString getExt() const;
    void setExt(const QString &newExt);

    Q_INVOKABLE qint64 getSize() const;
    void setSize(qint64 newSize);

signals:
private:

    QString m_path;
    QString m_ext;
    qint64 m_size;
};

#endif // FILEMANAGER_H
