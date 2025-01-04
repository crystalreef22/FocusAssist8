import QtQuick 2.15
import QtMultimedia
import tasktimer 1.0
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: bartimer
    implicitWidth: 200; implicitHeight: 34;

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
        transientParent: bartimer
        onChosen: {
            console.log(choiceTime)
            tasktimer.timerLength = choiceTime * 1000;
        }
    }
    FocusWindow{id: focusWindow}


    Rectangle {
        anchors.fill: parent;
        color: tasktimer.expired ? "#ff0000" : "#ffddee";

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.left: parent.left
            width: bartimer.width * tasktimer.timeLeftFraction;
            id: timeLeftBar;
            color: "#eeabd0";
            height: 10;
            antialiasing: true;
        }

        RowLayout{
            id: mainDisplay;
            anchors.fill: parent
            spacing:0;

            Row {
                Layout.alignment: Qt.AlignLeft;
                Text{
                    text: tasktimer.timeLeftDisplay;
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 18;
                    font.features: { "tnum": 1 }
                }
                MyButton {
                    id: btnTimeSetDisplay
                    text: tasktimer.timeSetDisplay;
                    width: 60
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 12;
                    font.features: { "tnum": 1 }
                    onClicked: { timeSelectDialog.show(); }
                }
            }

            Row {
                Layout.alignment: Qt.AlignRight;

                MyButton {
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

            }

        }

    }
}
