import QtQuick 2.15

Item {
    id: button;
    property color backgroundColor: "steelblue"
    property color textColor: "black"
    property string text: ""
    property font font: Qt.font({ pointSize:11 })
    property string iconSource: ""
    signal clicked()
    implicitHeight: 32;
    implicitWidth: 32;

    Rectangle{
        color: button.backgroundColor;
        anchors.fill: parent;
        anchors.margins: 1 // This creates the padding effect
        radius: 5;
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Image {
                visible: button.iconSource !== ""
                source: button.iconSource
                width: 24
                height: 24
                fillMode: Image.PreserveAspectFit
            }
            Text {
                id: buttonText
                text: button.text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: button.font
                color: button.textColor;
            }
        }
    }
    MouseArea {
        anchors.fill: parent;
        onClicked: {
            button.clicked();
        }
    }
}
