import QtQuick

ListView {
    id: root
    property var rows: []
    property int selectedIndex: -1
    property string query: ""
    property int maximumHeight: 392
    signal activated(int index)
    signal hovered(int index)

    model: rows
    clip: true
    interactive: contentHeight > maximumHeight
    implicitHeight: Math.min(contentHeight, maximumHeight)

    onSelectedIndexChanged: {
        if (selectedIndex >= 0) positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    delegate: ResultCell {
        required property var modelData
        width: ListView.view.width
        row: modelData
        query: root.query
        selectedIndex: root.selectedIndex
        onActivated: index => root.activated(index)
        onHovered: index => root.hovered(index)
    }
}
