import QtQuick
import "../"
import "calendar.js" as Almanac

Column {
    id: root
    spacing: 6

    readonly property var today: new Date()
    property int year: today.getFullYear()
    property int month: today.getMonth()

    function step(delta) {
        const next = Almanac.shift(year, month, delta);
        year = next.year;
        month = next.month;
    }

    Item {
        width: parent.width
        height: 40

        Column {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: "ALMANAC"
                color: Theme.muted
                font.family: Theme.mono
                font.pixelSize: 9
                font.letterSpacing: 1.4
            }
            Text {
                text: Almanac.monthName(root.month) + " " + root.year
                color: Theme.text
                font.family: Theme.serif
                font.pixelSize: 17
                font.weight: Font.Bold
            }
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14
            Repeater {
                model: [{ glyph: "‹", delta: -1 }, { glyph: "›", delta: 1 }]
                Text {
                    required property var modelData
                    text: modelData.glyph
                    color: Theme.heading
                    font.family: Theme.serif
                    font.pixelSize: 22
                    TapHandler { onTapped: root.step(modelData.delta) }
                }
            }
        }

        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.rule }
    }

    Grid {
        columns: 7
        width: parent.width

        Repeater {
            model: Almanac.weekdays()
            Text {
                required property string modelData
                width: root.width / 7
                horizontalAlignment: Text.AlignHCenter
                text: modelData
                color: Theme.muted
                font.family: Theme.mono
                font.pixelSize: 10
                bottomPadding: 4
            }
        }

        Repeater {
            model: Almanac.cells(root.year, root.month, root.today)
            Item {
                required property var modelData
                width: root.width / 7
                height: 28

                Rectangle {
                    visible: modelData.today
                    anchors.fill: parent
                    anchors.margins: 2
                    color: Theme.accent
                }
                Text {
                    anchors.centerIn: parent
                    text: modelData.day > 0 ? modelData.day : ""
                    color: modelData.today ? Theme.bar : Theme.heading
                    font.family: Theme.serif
                    font.pixelSize: 13
                    font.weight: modelData.today ? Font.Bold : Font.Normal
                }
            }
        }
    }
}
