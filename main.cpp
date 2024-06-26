#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "EncryptManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    EncryptManager *encryptManager = new EncryptManager(&app);
    engine.rootContext()->setContextProperty("encryptManager", encryptManager);
    const QUrl url(QStringLiteral("qrc:/untitled/Main.qml"));
    QObject::connect(encryptManager, &EncryptManager::progressChanged, [&](int progress) {
        QObject *rootObject = engine.rootObjects().first();
        QMetaObject::invokeMethod(rootObject, "updateProgress", Q_ARG(QVariant, progress));
    });
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
