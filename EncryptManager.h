#ifndef ENCRYPTMANAGER_H
#define ENCRYPTMANAGER_H

#include <qqml.h>
#include <QObject>
#include <QDebug>
#include <QFile>
#include <openssl/evp.h>
#include <openssl/rand.h>
#include <openssl/err.h>
#include <openssl/aes.h>
#include<QTemporaryFile>


class EncryptManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    QTemporaryFile tempFile{"tempFile"};
    explicit EncryptManager(QObject *parent = nullptr);
    Q_INVOKABLE QByteArray encryptAES(const QByteArray& data, const QByteArray& passphrase);
    Q_INVOKABLE QByteArray decryptAES(const QByteArray& data, const QByteArray& passphrase);
    void saveFile(const QByteArray& data);
    Q_INVOKABLE bool saveTempFile(QString filename);

signals:
};

#endif // ENCRYPTMANAGER_H
