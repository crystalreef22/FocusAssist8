import QtQuick 2.15
import QtMultimedia
import tasktimer 1.0
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: bartimer
    implicitWidth: 200; implicitHeight: 34;
    Layout.fillWidth: true;
    activeFocusOnTab: true;
    property bool timerExpired: tasktimer.expired;

    TaskTimer {
        id: tasktimer;
    }

    ListModel {
        id: soundModel
        ListElement { name: "Silent"; source: "" }
        ListElement { name: "Meditiation Bell"; source: "media/meditationbell.mp3" }
        ListElement { name: "Decaying Waves"; source: "media/Decayingwaves.mp3" }
    }
    property int soundModelActiveIndex: 0;

    MediaPlayer {
        id: expiredNotifier;
        audioOutput: AudioOutput { device: mediaDevices.defaultAudioOutput }
        source: soundModel.get(soundModelActiveIndex).source;
        loops: loopAlarmSoundsCheckbox.checked ? MediaPlayer.Infinite : 1;
        onPlayingChanged: function(playing) {
            if (!playing) tasktimer.alarmSilence(); // problem is that this will call onAlarmSoundingChanged
        }
    }
    MediaDevices { id: mediaDevices }

    Connections {
        target: tasktimer
        function onAlarmSoundingChanged() {
            if (tasktimer.alarmSounding) {
                if (!soundModelActiveIndex !== 0) {
                    expiredNotifier.play();
                    console.log("expired sound play");
                }
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
                    font.pointSize: 16;
                    font.features: { "tnum": 1 }
                }
                MyButton {
                    id: btnTimeSetDisplay
                    text: tasktimer.timeSetDisplay;
                    width: 60
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 10;
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
                    id: btnAdditionalMenu
                    iconSource: "media/viewmore.png"
                    width: 25
                    onClicked: {
                        additionalMenu.visible = !additionalMenu.visible
                    }
                    Menu {
                        popupType: Popup.Native
                        id: additionalMenu
                        y: btnAdditionalMenu.height
                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                        MenuItem {
                            text: "Reset timer"
                            onTriggered: tasktimer.reset();
                        }
                        Menu {
                            title: "Change mode..."
                            MenuItem {
                                text: "Alarm"
                                checkable: true
                                checked: tasktimer.expireAction === TaskTimer.ALARM
                                onTriggered: tasktimer.expireAction = TaskTimer.ALARM;
                            }
                            MenuItem {
                                text: "Repeating"
                                checkable: true
                                checked: tasktimer.expireAction === TaskTimer.REPEATING
                                onTriggered: tasktimer.expireAction = TaskTimer.REPEATING;
                            }
                        }
                        Menu {
                            title: "Sound effect"
                            Repeater {
                                model: soundModel
                                MenuItem {
                                    text: model.name
                                    checkable: true
                                    checked: model.index === soundModelActiveIndex;
                                    onTriggered: soundModelActiveIndex = model.index;
                                }
                            }
                        }

                        MenuItem {
                            text: "Delete timer"
                            onTriggered: bartimer.destroy();
                        }
                    }
                }
            }

        }

    }
}
