import QtQuick 2.15

Window {
    id:uselessFocusWindow
    title: "FOCUS!"
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint;
    //flags: Qt.Dialog
    //modality: Qt.ApplicationModal
    width: Screen.width;
    height: Screen.height;
    minimumWidth: width; maximumWidth: width; minimumHeight: height; maximumHeight: height;
    x: 0;y:0;


    MouseArea {
        id: mousearea;
        anchors.fill: parent
        onPressAndHold: function(mouse) {
            uselessFocusWindow.hide();
        }
    } // Click anywhere in window to dismiss
    Rectangle {
        anchors.fill: parent;
        color: "#000000";
        Text {
            anchors.centerIn: parent
            text: mousearea.pressed ? "dismissing..." : "FOCUS!!"
            color: "#ff0000"
            font: Qt.font({pointSize: 20})
        }
    }
}
