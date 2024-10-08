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
    this->m_timeLeftDisplay = "00:00:00";
    this->m_timeSetDisplay = "No timer set test";
}

// ************************* UTILS *********************

QString TaskTimer::secsLeftToString(long long secs){
    QString positiveIndicator = secs < 0 ? QString("-") : QString("");
    secs = std::abs(secs);
    long long hours = secs/3600;
    long long minutes = (secs/60)%60;
    long long seconds = (secs)%60;
    return positiveIndicator + QString("%3:%2:%1").arg(seconds, 2, 10, QChar('0')).arg(minutes, 2, 10, QChar('0')).arg(hours);
}


// ************************* SLOTS *********************

void TaskTimer::start(){
    if (m_running){
        qWarning("TaskTimer.cpp: Tried to start while running. Did not run");
        return;
    }
    m_running = true;
    emit runningChanged();
    qInfo("TaskTimer.cpp: started");
    this->m_timer.start(200); // setInterval of timer to 200 ms between ticks
    this->m_watch.restart();
    timeout();
}

void TaskTimer::stop(){
    if (!m_running) {
        qWarning("TaskTimer.cpp: Tried to stop when already stopped. Did not run");
        return;
    }
    m_running = false;
    emit runningChanged();
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
    m_expired = false;
    emit expiredChanged();
    updateDisplay();
    emit displayChanged();
// ************************* SLOTS *********************
}

void TaskTimer::togglePause(){

    if(m_expired){
        this->reset();
        qWarning() << "TaskTimer.cpp: Actually I expired: resetting...";
        return;
    }

    if(m_running) {
        this->stop();
    } else {
        this->start();
    }
}

void TaskTimer::timeout(){
    // qInfo() << "TaskTimer.cpp: tick after" << last_elapsed;
    long long remaining = timerLength() - (m_watch.elapsed() + last_elapsed);
    bool timerExpired = remaining < 0;
    long long remainingSecs = (timerExpired ? (remaining) : (remaining+999)) / 1000;
    m_timeLeftDisplay = secsLeftToString(remainingSecs);
    emit displayChanged();

    if (m_expired != timerExpired){
        m_expired = timerExpired;
        emit expiredChanged();
        qInfo("Expired changed");
    }

    //qInfo() << remainingSecs << timerExpired;
}

// ****************************************************

void TaskTimer::updateDisplay() {
    long long remaining = timerLength();
    if (m_running){
        remaining -= (m_watch.elapsed() + last_elapsed);
    }
    bool timerExpired = remaining < 0;
    long long remainingSecs = (timerExpired ? (remaining) : (remaining+999)) / 1000;
    m_timeLeftDisplay = secsLeftToString(remainingSecs);
    emit displayChanged();
}

long long TaskTimer::timerLength(){
    return m_timerLength;
}

void TaskTimer::setTimerLength(long long value){
    m_timerLength = value;

    if(m_timerLength < 0)
        m_timerLength = 0;




    this->updateDisplay();
    long long x = (m_timerLength+999)/ 1000;
    m_timeSetDisplay = secsLeftToString(x);
    emit timerLengthChanged();
}

QString TaskTimer::timeLeftDisplay(){
    return m_timeLeftDisplay;
}
QString TaskTimer::timeSetDisplay(){
    return m_timeSetDisplay;
}

bool TaskTimer::running(){
    return m_running;
}

bool TaskTimer::expired(){
    return m_expired;
}
double TaskTimer::timeLeftFraction(){
    double remaining = timerLength() - (m_watch.elapsed() + last_elapsed);
    return fmax(remaining / timerLength(), 0.0);
}

