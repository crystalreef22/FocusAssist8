import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import tasktimer 1.0
import QtMultimedia

ApplicationWindow {
    id: root
    width: 200; height: 90;
    minimumWidth: 150; minimumHeight: 80;
    visible: true
    flags: Qt.WindowStaysOnTopHint
    title: qsTr("Focus Assist")
   property bool closingAllowed: false

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

    TimeSelectDialog {
        id: timeSelectDialog;
        transientParent: root
        onChosen: {
            console.log(choiceTime)
            tasktimer.timerLength = choiceTime * 1000;
        }
    }

    onClosing: function(close) {
        if(!closingAllowed) {
            closeDialog.open();
        }

        close.accepted = closingAllowed;
    }

    MessageDialog {
        id: closeDialog
        text: "ARE YOU SURE?"
        informativeText: "Click OK to close window"
        buttons: MessageDialog.Ok | MessageDialog.Cancel

        onAccepted: {closingAllowed = true; Qt.quit();}
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
                    icon.source: "media/weird-horsecoint.png";
                    icon.color: "transparent";
                    onClicked: {
                        console.log("Cancelled")
                        tasktimer.reset()
                    }
                }
                /*Button {
                    id: btnTimerSetTime
                    text: "Set"
                    onClicked: {
                        console.log("Set time to 15min")
                        tasktimer.timerLength = 15 * 60 * 1000;

                    }
                }*/
                Button {
                    id: btnTimerAddTime
                    text: "+"
                    onClicked: {
                        console.log("Add to time 1 minute")
                        tasktimer.timerLength += 60 * 1000;

                    }
                }
                Button {
                    id: btnTimerSubTime
                    text: "-"
                    onClicked: {
                        console.log("remove from time 1 minute")
                        tasktimer.timerLength -=  60 * 1000;

                    }
                }
                Button {
                    id: btnTimeSelectDialog
                    text: "sea"
                    onClicked: { timeSelectDialog.visible = true; }
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
                width: Window.width * tasktimer.timeLeftFraction;
                id: timeLeftBar;
                color: "#eeabd0";
                height: 10;
            }
        }

    }
}

