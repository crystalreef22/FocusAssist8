#include<QDebug>
#include "tasktimer.h"

TaskTimer::TaskTimer(QObject *parent)
    : QObject{parent}
{
    connect(&m_timer, SIGNAL(timeout()),this, SLOT(timeout()));
    this->m_timerLength = 0;
    this->last_elapsed = 0;
    this->m_running = false;
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
}

void TaskTimer::togglePause(){
    m_running = !m_running;
    emit runningChanged();
    qInfo() << "TaskTimer.cpp: toggled running:" << m_running;
    if(m_running) {
        this->start();
    } else {
        this->stop();
    }
}

void TaskTimer::timeout(){
    // qInfo() << "TaskTimer.cpp: tick after" << last_elapsed;
    long long m_elapsed;
    m_elapsed = m_watch.elapsed() + last_elapsed;
    long long hours = m_elapsed/1000/3600;
    long long minutes = (m_elapsed/1000/60)%60;
    long long seconds = (m_elapsed/1000)%60;
    QString time = QString("%4%3%2:%1").arg(seconds, 2, 10, QChar('0')).arg(minutes, 2, 10, QChar('0')).arg(hours == 0 ? "" : ":").arg(hours);
    setDisplay(time);
    emit displayChanged();
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
