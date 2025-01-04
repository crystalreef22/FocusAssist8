import QtQuick 2.15
import QtMultimedia
import tasktimer 1.0
import QtQuick.Layouts

Item {
    id: bartimer
    width: 200; height: 150;

    TaskTimer {
        id: tasktimer;
    }

    MediaPlayer {
        id: expiredNotifier;
        audioOutput: AudioOutput { device: mediaDevices.defaultAudioOutput }
        source: "media/Decayingwaves.mp3"
        loops: 3;//MediaPlayer.Infinite;
    }
    MediaDevices { id: mediaDevices }

    Connections {
        target: tasktimer
        function onAlarmSoundingChanged() {
            if (tasktimer.alarmSounding) {
                expiredNotifier.play();
                console.log("expired sound play");
            } else {
                expiredNotifier.stop();
                console.log("expired sound stop");
            }
        }
        function onExpiredChanged() {
            if (tasktimer.expired) {
                switch (tasktimer.expireAction) {
                    case TaskTimer.ALARM: break;
                    case TaskTimer.SILENT: break;
                    case TaskTimer.FOCUSWINDOW:
                        focusWindow.show();
                        break;
                    default:
                        console.log("asjdsadnlk not implemented");
                }
            }
        }
    }

    TimeSelectDialog {
        id: timeSelectDialog;
        transientParent: root
        onChosen: {
            console.log(choiceTime)
            tasktimer.timerLength = choiceTime * 1000;
        }
    }
    FocusWindow{id: focusWindow}


    Rectangle {
        anchors.fill: parent;
        color: tasktimer.expired ? "#ff0000" : "#ffeedd";

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.left: parent.left
            width: Window.width * tasktimer.timeLeftFraction;
            id: timeLeftBar;
            color: "#eeabd0";
            height: 10;
            antialiasing: true;
        }

        ColumnLayout{
            id: mainDisplay;
            anchors.left: parent.left;
            anchors.right:parent.right;
            anchors.top:parent.top;

            Column {
                Layout.alignment: Qt.AlignHCenter;
                Text{
                    text: tasktimer.timeLeftDisplay;
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 24;
                }
                Text{
                    text: tasktimer.timeSetDisplay;
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12;
                }
            }

            Row {
                Layout.alignment: Qt.AlignRight;

                MyButton {
                    id: btnTimerPause
                    iconSource: "media/pause.png"
                    visible: !btnTimerMute.visible;

                    onClicked: {
                        console.log("PauseToggle");
                        tasktimer.togglePause();
                    }
                }
                MyButton {
                    id: btnTimerMute
                    text: "mut"
                    visible: tasktimer.alarmSounding;
                    onClicked: {
                        console.log("mute did");
                        tasktimer.alarmSilence();
                    }
                }

                MyButton {
                    id: btnTimerCancel
                    iconSource: "media/weird-horsecoint.png";
                    onClicked: {
                        console.log("Cancelled")
                        tasktimer.reset()
                    }
                }
                MyButton {
                    id: btnTimerAddTime
                    text: "+"
                    onClicked: {
                        console.log("Add to time 1 minute")
                        tasktimer.timerLength += 60 * 1000;

                    }
                }
                MyButton {
                    id: btnTimerSubTime
                    text: "-"
                    onClicked: {
                        console.log("remove from time 1 minute")
                        tasktimer.timerLength -=  60 * 1000;

                    }
                }
                MyButton {
                    id: btnTimeSelectDialog
                    text: "sea"
                    onClicked: { timeSelectDialog.show(); }
                }

            }

        }

    }
}
