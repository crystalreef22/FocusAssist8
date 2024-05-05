import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 200
    height: 90
    visible: true
    flags: Qt.WindowStaysOnTopHint

    title: qsTr("Focus Assist")
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
                    icon.source: "media/weird-horsecoint.png"
                    icon.color: "transparent"
                    width: 40;
                    height: 40;
                }

                Button{
                    icon.name: "pause"
                    width: 40;
                    height: 40;
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
