import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import tasktimer 1.0
import QtMultimedia

ApplicationWindow {
    id: root
    width: 192; height: 200;
    minimumWidth: 192; minimumHeight: 150;
    visible: true
    flags: Qt.Window
               | Qt.CustomizeWindowHint
               | Qt.WindowTitleHint
               | Qt.WindowMinimizeButtonHint
               | Qt.WindowMaximizeButtonHint
               | Qt.WindowFullscreenButtonHint // macos. TEST ON WINDOWS
               | Qt.WindowCloseButtonHint
               | Qt.WindowStaysOnTopHint

    title: qsTr("FocusAssist8 v0.3.0")
    property bool closingAllowed: false

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    } // Click anywhere in window to unfocus currently focused item

    TaskTimer {
        id: tasktimer;
    }

    ListModel {
        id: soundModel
        ListElement { name: "Silent"; source: "" }
        ListElement { name: "Meditiation Bell"; source: "media/meditationbell.mp3" }
        ListElement { name: "Decaying Waves"; source: "media/Decayingwaves.mp3" }
    }
    property int soundModelActiveIndex: 2;

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
                root.show();
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

    ColumnLayout {
        id: content
        anchors.fill: parent;
        Rectangle {
            Layout.fillWidth: true;
            Layout.preferredHeight: 150;
            color: tasktimer.expired ? "#ff0000" : "#ffeedd";

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.left: parent.left
                width: parent.width * tasktimer.timeLeftFraction;
                id: timeLeftBar;
                color: "#eeabd0";
                height: 10;
                antialiasing: true;
            }

            ColumnLayout{
                id: mainDisplay;
                anchors.fill: parent

                Column {
                    Layout.alignment: Qt.AlignHCenter;
                    Text{
                        text: tasktimer.timeLeftDisplay;
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 24;
                        font.features: { "tnum": 1 }
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
                        iconSource: "media/anotherday.png"
                        onClicked: { timeSelectDialog.show(); }
                    }
                    MyButton {
                        id: btnCloseMenu
                        iconSource: "media/viewmore.png"
                        onClicked: {
                            closeMenu.visible = !closeMenu.visible
                        }

                        Menu {
                            popupType: Popup.Native
                            id: closeMenu
                            y: btnCloseMenu.height
                            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                            Menu {
                                title: "Media settings"
                                MenuItem {
                                    id: loopAlarmSoundsCheckbox
                                    text: "Loop alarm sounds"
                                    checkable: true
                                    checked: false
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
                            }

                            MenuItem {
                                text: "Show Focus Window"
                                onTriggered: focusWindow.show();
                            }
                            MenuItem {
                                text: "Snooze Window"
                                onTriggered: root.hide();
                            }
                        }
                    }

                }

                ComboBox {
                    id: cmbExpireActionSelector
                    model: ["Alarm","Show Focus Window", "Repeat"]
                    currentIndex: 0
                    onCurrentIndexChanged: function() {
                        console.log(currentIndex);
                        switch (currentIndex) {
                        case 0:
                            tasktimer.expireAction = TaskTimer.ALARM;
                            break;
                        case 1:
                            tasktimer.expireAction = TaskTimer.FOCUSWINDOW;
                            break;
                        case 2:
                            tasktimer.expireAction = TaskTimer.REPEATING;
                            break;
                        default: console.log("ERR asjkdkjndan");
                        }
                        console.log("Changed expire action");
                    }
                }

            }

        }
        ColumnLayout {
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            spacing:0
            ScrollView {
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                contentWidth: availableWidth
                ColumnLayout {
                    anchors.fill: parent
                    id: smallBarTimerHolder
                }
            }
            MyButton {
                text: "Add new timer";
                Layout.fillWidth: true;
                onClicked: {
                    var component = Qt.createComponent("SmallBarTimer.qml")
                    var item      = component.createObject(smallBarTimerHolder)
                }
            }
        }
    }
}

