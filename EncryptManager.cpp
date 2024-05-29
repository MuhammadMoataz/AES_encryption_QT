#include "EncryptManager.h"

#define KEYSIZE 32
#define IVSIZE 16  

EncryptManager::EncryptManager(QObject *parent)
    : QObject{parent}
{}



bool EncryptManager::encryptAES(const QByteArray& data, const QByteArray& passphrase) {
    int rounds = 1;
    unsigned char key[KEYSIZE];
    unsigned char iv[IVSIZE];

    qDebug() << "Encryption password: " << passphrase;

    setPassword(passphrase);


    const unsigned char* password = (const unsigned char*) passphrase.constData();
    int i = EVP_BytesToKey(EVP_aes_256_cbc(), EVP_sha256(), nullptr, password, passphrase.length(),rounds,key,iv);
    if(i != KEYSIZE)
    {
        qCritical() << "EVP_BytesToKey() error: " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }

    EVP_CIPHER_CTX *en = EVP_CIPHER_CTX_new();
    EVP_CIPHER_CTX_init(en);
    if(!EVP_EncryptInit_ex(en, EVP_aes_256_cbc(),NULL,key,iv))
    {
        qCritical() << "EVP_EncryptInit_ex() failed " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }

    const char *input = data.data();
    char *out;
    int len = data.size();

    int c_len=len + AES_BLOCK_SIZE, f_len = 0;
    unsigned char *ciphertext =(unsigned char*)malloc(c_len);
    if(!EVP_EncryptInit_ex(en, NULL, NULL, NULL, NULL)) {
        qCritical() << "EVP_EncryptInit ex() failed " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }

    // May have to repeat this for large files
    if(!EVP_EncryptUpdate(en, ciphertext, &c_len,(unsigned char *)input, len))
    {
        qCritical() << "EVP_EncryptUpdate() failed " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }

    if(!EVP_EncryptFinal_ex(en, ciphertext+c_len, &f_len))
    {
        qCritical() << "EVP_EncryptFinal_ex() failed " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }



    len = c_len + f_len;
    out = (char*)ciphertext;
    free(ciphertext);
    EVP_CIPHER_CTX_cleanup(en);

    QByteArray finished;
    finished.append(out,len);

    // save encrypted data to temp file
    saveFile(finished);
    return true;
}




bool EncryptManager::decryptAES(const QByteArray &data, const QByteArray &passphrase)
{
    int rounds = 1;
    unsigned char key[KEYSIZE];
    unsigned char iv[IVSIZE];

    qDebug() << "Dec password: " << passphrase;


    if (QString::fromUtf8(passphrase) != this->password) return false;


    const unsigned char* password = (const unsigned char*) passphrase.constData();
    int i = EVP_BytesToKey(EVP_aes_256_cbc(), EVP_sha256(), nullptr, password, passphrase.length(),rounds,key,iv);
    if(i != KEYSIZE)
    {
        qCritical() << "EVP_BytesToKey() error: " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }

    EVP_CIPHER_CTX *de = EVP_CIPHER_CTX_new();
    EVP_CIPHER_CTX_init(de);
    if(!EVP_DecryptInit_ex(de, EVP_aes_256_cbc(),NULL,key,iv))
    {
        qCritical() << "EVP_DecryptInit_ex() failed " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }

    const char *input = data.data();
    char *out;
    int len = data.size();

    int p_len=len, f_len = 0;
    unsigned char *plaintext =(unsigned char*)malloc(p_len + AES_BLOCK_SIZE);

    // repeat?
    if(!EVP_DecryptUpdate(de, plaintext, &p_len, (unsigned char *) input, len)) {
        qCritical() << "EVP_DecryptUpdate() failed " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }

    if(!EVP_DecryptFinal_ex(de, plaintext, &f_len))
    {
        qCritical() << "EVP_DecryptFinal_ex() failed " << ERR_error_string(ERR_get_error(), NULL);
        return false;
    }

    len = p_len + f_len;
    out = (char *) plaintext;
    EVP_CIPHER_CTX_cleanup(de);

    // save encrypted data to temp file
    QByteArray res = QByteArray(out, len);
    saveFile(res);
    return true;
}



void EncryptManager::saveFile(const QByteArray &data)
{
    if (!tempFile.open()) {
        qDebug() << "Could not create temporary file";
        return;
    }

    tempFile.write(data);
    tempFile.close();
}


bool EncryptManager::saveTempFile(QString filename)
{
    qDebug() << "saveTempFile called " << filename;
    // qDebug() << "temp file" << tempFile.read(1024);
    QFile file(filename);
    if(!tempFile.open())
    {
        qCritical() << tempFile.errorString();
        return false;
    }

    if(!file.open(QFile::WriteOnly))
    {
        qCritical() << file.errorString();
        return false;
    }


    while(tempFile.atEnd() != true)
    {
        file.write(tempFile.read(1024));
    }

    file.close();
    tempFile.close();
    tempFile.remove();
    return true;
}

void EncryptManager::setPassword(const QByteArray& _password)
{
    this->password = _password;
}








