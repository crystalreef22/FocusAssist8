#include<QDebug>
#include "tasktimer.h"

TaskTimer::TaskTimer(QObject *parent)
    : QObject{parent}
{
    connect(&m_timer, SIGNAL(timeout()),this, SLOT(timeout()));
    this->m_timerLength = 0;
    this->last_elapsed = 0;
    this->m_running = false;
    this->m_expired = false;
    this->setDisplay("00:00");
}

// ************************* SLOTS *********************

void TaskTimer::start(){
    if (m_timer.isActive()){
        qWarning("TaskTimer.cpp: Tried to start while running. Did not run");
        return;
    }
    qInfo("TaskTimer.cpp: started");
    this->m_timer.start(200); // setInterval of timer to 200 ms between ticks
    this->m_watch.restart();
    timeout();
}

void TaskTimer::stop(){
    if (!m_timer.isActive()) {
        qWarning("TaskTimer.cpp: Tried to stop when already stopped. Did not run");
        return;
    }
    qInfo("TaskTimer.cpp: stopped");
    m_timer.stop();
    last_elapsed += m_watch.elapsed();
    qInfo() << last_elapsed;
}

void TaskTimer::reset(){
    qInfo("TaskTimer.cpp: reset");
    last_elapsed = 0;
    m_watch.restart();
    m_timer.stop();
    m_running = false;
    emit runningChanged();
    updateDisplay(true);
    emit displayChanged();
    m_expired = false;
    emit expiredChanged();
}

void TaskTimer::togglePause(){
    m_running = !m_running;
    emit runningChanged();
    qInfo() << "TaskTimer.cpp: toggled running:" << m_running;

    if(m_expired){
        this->reset();
        qWarning() << "TaskTimer.cpp: Actually I expired: resetting...";
        return;
    }

    if(m_running) {
        this->start();
    } else {
        this->stop();
    }
}

void TaskTimer::timeout(){
    // qInfo() << "TaskTimer.cpp: tick after" << last_elapsed;
    long long remaining = timerLength() - (m_watch.elapsed() + last_elapsed);
    bool timerExpired = remaining < 0;
    long long remainingSecs = timerExpired ? 0 : (remaining+999)/ 1000;
    long long hours = remainingSecs/3600;
    long long minutes = (remainingSecs/60)%60;
    long long seconds = (remainingSecs)%60;
    QString time = QString("%3:%2:%1").arg(seconds, 2, 10, QChar('0')).arg(minutes, 2, 10, QChar('0')).arg(hours);
    setDisplay(time);
    emit displayChanged();

    if (m_expired != timerExpired){
        m_expired = timerExpired;
        emit expiredChanged();
        qInfo("Expired changed");
    }

    qInfo() << remainingSecs << timerExpired;
}

// ****************************************************

void TaskTimer::updateDisplay(bool reset) {
    if (reset)
        setDisplay("00:00");
}

double TaskTimer::timerLength(){
    return m_timerLength;
}

void TaskTimer::setTimerLength(double value){
    m_timerLength = value;
}

QString TaskTimer::display(){
    return m_display;
}

void TaskTimer::setDisplay(QString value){
    m_display = value;
}

bool TaskTimer::running(){
    return m_running;
}

bool TaskTimer::expired(){
    return m_expired;
}
