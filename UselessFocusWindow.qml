import QtQuick 2.15

Window {
    id:uselessFocusWindow
    title: "FOCUS!"
    //flags: Qt.Dialog
    //modality: Qt.ApplicationModal
    width: 200;
    height: 100;
    x: (Screen.width-width)*Math.random()
    y: (Screen.height-height)*Math.random()
    minimumWidth: width; maximumWidth: width; minimumHeight: height; maximumHeight: height;

    MouseArea {
        anchors.fill: parent
        onClicked: uselessFocusWindow.close();
    } // Click anywhere in window to dismiss
    Rectangle {
        anchors.fill: parent;
        color: "#000000";
        Text {
            anchors.centerIn: parent
            text: "FOCUS!!"
            color: "#ff0000"
            font: Qt.font({pointSize: 20})
        }
    }
}
