#ifndef ENCDEC_H
#define ENCDEC_H

#include <QObject>

class EncDec : public QObject
{
    Q_OBJECT
public:
    explicit EncDec(QObject *parent = nullptr);

signals:
};

#endif // ENCDEC_H
