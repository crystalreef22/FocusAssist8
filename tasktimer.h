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

public:
    explicit TaskTimer(QObject *parent = nullptr);

public slots:
    void start();
    void stop();
    void reset();
    void toggle(bool value);
    void timeout();

signals:
    void displayChanged();
    void timerLengthChanged();

private:
    QTimer m_timer;
    QElapsedTimer m_watch;
    QString m_display;

    double m_timerLength;

    void updateDisplay(bool reset = false);
    double timerLength();
    void setTimerLength(double value);
    QString display();
    void setDisplay(QString value);

};

#endif // TASKTIMER_H
