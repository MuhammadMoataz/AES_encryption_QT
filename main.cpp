#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "EncryptManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    // QQuickStyle::setStyle("Fusion");
    QQmlApplicationEngine engine;
    EncryptManager *encryptManager = new EncryptManager(&app);
    engine.rootContext()->setContextProperty("encryptManager", encryptManager);
    const QUrl url(QStringLiteral("qrc:/untitled/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
