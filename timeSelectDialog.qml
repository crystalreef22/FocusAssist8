import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id:timeSelectDialog
    title: "Choose a new time"
    flags: Qt.Dialog
    modality: Qt.ApplicationModal
    width: 200;
    height: 100;
    minimumWidth: width; maximumWidth: width; minimumHeight: height; maximumHeight: height;

    signal chosen(int choiceTime)

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    } // Click anywhere in window to unfocus currently focused item

    onVisibleChanged: {
        if (visible) {
            inputMins.forceActiveFocus(); // Set focus to the TextField when the window is shown
        }
    }

    Rectangle{
        anchors.fill: parent;
        ColumnLayout{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            Row{
                spacing: 2;
                SpinBox {
                    id: inputHours
                    from: 0; to: 99;
                    editable: true;
                    width: 60
                }
                Text{text:":"}
                SpinBox {
                    id: inputMins
                    from: 0; to: 60;
                    editable: true;
                    focus: true;
                    width: 60;
                }
                Text{text:":"}
                SpinBox {
                    id: inputSecs
                    from: 0; to: 60;
                    editable: true;
                    width: 60
                }
            }
            Row{
                Layout.alignment: Qt.AlignRight;
                Button{
                    id: btnReject
                    text: "Cancel"
                    onClicked: {
                        console.log("Cancel clicked")
                        timeSelectDialog.visible = false;
                    }
                }
                Button{
                    id: btnAccept
                    text: "Ok"
                    onClicked: {
                        forceActiveFocus()

                        timeSelectDialog.chosen(inputHours.value*3600+inputMins.value*60+inputSecs.value)
                        console.log("Ok clicked")
                        console.log(inputHours.value*3600+inputMins.value*60+inputSecs.value)
                        timeSelectDialog.visible = false;
                    }
                }
            }
        }
    }

}
