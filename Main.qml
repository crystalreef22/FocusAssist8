import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import tasktimer 1.0
import QtMultimedia

ApplicationWindow {
    width: 200; height: 90;
    minimumWidth: 150; minimumHeight: 80;
    visible: true
    flags: Qt.WindowStaysOnTopHint
    title: qsTr("Focus Assist")

    TaskTimer {
        id: tasktimer;
    }

    MediaPlayer {
        id: expiredNotifier;
        audioOutput: AudioOutput {}
        source: "media/Decayingwaves.mp3"
        loops: 3;//MediaPlayer.Infinite;
    }

    Connections {
        target: tasktimer
        function onExpiredChanged() {
            if (tasktimer.expired) {
                expiredNotifier.play()
                console.log("expired sound play")
            } else {
                expiredNotifier.stop()
            }
        }
    }

    Rectangle {
        anchors.fill: parent;
        color: tasktimer.expired ? "#ff0000" : "#ffeedd";
        ColumnLayout{
            id: mainDisplay;
            anchors.left: parent.left;
            anchors.right:parent.right;
            anchors.top:parent.top;

            Column {
                Layout.alignment: Qt.AlignHCenter;
                Text{
                    text: tasktimer.display;
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 24;
                }
                Text{
                    text: "remaining";
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12;
                }
            }

            Row {
                Layout.alignment: Qt.AlignRight;

                Button {
                    id: btnTimerPause
                    icon.name: "pause";
                    width: 40;
                    height: 40;


                    onClicked: {
                        console.log("PauseToggle");
                        tasktimer.togglePause();
                    }
                }

                Button {
                    id: btnTimerCancel
                    text: "Cancel"
                    onClicked: {
                        console.log("Cancelled")
                        tasktimer.reset()
                    }
                }
                Button {
                    id: btnTimerSetTime
                    text: "Set"
                    onClicked: {
                        console.log("Set time to 25min")
                        tasktimer.timerLength = 15 * 60 * 1000;

                    }
                }

            }

        }
        Column {
            id: timeLeftColumn
            anchors.bottom:parent.bottom;
            height: 10;
            anchors.left: parent.left;
            anchors.right:parent.right;
            Rectangle {
                width: Window.width * 0.1;
                id: timeLeftBar;
                color: "#eeabd0";
                height: 10;
            }
        }

    }
}
