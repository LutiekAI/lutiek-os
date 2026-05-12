#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QUrl>
#include <QDir>
#include <QFile>
#include <QStandardPaths>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    app.setApplicationName("Lutiek Launcher");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("Lutiek");
    app.setOrganizationDomain("lutiek.com");

    QQuickStyle::setStyle("org.kde.desktop");

    QQmlApplicationEngine engine;

    QDir("~/.config/lutiek-launcher").mkpath("~");

    QUrl url = QUrl::fromLocalQml("qrc:/qml/Main.qml");

    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QCoreApplication::quit);
    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}