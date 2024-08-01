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
    explicit EncryptManager(QObject *parent = nullptr);

    Q_INVOKABLE void setFilePath(QString filename);

    int progress() const;
private:
    void setPassword(const QByteArray& _password);
    void setProgress(int progress);
    void encryptAES(QString filePath, const QByteArray& passphrase, qint64 size);
    void decryptAES(QString filePath, const QByteArray& passphrase, qint64 size);

    int m_progress;
    QByteArray password;
    QString m_filePath;

public slots:

    void encryptSlot(QString filePath, const QByteArray& passphrase, qint64 size);
    void decryptSlot(QString filePath, const QByteArray& passphrase, qint64 size);
    void isEncryptedFile(QString filePath);

signals:
    void progressChanged(int progress);
    void operationFinished(bool valid);
    void encryptionChecked(bool isEncrypted);
    void encryptionAborted();
    void decryptionAborted();
};

#endif // ENCRYPTMANAGER_H
