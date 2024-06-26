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
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
public:
    QTemporaryFile tempFile{"tempFile"};
    explicit EncryptManager(QObject *parent = nullptr);

    Q_INVOKABLE bool saveTempFile(QString filename);

    int progress() const;

private:
    QByteArray password;
    void setPassword(const QByteArray& _password);
    void setProgress(int progress);
    int m_progress;

public slots:
    bool encryptAES(QString filePath, const QByteArray& passphrase, qint64 size);
    bool decryptAES(QString filePath, const QByteArray& passphrase, qint64 size);

signals:
    void progressChanged(int progress);
};

#endif // ENCRYPTMANAGER_H
