#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "tasktimer.h"
#include <QStyleHints>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

#if QT_VERSION >= QT_VERSION_CHECK(6, 8, 0)
    app.styleHints()->setColorScheme(Qt::ColorScheme::Light);
#endif

    qmlRegisterType<TaskTimer>("tasktimer", 1, 0, "TaskTimer");

    const QUrl url(QStringLiteral("qrc:/FocusAssist8/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
