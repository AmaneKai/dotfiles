import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../"

Row {
    id: root
    spacing: 6

    Repeater {
        model: SystemTray.items

        IconImage {
            id: icon
            required property var modelData
            source: modelData.icon
            implicitSize: 16
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: mouse => {
                    if (mouse.button === Qt.MiddleButton) return icon.modelData.secondaryActivate();
                    const wantsMenu = mouse.button === Qt.RightButton || icon.modelData.onlyMenu;
                    if (wantsMenu && icon.modelData.hasMenu) return Controller.openTray(icon.modelData);
                    icon.modelData.activate();
                }
            }
        }
    }
}
