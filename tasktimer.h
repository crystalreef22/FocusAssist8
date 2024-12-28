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
    Q_PROPERTY(bool alarmSounding READ alarmSounding NOTIFY alarmSoundingChanged FINAL) // alarm will always be silenced unless ringing

    Q_PROPERTY(double timeLeftFraction READ timeLeftFraction NOTIFY displayChanged FINAL)

    Q_PROPERTY(T_Expire_Action expireAction READ expireAction WRITE setExpireAction NOTIFY expireActionChanged FINAL)

public:
    explicit TaskTimer(QObject *parent = nullptr);

    enum T_Expire_Action {
        SILENT,
        ALARM,
        FOCUSWINDOW
    };
    Q_ENUM(T_Expire_Action)

public slots:
    void start();
    void stop();
    void reset();
    void togglePause();
    void timeout();
    void alarmSilence();

signals:
    void displayChanged();
    void timerLengthChanged();
    void runningChanged();
    void expiredChanged();
    void alarmSoundingChanged();
    void expireActionChanged();

private:
    T_Expire_Action m_expireAction;

    QTimer m_timer;
    QElapsedTimer m_watch;

    QString m_timeLeftDisplay;
    QString m_timeSetDisplay;
    long long m_timerLength;
    bool m_running;
    bool m_expired;
    bool m_alarmSounding;

    long long last_elapsed;

    void updateDisplay();
    long long timerLength();
    void setTimerLength(long long value);
    QString timeLeftDisplay();
    QString timeSetDisplay();
    bool running();
    bool expired();
    bool alarmSounding();
    double timeLeftFraction();
    T_Expire_Action expireAction();
    void setExpireAction(T_Expire_Action value);

    // Not exposed
    QString secsLeftToString(long long secs);
};

#endif // TASKTIMER_H
