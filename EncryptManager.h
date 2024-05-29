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
    Q_INVOKABLE bool encryptAES(const QByteArray& data, const QByteArray& passphrase);
    Q_INVOKABLE bool decryptAES(const QByteArray& data, const QByteArray& passphrase);
    void saveFile(const QByteArray& data);
    Q_INVOKABLE bool saveTempFile(QString filename);

private:
    QByteArray password;
    void setPassword(const QByteArray& _password);

signals:
};

#endif // ENCRYPTMANAGER_H
