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
    Q_PROPERTY(QString timeLeftDisplay READ timeLeftDisplay NOTIFY displayChanged FINAL)
    Q_PROPERTY(QString timeSetDisplay READ timeSetDisplay NOTIFY timerLengthChanged FINAL)
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

    QString m_timeLeftDisplay;
    QString m_timeSetDisplay;
    long long m_timerLength;
    bool m_running;
    bool m_expired;

    long long last_elapsed;

    void updateDisplay();
    long long timerLength();
    void setTimerLength(long long value);
    QString timeLeftDisplay();
    QString timeSetDisplay();
    bool running();
    bool expired();
    double timeLeftFraction();

    // Not exposed
    QString secsLeftToString(long long secs);
};

#endif // TASKTIMER_H
