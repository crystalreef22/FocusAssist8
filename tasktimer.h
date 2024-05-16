#ifndef TASKTIMER_H
#define TASKTIMER_H

#include <QObject>
#include <QVariant>
#include <QTimer>
#include <QElapsedTimer>
#include <QDebug>


class TaskTimer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double timerLength READ timerLength WRITE setTimerLength NOTIFY timerLengthChanged FINAL)
    Q_PROPERTY(QString display READ display WRITE setDisplay NOTIFY displayChanged FINAL)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged FINAL)
    Q_PROPERTY(bool expired READ expired NOTIFY expiredChanged FINAL)

    Q_PROPERTY(double timeLeftFraction READ timeLeftFraction NOTIFY displayChanged FINAL)

public:
    explicit TaskTimer(QObject *parent = nullptr);

public slots:
    void start();
    void stop();
    void reset();
    void togglePause();
    void timeout();

signals:
    void displayChanged();
    void timerLengthChanged();
    void runningChanged();
    void expiredChanged();

private:
    QTimer m_timer;
    QElapsedTimer m_watch;

    QString m_display;
    double m_timerLength;
    bool m_running;
    bool m_expired;

    double last_elapsed;

    void updateDisplay();
    double timerLength();
    void setTimerLength(double value);
    QString display();
    void setDisplay(QString value);
    bool running();
    bool expired();
    double timeLeftFraction();


};

#endif // TASKTIMER_H
