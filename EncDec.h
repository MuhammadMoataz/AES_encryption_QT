#ifndef ENCDEC_H
#define ENCDEC_H

#include <QObject>
#include <QDebug>
#include <openssl/evp.h>
#include <openssl/rand.h>
#include <openssl/des.h>

class EncDec : public QObject
{
    Q_OBJECT
public:
    explicit EncDec(QObject *parent = nullptr);
    static QByteArray encrypt(const QByteArray &plainText, const QByteArray &key, const QByteArray &iv);

signals:
};

#endif // ENCDEC_H
