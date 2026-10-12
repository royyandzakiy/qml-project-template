#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtQml/QQmlExtensionPlugin>

// The App QML module (qml/) is a static library; this pulls its plugin into the binary.
Q_IMPORT_QML_PLUGIN(AppPlugin)

auto main(int argc, char *argv[]) -> int {
	const QGuiApplication app(argc, argv);
	QGuiApplication::setApplicationName(APP_NAME);
	QGuiApplication::setApplicationVersion(APP_VERSION);

	QQuickStyle::setStyle("Fusion");

	QQmlApplicationEngine engine;
	QObject::connect(
		&engine, &QQmlApplicationEngine::objectCreationFailed, &app, [] { QCoreApplication::exit(-1); },
		Qt::QueuedConnection);
	engine.loadFromModule("App", "Main");

	return QGuiApplication::exec();
}
