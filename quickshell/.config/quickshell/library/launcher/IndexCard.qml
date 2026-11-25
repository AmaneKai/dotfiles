import QtQuick

Rectangle {
    id: card
    readonly property int ruleCount: 4
    readonly property int firstRuleY: 26
    readonly property int ruleSpacing: 9

    width: 56
    height: 72
    color: "#f6e7c0"

    Rectangle { y: 14; width: parent.width; height: 2; color: "#a65651" }

    Repeater {
        model: card.ruleCount
        Rectangle {
            required property int index
            x: 4
            y: card.firstRuleY + index * card.ruleSpacing
            width: card.width - 8
            height: 1
            color: "#6f8fb5"
        }
    }
}
