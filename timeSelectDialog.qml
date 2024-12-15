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

    onVisibleChanged: {
        if (visible) {
            inputHours.value = 0; inputMins.value=0; inputSecs.value=0;
            inputMins.forceActiveFocus(); // Set focus to the TextField when the window is shown
        }
    }


    Rectangle{
        anchors.fill: parent;

        MouseArea {
            anchors.fill: parent
            onClicked: forceActiveFocus()
            KeyNavigation.tab: inputMins
        } // Click anywhere in window to unfocus currently focused item

        Keys.onEscapePressed: btnReject.clicked();
        Keys.onReturnPressed: btnAccept.clicked();
        Keys.onEnterPressed: btnAccept.clicked();

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
                    focusPolicy: Qt.NoFocus
                    id: btnReject
                    text: "Cancel"
                    onClicked: {
                        console.log("Cancel clicked")
                        timeSelectDialog.hide();
                    }
                }
                Button{
                    focusPolicy: Qt.NoFocus
                    id: btnAccept
                    text: "Ok"
                    onClicked: {
                        forceActiveFocus()

                        timeSelectDialog.chosen(inputHours.value*3600+inputMins.value*60+inputSecs.value)
                        console.log("Ok clicked")
                        console.log(inputHours.value*3600+inputMins.value*60+inputSecs.value)
                        timeSelectDialog.hide();
                    }
                }
            }
        }
    }

}
