import QtQuick

Item {
    id: root
    required property Item target
    property string text: ""

    Timer {
        id: delay
        interval: 450
        onTriggered: tip.wanted = true
    }

    HoverHandler {
        parent: root.target
        onHoveredChanged: {
            tip.wanted = false;
            if (hovered) delay.restart();
            else delay.stop();
        }
    }

    Tooltip {
        id: tip
        target: root.target
        text: root.text
    }
}
