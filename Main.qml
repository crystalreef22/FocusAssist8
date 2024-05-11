import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import tasktimer 1.0

ApplicationWindow {
    width: 200; height: 90;
    minimumWidth: 150; minimumHeight: 90;
    visible: true
    flags: Qt.WindowStaysOnTopHint
    title: qsTr("Focus Assist")

    TaskTimer {
        id: tasktimer;
    }

    Rectangle {
        anchors.fill: parent;
        color: "#ffeedd";
        ColumnLayout{
            id: mainDisplay;
            anchors.left: parent.left;
            anchors.right:parent.right;
            anchors.top:parent.top;
            Column {
                Layout.alignment: Qt.AlignHCenter;
                Text{
                    text: "25:00";
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
                Button{
                    id: btnTimerStart
                    icon.source: "media/weird-horsecoint.png"
                    icon.color: "transparent"
                    text: "Start"
                    width: 40
                    height: 40

                    onClicked: {
                        console.log("Start")
                    }
                }

                Button{
                    id: btnTimerStop
                    icon.source: "media/weird-horsecoint.png"
                    icon.color: "transparent"
                    text:"Stop"
                    width: 40
                    height: 40

                    onClicked: {
                        console.log("Pause")
                    }
                }

                Button{
                    id: btnTimerPause
                    icon.name: "pause"
                    width: 40;
                    height: 40;
                    onClicked: {
                        console.log("PauseToggle")
                    }
                }

                Button {
                    id: btnTimerCancel
                    text: "Cancel"
                    onClicked: {
                        console.log("Cancelled")
                    }
                }
                Button {
                    id: btnTimerSetTime
                    text: "Set"
                    onClicked: {
                        console.log("Set time to 5 secs")

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
