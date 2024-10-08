import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import tasktimer 1.0
import QtMultimedia

ApplicationWindow {
    id: root
    width: 200; height: 110;
    minimumWidth: 150; minimumHeight: 80;
    visible: true
    flags: Qt.WindowStaysOnTopHint
    title: qsTr("Focus Assist")
   property bool closingAllowed: false

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    } // Click anywhere in window to unfocus currently focused item

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
                TextField {
                    id: timerName
                    property string originalText: ""

                    placeholderText: "timer name..."

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            originalText = this.text;
                        }
                    }

                    Keys.onPressed: function(event){
                        if (event.key === Qt.Key_Escape) {
                            this.text = originalText;
                            this.focus = false;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            this.focus = false;
                        }
                    }
                }
            }

            Row {
                Layout.alignment: Qt.AlignRight;

                MyButton {
                    id: btnTimerPause
                    iconSource: "media/pause.png";

                    onClicked: {
                        console.log("PauseToggle");
                        tasktimer.togglePause();
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
                    onClicked: { timeSelectDialog.visible = true; }
                }


            }

        }

    }
}

