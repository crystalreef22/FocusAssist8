import QtQuick 2.15

Item {
    id: button;
    property color backgroundColor: "steelblue"
    property color focusColor: "lightblue"
    property color textColor: "black"
    property string text: ""
    property font font: Qt.font({ pointSize:11 })
    property string iconSource: ""
    signal clicked()
    implicitHeight: 32;
    implicitWidth: 32;
    activeFocusOnTab: true

    Rectangle{
        color: parent.activeFocus ? button.focusColor : button.backgroundColor
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
    Keys.onReturnPressed: button.clicked();
    Keys.onEnterPressed: button.clicked();
    Keys.onSpacePressed: button.clicked();

}
