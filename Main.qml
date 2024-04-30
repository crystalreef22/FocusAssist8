import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 200
    height: 90
    visible: true

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
                Button{
                    icon.source: "media/weird-horsecoint.png"
                    icon.color: "transparent"
                }

                Button{
                    icon.name: "pause"
                    icon.source: "media/weird-horsecoint.png"
                    icon.color: "red"
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
                anchors.left: parent.left;
                anchors.right:parent.right;
                id: timeLeftBar;
                color: "#eeabd0";
                height: 10;
            }
        }
    }
}
