import QtQuick
import "../"

Row {
    id: root
    property int current: 0
    signal chosen(int index)

    readonly property var drawers: [
        { numeral: "I", name: "All" },
        { numeral: "II", name: "Applications" },
        { numeral: "III", name: "Windows" },
        { numeral: "IV", name: "Run" }
    ]

    spacing: 6

    Repeater {
        model: root.drawers

        Rectangle {
            id: tab
            required property var modelData
            required property int index
            readonly property bool active: index === root.current

            width: (root.width - root.spacing * (root.drawers.length - 1)) / root.drawers.length
            height: 30
            color: active ? Theme.hairlineSoft : "transparent"
            border.width: 1
            border.color: active ? Theme.hairline : "transparent"

            Row {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: tab.modelData.numeral
                    color: Theme.accent
                    font.family: Theme.serif
                    font.pixelSize: 14
                    font.weight: Font.Bold
                }
                Text {
                    text: tab.modelData.name
                    color: tab.active ? Theme.text : Theme.muted
                    font.family: Theme.sans
                    font.pixelSize: 13
                }
            }

            MouseArea { anchors.fill: parent; onClicked: root.chosen(tab.index) }
        }
    }
}
