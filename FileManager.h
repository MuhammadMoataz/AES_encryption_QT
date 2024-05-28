#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include <QFile>
#include <QDebug>
#include <qqml.h>

class FileManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit FileManager(QObject *parent = nullptr);
    Q_INVOKABLE QByteArray readFile(QString filePath);
signals:
};

#endif // FILEMANAGER_H
