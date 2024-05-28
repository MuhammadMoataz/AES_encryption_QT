#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include <QFile>
#include <QDebug>
#include <qqml.h>
#include <QFileInfo>

class FileManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit FileManager(QObject *parent = nullptr);
    Q_INVOKABLE QByteArray readFile(QString filePath);
signals:
private:
    qint64 size;
    QString ext;
    QString path;
};

#endif // FILEMANAGER_H
