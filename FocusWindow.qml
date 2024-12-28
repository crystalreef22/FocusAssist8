import QtQuick 2.15

Window {
    id:focusWindow
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

        Timer {
            id: heldTimer
            interval: 6942 // funny number seconds
            running: false
            onTriggered: focusWindow.hide();
        }

        anchors.fill: parent
        onPressed: function(mouse) {
            heldTimer.restart();
        }
        onReleased: function(mouse) {
            heldTimer.stop();
        }

        cursorShape: Qt.BlankCursor;
    } // Click anywhere in window to dismiss
    Rectangle {
        anchors.fill: parent;
        color: "#000000";
        Text {
            anchors.centerIn: parent
            text: mousearea.pressed ? "dismissing... (hold for 6.9420 seconds)" : "FOCUS!!"
            color: "#ff0000"
            font: Qt.font({pointSize: 20})
        }
    }
}
