import QtQuick
import "../"

Item {
    id: root
    property real value: 0
    signal moved(real value)

    width: parent ? parent.width : 0
    height: 24

    function fractionAt(x) {
        return Math.max(0, Math.min(1, x / width));
    }

    Rectangle { anchors.verticalCenter: parent.verticalCenter; width: parent.width; height: 1; color: Theme.rule }
    Rectangle { anchors.verticalCenter: parent.verticalCenter; width: parent.width * root.value; height: 2; color: Theme.text }
    Rectangle {
        x: Math.max(0, Math.min(root.width - width, root.width * root.value - width / 2))
        anchors.verticalCenter: parent.verticalCenter
        width: 5
        height: 16
        color: Theme.accent
    }

    MouseArea {
        anchors.fill: parent
        onPressed: mouse => root.moved(root.fractionAt(mouse.x))
        onPositionChanged: mouse => { if (pressed) root.moved(root.fractionAt(mouse.x)); }
    }
}
