#ifndef ENCRYPTMANAGER_H
#define ENCRYPTMANAGER_H

#include <qqml.h>
#include <QObject>
#include <QDebug>
#include <QFile>
#include <thread>
#include <openssl/evp.h>
#include <openssl/rand.h>
#include <openssl/err.h>
#include <openssl/aes.h>
#include<QTemporaryFile>




class EncryptManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
public:
    QTemporaryFile tempFile{"tempFile"};
    explicit EncryptManager(QObject *parent = nullptr);

    Q_INVOKABLE bool saveTempFile(QString filename);

    int progress() const;

private:
    int m_progress;
    QByteArray password;

    void setPassword(const QByteArray& _password);
    void setProgress(int progress);
    void encryptAES(QString filePath, const QByteArray& passphrase, qint64 size);
    void decryptAES(QString filePath, const QByteArray& passphrase, qint64 size);

public slots:

    void encryptSlot(QString filePath, const QByteArray& passphrase, qint64 size);
    void decryptSlot(QString filePath, const QByteArray& passphrase, qint64 size);

signals:
    void progressChanged(int progress);
    void operationFinished(bool valid);
};

#endif // ENCRYPTMANAGER_H
