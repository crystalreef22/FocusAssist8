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

    onClosing: function(close) {
        if(!closingAllowed) {
            if (!focusWindow.visible) {
                closeDialog.open();
            }
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
                MyButton {
                    id: btnUselessFocusWindow
                    iconSource: "media/anotherday.png"
                    /*
                    onClicked: {            var component = Qt.createComponent("UselessFocusWindow.qml")
                        var window    = component.createObject(root)
                        window.show()}
                    */
                    onClicked: {
                        focusWindow.show();
                    }
                }

            }

            ComboBox {
                id: cmbExpireActionSelector
                model: ["Alarm","Silence","Show Focus Window"]
                currentIndex: 0
                onCurrentIndexChanged: function() {
                    console.log(currentIndex);
                    switch (currentIndex) {
                        case 0:
                            tasktimer.expireAction = TaskTimer.ALARM;
                            break;
                        case 1:
                            tasktimer.expireAction = TaskTimer.SILENT;
                            break;
                        case 2:
                            tasktimer.expireAction = TaskTimer.FOCUSWINDOW;
                            break;
                        default: console.log("ERR asjkdkjndan");
                    }
                    console.log("Changed expire action");
                }
            }

        }

    }
}

