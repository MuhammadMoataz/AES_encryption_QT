#include "EncryptManager.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QQuickItem>
#include <openssl/sha.h>
#define KEYSIZE 32
#define IVSIZE 16  
#define BLOCKSIZE 4096
#define ITER 1000

EncryptManager::EncryptManager(QObject *parent)
    : QObject{parent}
{}

void EncryptManager::encryptSlot(QString filePath, const QByteArray &passphrase, qint64 size)
{
    std::thread myThread(std::bind(&EncryptManager::encryptAES, this, filePath, passphrase, size));
    myThread.detach();
}

void EncryptManager::decryptSlot(QString filePath, const QByteArray &passphrase, qint64 size)
{
    std::thread myThread(std::bind(&EncryptManager::decryptAES, this, filePath, passphrase, size));
    myThread.detach();
}

void EncryptManager::encryptAES(QString filePath, const QByteArray& passphrase, qint64 size) {
    int rounds = 1;
    unsigned char key[KEYSIZE];
    unsigned char iv[IVSIZE];
    int encryptedSize = 0;

    qDebug() << "Encryption password: " << passphrase;

    /* Reset ProgressBar using setProgress */
    setProgress(0);
    qDebug() << "Progress reset: " << this->m_progress;

    setPassword(passphrase);


    const unsigned char* password = (const unsigned char*) passphrase.constData();


    RAND_bytes(iv, IVSIZE);
    int i = EVP_BytesToKey(EVP_aes_256_cbc(), EVP_sha256(), nullptr, password, passphrase.length(),rounds,key,iv);
    // PKCS5_PBKDF2_HMAC(password, passphrase.length(), , , ITER, EVP_sha256(), )
    if(i != KEYSIZE)
    {
        qCritical() << "EVP_BytesToKey() error: " << ERR_error_string(ERR_get_error(), NULL);
        emit operationFinished(false);
        return;
    }

    EVP_CIPHER_CTX *en = EVP_CIPHER_CTX_new();
    EVP_CIPHER_CTX_init(en);
    if(!EVP_EncryptInit_ex(en, EVP_aes_256_cbc(),NULL,key,iv))
    {
        qCritical() << "EVP_EncryptInit_ex() failed " << ERR_error_string(ERR_get_error(), NULL);
        emit operationFinished(false);
        return;
    }

    if(!EVP_EncryptInit_ex(en, NULL, NULL, NULL, NULL)) {
        qCritical() << "EVP_EncryptInit ex() failed " << ERR_error_string(ERR_get_error(), NULL);
        emit operationFinished(false);
        return;
    }

    QFile file(filePath);
    QFile saveFile(this->m_filePath);

    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "Error opening file:" << filePath;
        emit operationFinished(false);
        return;
    }

    if (!saveFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Could not create save file";
        emit operationFinished(false);
        return;
    }

    saveFile.write("AES__");
    saveFile.write((char*)iv,IVSIZE);

    /* Write the key in the file */
    // char md_buf[KEYSIZE];
    // SHA256(key,32,(unsigned char*)md_buf);

    // saveFile.write(md_buf,5);

    while(!file.atEnd()) {
        setProgress((float)encryptedSize/size * 100);
        QByteArray data = file.read(BLOCKSIZE);
        const char *input = data.data();
        char *out;
        int len = data.size();

        int c_len=len + AES_BLOCK_SIZE, f_len = 0;
        char *ciphertext =(char*)malloc(c_len);


        // May have to repeat this for large files
        if(!EVP_EncryptUpdate(en, (unsigned char *) ciphertext, &c_len,(unsigned char *)input, len))
        {
            qCritical() << "EVP_EncryptUpdate() failed " << ERR_error_string(ERR_get_error(), NULL);
            emit operationFinished(false);
            return;
        }


        /* Save Ciphered text in the temp file */
        encryptedSize += BLOCKSIZE;
        saveFile.write(ciphertext, c_len);

        if (file.atEnd()) {
            setProgress((float)encryptedSize/size * 100);
            encryptedSize += BLOCKSIZE;
            if(!EVP_EncryptFinal_ex(en, (unsigned char *) ciphertext, &f_len))
            {
                qCritical() << "EVP_EncryptFinal_ex() failed " << ERR_error_string(ERR_get_error(), NULL);
                emit operationFinished(false);
                return;
            }


            saveFile.write(ciphertext, f_len);
            setProgress((float)encryptedSize/size * 100);
        }

        free(ciphertext);

    }

    file.close();
    saveFile.close();
    EVP_CIPHER_CTX_cleanup(en);

    emit operationFinished(true);
}




void EncryptManager::decryptAES(QString filePath, const QByteArray &passphrase, qint64 size)
{
    int rounds = 1;
    unsigned char key[KEYSIZE];
    unsigned char iv[IVSIZE];
    int decryptedSize = 0;

    qDebug() << "Dec password: " << passphrase;

    /* Reset the progressBar */
    setProgress(0);

    // if (QString::fromUtf8(passphrase) != this->password) emit operationFinished(false);

    QFile file(filePath);
    QFile saveFile(this->m_filePath);

    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "Error opening file:" << filePath;
        emit operationFinished(false);
        return;
    }
    if (!saveFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qCritical() << "Error creating save file:" << filePath;
        emit operationFinished(false);
        return;
    }

    if(QString(file.read(5)) != "AES__")
    {
        qDebug() << "file AES checkpoint failure";
        emit operationFinished(false);
        return;
    }

    file.read((char*)iv,IVSIZE);


    const unsigned char* password = (const unsigned char*) passphrase.constData();
    int i = EVP_BytesToKey(EVP_aes_256_cbc(), EVP_sha256(), nullptr, password, passphrase.length(),rounds,key,iv);
    if(i != KEYSIZE)
    {
        qCritical() << "EVP_BytesToKey() error: " << ERR_error_string(ERR_get_error(), NULL);
        emit decryptionAborted();
        return;
    }


    EVP_CIPHER_CTX *de = EVP_CIPHER_CTX_new();
    EVP_CIPHER_CTX_init(de);
    if(!EVP_DecryptInit_ex(de, EVP_aes_256_cbc(),NULL,key,iv))
    {
        qCritical() << "EVP_DecryptInit_ex() failed " << ERR_error_string(ERR_get_error(), NULL);
        emit decryptionAborted();
        return;
    }



    // char savedKey[KEYSIZE], shaKey[KEYSIZE];
    // SHA256(key,32,(unsigned char*)shaKey);

    // file.read(savedKey,5);

    // for (int i = 0; i < 5; i++) {
    //     if (savedKey[i] != shaKey[i])  {
    //         qDebug() << "savedKey check";
    //         emit operationFinished(false);
    //     }
    // }

    while (!file.atEnd()) {
        setProgress((float)decryptedSize/size * 100);
        QByteArray data = file.read(BLOCKSIZE);
        const char *input = data.data();
        int len = data.size();

        int p_len=len, f_len = 0;
        char *plaintext =(char*)malloc(p_len + AES_BLOCK_SIZE);

        if(!EVP_DecryptUpdate(de, (unsigned char *) plaintext, &p_len, (unsigned char *) input, len)) {
            qCritical() << "EVP_DecryptUpdate() failed " << ERR_error_string(ERR_get_error(), NULL);
            emit decryptionAborted();
            return;
        }

        /* Save Plain tet in the temp file */
        decryptedSize += BLOCKSIZE;
        saveFile.write(plaintext, p_len);

        if (file.atEnd()) {
            setProgress((float)decryptedSize/size * 100);
            decryptedSize += BLOCKSIZE;
            if(!EVP_DecryptFinal_ex(de, (unsigned char *) plaintext, &f_len))
            {
                qCritical() << "EVP_DecryptFinal_ex() failed " << ERR_error_string(ERR_get_error(), NULL);
                emit decryptionAborted();
                return;
            }

            saveFile.write(plaintext, f_len);
            setProgress((float)decryptedSize/size * 100);
        }

        free(plaintext);

    }

    file.close();
    saveFile.close();
    EVP_CIPHER_CTX_cleanup(de);
    emit operationFinished(true);
}






void EncryptManager::setPassword(const QByteArray& _password)
{
    this->password = _password;
}

int EncryptManager::progress() const
{
    return m_progress;
}

void EncryptManager::setProgress(int progress)
{
    if (m_progress == progress)
            return;

    m_progress = progress;
    emit progressChanged(m_progress); // Emit the signal with the new progress value
}


void EncryptManager::isEncryptedFile(QString filePath)
{
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "Error opening file:" << filePath;
        emit encryptionChecked(false);
        return;
    }

    if(QString(file.read(5)) != "AES__")
    {
        qDebug() << "Selected file is plaintext";
        emit encryptionChecked(false);
        return;
    }

    emit encryptionChecked(true);
}


void EncryptManager::setFilePath(QString filename)
{
    this->m_filePath = filename;
}









