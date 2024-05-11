#include<QDebug>
#include "tasktimer.h"

TaskTimer::TaskTimer(QObject *parent)
    : QObject{parent}
{
    connect(&m_timer, SIGNAL(timeout()),this, SLOT(timeout()));
    this->m_timerLength = 0;
}

// ************************* SLOTS *********************

void TaskTimer::start(){
    qInfo("TaskTimer.cpp: started");
}

void TaskTimer::stop(){
    qInfo("TaskTimer.cpp: stopped");
}

void TaskTimer::reset(){
    qInfo("TaskTimer.cpp: reset");
}

void TaskTimer::toggle(bool value){
    qInfo("TaskTimer.cpp: toggled");
}

void TaskTimer::timeout(){
    qInfo("TaskTimer.cpp: tick");
}

// ****************************************************

void TaskTimer::updateDisplay(bool reset) {
    if (reset)
        setDisplay("???");
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
