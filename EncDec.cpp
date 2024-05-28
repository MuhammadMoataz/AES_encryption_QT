#include "EncDec.h"

EncDec::EncDec(QObject *parent)
    : QObject{parent}
{}

QByteArray EncDec::encrypt(const QByteArray &plainText, const QByteArray &key, const QByteArray &iv) {
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    if (!ctx) {
        qDebug() << "Failed to create EVP_CIPHER_CTX";
        return QByteArray();
    }

    if (EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, (const unsigned char *)key.constData(), (const unsigned char *)iv.constData()) != 1) {
        qDebug() << "Failed to initialize encryption";
        EVP_CIPHER_CTX_free(ctx);
        return QByteArray();
    }

    int outlen1 = plainText.length() + EVP_CIPHER_CTX_block_size(ctx);
    unsigned char *cipherText = new unsigned char[outlen1];

    int outlen2;
    if (EVP_EncryptUpdate(ctx, cipherText, &outlen1, (const unsigned char *)plainText.constData(), plainText.length()) != 1) {
        qDebug() << "Failed to perform encryption";
        delete[] cipherText;
        EVP_CIPHER_CTX_free(ctx);
        return QByteArray();
    }

    if (EVP_EncryptFinal_ex(ctx, cipherText + outlen1, &outlen2) != 1) {
        qDebug() << "Failed to finalize encryption";
        delete[] cipherText;
        EVP_CIPHER_CTX_free(ctx);
        return QByteArray();
    }

    QByteArray encryptedData(reinterpret_cast<char *>(cipherText), outlen1 + outlen2);
    delete[] cipherText;
    EVP_CIPHER_CTX_free(ctx);
    return encryptedData;
}
